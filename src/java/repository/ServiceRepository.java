package repository;

import model.Service;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class ServiceRepository extends BaseRepository<Service> {

    public List<Service> findAll() {
        String sql = "SELECT id, name, price, description FROM services ORDER BY id ASC";
        return query(sql, null, this::mapRow);
    }

    public Service findById(int id) {
        String sql = "SELECT id, name, price, description FROM services WHERE id = ?";
        return querySingle(sql, ps -> ps.setInt(1, id), this::mapRow);
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
