package repository;

import model.LoyaltyHistory;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

public class LoyaltyHistoryRepository extends BaseRepository<LoyaltyHistory> {

    public void recordHistory(int userId, int pointsChanged, int pointsRemaining, String reason, Date expiresAt) {
        String sql = "INSERT INTO loyalty_history (user_id, points_changed, points_remaining, reason, created_at, expires_at) " +
                     "VALUES (?, ?, ?, ?, GETDATE(), ?)";
        int rows = executeUpdate(sql, ps -> {
            ps.setInt(1, userId);
            ps.setInt(2, pointsChanged);
            ps.setInt(3, pointsRemaining);
            ps.setString(4, reason);
            if (expiresAt != null) ps.setTimestamp(5, new Timestamp(expiresAt.getTime()));
            else ps.setNull(5, java.sql.Types.TIMESTAMP);
        });
        if (rows <= 0) {
            throw new RuntimeException("Lỗi truy xuất CSDL khi ghi log điểm thưởng: Insert failed");
        }
    }

    public List<LoyaltyHistory> findByUserId(int userId) {
        String sql = "SELECT id, user_id, points_changed, points_remaining, reason, created_at, expires_at " +
                     "FROM loyalty_history WHERE user_id = ? ORDER BY created_at DESC, id DESC";
        return query(sql, ps -> ps.setInt(1, userId), this::mapRow);
    }

    private LoyaltyHistory mapRow(ResultSet rs) throws SQLException {
        LoyaltyHistory h = new LoyaltyHistory();
        h.setId(rs.getInt("id"));
        h.setUserId(rs.getInt("user_id"));
        h.setPointsChanged(rs.getInt("points_changed"));
        h.setPointsRemaining(rs.getInt("points_remaining"));
        h.setReason(rs.getString("reason"));
        if (rs.getTimestamp("created_at") != null) {
            h.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
        }
        if (rs.getTimestamp("expires_at") != null) {
            h.setExpiresAt(new Date(rs.getTimestamp("expires_at").getTime()));
        }
        return h;
    }
}
