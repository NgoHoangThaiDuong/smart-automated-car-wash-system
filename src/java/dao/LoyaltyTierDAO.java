package dao;

import model.LoyaltyTier;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LoyaltyTierDAO {

    public List<LoyaltyTier> findAll() {
        List<LoyaltyTier> list = new ArrayList<>();
        String sql = "SELECT id, name, point_multiplier, booking_window_days, min_washes, min_spend FROM tiers ORDER BY min_spend ASC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                LoyaltyTier lt = new LoyaltyTier();
                lt.setId(rs.getInt("id"));
                lt.setName(rs.getString("name"));
                lt.setPointMultiplier(rs.getDouble("point_multiplier"));
                lt.setBookingWindowDays(rs.getInt("booking_window_days"));
                lt.setMinWashes(rs.getInt("min_washes"));
                lt.setMinSpend(rs.getDouble("min_spend"));
                list.add(lt);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error listing loyalty tiers: " + e.getMessage(), e);
        }
        return list;
    }
}
