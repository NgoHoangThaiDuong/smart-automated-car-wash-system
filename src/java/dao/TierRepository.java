package repository;

import model.Tier;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class TierRepository extends BaseRepository<Tier> {

    public List<Tier> findAll() {
        String sql = "SELECT id, name, point_multiplier, booking_window_days, min_washes, min_spend " +
                     "FROM tiers ORDER BY min_spend ASC, id ASC";
        return query(sql, null, this::mapRow);
    }

    public Tier findById(int id) {
        String sql = "SELECT id, name, point_multiplier, booking_window_days, min_washes, min_spend " +
                     "FROM tiers WHERE id = ?";
        return querySingle(sql, ps -> ps.setInt(1, id), this::mapRow);
    }

    public Tier findByName(String name) {
        String sql = "SELECT id, name, point_multiplier, booking_window_days, min_washes, min_spend " +
                     "FROM tiers WHERE name = ?";
        return querySingle(sql, ps -> ps.setString(1, name), this::mapRow);
    }

    private Tier mapRow(ResultSet rs) throws SQLException {
        Tier t = new Tier();
        t.setId(rs.getInt("id"));
        t.setName(rs.getString("name"));
        t.setPointMultiplier(rs.getDouble("point_multiplier"));
        t.setBookingWindowDays(rs.getInt("booking_window_days"));
        t.setMinWashes(rs.getInt("min_washes"));
        t.setMinSpend(rs.getDouble("min_spend"));
        return t;
    }
}
