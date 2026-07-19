package dao;

import model.Booking;
import model.LoyaltyTier;
import model.User;
import model.Vehicle;
import model.WashService;
import model.Payment;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public int countBookings(String key, String status, String date) {
        String sql = "SELECT COUNT(*) FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN vehicles v ON b.vehicle_id = v.id " +
                "WHERE b.is_deleted = 0 " +
                "AND (? IS NULL OR u.fullname LIKE ? OR v.license_plate LIKE ?) " +
                "AND (? IS NULL OR b.booking_status = ?) " +
                "AND (? IS NULL OR CAST(b.booking_date AS DATE) = ?) ";

        String search = (key == null || key.trim().isEmpty()) ? null : "%" + key.trim() + "%";
        String bookingStatus = (status == null || status.trim().isEmpty()) ? null : status.trim();
        String bookingDate = (date == null || date.trim().isEmpty()) ? null : date.trim();

        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, search);
            ps.setString(2, search);
            ps.setString(3, search);
            ps.setString(4, bookingStatus);
            ps.setString(5, bookingStatus);
            ps.setString(6, bookingDate);
            ps.setString(7, bookingDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting bookings: " + e.getMessage(), e);
        }
        return 0;
    }

    public List<Booking> searchBookingsPaginated(String key, String status, String date, String sortBy, int offset, int limit) {
        String orderBy = "b.created_at DESC";
        if (sortBy != null) {
            switch (sortBy) {
                case "created_asc":
                    orderBy = "b.created_at ASC";
                    break;
                case "date_desc":
                    orderBy = "b.booking_date DESC, b.time_slot DESC";
                    break;
                case "date_asc":
                    orderBy = "b.booking_date ASC, b.time_slot ASC";
                    break;
                case "amount_desc":
                    orderBy = "b.total_amount DESC";
                    break;
                case "amount_asc":
                    orderBy = "b.total_amount ASC";
                    break;
                case "created_desc":
                default:
                    orderBy = "b.created_at DESC";
                    break;
            }
        }

        String sql = "SELECT b.id, b.user_id, b.vehicle_id, b.service_id, " +
                "b.booking_date, b.time_slot, b.booking_status, " +
                "ISNULL(p.payment_status, 'UNPAID') AS payment_status, p.payment_method, " +
                "b.total_amount, b.points_earned, " +
                "b.created_at, b.completed_at, " +
                "u.username, u.fullname, u.phone, u.tier_id, t.name AS tier_name, " +
                "v.license_plate, v.brand, v.model, v.color, " +
                "ws.name AS service_name, ws.price AS service_price, ws.duration_minutes " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN vehicles v ON b.vehicle_id = v.id " +
                "JOIN wash_services ws ON b.service_id = ws.id " +
                "LEFT JOIN tiers t ON u.tier_id = t.id " +
                "LEFT JOIN payments p ON b.id = p.booking_id " +
                "WHERE b.is_deleted = 0 " +
                "AND (? IS NULL OR u.fullname LIKE ? OR v.license_plate LIKE ?) " +
                "AND (? IS NULL OR b.booking_status = ?) " +
                "AND (? IS NULL OR CAST(b.booking_date AS DATE) = ?) " +
                "ORDER BY " + orderBy + " " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        String search = (key == null || key.trim().isEmpty()) ? null : "%" + key.trim() + "%";
        String bookingStatus = (status == null || status.trim().isEmpty()) ? null : status.trim();
        String bookingDate = (date == null || date.trim().isEmpty()) ? null : date.trim();

        List<Booking> list = new ArrayList<>();
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, search);
            ps.setString(2, search);
            ps.setString(3, search);
            ps.setString(4, bookingStatus);
            ps.setString(5, bookingStatus);
            ps.setString(6, bookingDate);
            ps.setString(7, bookingDate);
            ps.setInt(8, offset);
            ps.setInt(9, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(getBooking(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Error searching bookings paginated: " + e.getMessage(), e);
        }
        return list;
    }

    public Booking findById(int id) {
        String sql = "SELECT b.id, b.user_id, b.vehicle_id, b.service_id, " +
                "b.booking_date, b.time_slot, b.booking_status, " +
                "ISNULL(p.payment_status, 'UNPAID') AS payment_status, p.payment_method, " +
                "b.total_amount, b.points_earned, " +
                "b.created_at, b.completed_at, " +
                "u.username, u.fullname, u.phone, u.tier_id, t.name AS tier_name, " +
                "v.license_plate, v.brand, v.model, v.color, " +
                "ws.name AS service_name, ws.price AS service_price, ws.duration_minutes " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN vehicles v ON b.vehicle_id = v.id " +
                "JOIN wash_services ws ON b.service_id = ws.id " +
                "LEFT JOIN tiers t ON u.tier_id = t.id " +
                "LEFT JOIN payments p ON b.id = p.booking_id " +
                "WHERE b.id = ? AND b.is_deleted = 0";
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

    public boolean updateStatus(int id, String newStatus) {
        String sql = "UPDATE bookings SET booking_status = ?, " +
                "completed_at = CASE WHEN ? = 'COMPLETED' THEN GETDATE() ELSE completed_at END " +
                "WHERE id = ?";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, newStatus);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            throw new RuntimeException("Error updating booking status: " + e.getMessage(), e);
        }
    }

    public void updatePaymentStatus(int id, String paymentStatus, String paymentMethod) {
        String sql = "IF EXISTS (SELECT 1 FROM payments WHERE booking_id = ?)\n" +
                "BEGIN\n" +
                "    UPDATE payments \n" +
                "    SET payment_status = ?, \n" +
                "        payment_method = ?, \n" +
                "        paid_at = CASE WHEN ? = 'PAID' THEN GETDATE() ELSE paid_at END,\n" +
                "        updated_at = GETDATE()\n" +
                "    WHERE booking_id = ?\n" +
                "END\n" +
                "ELSE\n" +
                "BEGIN\n" +
                "    INSERT INTO payments (booking_id, user_id, amount, payment_status, payment_method, paid_at)\n" +
                "    SELECT id, user_id, total_amount, ?, ?, \n" +
                "           CASE WHEN ? = 'PAID' THEN GETDATE() ELSE NULL END\n" +
                "    FROM bookings\n" +
                "    WHERE id = ?\n" +
                "END";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setString(2, paymentStatus);
            ps.setString(3, paymentMethod);
            ps.setString(4, paymentStatus);
            ps.setInt(5, id);
            ps.setString(6, paymentStatus);
            ps.setString(7, paymentMethod);
            ps.setString(8, paymentStatus);
            ps.setInt(9, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating payment status: " + e.getMessage(), e);
        }
    }

    public void updatePointsEarned(int bookingId, int pointsEarned) {
        String sql = "UPDATE bookings SET points_earned = ? WHERE id = ?";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, pointsEarned);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating booking points earned: " + e.getMessage(), e);
        }
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE booking_status = ? AND is_deleted = 0";
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

    public int countByPaymentStatus(String paymentStatus) {
        String sql = "SELECT COUNT(*) FROM bookings b JOIN payments p ON b.id = p.booking_id " +
                "WHERE p.payment_status = ? AND b.is_deleted = 0";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting bookings by payment status: " + e.getMessage(), e);
        }
        return 0;
    }

    public double sumRevenue() {
        String sql = "SELECT ISNULL(SUM(b.total_amount), 0) FROM bookings b JOIN payments p ON b.id = p.booking_id WHERE p.payment_status = 'PAID'";
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
        String sql = "SELECT COUNT(*) FROM bookings WHERE CAST(booking_date AS DATE) = CAST(GETDATE() AS DATE) AND is_deleted = 0";
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

    public boolean cancel(int bookingId, int userId) {
        String updateBookingSql = "UPDATE bookings SET booking_status = 'CANCELLED' " +
                "WHERE id = ? AND user_id = ? AND is_deleted = 0 " +
                "AND booking_status IN ('PENDING', 'CONFIRMED') " +
                "AND EXISTS (SELECT 1 FROM payments WHERE booking_id = bookings.id " +
                "AND payment_status = 'UNPAID')";
        String updatePaymentSql = "UPDATE payments SET payment_status = 'CANCELLED', " +
                "updated_at = GETDATE() WHERE booking_id = ? AND user_id = ? " +
                "AND payment_status = 'UNPAID'";

        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setAutoCommit(false);
            int updated;
            try (PreparedStatement ps = cn.prepareStatement(updateBookingSql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, userId);
                updated = ps.executeUpdate();
            }
            if (updated == 0) {
                cn.rollback();
                return false;
            }
            try (PreparedStatement ps = cn.prepareStatement(updatePaymentSql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }
            cn.commit();
            return true;
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (Exception ignored) {
                }
            }
            throw new RuntimeException("Error cancelling customer booking: " + e.getMessage(), e);
        } finally {
            if (cn != null) {
                try {
                    cn.close();
                } catch (Exception ignored) {
                }
            }
        }
    }

    public boolean markPaymentPaid(int bookingId, int userId, String paymentMethod) {
        String sql = "UPDATE p SET p.payment_status = 'PAID', p.payment_method = ?, " +
                "p.paid_at = GETDATE(), p.updated_at = GETDATE() " +
                "FROM payments p JOIN bookings b ON p.booking_id = b.id " +
                "WHERE p.booking_id = ? AND p.user_id = ? AND b.user_id = ? " +
                "AND b.is_deleted = 0 AND b.booking_status IN ('PENDING', 'CONFIRMED') " +
                "AND p.payment_status = 'UNPAID'";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, paymentMethod);
            ps.setInt(2, bookingId);
            ps.setInt(3, userId);
            ps.setInt(4, userId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            throw new RuntimeException("Error paying customer booking: " + e.getMessage(), e);
        }
    }

    public int countOverlappingBookings(Date bookingDate, String startTime, String endTime) {
        String sql = "SELECT COUNT(*) FROM bookings " +
                "WHERE booking_date = ? AND is_deleted = 0 " +
                "AND booking_status NOT IN ('CANCELLED', 'NO_SHOW') " +
                "AND CONVERT(time, LEFT(time_slot, 5)) < CONVERT(time, ?) " +
                "AND CONVERT(time, RIGHT(time_slot, 5)) > CONVERT(time, ?)";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setDate(1, bookingDate);
            ps.setString(2, endTime);
            ps.setString(3, startTime);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting overlapping bookings: " + e.getMessage(), e);
        }
    }

    public List<Booking> findByUser(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.id, b.user_id, b.vehicle_id, b.service_id, " +
                "b.booking_date, b.time_slot, b.booking_status, " +
                "ISNULL(p.payment_status, 'UNPAID') AS payment_status, p.payment_method, " +
                "b.total_amount, b.points_earned, b.created_at, b.completed_at, " +
                "u.username, u.fullname, u.phone, u.tier_id, t.name AS tier_name, " +
                "v.license_plate, v.brand, v.model, v.color, " +
                "ws.name AS service_name, ws.price AS service_price, ws.duration_minutes " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN vehicles v ON b.vehicle_id = v.id " +
                "JOIN wash_services ws ON b.service_id = ws.id " +
                "LEFT JOIN tiers t ON u.tier_id = t.id " +
                "LEFT JOIN payments p ON b.id = p.booking_id " +
                "WHERE b.user_id = ? AND b.is_deleted = 0 " +
                "ORDER BY b.booking_date DESC, b.time_slot DESC";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(getBooking(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error loading customer bookings: " + e.getMessage(), e);
        }
        return list;
    }

    public int create(int userId, int vehicleId, int serviceId,
            Date bookingDate, String timeSlot, String startTime, String endTime,
            BigDecimal totalAmount, int maxConcurrentBookings) {
        String countCapacitySql = "SELECT COUNT(*) FROM bookings WITH (UPDLOCK, HOLDLOCK) " +
                "WHERE booking_date = ? AND is_deleted = 0 " +
                "AND booking_status NOT IN ('CANCELLED', 'NO_SHOW') " +
                "AND CONVERT(time, LEFT(time_slot, 5)) < CONVERT(time, ?) " +
                "AND CONVERT(time, RIGHT(time_slot, 5)) > CONVERT(time, ?)";
        String countVehicleSql = "SELECT COUNT(*) FROM bookings WITH (UPDLOCK, HOLDLOCK) " +
                "WHERE vehicle_id = ? AND booking_date = ? AND is_deleted = 0 " +
                "AND booking_status NOT IN ('CANCELLED', 'NO_SHOW') " +
                "AND CONVERT(time, LEFT(time_slot, 5)) < CONVERT(time, ?) " +
                "AND CONVERT(time, RIGHT(time_slot, 5)) > CONVERT(time, ?)";
        String insertBookingSql = "INSERT INTO bookings " +
                "(user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, total_amount, points_earned) " +
                "VALUES (?, ?, ?, ?, ?, 'CONFIRMED', ?, 0)";
        String insertPaymentSql = "INSERT INTO payments " +
                "(booking_id, user_id, amount, payment_status, payment_method) " +
                "VALUES (?, ?, ?, 'UNPAID', NULL)";

        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
            cn.setAutoCommit(false);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
            LocalTime intervalStart = LocalTime.parse(startTime, formatter);
            LocalTime bookingEnd = LocalTime.parse(endTime, formatter);
            while (intervalStart.isBefore(bookingEnd)) {
                LocalTime intervalEnd = intervalStart.plusMinutes(30);
                if (intervalEnd.isAfter(bookingEnd)) {
                    intervalEnd = bookingEnd;
                }

                try (PreparedStatement ps = cn.prepareStatement(countCapacitySql)) {
                    ps.setDate(1, bookingDate);
                    ps.setString(2, intervalEnd.format(formatter));
                    ps.setString(3, intervalStart.format(formatter));
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) >= maxConcurrentBookings) {
                            throw new IllegalArgumentException("Khung giờ này đã đủ 3 xe.");
                        }
                    }
                }
                intervalStart = intervalEnd;
            }

            try (PreparedStatement ps = cn.prepareStatement(countVehicleSql)) {
                ps.setInt(1, vehicleId);
                ps.setDate(2, bookingDate);
                ps.setString(3, endTime);
                ps.setString(4, startTime);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        throw new IllegalArgumentException("Xe này đã có booking trùng thời gian.");
                    }
                }
            }

            int bookingId;
            try (PreparedStatement ps = cn.prepareStatement(insertBookingSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, vehicleId);
                ps.setInt(3, serviceId);
                ps.setDate(4, bookingDate);
                ps.setString(5, timeSlot);
                ps.setBigDecimal(6, totalAmount);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new RuntimeException("Generated booking ID was not returned");
                    }
                    bookingId = keys.getInt(1);
                }
            }

            try (PreparedStatement ps = cn.prepareStatement(insertPaymentSql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, userId);
                ps.setBigDecimal(3, totalAmount);
                ps.executeUpdate();
            }

            cn.commit();
            return bookingId;
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (Exception ignored) {
                }
            }
            if (e instanceof IllegalArgumentException) {
                throw (IllegalArgumentException) e;
            }
            throw new RuntimeException("Error creating customer booking: " + e.getMessage(), e);
        } finally {
            if (cn != null) {
                try {
                    cn.close();
                } catch (Exception ignored) {
                }
            }
        }
    }

    public Booking getUpcomingBooking(int userId) {
        String sql = "SELECT TOP 1 b.id, b.user_id, b.vehicle_id, b.service_id, " +
                "b.booking_date, b.time_slot, b.booking_status, " +
                "ISNULL(p.payment_status, 'UNPAID') AS payment_status, p.payment_method, " +
                "b.total_amount, b.points_earned, " +
                "b.created_at, b.completed_at, " +
                "u.username, u.fullname, u.phone, u.tier_id, t.name AS tier_name, " +
                "v.license_plate, v.brand, v.model, v.color, " +
                "ws.name AS service_name, ws.price AS service_price, ws.duration_minutes " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN vehicles v ON b.vehicle_id = v.id " +
                "JOIN wash_services ws ON b.service_id = ws.id " +
                "LEFT JOIN tiers t ON u.tier_id = t.id " +
                "LEFT JOIN payments p ON b.id = p.booking_id " +
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

    public List<Booking> getRecentWashHistory(int userId, int limit) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT TOP (?) b.id, b.user_id, b.vehicle_id, b.service_id, " +
                "b.booking_date, b.time_slot, b.booking_status, " +
                "ISNULL(p.payment_status, 'UNPAID') AS payment_status, p.payment_method, " +
                "b.total_amount, b.points_earned, " +
                "b.created_at, b.completed_at, " +
                "u.username, u.fullname, u.phone, u.tier_id, t.name AS tier_name, " +
                "v.license_plate, v.brand, v.model, v.color, " +
                "ws.name AS service_name, ws.price AS service_price, ws.duration_minutes " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN vehicles v ON b.vehicle_id = v.id " +
                "JOIN wash_services ws ON b.service_id = ws.id " +
                "LEFT JOIN tiers t ON u.tier_id = t.id " +
                "LEFT JOIN payments p ON b.id = p.booking_id " +
                "WHERE b.user_id = ? " +
                "AND b.booking_status = 'COMPLETED' " +
                "AND ISNULL(p.payment_status, 'UNPAID') = 'PAID' " +
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
        
        Payment p = new Payment();
        p.setBookingId(b.getId());
        p.setUserId(b.getUserId());
        p.setAmount(BigDecimal.valueOf(b.getTotalAmount()));
        p.setPaymentStatus(b.getPaymentStatus());
        p.setPaymentMethod(b.getPaymentMethod());
        b.setPayment(p);

        b.setPointsEarned(rs.getInt("points_earned"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setCompletedAt(rs.getTimestamp("completed_at"));

        User u = new User();
        u.setUsername(rs.getString("username"));
        u.setFullname(rs.getString("fullname"));
        u.setPhone(rs.getString("phone"));
        
        try {
            int tierId = rs.getInt("tier_id");
            u.setTierId(tierId);
            String tierName = rs.getString("tier_name");
            if (tierName != null) {
                LoyaltyTier lt = new LoyaltyTier();
                lt.setId(tierId);
                lt.setName(tierName);
                u.setLoyaltyTier(lt);
            }
        } catch (java.sql.SQLException e) {
        }
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

    public List<Booking> findByUserId(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.id, b.user_id, b.vehicle_id, b.service_id, " +
                "b.booking_date, b.time_slot, b.booking_status, " +
                "ISNULL(p.payment_status, 'UNPAID') AS payment_status, p.payment_method, " +
                "b.total_amount, b.points_earned, " +
                "b.created_at, b.completed_at, " +
                "u.username, u.fullname, u.phone, u.tier_id, t.name AS tier_name, " +
                "v.license_plate, v.brand, v.model, v.color, " +
                "ws.name AS service_name, ws.price AS service_price, ws.duration_minutes " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN vehicles v ON b.vehicle_id = v.id " +
                "JOIN wash_services ws ON b.service_id = ws.id " +
                "LEFT JOIN tiers t ON u.tier_id = t.id " +
                "LEFT JOIN payments p ON b.id = p.booking_id " +
                "WHERE b.user_id = ? AND b.is_deleted = 0 " +
                "ORDER BY b.booking_date DESC, b.time_slot DESC";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(getBooking(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding bookings by user id: " + e.getMessage(), e);
        }
        return list;
    }
}
