package dto;

public class CustomerDashboardDTO {
    private String fullname;
    private String username;
    private String tierName;
    private int pointsBalance;
    private double lifetimeSpent;
    private int totalWashes;
    private int vehicleCount;
    private String nextTierName;
    private double nextTierMinSpend;
    private int nextTierMinWashes;
    private double progressPercent;
    private double remainingSpend;
    private int remainingWashes;

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getTierName() { return tierName; }
    public void setTierName(String tierName) { this.tierName = tierName; }
    public int getPointsBalance() { return pointsBalance; }
    public void setPointsBalance(int pointsBalance) { this.pointsBalance = pointsBalance; }
    public double getLifetimeSpent() { return lifetimeSpent; }
    public void setLifetimeSpent(double lifetimeSpent) { this.lifetimeSpent = lifetimeSpent; }
    public int getTotalWashes() { return totalWashes; }
    public void setTotalWashes(int totalWashes) { this.totalWashes = totalWashes; }
    public int getVehicleCount() { return vehicleCount; }
    public void setVehicleCount(int vehicleCount) { this.vehicleCount = vehicleCount; }
    public String getNextTierName() { return nextTierName; }
    public void setNextTierName(String nextTierName) { this.nextTierName = nextTierName; }
    public double getNextTierMinSpend() { return nextTierMinSpend; }
    public void setNextTierMinSpend(double nextTierMinSpend) { this.nextTierMinSpend = nextTierMinSpend; }
    public int getNextTierMinWashes() { return nextTierMinWashes; }
    public void setNextTierMinWashes(int nextTierMinWashes) { this.nextTierMinWashes = nextTierMinWashes; }
    public double getProgressPercent() { return progressPercent; }
    public void setProgressPercent(double progressPercent) { this.progressPercent = progressPercent; }
    public double getRemainingSpend() { return remainingSpend; }
    public void setRemainingSpend(double remainingSpend) { this.remainingSpend = remainingSpend; }
    public int getRemainingWashes() { return remainingWashes; }
    public void setRemainingWashes(int remainingWashes) { this.remainingWashes = remainingWashes; }
}
