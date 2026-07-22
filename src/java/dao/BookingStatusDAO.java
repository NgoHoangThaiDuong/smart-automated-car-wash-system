package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import mylib.DBUtils;

public class BookingStatusDAO {

    public List<String> findAll() {
        List<String> statuses = new ArrayList<>();
        String sql = "SELECT name FROM booking_statuses ORDER BY name";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                statuses.add(rs.getString("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return statuses;
    }
}
