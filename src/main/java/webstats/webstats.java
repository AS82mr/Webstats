package webstats;

import me.clip.placeholderapi.PlaceholderAPI;
import org.bukkit.Bukkit;
import org.bukkit.ChatColor;
import org.bukkit.Material;
import org.bukkit.command.Command;
import org.bukkit.command.CommandSender;
import org.bukkit.configuration.ConfigurationSection;
import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.configuration.file.YamlConfiguration;
import org.bukkit.enchantments.Enchantment;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.EventPriority;
import org.bukkit.event.Listener;
import org.bukkit.event.entity.EntityDamageEvent;
import org.bukkit.event.entity.EntityDeathEvent;
import org.bukkit.event.entity.EntityPickupItemEvent;
import org.bukkit.event.entity.EntityRegainHealthEvent;
import org.bukkit.event.inventory.InventoryClickEvent;
import org.bukkit.event.inventory.InventoryCloseEvent;
import org.bukkit.event.player.*;
import org.bukkit.inventory.ItemStack;
import org.bukkit.inventory.meta.ItemMeta;
import org.bukkit.inventory.meta.SkullMeta;
import org.bukkit.plugin.java.JavaPlugin;
import webstats.model.BarEntry;
import webstats.model.InventoryEntry;
import webstats.model.PlayerProfile;
import webstats.model.StatEntry;
import webstats.storage.MySQLStorage;
import webstats.storage.RedisStorage;
import webstats.storage.StorageProvider;

import de.tr7zw.nbtapi.NBTCompound;
import de.tr7zw.nbtapi.NBTItem;
import de.tr7zw.nbtapi.NBTCompoundList;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.regex.Pattern;

public class webstats extends JavaPlugin implements Listener {

    private StorageProvider primaryStorage;   // Redis (Fast)
    private StorageProvider backupStorage;    // MySQL (Permanent)

    private int updateTaskID = -1;
    private int heartbeatTaskID = -1;
    private int mysqlSyncTaskID = -1;

    // Queue of player profile snapshots waiting to be written to MySQL cold storage.
    // Populated on player quit (main thread); drained asynchronously by the sync task
    // and synchronously during onDisable to guarantee no data loss on clean shutdown.
    private final ConcurrentLinkedQueue<PlayerProfile> mysqlWriteQueue = new ConcurrentLinkedQueue<>();

    // Hashing to prevent duplicate uploads (Key is Username)
    private final ConcurrentHashMap<String, Integer> lastDataHash = new ConcurrentHashMap<>();

    // REDIS: Queue for players who need an update (Debouncing)
    private final Set<String> dirtyPlayers = Collections.synchronizedSet(new HashSet<>());

    // Local Cache for Username History (UUID -> Name)
    private File userCacheFile;
    private FileConfiguration userCacheConfig;

    // Mode Flag
    private boolean isRedisMode = false;

    // Pattern for color conversion
    private static final Pattern AMPERSAND_PATTERN = Pattern.compile("&([0-9a-fk-orA-FK-ORxX#])");

    @Override
    public void onEnable() {
        saveDefaultConfig();
        loadUserCache(); // Load the UUID->Name map

        String configType = getConfig().getString("storage-type", "mysql");
        getLogger().info("Loading storage type: " + configType);

        try {
            if (configType != null && configType.equalsIgnoreCase("redis")) {
                getLogger().info(">> ACTIVATING HYBRID MODE <<");
                getLogger().info("Primary: Redis (Hot Data - Instant)");
                getLogger().info("Backup:  MySQL (Cold Data - Permanent)");

                primaryStorage = new RedisStorage(this);
                backupStorage = new MySQLStorage(this);

                primaryStorage.setup();
                backupStorage.setup();
                isRedisMode = true;
            } else {
                getLogger().info(">> ACTIVATING STANDARD MODE <<");
                getLogger().info("Storage: MySQL Only");

                primaryStorage = new MySQLStorage(this);
                backupStorage = null;

                primaryStorage.setup();
                isRedisMode = false;
            }
        } catch (Exception e) {
            getLogger().severe("Failed to setup storage: " + e.getMessage());
            getServer().getPluginManager().disablePlugin(this);
            return;
        }

        getServer().getPluginManager().registerEvents(this, this);

        if (isRedisMode) {
            startRedisEngine();
        } else {
            startMySQLEngine();
        }

        getLogger().info("webstats enabled!");
        this.getCommand("wsreload").setExecutor(this);
        this.getCommand("wspurge").setExecutor(this);

        // Broadcast leaderboard config to Redis so the website knows what to render
        broadcastLeaderboardConfig();
    }

    @Override
    public void onDisable() {
        if (updateTaskID   != -1) getServer().getScheduler().cancelTask(updateTaskID);
        if (heartbeatTaskID != -1) getServer().getScheduler().cancelTask(heartbeatTaskID);
        if (mysqlSyncTaskID != -1) getServer().getScheduler().cancelTask(mysqlSyncTaskID);

        // Snapshot every still-online player before storage shuts down.
        for (Player p : Bukkit.getOnlinePlayers()) {
            try { mysqlWriteQueue.offer(gatherPlayerData(p)); } catch (Exception ignored) {}
        }

        // Determine which storage handles cold (MySQL) data.
        StorageProvider mysqlStorage = isRedisMode ? backupStorage : primaryStorage;
        if (mysqlStorage != null && !mysqlWriteQueue.isEmpty()) {
            // Blocking flush — totally acceptable during server shutdown.
            int flushed = 0;
            PlayerProfile snap;
            while ((snap = mysqlWriteQueue.poll()) != null) {
                mysqlStorage.saveProfile(snap);
                flushed++;
            }
            getLogger().info("[onDisable] Flushed " + flushed + " profiles to cold storage.");
            if (flushed > 0) getLogger().info("[Shutdown] Flushed " + flushed + " profile(s) to MySQL cold storage.");
        }

        if (primaryStorage != null) primaryStorage.shutdown();
        if (backupStorage  != null) backupStorage.shutdown();
    }

    // --- NAME CHANGE MIGRATION SYSTEM ---

    private void loadUserCache() {
        userCacheFile = new File(getDataFolder(), "user-cache.yml");
        if (!userCacheFile.exists()) {
            try {
                userCacheFile.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        userCacheConfig = YamlConfiguration.loadConfiguration(userCacheFile);
    }

    private void saveUserCache() {
        try {
            userCacheConfig.save(userCacheFile);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void handleNameChangeCheck(Player player) {
        String uuidKey = player.getUniqueId().toString();
        String currentName = player.getName();

        if (userCacheConfig.contains(uuidKey)) {
            String storedName = userCacheConfig.getString(uuidKey);

            // DETECT CHANGE: Stored Name != Current Name
            if (storedName != null && !storedName.equals(currentName)) {
                getLogger().warning("[Migration] Detected Name Change for " + player.getUniqueId() + ": " + storedName + " -> " + currentName);

                // MIGRATION: Update the database keys so data isn't lost
                Bukkit.getScheduler().runTaskAsynchronously(this, () -> {
                    if (primaryStorage != null) primaryStorage.updateUsername(storedName, currentName);
                    if (backupStorage != null) backupStorage.updateUsername(storedName, currentName);

                    // Clear hash so we force a fresh upload
                    lastDataHash.remove(currentName);
                });
            }
        }

        // Update Cache with new name
        userCacheConfig.set(uuidKey, currentName);
        saveUserCache();
    }

    // --- ENGINES ---

    private void startRedisEngine() {
        if (updateTaskID != -1) getServer().getScheduler().cancelTask(updateTaskID);
        if (heartbeatTaskID != -1) getServer().getScheduler().cancelTask(heartbeatTaskID);

        getLogger().info("Starting REDIS Hybrid Engine (Event-Based).");

        // 1. FAST PROCESSOR (Debounce) - Runs every 0.5s (10 ticks)
        updateTaskID = getServer().getScheduler().scheduleSyncRepeatingTask(this, () -> {
            if (dirtyPlayers.isEmpty()) return;

            Set<String> processQueue;
            synchronized (dirtyPlayers) {
                processQueue = new HashSet<>(dirtyPlayers);
                dirtyPlayers.clear();
            }

            for (String playerName : processQueue) {
                Player player = Bukkit.getPlayerExact(playerName);
                if (player != null && player.isOnline()) {
                    processPlayerUpdate(player, false);
                }
            }
        }, 10L, 10L);

        // 2. PASSIVE HEARTBEAT - Runs every 3 seconds (60 ticks)
        heartbeatTaskID = getServer().getScheduler().scheduleSyncRepeatingTask(this, () -> {
            for (Player p : Bukkit.getOnlinePlayers()) {
                markDirty(p);
            }
        }, 60L, 60L);

        // 3. MySQL cold-storage flush (quit snapshots)
        startMySQLFlushTask();
    }

    private void startMySQLEngine() {
        if (updateTaskID != -1) getServer().getScheduler().cancelTask(updateTaskID);

        int seconds = getConfig().getInt("update-every", 60);
        if (seconds < 1) seconds = 60;
        long intervalTicks = seconds * 20L;

        getLogger().info("Starting MYSQL Interval Task: " + seconds + "s.");

        updateTaskID = getServer().getScheduler().scheduleSyncRepeatingTask(this, () -> {
            if (Bukkit.getOnlinePlayers().isEmpty()) return;
            for (Player player : Bukkit.getOnlinePlayers()) {
                processPlayerUpdate(player, false);
            }
        }, intervalTicks, intervalTicks);

        // MySQL quit-snapshot flush (catches players who left between timer ticks)
        startMySQLFlushTask();
    }

    /**
     * Starts a repeating task that drains {@link #mysqlWriteQueue} to cold storage.
     * Safe to call multiple times — cancels the previous task first.
     * The interval is controlled by {@code mysql.sync-interval-minutes} in config (default 5).
     */
    private void startMySQLFlushTask() {
        if (mysqlSyncTaskID != -1) getServer().getScheduler().cancelTask(mysqlSyncTaskID);

        final StorageProvider mysqlStorage = isRedisMode ? backupStorage : primaryStorage;
        if (mysqlStorage == null) return;

        int minutes = getConfig().getInt("mysql.sync-interval-minutes", 5);
        long ticks  = Math.max(1, minutes) * 60L * 20L;

        mysqlSyncTaskID = getServer().getScheduler().scheduleSyncRepeatingTask(this, () -> {
            if (mysqlWriteQueue.isEmpty()) return;

            // Drain the queue on the main thread (fast — just polling a concurrent queue)
            final List<PlayerProfile> batch = new ArrayList<>();
            PlayerProfile snap;
            while ((snap = mysqlWriteQueue.poll()) != null) batch.add(snap);

            // Write to MySQL asynchronously so the main thread isn't blocked
            Bukkit.getScheduler().runTaskAsynchronously(this, () -> {
                int success = 0;
                for (PlayerProfile profile : batch) {
                    try {
                        mysqlStorage.saveProfile(profile);
                        success++;
                    } catch (Exception ex) {
                        getLogger().warning("[MySQL Sync] Failed to persist " + profile.name + ": " + ex.getMessage());
                    }
                }
                if (success > 0) getLogger().info("[MySQL Sync] Persisted " + success + "/" + batch.size() + " quit-snapshot(s) to cold storage.");
            });
        }, ticks, ticks);
    }

    // --- CORE LOGIC ---

    private void processPlayerUpdate(Player player, boolean forceBackup) {
        try {
            // 1. Gather Data (Using Username)
            PlayerProfile profile = gatherPlayerData(player);

            // 2. Check Hash (Don't upload if nothing changed)
            int currentHash = calculateProfileHash(profile);
            boolean dataChanged = !lastDataHash.containsKey(player.getName()) || lastDataHash.get(player.getName()) != currentHash;

            // If data changed OR we are forcing a backup (e.g. on Quit)
            if (dataChanged || forceBackup) {
                lastDataHash.put(player.getName(), currentHash);

                // 3. Save (Async to prevent lag)
                Bukkit.getScheduler().runTaskAsynchronously(this, () -> {
                    // A. Always save to Primary
                    if (primaryStorage != null) {
                        primaryStorage.saveProfile(profile);
                    }

                    // B. For MySQL Cold Storage (Backup)
                    if (backupStorage != null) {
                        // In Hybrid mode, we normally save on Quit via mysqlWriteQueue (startMySQLFlushTask).
                        // If forceBackup is true (e.g., from wsreload or manually), save immediately.
                        if (forceBackup || !isRedisMode) {
                            backupStorage.saveProfile(profile);
                        }
                    }
                });
            }
        } catch (Exception e) {
            getLogger().warning("Error updating " + player.getName() + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    // --- LEADERBOARD CONFIG BROADCASTER ---

    /**
     * Reads leaderboards.yml and pushes the config as JSON to Redis
     * under webstats:config:leaderboards so the website can render dynamic boards.
     * No-op when Redis is not available.
     */
    private void broadcastLeaderboardConfig() {
        if (!(primaryStorage instanceof RedisStorage)) {
            getLogger().info("[Leaderboards] Redis not active — skipping config broadcast.");
            return;
        }

        try {
            // Save default leaderboards.yml if it doesn’t exist, then load it
            saveResource("leaderboards.yml", false);
            File lbFile = new File(getDataFolder(), "leaderboards.yml");
            FileConfiguration lbConfig = YamlConfiguration.loadConfiguration(lbFile);

            ConfigurationSection lbSection = lbConfig.getConfigurationSection("leaderboards");
            if (lbSection == null) {
                getLogger().warning("[Leaderboards] leaderboards.yml has no 'leaderboards' section!");
                return;
            }

            // Build JSON:
            // { "wealth": { "title": "...", "rows": ["resolved line 1", "resolved line 2", ...] }, ... }
            Gson gson = new Gson();
            JsonObject root = new JsonObject();

            // Use any online player as PAPI context — many expansions (CMI, CoinsEngine) reject null
            Player ctx = Bukkit.getOnlinePlayers().isEmpty() ? null : Bukkit.getOnlinePlayers().iterator().next();

            for (String key : lbSection.getKeys(false)) {
                String title = lbSection.getString(key + ".title", key);
                List<String> placeholders = lbSection.getStringList(key + ".placeholders");

                // Resolve each placeholder line server-side via PlaceholderAPI
                com.google.gson.JsonArray rows = new com.google.gson.JsonArray();
                for (String line : placeholders) {
                    String resolved = PlaceholderAPI.setPlaceholders(ctx, line);
                    rows.add(resolved); // color codes kept intact (&x codes)
                }

                JsonObject entry = new JsonObject();
                entry.addProperty("title", title);
                entry.add("rows", rows);
                root.add(key, entry);
            }

            String json = gson.toJson(root);

            // Write to Redis — delegate through RedisStorage
            ((RedisStorage) primaryStorage).setRaw("webstats:config:leaderboards", json);
            getLogger().info("[Leaderboards] Config broadcast to Redis: " + root.keySet());

        } catch (Exception e) {
            getLogger().warning("[Leaderboards] Failed to broadcast config: " + e.getMessage());
        }
    }

    // --- TRIGGERS ---

    private void markDirty(Player p) {
        if (isRedisMode && p != null) {
            dirtyPlayers.add(p.getName());
        }
    }

    @EventHandler
    public void onJoin(PlayerJoinEvent e) {
        // 1. Check for Name Changes & Wipe old data if found
        handleNameChangeCheck(e.getPlayer());

        lastDataHash.remove(e.getPlayer().getName());
        markDirty(e.getPlayer());
    }

    @EventHandler(priority = EventPriority.LOWEST)
    public void onQuit(PlayerQuitEvent e) {
        Player player = e.getPlayer();
        try {
            // Gather data on the MAIN thread — Bukkit API is not thread-safe.
            // The player object is still valid during the quit event.
            PlayerProfile profile = gatherPlayerData(player);

            // Save to primary storage (Redis) asynchronously — fast hot-data update.
            if (primaryStorage != null) {
                final PlayerProfile snap = profile;
                Bukkit.getScheduler().runTaskAsynchronously(this, () -> primaryStorage.saveProfile(snap));
            }

            // Queue a snapshot for cold-storage (MySQL).
            // The mysqlWriteQueue is drained by startMySQLFlushTask every N minutes
            // and synchronously in onDisable — no async race condition on shutdown.
            mysqlWriteQueue.offer(profile);

        } catch (Exception ex) {
            getLogger().warning("[onQuit] Failed to snapshot " + player.getName() + ": " + ex.getMessage());
        }

        lastDataHash.remove(player.getName());
        dirtyPlayers.remove(player.getName());
    }

    // --- GAMEPLAY TRIGGERS (Redis Only) ---

    @EventHandler(priority = EventPriority.MONITOR, ignoreCancelled = true)
    public void onStatIncrement(PlayerStatisticIncrementEvent e) {
        markDirty(e.getPlayer());
    }

    @EventHandler(priority = EventPriority.MONITOR, ignoreCancelled = true)
    public void onInventoryClick(InventoryClickEvent e) {
        if (e.getWhoClicked() instanceof Player) markDirty((Player) e.getWhoClicked());
    }

    @EventHandler(priority = EventPriority.MONITOR, ignoreCancelled = true)
    public void onInventoryClose(InventoryCloseEvent e) {
        if (e.getPlayer() instanceof Player) markDirty((Player) e.getPlayer());
    }

    @EventHandler(priority = EventPriority.MONITOR, ignoreCancelled = true)
    public void onDrop(PlayerDropItemEvent e) {
        markDirty(e.getPlayer());
    }

    @EventHandler(priority = EventPriority.MONITOR, ignoreCancelled = true)
    public void onPickup(EntityPickupItemEvent e) {
        if (e.getEntity() instanceof Player) markDirty((Player) e.getEntity());
    }

    @EventHandler(priority = EventPriority.MONITOR, ignoreCancelled = true)
    public void onDeath(EntityDeathEvent e) {
        if (e.getEntity() instanceof Player) markDirty((Player) e.getEntity());
        if (e.getEntity().getKiller() != null) markDirty(e.getEntity().getKiller());
    }

    @EventHandler(priority = EventPriority.MONITOR, ignoreCancelled = true)
    public void onHealth(EntityRegainHealthEvent e) {
        if (e.getEntity() instanceof Player) markDirty((Player) e.getEntity());
    }

    @EventHandler(priority = EventPriority.MONITOR, ignoreCancelled = true)
    public void onDamage(EntityDamageEvent e) {
        if (e.getEntity() instanceof Player) markDirty((Player) e.getEntity());
    }

    @EventHandler(priority = EventPriority.MONITOR, ignoreCancelled = true)
    public void onCommandPreprocess(PlayerCommandPreprocessEvent e) {
        markDirty(e.getPlayer());
    }

    @EventHandler(priority = EventPriority.MONITOR, ignoreCancelled = true)
    public void onGameMode(PlayerGameModeChangeEvent e) {
        markDirty(e.getPlayer());
    }

    // --- COMMANDS ---

    @Override
    public boolean onCommand(CommandSender sender, Command command, String label, String[] args) {
        if (command.getName().equalsIgnoreCase("wsreload")) {
            reloadConfig(); // Reload from disk
            loadUserCache(); // Reload cache

            lastDataHash.clear(); // Clear cache
            dirtyPlayers.clear();

            // Re-evaluate storage type on reload
            String configType = getConfig().getString("storage-type", "mysql");
            if (configType != null && configType.equalsIgnoreCase("redis")) {
                if (!isRedisMode) { // Switched to Redis
                    isRedisMode = true;
                    try {
                        if (primaryStorage != null) primaryStorage.shutdown();
                        primaryStorage = new RedisStorage(this);
                        primaryStorage.setup();
                        backupStorage = new MySQLStorage(this);
                        backupStorage.setup();
                    } catch (Exception ignored) {}
                }
                startRedisEngine();
            } else {
                if (isRedisMode) { // Switched to MySQL
                    isRedisMode = false;
                    try {
                        if (primaryStorage != null) primaryStorage.shutdown();
                        if (backupStorage != null) backupStorage.shutdown();
                        primaryStorage = new MySQLStorage(this);
                        primaryStorage.setup();
                        backupStorage = null;
                    } catch (Exception ignored) {}
                }
                startMySQLEngine();
            }

            sender.sendMessage(ChatColor.GREEN + "webstats reloaded. Mode: " + (isRedisMode ? "REDIS Hybrid" : "MYSQL Timer"));

            // Re-broadcast leaderboard config after reload
            broadcastLeaderboardConfig();

            // Force update everyone
            if (!Bukkit.getOnlinePlayers().isEmpty()) {
                Bukkit.getOnlinePlayers().forEach(p -> processPlayerUpdate(p, true));
                sender.sendMessage(ChatColor.GREEN + "Forced data sync to both Hot & Cold storage for all operatives.");
            }
            return true;
        }

        if (command.getName().equalsIgnoreCase("wspurge")) {
            if (!sender.hasPermission("webstats.purge")) {
                sender.sendMessage(ChatColor.RED + "No permission.");
                return true;
            }
            sender.sendMessage(ChatColor.RED + "Purging database... expect a small lag spike.");
            Bukkit.getScheduler().runTaskAsynchronously(this, () -> {
                if (primaryStorage != null) primaryStorage.purgeAllData();
                if (backupStorage != null && isRedisMode) backupStorage.purgeAllData();
                lastDataHash.clear(); // Clear cache so everything re-saves
                sender.sendMessage(ChatColor.GREEN + "Database Purge Complete.");
            });
            return true;
        }

        if (command.getName().equalsIgnoreCase("ws")) {
            if (args.length > 0 && args[0].equalsIgnoreCase("debug")) {
                if (!sender.hasPermission("webstats.admin")) return true;
                
                Player target = (args.length > 1) ? Bukkit.getPlayer(args[1]) : (sender instanceof Player ? (Player) sender : null);
                
                if (target == null) {
                    sender.sendMessage(ChatColor.RED + "Specify an online player.");
                    return true;
                }

                sender.sendMessage(ChatColor.YELLOW + "Manually triggering DEBUG update for " + target.getName() + "...");
                processPlayerUpdate(target, true);
                sender.sendMessage(ChatColor.GREEN + "Pushed profile to both hot and cold storage.");
                return true;
            }
        }
        return false;
    }

    // --- DATA GATHERING UTILITIES ---

    private int calculateProfileHash(PlayerProfile p) {
        int result = 1;
        for (StatEntry s : p.stats) result = 31 * result + (s.valueClean != null ? s.valueClean.hashCode() : 0);
        for (BarEntry b : p.bars) result = 31 * result + (b.value != null ? b.value.hashCode() : 0);
        for (InventoryEntry i : p.inventory) {
            result = 31 * result + i.slot + (i.type != null ? i.type.hashCode() : 0) + i.amount;
        }
        result = 31 * result + p.heldSlot;
        return result;
    }

    private PlayerProfile gatherPlayerData(Player player) {
        // PlayerProfile NO LONGER USES UUID
        PlayerProfile profile = new PlayerProfile(player.getName());

        // A. Stats
        ConfigurationSection statsSec = getConfig().getConfigurationSection("placeholders");
        ConfigurationSection defsSec = getConfig().getConfigurationSection("definers");

        if (statsSec != null) {
            for (String key : statsSec.getKeys(false)) {
                try {
                    int sectionIndex = Integer.parseInt(key);
                    String sectionTitleRaw = statsSec.getString(key + ".section_title", "Section " + key);
                    String sectionTitleHtml = convertMinecraftColorsToHTML(PlaceholderAPI.setPlaceholders(player, sectionTitleRaw));

                    List<String> phs = statsSec.getStringList(key + ".phs");
                    List<String> tags = defsSec.getStringList(key + ".tags");

                    for (int i = 0; i < phs.size(); i++) {
                        String rawPh = phs.get(i);
                        String filledPh = PlaceholderAPI.setPlaceholders(player, rawPh);
                        String tag = (i < tags.size()) ? tags.get(i) : "";

                        String valHtml = convertMinecraftColorsToHTML(filledPh);
                        String valClean = ChatColor.stripColor(ChatColor.translateAlternateColorCodes('&', filledPh));

                        String defHtml = convertMinecraftColorsToHTML(tag);
                        String defClean = ChatColor.stripColor(ChatColor.translateAlternateColorCodes('&', tag));

                        String titleEntry = (i == 0) ? sectionTitleHtml : null;

                        profile.stats.add(new StatEntry(rawPh, valHtml, valClean, defHtml, defClean, sectionIndex, titleEntry, i));
                    }
                } catch (NumberFormatException ignored) {}
            }
        }

        // B. Bars
        ConfigurationSection barsPh = getConfig().getConfigurationSection("bars_placeholders");
        ConfigurationSection barsTags = getConfig().getConfigurationSection("bars_definers");
        ConfigurationSection barsMax = getConfig().getConfigurationSection("bars_max_values");

        if (barsPh != null) {
            List<String> phs = barsPh.getStringList("phs");
            List<String> tags = (barsTags != null) ? barsTags.getStringList("tags") : null;
            List<String> maxVals = (barsMax != null) ? barsMax.getStringList("values") : null;

            for (int i = 0; i < phs.size(); i++) {
                String rawPh = phs.get(i);
                String val = PlaceholderAPI.setPlaceholders(player, rawPh);
                String tag = (tags != null && i < tags.size()) ? tags.get(i) : "bar_" + i;

                String maxRaw = (maxVals != null && i < maxVals.size()) ? maxVals.get(i) : "100";
                String maxVal = PlaceholderAPI.setPlaceholders(player, maxRaw);

                profile.bars.add(new BarEntry(rawPh, val, maxVal, tag, i));
            }
        }

        // C. Inventory (With Texture Extraction)
        ItemStack[] items = player.getInventory().getContents();
        for (int i = 0; i < items.length; i++) {
            if (items[i] != null && !items[i].getType().isAir()) {
                // Get Smart Texture URL
                String texture = getSmartItemTexture(items[i]);

                profile.inventory.add(new InventoryEntry(
                        i,
                        items[i].getType().toString(),
                        items[i].getAmount(),
                        texture,
                        getItemTooltip(items[i])
                ));
            }
        }

        // NOTE: getContents() on modern Paper/Spigot returns ALL 41 slots (0-40),
        // including the offhand at index 40. Do NOT add slot 40 again manually —
        // that causes a duplicate PK crash in MySQL (player_name, slot).

        profile.heldSlot = player.getInventory().getHeldItemSlot();
        return profile;
    }

    /**
     * Extracts the RAW Texture URL from the head.
     * Returns a standard "custom_head:<HASH>" string or a full URL.
     */
    private String getSmartItemTexture(ItemStack item) {
        if (item == null || item.getType() == Material.AIR) return "";

        if (item.getType() == Material.PLAYER_HEAD || item.getType() == Material.PLAYER_WALL_HEAD) {
            
            boolean debug = getConfig().getBoolean("debug", false);
            if (debug) Bukkit.getLogger().info("[Webstats Debug] Processing HEAD item...");
            try {
                 if (debug) Bukkit.getLogger().info("[Webstats Debug] Raw NBT: " + new NBTItem(item).toString());
            } catch (Exception e) {}

            if (item.getItemMeta() instanceof SkullMeta meta) {
                
                // 1. Spigot 1.18+ API check for injected Profiles (Bypasses NBT limits, works with XSeries in 1.21+)
                try {
                    org.bukkit.profile.PlayerProfile profile = meta.getOwnerProfile();
                    if (profile != null && profile.getTextures() != null) {
                        java.net.URL url = profile.getTextures().getSkin();
                        if (url != null) {
                            String fullUrl = url.toString();
                            String textureId = fullUrl.substring(fullUrl.lastIndexOf('/') + 1);
                            return "custom_head:" + textureId;
                        }
                    }
                } catch (Throwable e) {
                    if (debug) Bukkit.getLogger().info("[Webstats Debug] API profile failed: " + e.getMessage());
                }

                // 2. Fallback: try raw NBT parsing (for older items or specific formats)
                try {
                    NBTItem nbti = new NBTItem(item);
                    if (nbti.hasTag("SkullOwner")) {
                        NBTCompound skullOwner = nbti.getCompound("SkullOwner");
                        if (skullOwner != null && skullOwner.hasTag("Properties")) {
                            NBTCompound props = skullOwner.getCompound("Properties");
                            if (props != null && props.hasTag("textures")) {
                                NBTCompoundList textures = props.getCompoundList("textures");
                                if (!textures.isEmpty()) {
                                    String b64 = textures.get(0).getString("Value");
                                    String decoded = new String(java.util.Base64.getDecoder().decode(b64));
                                    java.util.regex.Matcher m = java.util.regex.Pattern.compile("url\":\\s*\"(http[^\"]+)").matcher(decoded);
                                    if (m.find()) {
                                        String url = m.group(1);
                                        return "custom_head:" + url.substring(url.lastIndexOf('/') + 1);
                                    }
                                }
                            }
                        }
                        // Alternate string NBT tag
                        String stringOwner = nbti.getString("SkullOwner");
                        if (stringOwner != null && !stringOwner.isEmpty() && stringOwner.matches("[a-zA-Z0-9_]{3,16}")) {
                            if (!stringOwner.equals("XSeries")) return "https://api.mineatar.io/head/" + stringOwner + "?scale=16";
                        }
                    }
                } catch (Throwable ignored) {}

                // 3. Fallback: standard player head name
                if (meta.hasOwner()) {
                    String name = null;
                    if (meta.getOwningPlayer() != null) name = meta.getOwningPlayer().getName();
                    else if (meta.getOwner() != null) name = meta.getOwner();
                    
                    if (name != null) {
                        // Block libraries dummy names that bypass rate limits
                        if (name.equals("XSeries") || name.equalsIgnoreCase("CS-CoreLib")) {
                            return "custom_head:unknown";
                        }
                        if (name.matches("[a-zA-Z0-9_]{1,16}")) {
                            return "https://api.mineatar.io/head/" + name + "?scale=16";
                        }
                    }
                }
            }
            return "custom_head:unknown";
        }

        // 3. Standard Item
        String cleanName = item.getType().name().toLowerCase();
        if (cleanName.startsWith("minecraft:")) cleanName = cleanName.substring(10);
        return "https://mc.nerothe.com/img/1.21.8/minecraft_" + cleanName + ".png";
    }

    private String capitalizeWords(String input) {
        String[] words = input.split(" ");
        StringBuilder capitalized = new StringBuilder();
        for (String word : words) {
            if (!word.isEmpty()) {
                capitalized.append(Character.toUpperCase(word.charAt(0)))
                        .append(word.substring(1)).append(" ");
            }
        }
        return capitalized.toString().trim();
    }

    private String getItemTooltip(ItemStack item) {
        StringBuilder tooltip = new StringBuilder();
        if (item.hasItemMeta()) {
            ItemMeta meta = item.getItemMeta();
            if (meta.hasDisplayName()) {
                tooltip.append(meta.getDisplayName()).append("\n");
            } else {
                String defaultName = item.getType().toString().replace("_", " ").toLowerCase();
                tooltip.append(capitalizeWords(defaultName)).append("\n");
            }
            if (meta.hasEnchants()) {
                Map<Enchantment, Integer> enchants = meta.getEnchants();
                for (Map.Entry<Enchantment, Integer> entry : enchants.entrySet()) {
                    String enchName = entry.getKey().getKey().getKey().replace("_", " ").toLowerCase();
                    enchName = capitalizeWords(enchName);
                    tooltip.append("&7").append(enchName).append(" ").append(entry.getValue()).append("\n");
                }
            }
            if (meta.hasLore()) {
                for (String loreLine : meta.getLore()) {
                    tooltip.append(loreLine).append("\n");
                }
            }
        } else {
            String defaultName = item.getType().toString().replace("_", " ").toLowerCase();
            tooltip.append(capitalizeWords(defaultName));
        }
        return convertMinecraftColorsToHTML(tooltip.toString().trim().replace("\n", "<br>"));
    }

    // --- COLOR CONVERSION LOGIC ---

// --- COLOR CONVERSION LOGIC (SECURE VERSION) ---

    private String convertMinecraftColorsToHTML(String text) {
        if (text == null || text.isEmpty()) return "";

        // Normalize & -> § and <br> -> \n
        text = AMPERSAND_PATTERN.matcher(text).replaceAll("§$1");
        text = text.replace("<br>", "\n");

        StringBuilder sb = new StringBuilder();
        Deque<String> openSpans = new ArrayDeque<>();
        int len = text.length();

        for (int i = 0; i < len; i++) {
            char c = text.charAt(i);

            // Handle Line Breaks (Reset Formatting)
            if (c == '\n') {
                closeAllSpans(sb, openSpans);
                sb.append("<br>");
                continue;
            }

            // Handle Color Codes
            if (c == '§' && i + 1 < len) {
                char code = Character.toLowerCase(text.charAt(i + 1));

                // Hex Codes (§x§r§r§g§g§b§b)
                if (code == 'x' && i + 13 < len && isValidHexSequence(text, i)) {
                    closeAllSpans(sb, openSpans); // Reset previous
                    String hex = extractHex(text, i);
                    sb.append("<span style='color:#").append(hex).append("'>");
                    openSpans.push("</span>");
                    i += 13; // Skip sequence
                    continue;
                }

                // Standard Colors
                if (isColor(code)) {
                    closeAllSpans(sb, openSpans); // Reset previous
                    sb.append(getColorSpan(code));
                    openSpans.push("</span>");
                    i++;
                    continue;
                }

                // Formatting (Bold, Italic, etc.)
                if (isFormat(code)) {
                    sb.append(getFormatSpan(code));
                    openSpans.push("</span>");
                    i++;
                    continue;
                }

                // Reset
                if (code == 'r') {
                    closeAllSpans(sb, openSpans);
                    i++;
                    continue;
                }
            }

            // --- SECURITY FIX STARTS HERE ---
            // Instead of just sb.append(c), we escape dangerous characters.
            switch (c) {
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#39;"); break;
                case '&': sb.append("&amp;"); break;
                default: sb.append(c);
            }
            // --- SECURITY FIX ENDS HERE ---
        }

        closeAllSpans(sb, openSpans);
        return sb.toString();
    }

    // --- HTML CONVERSION HELPERS ---

    private void closeAllSpans(StringBuilder sb, Deque<String> openSpans) {
        while (!openSpans.isEmpty()) sb.append(openSpans.pop());
    }

    private boolean isValidHexSequence(String text, int index) {
        for (int j = 2; j <= 12; j += 2) {
            if (text.charAt(index + j) != '§') return false;
            if (!isHexChar(text.charAt(index + j + 1))) return false;
        }
        return true;
    }

    private String extractHex(String text, int index) {
        return "" + text.charAt(index + 3) + text.charAt(index + 5) +
                text.charAt(index + 7) + text.charAt(index + 9) +
                text.charAt(index + 11) + text.charAt(index + 13);
    }

    private boolean isHexChar(char c) {
        return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F');
    }

    private boolean isColor(char code) {
        return (code >= '0' && code <= '9') || (code >= 'a' && code <= 'f');
    }

    private boolean isFormat(char code) {
        return code == 'k' || code == 'l' || code == 'm' || code == 'n' || code == 'o';
    }

    private String getColorSpan(char code) {
        switch (code) {
            case '0': return "<span style='color:#000000'>";
            case '1': return "<span style='color:#0000AA'>";
            case '2': return "<span style='color:#00AA00'>";
            case '3': return "<span style='color:#00AAAA'>";
            case '4': return "<span style='color:#AA0000'>";
            case '5': return "<span style='color:#AA00AA'>";
            case '6': return "<span style='color:#FFAA00'>";
            case '7': return "<span style='color:#AAAAAA'>";
            case '8': return "<span style='color:#555555'>";
            case '9': return "<span style='color:#5555FF'>";
            case 'a': return "<span style='color:#55FF55'>";
            case 'b': return "<span style='color:#55FFFF'>";
            case 'c': return "<span style='color:#FF5555'>";
            case 'd': return "<span style='color:#FF55FF'>";
            case 'e': return "<span style='color:#FFFF55'>";
            case 'f': return "<span style='color:#FFFFFF'>";
            default: return "";
        }
    }

    private String getFormatSpan(char code) {
        switch (code) {
            case 'l': return "<span style='font-weight:bold;'>";
            case 'n': return "<span style='text-decoration:underline;'>";
            case 'o': return "<span style='font-style:italic;'>";
            case 'm': return "<span style='text-decoration:line-through;'>";
            case 'k': return "<span class='obfuscated'>"; // Handle via CSS if needed
            default: return "";
        }
    }
}