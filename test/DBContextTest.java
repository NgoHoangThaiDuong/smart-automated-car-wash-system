import config.DBContext;
import java.sql.Connection;
import java.sql.Statement;

public class DBContextTest {
    public static boolean runTests() {
        System.out.println("\n--- [TEST] DBContextTest ---");
        try {
            System.out.println("1. Kiem tra ket noi den SQL Server...");
            Connection conn1 = DBContext.getConnection();
            if (conn1 == null || conn1.isClosed()) {
                System.err.println("[FAILED] DBContext.getConnection() tra ve null hoac ket noi da bi dong.");
                return false;
            }
            System.out.println("[PASS] Ket noi SQL Server thanh cong!");

            System.out.println("2. Kiem tra tinh chat Singleton (2 lan goi tra ve cung 1 instance)...");
            Connection conn2 = DBContext.getConnection();
            if (conn1 != conn2) {
                System.err.println("[FAILED] DBContext khong dam bao tinh chat Singleton (2 instance khac nhau).");
                return false;
            }
            System.out.println("[PASS] Tinh chat Singleton duoc kiem chung!");

            System.out.println("3. Tu dong kiem tra va khoi tao bang users neu chua ton tai trong CarWashDB...");
            try (Statement st = conn1.createStatement()) {
                String ddl = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U') " +
                             "BEGIN " +
                             "CREATE TABLE users (" +
                             "id INT IDENTITY(1,1) PRIMARY KEY, " +
                             "username VARCHAR(50) NOT NULL UNIQUE, " +
                             "password VARCHAR(255) NOT NULL, " +
                             "fullname NVARCHAR(100), " +
                             "phone VARCHAR(20), " +
                             "role VARCHAR(20) DEFAULT 'CUSTOMER', " +
                             "created_at DATETIME DEFAULT GETDATE()" +
                             "); " +
                             "INSERT INTO users (username, password, fullname, phone, role) VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', N'Quản trị viên', '0123456789', 'ADMIN'); " +
                             "END";
                st.execute(ddl);
                System.out.println("[PASS] Bang users da san sang hoat dong!");
            }

            return true;
        } catch (Exception e) {
            System.err.println("[FAILED] Xay ra Exception khi ket noi DBContext: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
