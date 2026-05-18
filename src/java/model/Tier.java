package model;

public class Tier {
    private int id;
    private String name;
    private double pointMultiplier;
    private int bookingWindowDays;
    private int minWashes;
    private double minSpend;

    public Tier() {
    }

    public Tier(int id, String name, double pointMultiplier, int bookingWindowDays, int minWashes, double minSpend) {
        this.id = id;
        this.name = name;
        this.pointMultiplier = pointMultiplier;
        this.bookingWindowDays = bookingWindowDays;
        this.minWashes = minWashes;
        this.minSpend = minSpend;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPointMultiplier() {
        return pointMultiplier;
    }

    public void setPointMultiplier(double pointMultiplier) {
        this.pointMultiplier = pointMultiplier;
    }

    public int getBookingWindowDays() {
        return bookingWindowDays;
    }

    public void setBookingWindowDays(int bookingWindowDays) {
        this.bookingWindowDays = bookingWindowDays;
    }

    public int getMinWashes() {
        return minWashes;
    }

    public void setMinWashes(int minWashes) {
        this.minWashes = minWashes;
    }

    public double getMinSpend() {
        return minSpend;
    }

    public void setMinSpend(double minSpend) {
        this.minSpend = minSpend;
    }

    @Override
    public String toString() {
        return "Tier{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", pointMultiplier=" + pointMultiplier +
                ", bookingWindowDays=" + bookingWindowDays +
                ", minWashes=" + minWashes +
                ", minSpend=" + minSpend +
                '}';
    }
}
