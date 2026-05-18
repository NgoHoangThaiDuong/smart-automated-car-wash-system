package repository;

import model.Promotion;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class PromotionRepository extends BaseRepository<Promotion> {

    public List<Promotion> findAllActive() {
        String sql = "SELECT id, code, discount_percent, min_tier_id, is_active FROM promotions WHERE is_active = 1";
        return query(sql, null, this::mapRow);
    }

    public Promotion findByCode(String code) {
        String sql = "SELECT id, code, discount_percent, min_tier_id, is_active FROM promotions WHERE code = ? AND is_active = 1";
        return querySingle(sql, ps -> ps.setString(1, code), this::mapRow);
    }

    private Promotion mapRow(ResultSet rs) throws SQLException {
        Promotion p = new Promotion();
        p.setId(rs.getInt("id"));
        p.setCode(rs.getString("code"));
        p.setDiscountPercent(rs.getInt("discount_percent"));
        p.setMinTierId(rs.getInt("min_tier_id"));
        p.setActive(rs.getBoolean("is_active"));
        return p;
    }
}
