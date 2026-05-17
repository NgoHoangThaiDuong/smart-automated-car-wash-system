import config.DBContext;
import model.User;
import repository.UserRepository;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class UserRepositoryTest {

    public static boolean runTests() {
        System.out.println("\n--- [TEST] UserRepositoryTest ---");
        UserRepository repo = new UserRepository();
        String testUsername = "test_unit_" + System.currentTimeMillis();

        try {
            System.out.println("1. Test create() va findByUsername()...");
            repo.create(testUsername, "hashedpass123", "Unit Test User", "0987654321", "CUSTOMER");
            System.out.println("[PASS] create() insert thanh cong!");

            User createdUser = repo.findByUsername(testUsername);
            if (createdUser == null) {
                System.err.println("[FAILED] Khong tim thay user vua tao bang findByUsername().");
                return false;
            }
            if (!"Unit Test User".equals(createdUser.getFullname())) {
                System.err.println("[FAILED] Dư lieu fullname khong khop.");
                return false;
            }
            System.out.println("[PASS] findByUsername() tim dung thong tin user!");

            System.out.println("2. Test findById()...");
            User userById = repo.findById(createdUser.getId());
            if (userById == null || userById.getId() != createdUser.getId()) {
                System.err.println("[FAILED] findById() khong tra ve dung user.");
                return false;
            }
            System.out.println("[PASS] findById() hoat dong chinh xac!");

            System.out.println("3. Test findByUsername() voi username khong ton tai (ky vong null)...");
            User nonexistent = repo.findByUsername("nonexistent_" + System.currentTimeMillis());
            if (nonexistent != null) {
                System.err.println("[FAILED] findByUsername() tra ve du lieu khi tim username khong ton tai.");
                return false;
            }
            System.out.println("[PASS] Xu ly an toan khi khong tim thay user!");

            return true;
        } catch (Exception e) {
            System.err.println("[FAILED] Xay ra Exception trong UserRepositoryTest: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            // Dọn dẹp dữ liệu rác trong CSDL sau khi test xong
            System.out.println("4. Don dep du lieu test trong CSDL...");
            String sql = "DELETE FROM users WHERE username = ?";
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, testUsername);
                ps.executeUpdate();
                System.out.println("[CLEANUP] Da xoa user test: " + testUsername);
            } catch (Exception ex) {
                System.err.println("[CLEANUP FAILED] Khong the xoa user test: " + ex.getMessage());
            }
        }
    }
}
