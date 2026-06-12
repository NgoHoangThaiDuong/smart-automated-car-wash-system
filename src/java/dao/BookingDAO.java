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

    private static final String BASE_SELECT =
        "SELECT b.id, b.user_id, b.vehicle_id, b.service_id, " +
        "       b.booking_date, b.time_slot, b.booking_status, b.payment_status, " +
        "       b.payment_method, b.total_amount, b.points_earned, b.notes, " +
        "       b.created_at, b.completed_at, " +
        "       u.username, u.fullname, u.phone, " +
        "       v.license_plate, v.brand, v.model, v.color, " +
        "       ws.name AS service_name, ws.price AS service_price, ws.duration_minutes " +
        "FROM bookings b " +
        "JOIN users u ON b.user_id = u.id " +
        "JOIN vehicles v ON b.vehicle_id = v.id " +
        "JOIN wash_services ws ON b.service_id = ws.id ";

    public List<Booking> findByFilter(String search, String status, String date) {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(BASE_SELECT + "WHERE 1=1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (CAST(b.id AS VARCHAR) LIKE ? OR u.fullname LIKE ? OR u.username LIKE ? OR v.license_plate LIKE ?) ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND b.booking_status = ? ");
        }
        if (date != null && !date.trim().isEmpty()) {
            sql.append("AND CAST(b.booking_date AS DATE) = ? ");
        }
        sql.append("ORDER BY b.created_at DESC");

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String like = "%" + search.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status.trim());
            }
            if (date != null && !date.trim().isEmpty()) {
                ps.setString(idx++, date.trim());
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error filtering bookings: " + e.getMessage(), e);
        }
        return list;
    }

    public Booking findById(int id) {
        String sql = BASE_SELECT + "WHERE b.id = ?";
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
