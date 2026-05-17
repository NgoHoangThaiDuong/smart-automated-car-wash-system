package repository;

import config.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public abstract class BaseRepository<T> {

    @FunctionalInterface
    protected interface RowMapper<T> {
        T map(ResultSet rs) throws SQLException;
    }

    @FunctionalInterface
    protected interface StatementSetter {
        void setValues(PreparedStatement ps) throws SQLException;
    }

    protected List<T> query(String sql, StatementSetter setter, RowMapper<T> mapper) {
        List<T> list = new ArrayList<>();
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (setter != null) {
                setter.setValues(ps);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapper.map(rs));
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Lỗi truy xuất CSDL khi thực thi query: " + sql, e);
        }
        return list;
    }

    protected T querySingle(String sql, StatementSetter setter, RowMapper<T> mapper) {
        List<T> list = query(sql, setter, mapper);
        return list.isEmpty() ? null : list.get(0);
    }

    protected int executeUpdate(String sql, StatementSetter setter) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (setter != null) {
                setter.setValues(ps);
            }
            return ps.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Lỗi cập nhật CSDL khi thực thi: " + sql, e);
        }
    }
}
