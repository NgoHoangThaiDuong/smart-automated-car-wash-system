package repository;

import model.Vehicle;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class VehicleRepository extends BaseRepository<Vehicle> {

    public List<Vehicle> findByUserId(int userId) {
        String sql = "SELECT id, user_id, license_plate, is_default FROM vehicles WHERE user_id = ? ORDER BY is_default DESC, id DESC";
        return query(sql, ps -> ps.setInt(1, userId), this::mapRow);
    }

    public void addVehicle(int userId, String licensePlate, boolean isDefault) {
        if (isDefault) {
            String resetSql = "UPDATE vehicles SET is_default = 0 WHERE user_id = ?";
            executeUpdate(resetSql, ps -> ps.setInt(1, userId));
        }

        String sql = "INSERT INTO vehicles (user_id, license_plate, is_default) VALUES (?, ?, ?)";
        executeUpdate(sql, ps -> {
            ps.setInt(1, userId);
            ps.setString(2, licensePlate);
            ps.setBoolean(3, isDefault);
        });
    }

    public void setDefault(int userId, int vehicleId) {
        String resetSql = "UPDATE vehicles SET is_default = 0 WHERE user_id = ?";
        executeUpdate(resetSql, ps -> ps.setInt(1, userId));

        String updateSql = "UPDATE vehicles SET is_default = 1 WHERE user_id = ? AND id = ?";
        executeUpdate(updateSql, ps -> {
            ps.setInt(1, userId);
            ps.setInt(2, vehicleId);
        });
    }

    private Vehicle mapRow(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setId(rs.getInt("id"));
        v.setUserId(rs.getInt("user_id"));
        v.setLicensePlate(rs.getString("license_plate"));
        v.setDefaultVehicle(rs.getBoolean("is_default"));
        return v;
    }
}
