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

            System.out.println("3. Tu dong kiem tra va khoi tao cac bang CSDL tu file sql/schema.sql va sql/seed.sql...");
            try (Statement st = conn1.createStatement()) {
                String schemaSql = new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get("sql/schema.sql")), "UTF-8");
                st.execute(schemaSql);

                String seedSql = new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get("sql/seed.sql")), "UTF-8");
                st.execute(seedSql);

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
