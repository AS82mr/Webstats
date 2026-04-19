package webstats.model;

import java.util.ArrayList;
import java.util.List;

public class PlayerProfile {
    public String name;
    public long lastUpdated;

    public List<StatEntry> stats = new ArrayList<>();
    public List<BarEntry> bars = new ArrayList<>();
    public List<InventoryEntry> inventory = new ArrayList<>();

    public PlayerProfile(String name) {
        this.name = name;
        this.lastUpdated = System.currentTimeMillis();
    }
}