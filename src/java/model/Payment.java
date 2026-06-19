package model;

import java.math.BigDecimal;
import java.util.Date;

public class Payment {
    public static final String UNPAID = "UNPAID";
    public static final String PAID = "PAID";
    public static final String FAILED = "FAILED";
    public static final String CANCELLED = "CANCELLED";

    private int id;
    private int bookingId;
    private int userId;
    private BigDecimal amount;
    private String paymentMethod;
    private String paymentStatus;
    private Date paidAt;
    private Date createdAt;
    private Date updatedAt;

    public Payment() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Date getPaidAt() { return paidAt; }
    public void setPaidAt(Date paidAt) { this.paidAt = paidAt; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
