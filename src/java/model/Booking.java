package model;

import java.util.Date;

public class Booking {
    private int id;
    private int userId;
    private int vehicleId;
    private int serviceId;
    private String bookingDate;
    private String timeSlot;
    private String bookingStatus;
    private String paymentStatus;
    private String paymentMethod;
    private double totalAmount;
    private int pointsEarned;
    private Date createdAt;
    private Date completedAt;
    private boolean deleted;
    private boolean customerCancellable;
    private boolean customerPayable;

    private User user;
    private Vehicle vehicle;
    private WashService service;
    private Payment payment;

    public Booking() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getFormattedBookingDate() {
        if (bookingDate == null) return "";
        String[] parts = bookingDate.split("-");
        if (parts.length == 3) {
            return parts[2] + "/" + parts[1] + "/" + parts[0];
        }
        return bookingDate;
    }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public int getPointsEarned() { return pointsEarned; }
    public void setPointsEarned(int pointsEarned) { this.pointsEarned = pointsEarned; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getCompletedAt() { return completedAt; }
    public void setCompletedAt(Date completedAt) { this.completedAt = completedAt; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Vehicle getVehicle() { return vehicle; }
    public void setVehicle(Vehicle vehicle) { this.vehicle = vehicle; }

    public WashService getService() { return service; }
    public void setService(WashService service) { this.service = service; }

    public Payment getPayment() { return payment; }
    public void setPayment(Payment payment) { this.payment = payment; }

    public boolean isDeleted() { return deleted; }
    public void setDeleted(boolean deleted) { this.deleted = deleted; }

    public boolean isCustomerCancellable() { return customerCancellable; }
    public void setCustomerCancellable(boolean customerCancellable) {
        this.customerCancellable = customerCancellable;
    }

    public boolean isCustomerPayable() { return customerPayable; }
    public void setCustomerPayable(boolean customerPayable) {
        this.customerPayable = customerPayable;
    }
}
