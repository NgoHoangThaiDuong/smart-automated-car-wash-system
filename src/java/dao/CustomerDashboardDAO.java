package dao;

import dto.CustomerDashboardDTO;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CustomerDashboardDAO {

    public CustomerDashboardDTO getCustomerDashboard(int userId) {
        String userSql =
                "SELECT u.username, u.fullname, u.points_balance, u.lifetime_spent, u.total_washes, " +
                "       t.name AS tier_name, t.min_spend AS current_min_spend, t.min_washes AS current_min_washes, " +
                "       (SELECT COUNT(*) FROM vehicles v WHERE v.user_id = u.id) AS vehicle_count " +
                "FROM users u LEFT JOIN tiers t ON u.tier_id = t.id WHERE u.id = ?";
        String nextTierSql =
                "SELECT TOP 1 name, min_spend, min_washes FROM tiers " +
                "WHERE min_spend > ? OR min_washes > ? ORDER BY min_spend ASC, min_washes ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement userPs = conn.prepareStatement(userSql)) {
            userPs.setInt(1, userId);
            try (ResultSet rs = userPs.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                CustomerDashboardDTO dto = new CustomerDashboardDTO();
                dto.setUsername(rs.getString("username"));
                dto.setFullname(rs.getString("fullname"));
                dto.setTierName(rs.getString("tier_name"));
                dto.setPointsBalance(rs.getInt("points_balance"));
                dto.setLifetimeSpent(rs.getDouble("lifetime_spent"));
                dto.setTotalWashes(rs.getInt("total_washes"));
                dto.setVehicleCount(rs.getInt("vehicle_count"));

                try (PreparedStatement nextPs = conn.prepareStatement(nextTierSql)) {
                    nextPs.setDouble(1, rs.getDouble("current_min_spend"));
                    nextPs.setInt(2, rs.getInt("current_min_washes"));
                    try (ResultSet nextRs = nextPs.executeQuery()) {
                        if (nextRs.next()) {
                            double nextSpend = nextRs.getDouble("min_spend");
                            int nextWashes = nextRs.getInt("min_washes");
                            double spendProgress = nextSpend > 0 ? dto.getLifetimeSpent() / nextSpend : 1.0;
                            double washProgress = nextWashes > 0 ? (double) dto.getTotalWashes() / nextWashes : 1.0;

                            dto.setNextTierName(nextRs.getString("name"));
                            dto.setNextTierMinSpend(nextSpend);
                            dto.setNextTierMinWashes(nextWashes);
                            dto.setRemainingSpend(Math.max(0, nextSpend - dto.getLifetimeSpent()));
                            dto.setRemainingWashes(Math.max(0, nextWashes - dto.getTotalWashes()));
                            dto.setProgressPercent(Math.min(100.0, Math.max(spendProgress, washProgress) * 100.0));
                        } else {
                            dto.setProgressPercent(100.0);
                        }
                    }
                }
                return dto;
            }
        } catch (Exception e) {
            throw new RuntimeException("Error loading customer dashboard: " + e.getMessage(), e);
        }
    }
}
