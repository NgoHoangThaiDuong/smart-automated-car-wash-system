package model;

public class Promotion {
    private int id;
    private String code;
    private int discountPercent;
    private int minTierId;
    private boolean isActive;

    public Promotion() {
    }

    public Promotion(int id, String code, int discountPercent, int minTierId, boolean isActive) {
        this.id = id;
        this.code = code;
        this.discountPercent = discountPercent;
        this.minTierId = minTierId;
        this.isActive = isActive;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(int discountPercent) {
        this.discountPercent = discountPercent;
    }

    public int getMinTierId() {
        return minTierId;
    }

    public void setMinTierId(int minTierId) {
        this.minTierId = minTierId;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "Promotion{" +
                "id=" + id +
                ", code='" + code + '\'' +
                ", discountPercent=" + discountPercent +
                ", minTierId=" + minTierId +
                ", isActive=" + isActive +
                '}';
    }
}
