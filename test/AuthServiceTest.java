import config.DBContext;
import exception.AuthException;
import model.User;
import service.AuthService;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class AuthServiceTest {

    public static boolean runTests() {
        System.out.println("\n--- [TEST] AuthServiceTest ---");
        AuthService authService = new AuthService();
        String testUsername = "auth_unit_" + System.currentTimeMillis();
        String testPassword = "securePassword123";

        try {
            System.out.println("1. Test hashMD5()...");
            String expectedHash = "e10adc3949ba59abbe56e057f20f883e";
            String actualHash = AuthService.hashMD5("123456");
            if (!expectedHash.equals(actualHash)) {
                System.err.println("[FAILED] hashMD5() cho chuoi '123456' khong ra dung ket qua ky vong.");
                return false;
            }
            System.out.println("[PASS] hashMD5() ma hoa chuan xac!");

            System.out.println("2. Test register() tai khoan moi...");
            authService.register(testUsername, testPassword, "Auth Unit User", "0912345678");
            System.out.println("[PASS] register() tao tai khoan thanh cong!");

            System.out.println("3. Test register() voi username da ton tai (ky vong AuthException)...");
            boolean duplicateFailed = false;
            try {
                authService.register(testUsername, "anotherpass", "Duplicate User", "0900000000");
            } catch (AuthException e) {
                duplicateFailed = true;
            }
            if (!duplicateFailed) {
                System.err.println("[FAILED] register() khong nem ra AuthException khi dang ky username trung lap.");
                return false;
            }
            System.out.println("[PASS] register() da chan dung viec dang ky trung username!");

            System.out.println("4. Test login() thanh cong voi thong tin chinh xac...");
            User loggedIn = authService.login(testUsername, testPassword);
            if (loggedIn == null || !testUsername.equals(loggedIn.getUsername())) {
                System.err.println("[FAILED] login() khong tra ve dung user sau khi dang nhap thanh cong.");
                return false;
            }
            System.out.println("[PASS] login() hoat dong dung cho case mat khau chinh xac!");

            System.out.println("5. Test login() sai mat khau (ky vong AuthException)...");
            boolean wrongPassCaught = false;
            try {
                authService.login(testUsername, "wrongPassword");
            } catch (AuthException e) {
                wrongPassCaught = true;
            }
            if (!wrongPassCaught) {
                System.err.println("[FAILED] login() khong nem ra AuthException khi mat khau sai.");
                return false;
            }
            System.out.println("[PASS] login() da chan dung case sai mat khau!");

            System.out.println("6. Test login() voi username khong ton tai (ky vong AuthException)...");
            boolean wrongUserCaught = false;
            try {
                authService.login("nonexistent_" + System.currentTimeMillis(), "somepass");
            } catch (AuthException e) {
                wrongUserCaught = true;
            }
            if (!wrongUserCaught) {
                System.err.println("[FAILED] login() khong nem ra AuthException khi username khong ton tai.");
                return false;
            }
            System.out.println("[PASS] login() da chan dung case username khong ton tai!");

            return true;
        } catch (Exception e) {
            System.err.println("[FAILED] Xay ra Exception trong AuthServiceTest: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            System.out.println("7. Don dep du lieu tai khoan test trong CSDL...");
            String sql = "DELETE FROM users WHERE username = ?";
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, testUsername);
                ps.executeUpdate();
                System.out.println("[CLEANUP] Da xoa tai khoan test: " + testUsername);
            } catch (Exception ex) {
                System.err.println("[CLEANUP FAILED] Khong the xoa tai khoan test: " + ex.getMessage());
            }
        }
    }
}
