package repository;

import config.DBContext;
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserRepository {

    public void create(String username, String hashedPassword, String role) {
        create(username, hashedPassword, null, null, role);
    }

    public void create(String username, String hashedPassword, String fullname, String phone, String role) {
        String sql = "INSERT INTO users (username, password, fullname, phone, role) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, fullname);
            ps.setString(4, phone);
            ps.setString(5, role != null ? role : "CUSTOMER");
            int rows = ps.executeUpdate();
            if (rows <= 0) {
                throw new SQLException("Insert user failed");
            }
        } catch (Exception e) {
            throw new RuntimeException("Lỗi truy xuất CSDL khi tạo user", e);
        }
    }

    public User findByUsername(String username) {
        String sql = "SELECT id, username, password, fullname, phone, role, created_at FROM users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
            return null; // Không tìm thấy thì trả về null (theo đúng yêu cầu kiểm chứng)
        } catch (Exception e) {
            throw new RuntimeException("Lỗi truy xuất CSDL khi tìm user theo username", e);
        }
    }

    public User findById(int id) {
        String sql = "SELECT id, username, password, fullname, phone, role, created_at FROM users WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
            return null;
        } catch (Exception e) {
            throw new RuntimeException("Lỗi truy xuất CSDL khi tìm user theo id", e);
        }
    }

    public List<User> findAll() {
        String sql = "SELECT id, username, password, fullname, phone, role, created_at FROM users ORDER BY id DESC";
        List<User> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Lỗi truy xuất CSDL danh sách users", e);
        }
        return list;
    }

    public void updateProfile(int id, String fullname, String phone) {
        String sql = "UPDATE users SET fullname = ?, phone = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setInt(3, id);
            ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi cập nhật thông tin user", e);
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setFullname(rs.getString("fullname"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
