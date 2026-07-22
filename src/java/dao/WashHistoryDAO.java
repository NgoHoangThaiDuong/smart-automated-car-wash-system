package dao;

import dto.WashHistoryDTO;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class WashHistoryDAO {

    private static String FROM_AND_WHERE =
            " FROM bookings b "
            + "JOIN payments p ON p.booking_id = b.id "
            + "JOIN vehicles v ON v.id = b.vehicle_id "
            + "JOIN wash_services ws ON ws.id = b.service_id "
            + "WHERE b.user_id = ? "
            + "AND b.booking_status = 'COMPLETED' "
            + "AND p.payment_status = 'PAID' "
            + "AND b.is_deleted = 0 ";

    public List<WashHistoryDTO> findByUser(int userId, String search, String period,
            Integer serviceId, Integer vehicleId, int offset, int limit) {
        QueryParts query = buildQuery(userId, search, period, serviceId, vehicleId);
        String sql = "SELECT b.id, b.completed_at, v.brand, v.model, "
                + "v.license_plate, v.image_path, ws.name AS service_name, "
                + "p.amount, b.points_earned"
                + FROM_AND_WHERE + query.where
                + "ORDER BY b.completed_at DESC, b.id DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<WashHistoryDTO> rows = new ArrayList<>();
        try (Connection connection = DBUtils.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            int index = bind(statement, query.parameters);
            statement.setInt(index++, offset);
            statement.setInt(index, limit);
            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    rows.add(mapRow(result));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error loading customer wash history: " + e.getMessage(), e);
        }
        return rows;
    }

    public int countByUser(int userId, String search, String period,
            Integer serviceId, Integer vehicleId) {
        QueryParts query = buildQuery(userId, search, period, serviceId, vehicleId);
        String sql = "SELECT COUNT(*)" + FROM_AND_WHERE + query.where;
        try (Connection connection = DBUtils.getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            bind(statement, query.parameters);
            try (ResultSet result = statement.executeQuery()) {
                return result.next() ? result.getInt(1) : 0;
            }
        } catch (Exception e) {
            throw new RuntimeException("Error counting customer wash history: " + e.getMessage(), e);
        }
    }

    private QueryParts buildQuery(int userId, String search, String period,
            Integer serviceId, Integer vehicleId) {
        StringBuilder where = new StringBuilder();
        List<Object> parameters = new ArrayList<>();
        parameters.add(userId);

        Integer periodDays = periodDays(period);
        if (periodDays != null) {
            where.append("AND b.completed_at >= DATEADD(day, ?, GETDATE()) ");
            parameters.add(-periodDays);
        }
        if (search != null && !search.isEmpty()) {
            where.append("AND (CAST(b.id AS VARCHAR(20)) LIKE ? "
                    + "OR v.license_plate LIKE ? OR v.brand LIKE ? "
                    + "OR v.model LIKE ? OR ws.name LIKE ?) ");
            String keyword = "%" + search + "%";
            for (int i = 0; i < 5; i++) {
                parameters.add(keyword);
            }
        }
        if (serviceId != null) {
            where.append("AND b.service_id = ? ");
            parameters.add(serviceId);
        }
        if (vehicleId != null) {
            where.append("AND b.vehicle_id = ? ");
            parameters.add(vehicleId);
        }
        return new QueryParts(where.toString(), parameters);
    }

    private int bind(PreparedStatement statement, List<Object> parameters) throws Exception {
        int index = 1;
        for (Object parameter : parameters) {
            if (parameter instanceof Integer) {
                statement.setInt(index++, (Integer) parameter);
            } else {
                statement.setString(index++, String.valueOf(parameter));
            }
        }
        return index;
    }

    private Integer periodDays(String period) {
        if ("7".equals(period)) {
            return 7;
        }
        if ("90".equals(period)) {
            return 90;
        }
        if ("all".equals(period)) {
            return null;
        }
        return 30;
    }

    private WashHistoryDTO mapRow(ResultSet result) throws Exception {
        WashHistoryDTO row = new WashHistoryDTO();
        row.setBookingId(result.getInt("id"));
        row.setWashDate(result.getTimestamp("completed_at"));
        row.setVehicleBrand(result.getString("brand"));
        row.setVehicleModel(result.getString("model"));
        row.setLicensePlate(result.getString("license_plate"));
        row.setVehicleImagePath(result.getString("image_path"));
        row.setServiceName(result.getString("service_name"));
        row.setAmountPaid(result.getBigDecimal("amount"));
        row.setPointsEarned(result.getInt("points_earned"));
        return row;
    }

    private static class QueryParts {

        private String where;
        private List<Object> parameters;

        QueryParts(String where, List<Object> parameters) {
            this.where = where;
            this.parameters = parameters;
        }
    }
}
