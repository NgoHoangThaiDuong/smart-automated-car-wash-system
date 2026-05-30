package dao;

import model.Vehicle;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    public void create(int userId, String licensePlate, String brand, String model, String color) {
        String sql = "INSERT INTO vehicles (user_id, license_plate, brand, model, color) VALUES (?, ?, ?, ?, ?)";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, licensePlate);
            ps.setString(3, brand);
            ps.setString(4, model);
            ps.setString(5, color);

            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error adding vehicle: " + e.getMessage(), e);
        }
    }

    public List<Vehicle> findByUserId(int userId) {
        List<Vehicle> list = new ArrayList<>();

        String sql = "SELECT id, user_id, license_plate, brand, model, color FROM vehicles WHERE user_id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Vehicle v = new Vehicle();

                    v.setId(rs.getInt("id"));
                    v.setUserId(rs.getInt("user_id"));
                    v.setLicensePlate(rs.getString("license_plate"));
                    v.setBrand(rs.getString("brand"));
                    v.setModel(rs.getString("model"));
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
        String sql = "SELECT id, user_id, license_plate, brand, model, color FROM vehicles WHERE id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Vehicle v = new Vehicle();

                    v.setId(rs.getInt("id"));
                    v.setUserId(rs.getInt("user_id"));
                    v.setLicensePlate(rs.getString("license_plate"));
                    v.setBrand(rs.getString("brand"));
                    v.setModel(rs.getString("model"));
                    v.setColor(rs.getString("color"));

                    return v;
                }
            }

        } catch (Exception e) {
            throw new RuntimeException("Error finding vehicle: " + e.getMessage(), e);
        }

        return null;
    }

    public void update(int id, String licensePlate, String brand, String model, String color) {
        String sql = "UPDATE vehicles SET license_plate = ?, brand = ?, model = ?, color = ? WHERE id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, licensePlate);
            ps.setString(2, brand);
            ps.setString(3, model);
            ps.setString(4, color);
            ps.setInt(5, id);

            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error updating vehicle: " + e.getMessage(), e);
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM vehicles WHERE id = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error deleting vehicle: " + e.getMessage(), e);
        }
    }

    public boolean existsByPlateExceptId(String plate, int id) {
        String sql = "SELECT id FROM vehicles WHERE license_plate = ? AND id <> ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, plate);
            ps.setInt(2, id);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            throw new RuntimeException("Error checking vehicle plate: " + e.getMessage(), e);
        }
    }

    public boolean existsByPlate(String plate) {
        String sql = "SELECT id FROM vehicles WHERE license_plate = ?";

        try ( Connection conn = DBUtils.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, plate);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            throw new RuntimeException("Error checking vehicle plate: " + e.getMessage(), e);
        }
    }
}
