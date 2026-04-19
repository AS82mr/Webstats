package webstats.model;

public class StatEntry {
    public String name;
    public String valueHtml;
    public String valueClean;
    public String definer;
    public String definerClean; // NEW: Clean version of the tag/label
    public int sectionIndex;
    public String sectionTitle;
    public int orderIndex;

    // Updated Constructor with 8 arguments
    public StatEntry(String name, String valueHtml, String valueClean, String definer, String definerClean, int sectionIndex, String sectionTitle, int orderIndex) {
        this.name = name;
        this.valueHtml = valueHtml;
        this.valueClean = valueClean;
        this.definer = definer;
        this.definerClean = definerClean;
        this.sectionIndex = sectionIndex;
        this.sectionTitle = sectionTitle;
        this.orderIndex = orderIndex;
    }
}