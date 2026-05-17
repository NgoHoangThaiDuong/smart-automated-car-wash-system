package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DBContext {
    private static final String MASTER_URL = "jdbc:sqlserver://localhost:1433;databaseName=master";
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=CarWashDB";
    private static final String USER = "sa";
    private static final String PASS = "Car@Wash";

    private static Connection connection;

    private DBContext() {} // Ngăn khởi tạo trực tiếp

    public static Connection getConnection() throws Exception {
        if (connection == null || connection.isClosed()) {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // Tự động kiểm tra và tạo database CarWashDB nếu chưa tồn tại (Hỗ trợ máy mới hoàn toàn)
            try (Connection masterConn = DriverManager.getConnection(MASTER_URL, USER, PASS);
                 Statement st = masterConn.createStatement()) {
                st.execute("IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CarWashDB') BEGIN CREATE DATABASE CarWashDB; END;");
            } catch (Exception ignored) {
                // Nếu không có quyền hoặc đã tồn tại thì bỏ qua
            }

            connection = DriverManager.getConnection(URL, USER, PASS);
        }
        return connection;
    }
}
