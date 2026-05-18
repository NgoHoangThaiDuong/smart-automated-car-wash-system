package repository;

import model.User;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class UserRepository extends BaseRepository<User> {

    public void create(String username, String hashedPassword, String role) {
        create(username, hashedPassword, null, null, role);
    }

    public void create(String username, String hashedPassword, String fullname, String phone, String role) {
        String sql = "INSERT INTO users (username, password, fullname, phone, role) VALUES (?, ?, ?, ?, ?)";
        int rows = executeUpdate(sql, ps -> {
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, fullname);
            ps.setString(4, phone);
            ps.setString(5, role != null ? role : "CUSTOMER");
        });
        if (rows <= 0) {
            throw new RuntimeException("Lỗi truy xuất CSDL khi tạo user: Insert failed");
        }
    }

    public User findByUsername(String username) {
        String sql = "SELECT id, username, password, fullname, phone, role, created_at FROM users WHERE username = ?";
        return querySingle(sql, ps -> ps.setString(1, username), this::mapRow);
    }

    public User findById(int id) {
        String sql = "SELECT id, username, password, fullname, phone, role, created_at FROM users WHERE id = ?";
        return querySingle(sql, ps -> ps.setInt(1, id), this::mapRow);
    }

    public List<User> findAll() {
        String sql = "SELECT id, username, password, fullname, phone, role, created_at FROM users ORDER BY id DESC";
        return query(sql, null, this::mapRow);
    }

    public void updateProfile(int id, String fullname, String phone) {
        String sql = "UPDATE users SET fullname = ?, phone = ? WHERE id = ?";
        executeUpdate(sql, ps -> {
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setInt(3, id);
        });
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
