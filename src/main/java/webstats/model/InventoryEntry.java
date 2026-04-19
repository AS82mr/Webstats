package webstats.model;

public class InventoryEntry {
    public int slot;
    public String type;
    public int amount;
    public String texture;
    public String tooltip;

    public InventoryEntry(int slot, String type, int amount, String texture, String tooltip) {
        this.slot = slot;
        this.type = type;
        this.amount = amount;
        this.texture = texture;
        this.tooltip = tooltip;
    }
}