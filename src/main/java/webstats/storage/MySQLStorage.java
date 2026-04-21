package webstats.storage;

import webstats.webstats;
import webstats.model.*;
import java.sql.*;

public class MySQLStorage implements StorageProvider {
    private final webstats plugin;
    private Connection connection;

    public MySQLStorage(webstats plugin) {
        this.plugin = plugin;
    }

    @Override
    public void setup() throws SQLException {
        String host = plugin.getConfig().getString("mysql.host");
        String port = plugin.getConfig().getString("mysql.port");
        String db = plugin.getConfig().getString("mysql.database");
        String user = plugin.getConfig().getString("mysql.username");
        String pass = plugin.getConfig().getString("mysql.password");

        // NOTE: autoReconnect=true is intentionally omitted. It silently resets
        // autoCommit=true on reconnect, breaking transactions without throwing an error.
        // ensureConnection() handles stale connections safely instead.
        String url = "jdbc:mysql://" + host + ":" + port + "/" + db
                + "?useSSL=false&allowPublicKeyRetrieval=true"
                + "&connectionTimeout=5000&socketTimeout=30000";
        connection = DriverManager.getConnection(url, user, pass);
        createTables();
    }

    private void ensureConnection() throws SQLException {
        if (connection == null || connection.isClosed() || !connection.isValid(2)) setup();
    }

    private void createTables() throws SQLException {
        try (Statement stmt = connection.createStatement()) {
            // Using player_name as Primary Key
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS player_stats (player_name VARCHAR(64) NOT NULL, placeholder_name TEXT, placeholder_value TEXT, placeholder_value_clean TEXT, placeholder_definer TEXT, placeholder_definer_clean TEXT, section_index INT, section_title TEXT, order_index INT, last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (player_name, section_index, order_index))");
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS progressive_bars (player_name VARCHAR(64) NOT NULL, placeholder_name TEXT, placeholder_value TEXT, placeholder_max TEXT, placeholder_definer TEXT, order_index INT, last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (player_name, order_index))");
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS player_inventories (player_name VARCHAR(64) NOT NULL, slot INT NOT NULL, item_type VARCHAR(255), item_amount INT, item_texture TEXT, item_tooltip TEXT, last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (player_name, slot))");
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS player_profiles (player_name VARCHAR(64) PRIMARY KEY, held_slot INT DEFAULT 0, last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)");
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS player_searches (player_name VARCHAR(64) PRIMARY KEY, search_count INT DEFAULT 0)");
        }
    }

    @Override
    public void shutdown() {
        try { if (connection != null) connection.close(); } catch (SQLException ignored) {}
    }

    @Override
    public synchronized void saveProfile(PlayerProfile p) {
        try {
            ensureConnection();
            connection.setAutoCommit(false);

            // 1. ATOMIC DELETE: Clear previous state entirely.
            // Since autoCommit=false, website users will NOT see an empty state because MySQL
            // uses Read-Committed isolation; they will see the old data until commit() fires below.
            try (PreparedStatement psDelStats = connection.prepareStatement("DELETE FROM player_stats WHERE player_name = ?");
                 PreparedStatement psDelBars = connection.prepareStatement("DELETE FROM progressive_bars WHERE player_name = ?");
                 PreparedStatement psDelInv = connection.prepareStatement("DELETE FROM player_inventories WHERE player_name = ?")) {
                 
                psDelStats.setString(1, p.name); psDelStats.executeUpdate();
                psDelBars.setString(1, p.name); psDelBars.executeUpdate();
                psDelInv.setString(1, p.name); psDelInv.executeUpdate();
            }

            // 2. Stats: Insert fresh state
            if (!p.stats.isEmpty()) {
                try (PreparedStatement ps = connection.prepareStatement(
                        "INSERT INTO player_stats (player_name, placeholder_name, placeholder_value, placeholder_value_clean, " +
                        "placeholder_definer, placeholder_definer_clean, section_index, section_title, order_index) " +
                        "VALUES (?,?,?,?,?,?,?,?,?)")) {
                    for (StatEntry s : p.stats) {
                        ps.setString(1, p.name); ps.setString(2, s.name); ps.setString(3, s.valueHtml); ps.setString(4, s.valueClean); ps.setString(5, s.definer); ps.setString(6, s.definerClean); ps.setInt(7, s.sectionIndex); ps.setString(8, s.sectionTitle); ps.setInt(9, s.orderIndex);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            // 3. Bars: Insert fresh state
            if (!p.bars.isEmpty()) {
                try (PreparedStatement ps = connection.prepareStatement(
                        "INSERT INTO progressive_bars (player_name, placeholder_name, placeholder_value, placeholder_max, placeholder_definer, order_index) " +
                        "VALUES (?,?,?,?,?,?)")) {
                    for (BarEntry b : p.bars) {
                        ps.setString(1, p.name); ps.setString(2, b.name); ps.setString(3, b.value); ps.setString(4, b.maxValue); ps.setString(5, b.definer); ps.setInt(6, b.orderIndex);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            // 4. Inventory: Insert fresh state
            if (!p.inventory.isEmpty()) {
                java.util.Set<Integer> seenSlots = new java.util.HashSet<>();
                try (PreparedStatement ps = connection.prepareStatement(
                        "INSERT INTO player_inventories (player_name, slot, item_type, item_amount, item_texture, item_tooltip) " +
                        "VALUES (?,?,?,?,?,?)")) {
                    for (InventoryEntry i : p.inventory) {
                        // Prevent identical slots crashing the batch if other plugins duplicate things
                        if (seenSlots.contains(i.slot)) continue;
                        seenSlots.add(i.slot);

                        ps.setString(1, p.name); ps.setInt(2, i.slot); ps.setString(3, i.type); ps.setInt(4, i.amount); ps.setString(5, i.texture); ps.setString(6, i.tooltip);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            // 5. Profile Metadata (Held Slot)
            try (PreparedStatement ps = connection.prepareStatement(
                    "INSERT INTO player_profiles (player_name, held_slot) VALUES (?, ?) " +
                    "ON DUPLICATE KEY UPDATE held_slot = ?")) {
                ps.setString(1, p.name);
                ps.setInt(2, p.heldSlot);
                ps.setInt(3, p.heldSlot);
                ps.executeUpdate();
            }

            connection.commit();
            connection.setAutoCommit(true);
            System.out.println("[webstats] Successfully saved profile: " + p.name);
        } catch (SQLException e) {
            try { if (connection != null) connection.rollback(); } catch (SQLException ignored) {}
            System.err.println("[webstats] MySQL saveProfile failed for " + p.name + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public synchronized void updateUsername(String oldName, String newName) {
        try {
            ensureConnection();
            // Rename data in all tables
            updateTableUser(oldName, newName, "player_stats");
            updateTableUser(oldName, newName, "progressive_bars");
            updateTableUser(oldName, newName, "player_inventories");
            updateTableUser(oldName, newName, "player_profiles");
            updateTableUser(oldName, newName, "player_searches");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateTableUser(String oldName, String newName, String table) throws SQLException {
        // IGNORE prevents error if newName already has some partial data (it will just keep the old stuff)
        String sql = "UPDATE IGNORE " + table + " SET player_name = ? WHERE player_name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setString(2, oldName);
            ps.executeUpdate();
        }
        // Cleanup remaining old data (if any was left due to conflict)
        try (PreparedStatement ps = connection.prepareStatement("DELETE FROM " + table + " WHERE player_name = ?")) {
            ps.setString(1, oldName);
            ps.executeUpdate();
        }
    }

    @Override
    public synchronized void deleteData(String playerName) {
        try {
            ensureConnection();
            try (Statement stmt = connection.createStatement()) {
                stmt.executeUpdate("DELETE FROM player_stats WHERE player_name = '" + playerName + "'");
                stmt.executeUpdate("DELETE FROM progressive_bars WHERE player_name = '" + playerName + "'");
                stmt.executeUpdate("DELETE FROM player_inventories WHERE player_name = '" + playerName + "'");
                stmt.executeUpdate("DELETE FROM player_searches WHERE player_name = '" + playerName + "'");
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public synchronized void incrementSearch(String playerName) {
        try {
            ensureConnection();
            try (PreparedStatement ps = connection.prepareStatement("INSERT INTO player_searches (player_name, search_count) VALUES (?, 1) ON DUPLICATE KEY UPDATE search_count = search_count + 1")) {
                ps.setString(1, playerName);
                ps.executeUpdate();
            }
            if (plugin.getConfig().getBoolean("debug", false)) {
                System.out.println("[webstats] Incremented search for: " + playerName);
            }
        } catch (SQLException e) {
            System.err.println("[webstats] MySQL incrementSearch failed: " + e.getMessage());
        }
    }

    @Override
    public synchronized void purgeAllData() {
        try {
            ensureConnection();
            try (Statement stmt = connection.createStatement()) {
                stmt.executeUpdate("TRUNCATE TABLE player_stats");
                stmt.executeUpdate("TRUNCATE TABLE progressive_bars");
                stmt.executeUpdate("TRUNCATE TABLE player_inventories");
                stmt.executeUpdate("TRUNCATE TABLE player_searches");
            }
        } catch (SQLException e) {}
    }
}