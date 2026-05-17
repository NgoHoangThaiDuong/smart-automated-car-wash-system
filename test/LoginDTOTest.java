import dto.LoginDTO;

public class LoginDTOTest {

    public static boolean runTests() {
        System.out.println("\n--- [TEST] LoginDTOTest ---");
        try {
            System.out.println("1. Test username null hoac rong...");
            LoginDTO emptyUser = new LoginDTO("", "password123");
            if (emptyUser.validate() == null) {
                System.err.println("[FAILED] Khong bao loi khi username rong.");
                return false;
            }
            System.out.println("[PASS] Validate dung khi username rong!");

            System.out.println("2. Test password null hoac rong...");
            LoginDTO emptyPass = new LoginDTO("username", "   ");
            if (emptyPass.validate() == null) {
                System.err.println("[FAILED] Khong bao loi khi password rong.");
                return false;
            }
            System.out.println("[PASS] Validate dung khi password rong!");

            System.out.println("3. Test password ngan duoi 6 ky tu...");
            LoginDTO shortPass = new LoginDTO("username", "12345");
            if (shortPass.validate() == null) {
                System.err.println("[FAILED] Khong bao loi khi mat khau qua ngan.");
                return false;
            }
            System.out.println("[PASS] Validate dung khi mat khau qua ngan!");

            System.out.println("4. Test du lieu hoan toan hop le (ky vong null)...");
            LoginDTO validDto = new LoginDTO("validUser", "securePass123");
            if (validDto.validate() != null) {
                System.err.println("[FAILED] Bao loi sai cho du lieu hoan toan hop le: " + validDto.validate());
                return false;
            }
            System.out.println("[PASS] LoginDTO validate thanh cong 100%!");

            return true;
        } catch (Exception e) {
            System.err.println("[FAILED] Xay ra Exception trong LoginDTOTest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
