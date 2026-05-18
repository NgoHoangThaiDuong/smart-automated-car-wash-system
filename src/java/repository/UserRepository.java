package repository;

import model.Tier;
import model.User;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class UserRepository extends BaseRepository<User> {

    public void create(String username, String hashedPassword, String role) {
        create(username, hashedPassword, null, null, role);
    }

    public void create(String username, String hashedPassword, String fullname, String phone, String role) {
        String sql = "INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, lifetime_spent) " +
                     "VALUES (?, ?, ?, ?, ?, (SELECT TOP 1 id FROM tiers WHERE name='Member'), 0, 0)";
        int rows = executeUpdate(sql, ps -> {
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, fullname);
            ps.setString(4, phone);
            ps.setString(5, role != null ? role : "CUSTOMER");
        });
        if (rows <= 0) {
            throw new RuntimeException("Lỗi truy xuất CSDL khi tạo user: Insert failed");
        }
    }

    public User findByUsername(String username) {
        String sql = "SELECT u.id, u.username, u.password, u.fullname, u.phone, u.role, u.tier_id, u.points_balance, u.lifetime_spent, u.created_at, " +
                     "t.name AS tier_name, t.point_multiplier, t.booking_window_days, t.min_washes, t.min_spend " +
                     "FROM users u " +
                     "LEFT JOIN tiers t ON u.tier_id = t.id " +
                     "WHERE u.username = ?";
        return querySingle(sql, ps -> ps.setString(1, username), this::mapRow);
    }

    public User findById(int id) {
        String sql = "SELECT u.id, u.username, u.password, u.fullname, u.phone, u.role, u.tier_id, u.points_balance, u.lifetime_spent, u.created_at, " +
                     "t.name AS tier_name, t.point_multiplier, t.booking_window_days, t.min_washes, t.min_spend " +
                     "FROM users u " +
                     "LEFT JOIN tiers t ON u.tier_id = t.id " +
                     "WHERE u.id = ?";
        return querySingle(sql, ps -> ps.setInt(1, id), this::mapRow);
    }

    public List<User> findAll() {
        String sql = "SELECT u.id, u.username, u.password, u.fullname, u.phone, u.role, u.tier_id, u.points_balance, u.lifetime_spent, u.created_at, " +
                     "t.name AS tier_name, t.point_multiplier, t.booking_window_days, t.min_washes, t.min_spend " +
                     "FROM users u " +
                     "LEFT JOIN tiers t ON u.tier_id = t.id " +
                     "ORDER BY u.id DESC";
        return query(sql, null, this::mapRow);
    }

    public void updateProfile(int id, String fullname, String phone) {
        String sql = "UPDATE users SET fullname = ?, phone = ? WHERE id = ?";
        executeUpdate(sql, ps -> {
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setInt(3, id);
        });
    }

    public void updateLoyalty(int id, int tierId, int pointsBalance, double lifetimeSpent) {
        String sql = "UPDATE users SET tier_id = ?, points_balance = ?, lifetime_spent = ? WHERE id = ?";
        executeUpdate(sql, ps -> {
            ps.setInt(1, tierId);
            ps.setInt(2, pointsBalance);
            ps.setDouble(3, lifetimeSpent);
            ps.setInt(4, id);
        });
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setFullname(rs.getString("fullname"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setTierId(rs.getInt("tier_id"));
        u.setPointsBalance(rs.getInt("points_balance"));
        u.setLifetimeSpent(rs.getDouble("lifetime_spent"));
        u.setCreatedAt(rs.getTimestamp("created_at"));

        if (rs.getObject("tier_name") != null) {
            Tier t = new Tier();
            t.setId(rs.getInt("tier_id"));
            t.setName(rs.getString("tier_name"));
            t.setPointMultiplier(rs.getDouble("point_multiplier"));
            t.setBookingWindowDays(rs.getInt("booking_window_days"));
            t.setMinWashes(rs.getInt("min_washes"));
            t.setMinSpend(rs.getDouble("min_spend"));
            u.setTier(t);
        }
        return u;
    }
}
