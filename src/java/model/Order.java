package model;

import java.io.Serializable;
import java.util.Date;

public class Order implements Serializable {
    private int id;
    private int userId;
    private int serviceId;
    private Integer promotionId;
    private String carPlate;
    private Date bookDate;
    private String status; // PENDING, COMPLETED, CANCELLED
    private int pointsUsed;
    private double finalPrice;

    // Thông tin bổ sung để hiển thị trên giao diện (join)
    private String serviceName;
    private double servicePrice;
    private String userFullname;
    private String promotionCode;
    private int discountPercent;

    public Order() {}

    public Order(int id, int userId, int serviceId, Integer promotionId, String carPlate, Date bookDate, String status, int pointsUsed, double finalPrice) {
        this.id = id;
        this.userId = userId;
        this.serviceId = serviceId;
        this.promotionId = promotionId;
        this.carPlate = carPlate;
        this.bookDate = bookDate;
        this.status = status;
        this.pointsUsed = pointsUsed;
        this.finalPrice = finalPrice;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public Integer getPromotionId() { return promotionId; }
    public void setPromotionId(Integer promotionId) { this.promotionId = promotionId; }

    public String getCarPlate() { return carPlate; }
    public void setCarPlate(String carPlate) { this.carPlate = carPlate; }

    public Date getBookDate() { return bookDate; }
    public void setBookDate(Date bookDate) { this.bookDate = bookDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getPointsUsed() { return pointsUsed; }
    public void setPointsUsed(int pointsUsed) { this.pointsUsed = pointsUsed; }

    public double getFinalPrice() { return finalPrice; }
    public void setFinalPrice(double finalPrice) { this.finalPrice = finalPrice; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public double getServicePrice() { return servicePrice; }
    public void setServicePrice(double servicePrice) { this.servicePrice = servicePrice; }

    public String getUserFullname() { return userFullname; }
    public void setUserFullname(String userFullname) { this.userFullname = userFullname; }

    public String getPromotionCode() { return promotionCode; }
    public void setPromotionCode(String promotionCode) { this.promotionCode = promotionCode; }

    public int getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }
}
