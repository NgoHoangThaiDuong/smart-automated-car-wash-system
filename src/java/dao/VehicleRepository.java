package dao;

import model.Vehicle;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VehicleRepository {

    public void create(int userId, String licensePlate, String vehicleType, String color) {
        String sql = "INSERT INTO vehicles (user_id, license_plate, vehicle_type, color) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, licensePlate);
            ps.setString(3, vehicleType);
            ps.setString(4, color);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error adding vehicle: " + e.getMessage(), e);
        }
    }

    public List<Vehicle> findByUserId(int userId) {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT id, user_id, license_plate, vehicle_type, color FROM vehicles WHERE user_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Vehicle v = new Vehicle();
                    v.setId(rs.getInt("id"));
                    v.setUserId(rs.getInt("user_id"));
                    v.setLicensePlate(rs.getString("license_plate"));
                    v.setVehicleType(rs.getString("vehicle_type"));
                    v.setColor(rs.getString("color"));
                    list.add(v);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error listing user vehicles: " + e.getMessage(), e);
        }
        return list;
    }

    public Vehicle findById(int id) {
        String sql = "SELECT id, user_id, license_plate, vehicle_type, color FROM vehicles WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Vehicle v = new Vehicle();
                    v.setId(rs.getInt("id"));
                    v.setUserId(rs.getInt("user_id"));
                    v.setLicensePlate(rs.getString("license_plate"));
                    v.setVehicleType(rs.getString("vehicle_type"));
                    v.setColor(rs.getString("color"));
                    return v;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding vehicle: " + e.getMessage(), e);
        }
        return null;
    }

    public void update(int id, String licensePlate, String vehicleType, String color) {
        String sql = "UPDATE vehicles SET license_plate = ?, vehicle_type = ?, color = ? WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, licensePlate);
            ps.setString(2, vehicleType);
            ps.setString(3, color);
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error updating vehicle: " + e.getMessage(), e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM vehicles WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting vehicle: " + e.getMessage(), e);
        }
    }
}
