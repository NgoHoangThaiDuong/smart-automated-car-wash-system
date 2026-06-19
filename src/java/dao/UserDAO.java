package dao;

import model.User;
import model.LoyaltyTier;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public void create(String username, String hashedPassword, String fullname, String phone, String role) {
        String sql = "INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent) " +
                     "VALUES (?, ?, ?, ?, ?, (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0.00)";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, fullname);
            ps.setString(4, phone);
            ps.setString(5, role != null ? role : "CUSTOMER");
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error during user registration: " + e.getMessage(), e);
        }
    }

    public User findByUsername(String username) {
        String sql = "SELECT u.id, u.username, u.password, u.fullname, u.phone, u.role, u.tier_id, u.points_balance, u.total_washes, u.lifetime_spent, u.created_at, " +
                     "t.name AS tier_name, t.point_multiplier, t.booking_window_days, t.min_washes, t.min_spend " +
                     "FROM users u " +
                     "LEFT JOIN tiers t ON u.tier_id = t.id " +
                     "WHERE u.username = ?";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return getUser(rs);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding user by username: " + e.getMessage(), e);
        }
        return null;
    }

    public User findById(int id) {
        String sql = "SELECT u.id, u.username, u.password, u.fullname, u.phone, u.role, u.tier_id, u.points_balance, u.total_washes, u.lifetime_spent, u.created_at, " +
                     "t.name AS tier_name, t.point_multiplier, t.booking_window_days, t.min_washes, t.min_spend " +
                     "FROM users u " +
                     "LEFT JOIN tiers t ON u.tier_id = t.id " +
                     "WHERE u.id = ?";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return getUser(rs);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding user by ID: " + e.getMessage(), e);
        }
        return null;
    }

    public void updateProfile(int id, String fullname, String phone) {
        String sql = "UPDATE users SET fullname = ?, phone = ? WHERE id = ?";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating user profile: " + e.getMessage(), e);
        }
    }

    private User getUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setFullname(rs.getString("fullname"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setTierId(rs.getInt("tier_id"));
        u.setPointsBalance(rs.getInt("points_balance"));
        u.setTotalWashes(rs.getInt("total_washes"));
        u.setLifetimeSpent(rs.getDouble("lifetime_spent"));
        u.setCreatedAt(rs.getTimestamp("created_at"));

        if (rs.getObject("tier_id") != null) {
            LoyaltyTier lt = new LoyaltyTier();
            lt.setId(rs.getInt("tier_id"));
            lt.setName(rs.getString("tier_name"));
            lt.setPointMultiplier(rs.getDouble("point_multiplier"));
            lt.setBookingWindowDays(rs.getInt("booking_window_days"));
            lt.setMinWashes(rs.getInt("min_washes"));
            lt.setMinSpend(rs.getDouble("min_spend"));
            u.setLoyaltyTier(lt);
        }
        return u;
    }
}
