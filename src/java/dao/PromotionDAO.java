package dao;

import model.Promotion;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {

    private static String SELECT_ALL
            = "SELECT "
            + "p.id, "
            + "p.promotion_name, "
            + "p.description, "
            + "p.discount_type, "
            + "p.discount_value, "
            + "p.target_tier_id, "
            + "ISNULL(t.name, 'ALL') AS target_tier_name, "
            + "p.start_date, "
            + "p.end_date, "
            + "p.status, "
            + "p.is_deleted, "
            + "p.created_at, "
            + "p.updated_at "
            + "FROM promotions p "
            + "LEFT JOIN tiers t "
            + "ON p.target_tier_id = t.id "
            + "WHERE p.is_deleted = 0 "
            + "ORDER BY p.id DESC";

    private static String SELECT_BY_ID
            = "SELECT "
            + "p.id, "
            + "p.promotion_name, "
            + "p.description, "
            + "p.discount_type, "
            + "p.discount_value, "
            + "p.target_tier_id, "
            + "ISNULL(t.name, 'ALL') AS target_tier_name, "
            + "p.start_date, "
            + "p.end_date, "
            + "p.status, "
            + "p.is_deleted, "
            + "p.created_at, "
            + "p.updated_at "
            + "FROM promotions p "
            + "LEFT JOIN tiers t "
            + "ON p.target_tier_id = t.id "
            + "WHERE p.id = ? "
            + "AND p.is_deleted = 0";

    private static String UPDATE_PROMOTION
            = "UPDATE promotions "
            + "SET promotion_name = ?, "
            + "description = ?, "
            + "discount_type = ?, "
            + "discount_value = ?, "
            + "target_tier_id = ?, "
            + "start_date = ?, "
            + "end_date = ?, "
            + "status = ?, "
            + "updated_at = GETDATE() "
            + "WHERE id = ? "
            + "AND is_deleted = 0";

    private static String SOFT_DELETE
            = "UPDATE promotions "
            + "SET is_deleted = 1, "
            + "updated_at = GETDATE() "
            + "WHERE id = ? "
            + "AND is_deleted = 0";

    public List<Promotion> findAll()
            throws SQLException, ClassNotFoundException {

        List<Promotion> list = new ArrayList<>();

        try (
                Connection conn = DBUtils.getConnection();
                PreparedStatement ps
                = conn.prepareStatement(SELECT_ALL);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        }

        return list;
    }

    public Promotion findById(int id)
            throws SQLException, ClassNotFoundException {

        try (
                Connection conn = DBUtils.getConnection();
                PreparedStatement ps
                = conn.prepareStatement(SELECT_BY_ID)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        }

        return null;
    }

    public boolean update(Promotion promotion)
            throws SQLException, ClassNotFoundException {

        try (
                Connection conn = DBUtils.getConnection();
                PreparedStatement ps
                = conn.prepareStatement(UPDATE_PROMOTION)) {

            ps.setString(
                    1,
                    promotion.getPromotionName());

            ps.setString(
                    2,
                    promotion.getDescription());

            ps.setString(
                    3,
                    promotion.getDiscountType());

            ps.setBigDecimal(
                    4,
                    promotion.getDiscountValue());

            if (promotion.getTargetTierId() == null) {
                ps.setNull(5, Types.INTEGER);
            } else {
                ps.setInt(
                        5,
                        promotion.getTargetTierId());
            }

            ps.setDate(
                    6,
                    promotion.getStartDate());

            ps.setDate(
                    7,
                    promotion.getEndDate());

            ps.setString(
                    8,
                    promotion.getStatus());

            ps.setInt(
                    9,
                    promotion.getId());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean softDelete(int id)
            throws SQLException, ClassNotFoundException {

        try (
                Connection conn = DBUtils.getConnection();
                PreparedStatement ps
                = conn.prepareStatement(SOFT_DELETE)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;
        }
    }

    private Promotion mapResultSet(ResultSet rs)
            throws SQLException {

        Promotion promotion = new Promotion();

        promotion.setId(
                rs.getInt("id"));

        promotion.setPromotionName(
                rs.getString("promotion_name"));

        promotion.setDescription(
                rs.getString("description"));

        promotion.setDiscountType(
                rs.getString("discount_type"));

        promotion.setDiscountValue(
                rs.getBigDecimal("discount_value"));

        int tierId = rs.getInt("target_tier_id");

        if (rs.wasNull()) {
            promotion.setTargetTierId(null);
        } else {
            promotion.setTargetTierId(tierId);
        }

        promotion.setTargetTierName(
                rs.getString("target_tier_name"));

        promotion.setStartDate(
                rs.getDate("start_date"));

        promotion.setEndDate(
                rs.getDate("end_date"));

        promotion.setStatus(
                rs.getString("status"));

        promotion.setDeleted(
                rs.getBoolean("is_deleted"));

        promotion.setCreatedAt(
                rs.getTimestamp("created_at"));

        promotion.setUpdatedAt(
                rs.getTimestamp("updated_at"));

        return promotion;
    }
    private static String INSERT_PROMOTION
        = "INSERT INTO promotions ("
        + "promotion_name, "
        + "description, "
        + "discount_type, "
        + "discount_value, "
        + "target_tier_id, "
        + "start_date, "
        + "end_date, "
        + "status"
        + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    
    public boolean insert(Promotion promotion)
        throws SQLException, ClassNotFoundException {

    try (
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps
            = conn.prepareStatement(INSERT_PROMOTION)) {

        ps.setString(
                1,
                promotion.getPromotionName());

        ps.setString(
                2,
                promotion.getDescription());

        ps.setString(
                3,
                promotion.getDiscountType());

        ps.setBigDecimal(
                4,
                promotion.getDiscountValue());

        if (promotion.getTargetTierId() == null) {
            ps.setNull(5, Types.INTEGER);
        } else {
            ps.setInt(
                    5,
                    promotion.getTargetTierId());
        }

        ps.setDate(
                6,
                promotion.getStartDate());

        ps.setDate(
                7,
                promotion.getEndDate());

        ps.setString(
                8,
                promotion.getStatus());

        return ps.executeUpdate() > 0;
    }}
}