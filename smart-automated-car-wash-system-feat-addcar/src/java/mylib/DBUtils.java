    package mylib;

    import java.sql.Connection;
    import java.sql.DriverManager;
    import java.sql.SQLException;

    public class DBUtils {

        public static Connection getConnection() throws ClassNotFoundException, SQLException {
            String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
            String url = EnvConfig.get("DB_URL");
            String user = EnvConfig.get("DB_USER");
            String pass = EnvConfig.get("DB_PASSWORD");

            if (user == null || pass == null) {
                throw new RuntimeException("CRITICAL: Không tìm thấy DB_USER hoặc DB_PASSWORD trong file .env!");
            }

            Class.forName(driver);

            return DriverManager.getConnection(url, user, pass);
        }
    }
