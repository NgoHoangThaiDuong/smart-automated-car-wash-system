package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Payment;
import model.PaymentDetail;
import mylib.DBUtils;

public class PaymentDAO {

    public Payment getPaymentByBookingId(int bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id=?";
        try (Connection con = DBUtils.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Payment payment = new Payment();
                payment.setId(rs.getInt("id"));
                payment.setBookingId(rs.getInt("booking_id"));
                payment.setUserId(rs.getInt("user_id"));
                payment.setAmount(rs.getBigDecimal("amount"));
                payment.setPaymentMethod(rs.getString("payment_method"));
                payment.setPaymentStatus(rs.getString("payment_status"));
                payment.setPaidAt(rs.getTimestamp("paid_at"));
                payment.setCreatedAt(rs.getTimestamp("created_at"));
                payment.setUpdatedAt(rs.getTimestamp("updated_at"));
                return payment;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePayment(int bookingId, String paymentMethod) {
        String sql = "UPDATE payments "
                + "SET payment_status=?, "
                + "payment_method=?, "
                + "paid_at=GETDATE(), "
                + "updated_at=GETDATE() "
                + "WHERE booking_id=?";
        try (Connection con = DBUtils.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, Payment.PAID);
            ps.setString(2, paymentMethod);
            ps.setInt(3, bookingId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public PaymentDetail getPaymentDetail(int bookingId) {
        String sql = "SELECT "
                + "p.booking_id, p.amount, p.payment_method, p.payment_status, "
                + "u.fullname, u.phone, "
                + "v.brand, v.model, v.license_plate, "
                + "ws.name AS service_name, "
                + "b.booking_date, b.time_slot "
                + "FROM payments p "
                + "JOIN bookings b ON p.booking_id = b.id "
                + "JOIN users u ON b.user_id = u.id "
                + "JOIN vehicles v ON b.vehicle_id = v.id "
                + "JOIN wash_services ws ON b.service_id = ws.id "
                + "WHERE p.booking_id = ?";
        try (Connection con = DBUtils.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PaymentDetail detail = new PaymentDetail();
                detail.setBookingId(rs.getInt("booking_id"));
                detail.setCustomerName(rs.getString("fullname"));
                detail.setPhone(rs.getString("phone"));
                detail.setVehicleBrand(rs.getString("brand"));
                detail.setVehicleModel(rs.getString("model"));
                detail.setLicensePlate(rs.getString("license_plate"));
                detail.setServiceName(rs.getString("service_name"));
                detail.setBookingDate(rs.getString("booking_date"));
                detail.setTimeSlot(rs.getString("time_slot"));
                detail.setAmount(rs.getBigDecimal("amount"));
                detail.setPaymentMethod(rs.getString("payment_method"));
                detail.setPaymentStatus(rs.getString("payment_status"));
                return detail;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
