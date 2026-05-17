package model;

import java.io.Serializable;
import java.util.Date;

public class Order implements Serializable {
    private int id;
    private int userId;
    private int serviceId;
    private String carPlate;
    private Date bookDate;
    private String status; // PENDING, COMPLETED, CANCELLED

    // Thông tin bổ sung để hiển thị trên giao diện (join)
    private String serviceName;
    private double servicePrice;
    private String userFullname;

    public Order() {}

    public Order(int id, int userId, int serviceId, String carPlate, Date bookDate, String status) {
        this.id = id;
        this.userId = userId;
        this.serviceId = serviceId;
        this.carPlate = carPlate;
        this.bookDate = bookDate;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public String getCarPlate() { return carPlate; }
    public void setCarPlate(String carPlate) { this.carPlate = carPlate; }

    public Date getBookDate() { return bookDate; }
    public void setBookDate(Date bookDate) { this.bookDate = bookDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public double getServicePrice() { return servicePrice; }
    public void setServicePrice(double servicePrice) { this.servicePrice = servicePrice; }

    public String getUserFullname() { return userFullname; }
    public void setUserFullname(String userFullname) { this.userFullname = userFullname; }
}
