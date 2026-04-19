package webstats.model;

public class BarEntry {
    public String name;
    public String value;
    public String maxValue;
    public String definer;
    public int orderIndex;

    public BarEntry(String name, String value, String maxValue, String definer, int orderIndex) {
        this.name = name;
        this.value = value;
        this.maxValue = maxValue;
        this.definer = definer;
        this.orderIndex = orderIndex;
    }
}