package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=CarWashDB";
    private static final String USER = "sa";
    private static final String PASS = "123456";

    private static Connection connection;

    private DBContext() {} // Ngăn khởi tạo trực tiếp

    public static Connection getConnection() throws Exception {
        if (connection == null || connection.isClosed()) {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(URL, USER, PASS);
        }
        return connection;
    }
}
