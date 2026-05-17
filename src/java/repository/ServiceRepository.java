package repository;

import config.DBContext;
import model.Service;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceRepository {

    public List<Service> findAll() {
        String sql = "SELECT id, name, price, description FROM services ORDER BY id ASC";
        List<Service> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Lỗi lấy danh sách services", e);
        }
        return list;
    }

    public Service findById(int id) {
        String sql = "SELECT id, name, price, description FROM services WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Lỗi tìm service theo id", e);
        }
        return null;
    }

    private Service mapRow(ResultSet rs) throws SQLException {
        Service s = new Service();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setPrice(rs.getDouble("price"));
        s.setDescription(rs.getString("description"));
        return s;
    }
}
