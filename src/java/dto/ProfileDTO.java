package dto;

import model.User;
import model.LoyaltyTier;

public class ProfileDTO {
    private User user;
    private LoyaltyTier nextTier;
    private double remainingSpend;
    private double progressPercent;

    private String fullname;
    private String phone;

    public ProfileDTO() {}

    public ProfileDTO(User user, LoyaltyTier nextTier, double remainingSpend, double progressPercent) {
        this.user = user;
        this.nextTier = nextTier;
        this.remainingSpend = remainingSpend;
        this.progressPercent = progressPercent;
    }

    public ProfileDTO(String fullname, String phone) {
        this.fullname = fullname;
        this.phone = phone;
    }

    public String validate() {
        if (fullname == null || fullname.trim().isEmpty()) {
            return "Họ và tên không được để trống!";
        }
        if (phone == null || phone.trim().isEmpty()) {
            return "Số điện thoại không được để trống!";
        }
        if (!phone.trim().matches("^0\\d{9}$")) {
            return "Số điện thoại không hợp lệ (phải bắt đầu bằng số 0 và có đúng 10 chữ số)!";
        }
        return null;
    }

    public User getUser() {
        return user;
    }

    public LoyaltyTier getNextTier() {
        return nextTier;
    }

    public double getRemainingSpend() {
        return remainingSpend;
    }

    public double getProgressPercent() {
        return progressPercent;
    }

    public String getFullname() {
        return fullname != null ? fullname.trim() : "";
    }

    public String getPhone() {
        return phone != null ? phone.trim() : "";
    }
}
