package mylib;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DBUtils {
    private static Connection connection;

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        if (connection == null || connection.isClosed()) {
            String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
            String masterUrl = EnvConfig.get("DB_MASTER_URL");
            String url = EnvConfig.get("DB_URL");
            String user = EnvConfig.get("DB_USER");
            String pass = EnvConfig.get("DB_PASSWORD");
            String dbName = EnvConfig.get("DB_NAME");

            if (user == null || pass == null) {
                throw new RuntimeException("CRITICAL: Không tìm thấy DB_USER hoặc DB_PASSWORD trong file .env!");
            }

            Class.forName(driver);

            try (Connection masterConn = DriverManager.getConnection(masterUrl, user, pass);
                 Statement st = masterConn.createStatement()) {
                st.execute("IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = '" + dbName + "') BEGIN CREATE DATABASE " + dbName + "; END;");
            } catch (Exception ignored) {}

            connection = DriverManager.getConnection(url, user, pass);
        }
        return connection;
    }
}
