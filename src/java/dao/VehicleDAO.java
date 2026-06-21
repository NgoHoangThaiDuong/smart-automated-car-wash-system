package dao;

import model.Vehicle;
import mylib.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

    public void create(int userId, String licensePlate, String brand, String model,
            String color, String imagePath) {
        String sql = "INSERT INTO vehicles " +
                "(user_id, license_plate, brand, model, color, image_path) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try ( Connection cn = DBUtils.getConnection();  PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, licensePlate);
            ps.setString(3, brand);
            ps.setString(4, model);
            ps.setString(5, color);
            ps.setString(6, imagePath);

            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error adding vehicle: " + e.getMessage(), e);
        }
    }

    public List<Vehicle> findByUserId(int userId) {
        List<Vehicle> list = new ArrayList<>();

        String sql = "SELECT id, user_id, license_plate, brand, model, color, image_path " +
                "FROM vehicles WHERE user_id = ? AND is_deleted = 0 ORDER BY id DESC";

        try ( Connection cn = DBUtils.getConnection();  PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapVehicle(rs));
                }
            }

        } catch (Exception e) {
            throw new RuntimeException("Error listing user vehicles: " + e.getMessage(), e);
        }

        return list;
    }

    public Vehicle findById(int id) {
        String sql = "SELECT id, user_id, license_plate, brand, model, color, image_path " +
                "FROM vehicles WHERE id = ? AND is_deleted = 0";

        try ( Connection cn = DBUtils.getConnection();  PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapVehicle(rs);
                }
            }

        } catch (Exception e) {
            throw new RuntimeException("Error finding vehicle: " + e.getMessage(), e);
        }

        return null;
    }

    public Vehicle findByIdAndUserId(int id, int userId) {
        String sql = "SELECT id, user_id, license_plate, brand, model, color, image_path " +
                "FROM vehicles WHERE id = ? AND user_id = ? AND is_deleted = 0";
        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapVehicle(rs) : null;
            }
        } catch (Exception e) {
            throw new RuntimeException("Error finding owned vehicle: " + e.getMessage(), e);
        }
    }

    public boolean updateForUser(int id, int userId, String licensePlate,
            String brand, String model, String color) {
        String sql = "UPDATE vehicles SET license_plate = ?, brand = ?, model = ?, color = ? " +
                "WHERE id = ? AND user_id = ? AND is_deleted = 0";

        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, licensePlate);
            ps.setString(2, brand);
            ps.setString(3, model);
            ps.setString(4, color);
            ps.setInt(5, id);
            ps.setInt(6, userId);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            throw new RuntimeException("Error updating vehicle: " + e.getMessage(), e);
        }
    }

    public boolean updateForUserWithImage(int id, int userId, String licensePlate,
            String brand, String model, String color, String imagePath) {
        String sql = "UPDATE vehicles SET license_plate = ?, brand = ?, model = ?, " +
                "color = ?, image_path = ? " +
                "WHERE id = ? AND user_id = ? AND is_deleted = 0";

        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, licensePlate);
            ps.setString(2, brand);
            ps.setString(3, model);
            ps.setString(4, color);
            ps.setString(5, imagePath);
            ps.setInt(6, id);
            ps.setInt(7, userId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            throw new RuntimeException("Error updating vehicle image: " + e.getMessage(), e);
        }
    }

    public boolean deleteForUser(int id, int userId) {
        String sql = "UPDATE vehicles SET is_deleted = 1 " +
                "WHERE id = ? AND user_id = ? AND is_deleted = 0";

        try (Connection cn = DBUtils.getConnection();
                PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            throw new RuntimeException("Error deleting vehicle: " + e.getMessage(), e);
        }
    }

    public boolean existsByPlateExceptId(String plate, int id) {
        String sql = "SELECT id FROM vehicles WHERE license_plate = ? AND id <> ?";

        try ( Connection cn = DBUtils.getConnection();  PreparedStatement ps = cn.prepareStatement(sql)) {

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

        try ( Connection cn = DBUtils.getConnection();  PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, plate);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            throw new RuntimeException("Error checking vehicle plate: " + e.getMessage(), e);
        }
    }

    private Vehicle mapVehicle(ResultSet rs) throws Exception {
        Vehicle vehicle = new Vehicle();
        vehicle.setId(rs.getInt("id"));
        vehicle.setUserId(rs.getInt("user_id"));
        vehicle.setLicensePlate(rs.getString("license_plate"));
        vehicle.setBrand(rs.getString("brand"));
        vehicle.setModel(rs.getString("model"));
        vehicle.setColor(rs.getString("color"));
        vehicle.setImagePath(rs.getString("image_path"));
        return vehicle;
    }
}
