package dao;

import model.Booking;
import model.User;
import model.Vehicle;
import model.WashService;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public List<Booking> searchBookings(String search, String status, String date) {
        String sql =
            "SELECT b.id, b.user_id, b.vehicle_id, b.service_id, " +
            "b.booking_date, b.time_slot, b.booking_status, b.payment_status, " +
            "b.payment_method, b.total_amount, b.points_earned, b.notes, " +
            "b.created_at, b.completed_at, " +
            "u.username, u.fullname, u.phone, " +
            "v.license_plate, v.brand, v.model, v.color, " +
            "ws.name AS service_name, ws.price AS service_price, ws.duration_minutes " +
            "FROM bookings b " +
            "JOIN users u ON b.user_id = u.id " +
            "JOIN vehicles v ON b.vehicle_id = v.id " +
            "JOIN wash_services ws ON b.service_id = ws.id " +
            "WHERE (? IS NULL OR CAST(b.id AS VARCHAR) LIKE ? OR u.fullname LIKE ? OR u.username LIKE ? OR v.license_plate LIKE ?) " +
            "AND (? IS NULL OR b.booking_status = ?) " +
            "AND (? IS NULL OR CAST(b.booking_date AS DATE) = ?) " +
            "ORDER BY b.created_at DESC";

        String likeSearch = (search == null || search.trim().isEmpty()) ? null : "%" + search.trim() + "%";
        String statusVal  = (status == null || status.trim().isEmpty()) ? null : status.trim();
        String dateVal    = (date == null || date.trim().isEmpty()) ? null : date.trim();

        List<Booking> list = new ArrayList<>();
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, likeSearch);
            ps.setString(2, likeSearch);
            ps.setString(3, likeSearch);
            ps.setString(4, likeSearch);
            ps.setString(5, likeSearch);
            ps.setString(6, statusVal);
            ps.setString(7, statusVal);
            ps.setString(8, dateVal);
            ps.setString(9, dateVal);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Error searching bookings: " + e.getMessage(), e);
        }
        return list;
    }

    public Booking findById(int id) {
        String sql =
            "SELECT b.id, b.user_id, b.vehicle_id, b.service_id, " +
            "b.booking_date, b.time_slot, b.booking_status, b.payment_status, " +
            "b.payment_method, b.total_amount, b.points_earned, b.notes, " +
            "b.created_at, b.completed_at, " +
            "u.username, u.fullname, u.phone, " +
            "v.license_plate, v.brand, v.model, v.color, " +
            "ws.name AS service_name, ws.price AS service_price, ws.duration_minutes " +
            "FROM bookings b " +
            "JOIN users u ON b.user_id = u.id " +
            "JOIN vehicles v ON b.vehicle_id = v.id " +
            "JOIN wash_services ws ON b.service_id = ws.id " +
            "WHERE b.id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding booking by id: " + e.getMessage(), e);
        }
        return null;
    }

    public void updateStatus(int id, String newStatus) {
        String sql = "UPDATE bookings SET booking_status = ? WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating booking status: " + e.getMessage(), e);
        }
    }

    public void updateStatusCompleted(int id) {
        String sql = "UPDATE bookings SET booking_status = 'COMPLETED', completed_at = GETDATE() WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error completing booking: " + e.getMessage(), e);
        }
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE booking_status = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting bookings by status: " + e.getMessage(), e);
        }
        return 0;
    }

    public double sumRevenue() {
        String sql = "SELECT ISNULL(SUM(total_amount), 0) FROM bookings WHERE payment_status = 'PAID'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            throw new RuntimeException("Error summing revenue: " + e.getMessage(), e);
        }
        return 0;
    }

    public int countTodayBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE CAST(booking_date AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            throw new RuntimeException("Error counting today bookings: " + e.getMessage(), e);
        }
        return 0;
    }

    private Booking mapRow(ResultSet rs) throws Exception {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setUserId(rs.getInt("user_id"));
        b.setVehicleId(rs.getInt("vehicle_id"));
        b.setServiceId(rs.getInt("service_id"));
        b.setBookingDate(rs.getString("booking_date"));
        b.setTimeSlot(rs.getString("time_slot"));
        b.setBookingStatus(rs.getString("booking_status"));
        b.setPaymentStatus(rs.getString("payment_status"));
        b.setPaymentMethod(rs.getString("payment_method"));
        b.setTotalAmount(rs.getDouble("total_amount"));
        b.setPointsEarned(rs.getInt("points_earned"));
        b.setNotes(rs.getString("notes"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setCompletedAt(rs.getTimestamp("completed_at"));

        User u = new User();
        u.setUsername(rs.getString("username"));
        u.setFullname(rs.getString("fullname"));
        u.setPhone(rs.getString("phone"));
        b.setUser(u);

        Vehicle v = new Vehicle();
        v.setLicensePlate(rs.getString("license_plate"));
        v.setBrand(rs.getString("brand"));
        v.setModel(rs.getString("model"));
        v.setColor(rs.getString("color"));
        b.setVehicle(v);

        WashService ws = new WashService();
        ws.setName(rs.getString("service_name"));
        ws.setPrice(rs.getDouble("service_price"));
        ws.setDurationMinutes(rs.getInt("duration_minutes"));
        b.setService(ws);

        return b;
    }
}
