package dao;

import model.Booking;
import model.User;
import model.Vehicle;
import model.WashService;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // Dùng chung cho các method cần SELECT TOP hoặc filter user
    private static final String BASE_SELECT =
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
        "JOIN wash_services ws ON b.service_id = ws.id ";

    public List<Booking> searchBookings(String key, String status, String date) {
        String sql = BASE_SELECT +
                "WHERE b.is_deleted = 0 " +
                "AND (? IS NULL OR CAST(b.id AS VARCHAR) LIKE ? OR u.fullname LIKE ? OR u.username LIKE ? OR v.license_plate LIKE ?) " +
                "AND (? IS NULL OR b.booking_status = ?) " +
                "AND (? IS NULL OR CAST(b.booking_date AS DATE) = ?) " +
                "ORDER BY b.created_at DESC";

        String search = (key == null || key.trim().isEmpty()) ? null : "%" + key.trim() + "%";
        String bookingStatus = (status == null || status.trim().isEmpty()) ? null : status.trim();
        String bookingDate = (date == null || date.trim().isEmpty()) ? null : date.trim();

        List<Booking> list = new ArrayList<>();
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, search);
            ps.setString(2, search);
            ps.setString(3, search);
            ps.setString(4, search);
            ps.setString(5, search);
            ps.setString(6, bookingStatus);
            ps.setString(7, bookingStatus);
            ps.setString(8, bookingDate);
            ps.setString(9, bookingDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(getBooking(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Error searching bookings: " + e.getMessage(), e);
        }
        return list;
    }

    public Booking findById(int id) {
        String sql = BASE_SELECT + "WHERE b.id = ? AND b.is_deleted = 0";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return getBooking(rs);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding booking by id: " + e.getMessage(), e);
        }
        return null;
    }

    public void updateStatus(int id, String newStatus) {
        String sql = "UPDATE bookings SET booking_status = ?, " +
                "completed_at = CASE WHEN ? = 'COMPLETED' THEN GETDATE() ELSE completed_at END " +
                "WHERE id = ?";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, newStatus);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating booking status: " + e.getMessage(), e);
        }
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE booking_status = ?";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting bookings by status: " + e.getMessage(), e);
        }
        return 0;
    }

    public double sumRevenue() {
        String sql = "SELECT ISNULL(SUM(total_amount), 0) FROM bookings WHERE payment_status = 'PAID'";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getDouble(1);
        } catch (Exception e) {
            throw new RuntimeException("Error summing revenue: " + e.getMessage(), e);
        }
        return 0;
    }

    public int countTodayBookings() {
        String sql = "SELECT COUNT(*) FROM bookings WHERE CAST(booking_date AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            throw new RuntimeException("Error counting today bookings: " + e.getMessage(), e);
        }
        return 0;
    }

    // -------------------------------------------------------
    // Methods từ main (Customer Dashboard & Booking Creation)
    // -------------------------------------------------------

    public int countBookingsBySlot(Date bookingDate, String timeSlot) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE booking_date = ? AND time_slot = ? " +
                     "AND booking_status NOT IN ('CANCELLED', 'NO_SHOW')";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setDate(1, bookingDate);
            ps.setString(2, timeSlot);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting bookings by slot: " + e.getMessage(), e);
        }
    }

    public int createBooking(int userId, int vehicleId, int serviceId, Date bookingDate,
                             String timeSlot, BigDecimal totalAmount, String notes) {
        String sql = "INSERT INTO bookings " +
                "(user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, " +
                " payment_status, payment_method, total_amount, points_earned, notes) " +
                "VALUES (?, ?, ?, ?, ?, 'CONFIRMED', 'UNPAID', NULL, ?, 0, ?)";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, vehicleId);
            ps.setInt(3, serviceId);
            ps.setDate(4, bookingDate);
            ps.setString(5, timeSlot);
            ps.setBigDecimal(6, totalAmount);
            ps.setString(7, notes);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
            throw new RuntimeException("Generated booking ID was not returned");
        } catch (Exception e) {
            throw new RuntimeException("Error creating booking: " + e.getMessage(), e);
        }
    }

    public Booking getUpcomingBookingByUserId(int userId) {
        String sql = "SELECT TOP 1 " + BASE_SELECT.substring("SELECT ".length()) +
                "WHERE b.user_id = ? AND b.booking_date >= CAST(GETDATE() AS DATE) " +
                "AND b.booking_status IN ('CONFIRMED', 'IN_PROGRESS') " +
                "ORDER BY b.booking_date ASC, b.time_slot ASC";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? getBooking(rs) : null;
            }
        } catch (Exception e) {
            throw new RuntimeException("Error loading upcoming booking: " + e.getMessage(), e);
        }
    }

    public List<Booking> getRecentBookingsByUserId(int userId, int limit) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT TOP (?) " + BASE_SELECT.substring("SELECT ".length()) +
                "WHERE b.user_id = ? ORDER BY b.created_at DESC";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(getBooking(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Error loading recent bookings: " + e.getMessage(), e);
        }
        return list;
    }

    public List<Booking> getRecentWashHistoryByUserId(int userId, int limit) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT TOP (?) " + BASE_SELECT.substring("SELECT ".length()) +
                "WHERE b.user_id = ? " +
                "AND b.booking_status = 'COMPLETED' " +
                "AND b.payment_status = 'PAID' " +
                "ORDER BY b.completed_at DESC";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(getBooking(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Error loading recent wash history: " + e.getMessage(), e);
        }
        return list;
    }

    private Booking getBooking(ResultSet rs) throws Exception {
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
