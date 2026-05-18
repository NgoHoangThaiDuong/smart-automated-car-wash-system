package repository;

import model.Order;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

public class OrderRepository extends BaseRepository<Order> {

    public void createOrder(int userId, int serviceId, String carPlate, Date bookDate) {
        createOrder(userId, serviceId, null, carPlate, bookDate, 0, 0.0);
    }

    public void createOrder(int userId, int serviceId, Integer promotionId, String carPlate, Date bookDate, int pointsUsed, double finalPrice) {
        String sql = "INSERT INTO orders (user_id, service_id, promotion_id, car_plate, book_date, status, points_used, final_price) " +
                     "VALUES (?, ?, ?, ?, ?, 'PENDING', ?, ?)";
        int rows = executeUpdate(sql, ps -> {
            ps.setInt(1, userId);
            ps.setInt(2, serviceId);
            if (promotionId != null && promotionId > 0) ps.setInt(3, promotionId);
            else ps.setNull(3, java.sql.Types.INTEGER);
            ps.setString(4, carPlate);
            ps.setTimestamp(5, new Timestamp(bookDate.getTime()));
            ps.setInt(6, pointsUsed);
            ps.setDouble(7, finalPrice);
        });
        if (rows <= 0) {
            throw new RuntimeException("Lỗi truy xuất CSDL khi tạo đơn hàng mới: Insert failed");
        }
    }

    public Order findById(int id) {
        String sql = "SELECT o.id, o.user_id, o.service_id, o.promotion_id, o.car_plate, o.book_date, o.status, o.points_used, o.final_price, " +
                     "s.name AS service_name, s.price AS service_price, u.fullname AS user_fullname, p.code AS promotion_code, p.discount_percent " +
                     "FROM orders o " +
                     "JOIN services s ON o.service_id = s.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "LEFT JOIN promotions p ON o.promotion_id = p.id " +
                     "WHERE o.id = ?";
        return querySingle(sql, ps -> ps.setInt(1, id), this::mapRow);
    }

    public List<Order> findByUserId(int userId) {
        String sql = "SELECT o.id, o.user_id, o.service_id, o.promotion_id, o.car_plate, o.book_date, o.status, o.points_used, o.final_price, " +
                     "s.name AS service_name, s.price AS service_price, u.fullname AS user_fullname, p.code AS promotion_code, p.discount_percent " +
                     "FROM orders o " +
                     "JOIN services s ON o.service_id = s.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "LEFT JOIN promotions p ON o.promotion_id = p.id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.book_date DESC, o.id DESC";
        return query(sql, ps -> ps.setInt(1, userId), this::mapRow);
    }

    public List<Order> findAll() {
        String sql = "SELECT o.id, o.user_id, o.service_id, o.promotion_id, o.car_plate, o.book_date, o.status, o.points_used, o.final_price, " +
                     "s.name AS service_name, s.price AS service_price, u.fullname AS user_fullname, p.code AS promotion_code, p.discount_percent " +
                     "FROM orders o " +
                     "JOIN services s ON o.service_id = s.id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "LEFT JOIN promotions p ON o.promotion_id = p.id " +
                     "ORDER BY o.book_date DESC, o.id DESC";
        return query(sql, null, this::mapRow);
    }

    public void updateStatus(int id, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        executeUpdate(sql, ps -> {
            ps.setString(1, status);
            ps.setInt(2, id);
        });
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setServiceId(rs.getInt("service_id"));
        if (rs.getObject("promotion_id") != null) {
            o.setPromotionId(rs.getInt("promotion_id"));
        }
        o.setCarPlate(rs.getString("car_plate"));
        o.setBookDate(new Date(rs.getTimestamp("book_date").getTime()));
        o.setStatus(rs.getString("status"));
        o.setPointsUsed(rs.getInt("points_used"));
        o.setFinalPrice(rs.getDouble("final_price"));

        o.setServiceName(rs.getString("service_name"));
        o.setServicePrice(rs.getDouble("service_price"));
        o.setUserFullname(rs.getString("user_fullname"));
        o.setPromotionCode(rs.getString("promotion_code"));
        o.setDiscountPercent(rs.getInt("discount_percent"));
        return o;
    }
}
