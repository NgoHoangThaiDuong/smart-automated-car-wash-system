package dao;

import model.User;
import model.LoyaltyTier;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public int countCustomers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'CUSTOMER' AND is_deleted = 0";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting customers: " + e.getMessage(), e);
        }
        return 0;
    }

    public int countRegisteredVehicles() {
        String sql = "SELECT COUNT(*) FROM vehicles WHERE is_deleted = 0";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting registered vehicles: " + e.getMessage(), e);
        }
        return 0;
    }

    public double sumLifetimeSpent() {
        String sql = "SELECT SUM(lifetime_spent) FROM users WHERE role = 'CUSTOMER' AND is_deleted = 0";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error summing lifetime spent: " + e.getMessage(), e);
        }
        return 0.0;
    }


    public int countCustomers(String key, Integer tierId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users u WHERE u.role = 'CUSTOMER' ");
        List<Object> params = new ArrayList<>();
        
        if (key != null && !key.trim().isEmpty()) {
            sql.append("AND (u.fullname LIKE ? OR u.phone LIKE ? OR u.username LIKE ?) ");
            String keyParam = "%" + key.trim() + "%";
            params.add(keyParam);
            params.add(keyParam);
            params.add(keyParam);
        }
        
        if (tierId != null && tierId > 0) {
            sql.append("AND u.tier_id = ? ");
            params.add(tierId);
        }
        
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String) {
                    ps.setString(i + 1, (String) p);
                } else if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                }
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting customers: " + e.getMessage(), e);
        }
        return 0;
    }

    public List<User> searchCustomersPaginated(String key, Integer tierId, String sortBy, int offset, int limit) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT u.id, u.username, u.password, u.fullname, u.phone, u.role, u.tier_id, u.points_balance, u.total_washes, u.lifetime_spent, u.created_at, u.is_deleted, " +
            "t.name AS tier_name, t.point_multiplier, t.booking_window_days, t.min_washes, t.min_spend, " +
            "(SELECT COUNT(*) FROM vehicles v WHERE v.user_id = u.id AND v.is_deleted = 0) AS vehicle_count " +
            "FROM users u " +
            "LEFT JOIN tiers t ON u.tier_id = t.id " +
            "WHERE u.role = 'CUSTOMER' "
        );
        
        List<Object> params = new ArrayList<>();
        
        if (key != null && !key.trim().isEmpty()) {
            sql.append("AND (u.fullname LIKE ? OR u.phone LIKE ?) ");
            String keyParam = "%" + key.trim() + "%";
            params.add(keyParam);
            params.add(keyParam);
        }
        
        if (tierId != null && tierId > 0) {
            sql.append("AND u.tier_id = ? ");
            params.add(tierId);
        }
        
        String orderBy = "u.fullname ASC";
        if (sortBy != null) {
            switch (sortBy) {
                case "name_desc":
                    orderBy = "u.fullname DESC";
                    break;
                case "spent_desc":
                    orderBy = "u.lifetime_spent DESC";
                    break;
                case "spent_asc":
                    orderBy = "u.lifetime_spent ASC";
                    break;
                case "washes_desc":
                    orderBy = "u.total_washes DESC";
                    break;
                case "washes_asc":
                    orderBy = "u.total_washes ASC";
                    break;
                case "points_desc":
                    orderBy = "u.points_balance DESC";
                    break;
                case "points_asc":
                    orderBy = "u.points_balance ASC";
                    break;
                case "name_asc":
                default:
                    orderBy = "u.fullname ASC";
                    break;
            }
        }
        
        sql.append("ORDER BY ").append(orderBy).append(" ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);
        
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String) {
                    ps.setString(i + 1, (String) p);
                } else if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                }
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(getUser(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error searching customers paginated: " + e.getMessage(), e);
        }
        return list;
    }


    public void updateUserStatsAndTier(int userId, double spendAmount, int pointsEarned) {
        User user = findById(userId);
        if (user == null) {
            throw new RuntimeException("User not found with ID: " + userId);
        }

        int newWashes = user.getTotalWashes() + 1;
        double newSpent = user.getLifetimeSpent() + spendAmount;
        int newPoints = user.getPointsBalance() + pointsEarned;

        int currentTierId = user.getTierId();
        List<LoyaltyTier> tiers = new LoyaltyTierDAO().findAll();

        // Loop để xử lý trường hợp nhảy nhiều tier cùng lúc
        boolean upgraded = true;
        while (upgraded) {
            upgraded = false;
            LoyaltyTier nextTier = null;
            for (int i = 0; i < tiers.size() - 1; i++) {
                if (tiers.get(i).getId() == currentTierId) {
                    nextTier = tiers.get(i + 1);
                    break;
                }
            }
            if (nextTier != null && (newPoints >= (int) nextTier.getMinSpend() || newWashes >= nextTier.getMinWashes())) {
                newPoints -= (int) nextTier.getMinSpend();
                newWashes -= nextTier.getMinWashes();
                currentTierId = nextTier.getId();
                upgraded = true;
            }
        }

        String sql = "UPDATE users SET total_washes = ?, lifetime_spent = ?, points_balance = ?, tier_id = ? WHERE id = ?";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, newWashes);
            ps.setDouble(2, newSpent);
            ps.setInt(3, newPoints);
            ps.setInt(4, currentTierId);
            ps.setInt(5, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating user stats and loyalty tier: " + e.getMessage(), e);
        }
    }

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
        String sql = "SELECT u.id, u.username, u.password, u.fullname, u.phone, u.role, u.tier_id, u.points_balance, u.total_washes, u.lifetime_spent, u.created_at, u.is_deleted, " +
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
        String sql = "SELECT u.id, u.username, u.password, u.fullname, u.phone, u.role, u.tier_id, u.points_balance, u.total_washes, u.lifetime_spent, u.created_at, u.is_deleted, " +
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
        u.setDeleted(rs.getBoolean("is_deleted"));

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
        
        try {
            u.setVehicleCount(rs.getInt("vehicle_count"));
        } catch (SQLException e) {
        }

        return u;
    }

    public void delete(int id, boolean ban) {
        String sql = "UPDATE users SET is_deleted = ? WHERE id = ?";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, ban ? 1 : 0);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating ban status: " + e.getMessage(), e);
        }
    }

    public void updatePassword(int id, String hashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating user password: " + e.getMessage(), e);
        }
    }

}

