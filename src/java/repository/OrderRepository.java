package repository;

import model.Order;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

public class OrderRepository extends BaseRepository<Order> {

    public void createOrder(int userId, int serviceId, String carPlate, Date bookDate) {
        String sql = "INSERT INTO orders (user_id, service_id, car_plate, book_date, status) VALUES (?, ?, ?, ?, 'PENDING')";
        int rows = executeUpdate(sql, ps -> {
            ps.setInt(1, userId);
            ps.setInt(2, serviceId);
            ps.setString(3, carPlate);
            ps.setTimestamp(4, new Timestamp(bookDate.getTime()));
        });
        if (rows <= 0) {
            throw new RuntimeException("Lỗi truy xuất CSDL khi tạo đơn hàng mới: Insert failed");
        }
    }

    public List<Order> findByUserId(int userId) {
        String sql = "SELECT o.id, o.user_id, o.service_id, o.car_plate, o.book_date, o.status, " +
                     "s.name AS service_name, s.price AS service_price, u.fullname AS user_fullname " +
                     "FROM orders o " +
                     "JOIN services s ON o.service_id = s.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.book_date DESC, o.id DESC";
        return query(sql, ps -> ps.setInt(1, userId), this::mapRow);
    }

    public List<Order> findAll() {
        String sql = "SELECT o.id, o.user_id, o.service_id, o.car_plate, o.book_date, o.status, " +
                     "s.name AS service_name, s.price AS service_price, u.fullname AS user_fullname " +
                     "FROM orders o " +
                     "JOIN services s ON o.service_id = s.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.book_date DESC, o.id DESC";
        return query(sql, null, this::mapRow);
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setServiceId(rs.getInt("service_id"));
        o.setCarPlate(rs.getString("car_plate"));
        o.setBookDate(new Date(rs.getTimestamp("book_date").getTime()));
        o.setStatus(rs.getString("status"));

        o.setServiceName(rs.getString("service_name"));
        o.setServicePrice(rs.getDouble("service_price"));
        o.setUserFullname(rs.getString("user_fullname"));
        return o;
    }
}
