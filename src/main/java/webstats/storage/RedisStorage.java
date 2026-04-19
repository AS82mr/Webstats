package webstats.storage;

import com.google.gson.Gson;
import webstats.webstats;
import webstats.model.PlayerProfile;
import redis.clients.jedis.JedisPooled;

public class RedisStorage implements StorageProvider {

    private final webstats plugin;
    private JedisPooled redis;
    private final Gson gson;

    public RedisStorage(webstats plugin) {
        this.plugin = plugin;
        this.gson = new Gson();
    }

    @Override
    public void setup() {
        String host = plugin.getConfig().getString("redis.host", "localhost");
        int port = plugin.getConfig().getInt("redis.port", 6379);
        String pass = plugin.getConfig().getString("redis.password", "");
        if (pass.isEmpty()) redis = new JedisPooled(host, port);
        else redis = new JedisPooled(host, port, null, pass);
    }

    @Override
    public void shutdown() {
        if (redis != null) redis.close();
    }

    @Override
    public void saveProfile(PlayerProfile profile) {
        try {
            String json = gson.toJson(profile);
            int ttl = plugin.getConfig().getInt("redis.ttl", -1);
            String key = "webstats:player:" + profile.name; // Username Key

            if (ttl <= 0) redis.set(key, json);
            else redis.setex(key, ttl, json);
        } catch (Exception e) { e.printStackTrace(); }
    }

    /** Write an arbitrary key-value pair to Redis (e.g. config broadcasts). */
    public void setRaw(String key, String value) {
        try { redis.set(key, value); } catch (Exception e) { e.printStackTrace(); }
    }

    @Override
    public void updateUsername(String oldName, String newName) {
        try {
            String oldKey = "webstats:player:" + oldName;
            String newKey = "webstats:player:" + newName;

            if (redis.exists(oldKey)) {
                // Rename Key (effectively moving the data)
                redis.rename(oldKey, newKey);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    @Override
    public void deleteData(String playerName) {
        try { redis.del("webstats:player:" + playerName); } catch (Exception e) {}
    }

    @Override
    public void incrementSearch(String playerName) {
        try { redis.zincrby("webstats:search_leaderboard", 1, playerName); } catch (Exception ignored) {}
    }

    @Override
    public void purgeAllData() {
        try { redis.flushDB(); } catch (Exception e) {}
    }
}