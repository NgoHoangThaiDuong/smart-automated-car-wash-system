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

            System.out.println("3. Tu dong kiem tra va khoi tao cac bang CSDL (users, services, orders)...");
            try (Statement st = conn1.createStatement()) {
                String createUsers = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U') " +
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
                st.execute(createUsers);

                String createServices = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='services' AND xtype='U') " +
                             "BEGIN " +
                             "CREATE TABLE services (" +
                             "id INT IDENTITY(1,1) PRIMARY KEY, " +
                             "name NVARCHAR(100) NOT NULL, " +
                             "price DECIMAL(10,2) NOT NULL, " +
                             "description NVARCHAR(255)" +
                             "); " +
                             "INSERT INTO services (name, price, description) VALUES (N'Rửa xe bọt tuyết', 50000, N'Rửa sạch bề mặt bằng bọt tuyết siêu cấp'); " +
                             "INSERT INTO services (name, price, description) VALUES (N'Rửa xe + Hút bụi', 80000, N'Rửa bọt tuyết và dọn nội thất cơ bản'); " +
                             "INSERT INTO services (name, price, description) VALUES (N'Rửa xe + Phủ Ceramic', 150000, N'Rửa bọt tuyết và phủ bóng Ceramic bảo vệ sơn xe'); " +
                             "END";
                st.execute(createServices);

                String createOrders = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='orders' AND xtype='U') " +
                             "BEGIN " +
                             "CREATE TABLE orders (" +
                             "id INT IDENTITY(1,1) PRIMARY KEY, " +
                             "user_id INT FOREIGN KEY REFERENCES users(id), " +
                             "service_id INT FOREIGN KEY REFERENCES services(id), " +
                             "car_plate VARCHAR(20) NOT NULL, " +
                             "book_date DATETIME NOT NULL, " +
                             "status NVARCHAR(20) DEFAULT 'PENDING'" +
                             "); " +
                             "END";
                st.execute(createOrders);

                System.out.println("[PASS] Cac bang CSDL (users, services, orders) da san sang hoat dong!");
            }

            return true;
        } catch (Exception e) {
            System.err.println("[FAILED] Xay ra Exception khi ket noi DBContext: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
