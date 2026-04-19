package webstats.storage;

import webstats.model.PlayerProfile;

public interface StorageProvider {
    void setup() throws Exception;
    void shutdown();

    void saveProfile(PlayerProfile profile);
    void incrementSearch(String playerName);

    void updateUsername(String oldName, String newName);

    void deleteData(String playerName);
    void purgeAllData();
}