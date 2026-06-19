package dao;

import model.WashService;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WashServiceDAO {

    public List<WashService> findAll() {
        List<WashService> list = new ArrayList<>();
        String sql = "SELECT id, name, description, price, duration_minutes, is_active, is_deleted " +
                     "FROM wash_services WHERE is_deleted = 0 ORDER BY price ASC";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(getWashService(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Error listing wash services: " + e.getMessage(), e);
        }
        return list;
    }

    public List<WashService> findAllWithBookingCount() {
        List<WashService> list = new ArrayList<>();
        String sql = "SELECT ws.id, ws.name, ws.description, ws.price, ws.duration_minutes, ws.is_active, ws.is_deleted, " +
                     "COUNT(b.id) AS booking_count " +
                     "FROM wash_services ws " +
                     "LEFT JOIN bookings b ON ws.id = b.service_id AND b.is_deleted = 0 " +
                     "WHERE ws.is_deleted = 0 " +
                     "GROUP BY ws.id, ws.name, ws.description, ws.price, ws.duration_minutes, ws.is_active, ws.is_deleted " +
                     "ORDER BY ws.price ASC";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                WashService ws = getWashService(rs);
                ws.setBookingCount(rs.getInt("booking_count"));
                list.add(ws);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error listing wash services with booking count: " + e.getMessage(), e);
        }
        return list;
    }

    public WashService findById(int id) {
        String sql = "SELECT id, name, description, price, duration_minutes, is_active, is_deleted " +
                     "FROM wash_services WHERE id = ? AND is_deleted = 0";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return getWashService(rs);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding wash service by ID: " + e.getMessage(), e);
        }
        return null;
    }

    public void create(WashService service) {
        String sql = "INSERT INTO wash_services (name, description, price, duration_minutes, is_active, is_deleted) " +
                     "VALUES (?, ?, ?, ?, ?, 0)";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, service.getName());
            ps.setString(2, service.getDescription());
            ps.setDouble(3, service.getPrice());
            ps.setInt(4, service.getDurationMinutes());
            ps.setBoolean(5, service.isActive());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error creating wash service: " + e.getMessage(), e);
        }
    }

    public void update(WashService service) {
        String sql = "UPDATE wash_services SET name = ?, description = ?, price = ?, duration_minutes = ?, is_active = ? " +
                     "WHERE id = ? AND is_deleted = 0";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, service.getName());
            ps.setString(2, service.getDescription());
            ps.setDouble(3, service.getPrice());
            ps.setInt(4, service.getDurationMinutes());
            ps.setBoolean(5, service.isActive());
            ps.setInt(6, service.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating wash service: " + e.getMessage(), e);
        }
    }

    public void updateStatus(int id, boolean isActive) {
        String sql = "UPDATE wash_services SET is_active = ? WHERE id = ? AND is_deleted = 0";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating wash service status: " + e.getMessage(), e);
        }
    }

    public void delete(int id) {
        String sql = "UPDATE wash_services SET is_deleted = 1 WHERE id = ?";
        try (Connection cn = DBUtils.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting wash service: " + e.getMessage(), e);
        }
    }

    private WashService getWashService(ResultSet rs) throws SQLException {
        WashService ws = new WashService();
        ws.setId(rs.getInt("id"));
        ws.setName(rs.getString("name"));
        ws.setDescription(rs.getString("description"));
        ws.setPrice(rs.getDouble("price"));
        ws.setDurationMinutes(rs.getInt("duration_minutes"));
        ws.setActive(rs.getBoolean("is_active"));
        ws.setDeleted(rs.getBoolean("is_deleted"));
        return ws;
    }
}
