package model;

import java.util.Date;

public class User {
    private int id;
    private String username;
    private String password;
    private String fullname;
    private String phone;
    private String role;
    private int tierId;
    private int pointsBalance;
    private double lifetimeSpent;
    private Date createdAt;

    private LoyaltyTier loyaltyTier;

    public User() {
    }

    public User(int id, String username, String password, String fullname, String phone, String role, int tierId, int pointsBalance, double lifetimeSpent, Date createdAt) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.phone = phone;
        this.role = role;
        this.tierId = tierId;
        this.pointsBalance = pointsBalance;
        this.lifetimeSpent = lifetimeSpent;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public int getTierId() {
        return tierId;
    }

    public void setTierId(int tierId) {
        this.tierId = tierId;
    }

    public int getPointsBalance() {
        return pointsBalance;
    }

    public void setPointsBalance(int pointsBalance) {
        this.pointsBalance = pointsBalance;
    }

    public double getLifetimeSpent() {
        return lifetimeSpent;
    }

    public void setLifetimeSpent(double lifetimeSpent) {
        this.lifetimeSpent = lifetimeSpent;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public LoyaltyTier getLoyaltyTier() {
        return loyaltyTier;
    }

    public void setLoyaltyTier(LoyaltyTier loyaltyTier) {
        this.loyaltyTier = loyaltyTier;
    }
}
