package model;

import java.util.Date;

public class LoyaltyHistory {
    private int id;
    private int userId;
    private int pointsChanged;
    private int pointsRemaining;
    private String reason;
    private Date createdAt;
    private Date expiresAt;

    public LoyaltyHistory() {
    }

    public LoyaltyHistory(int id, int userId, int pointsChanged, int pointsRemaining, String reason, Date createdAt, Date expiresAt) {
        this.id = id;
        this.userId = userId;
        this.pointsChanged = pointsChanged;
        this.pointsRemaining = pointsRemaining;
        this.reason = reason;
        this.createdAt = createdAt;
        this.expiresAt = expiresAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getPointsChanged() {
        return pointsChanged;
    }

    public void setPointsChanged(int pointsChanged) {
        this.pointsChanged = pointsChanged;
    }

    public int getPointsRemaining() {
        return pointsRemaining;
    }

    public void setPointsRemaining(int pointsRemaining) {
        this.pointsRemaining = pointsRemaining;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Date expiresAt) {
        this.expiresAt = expiresAt;
    }

    @Override
    public String toString() {
        return "LoyaltyHistory{" +
                "id=" + id +
                ", userId=" + userId +
                ", pointsChanged=" + pointsChanged +
                ", pointsRemaining=" + pointsRemaining +
                ", reason='" + reason + '\'' +
                ", createdAt=" + createdAt +
                ", expiresAt=" + expiresAt +
                '}';
    }
}
