import dto.RegisterDTO;

public class RegisterDTOTest {

    public static boolean runTests() {
        System.out.println("\n--- [TEST] RegisterDTOTest ---");
        try {
            System.out.println("1. Test username rong hoac do dai khong hop le (duoi 3 ky tu)...");
            RegisterDTO shortUser = new RegisterDTO("ab", "pass123", "pass123", "Full Name", "0912345678");
            if (shortUser.validate() == null) {
                System.err.println("[FAILED] Khong bao loi khi username qua ngan (< 3 ky tu).");
                return false;
            }
            System.out.println("[PASS] Validate dung khi username qua ngan!");

            System.out.println("2. Test mat khau ngan (< 6 ky tu)...");
            RegisterDTO shortPass = new RegisterDTO("validUser", "12345", "12345", "Full Name", "0912345678");
            if (shortPass.validate() == null) {
                System.err.println("[FAILED] Khong bao loi khi mat khau qua ngan (< 6 ky tu).");
                return false;
            }
            System.out.println("[PASS] Validate dung khi mat khau qua ngan!");

            System.out.println("3. Test mat khau xac nhan khong khop...");
            RegisterDTO mismatchPass = new RegisterDTO("validUser", "password123", "differentPass", "Full Name", "0912345678");
            if (mismatchPass.validate() == null) {
                System.err.println("[FAILED] Khong bao loi khi mat khau xac nhan khong khop.");
                return false;
            }
            System.out.println("[PASS] Validate dung khi mat khau xac nhan khong khop!");

            System.out.println("4. Test so dien thoai sai dinh dang (chua ky tu chu)...");
            RegisterDTO invalidPhone = new RegisterDTO("validUser", "password123", "password123", "Full Name", "invalidPhone");
            if (invalidPhone.validate() == null) {
                System.err.println("[FAILED] Khong bao loi khi so dien thoai sai dinh dang.");
                return false;
            }
            System.out.println("[PASS] Validate dung khi so dien thoai sai dinh dang!");

            System.out.println("5. Test du lieu hoan toan hop le (ky vong null)...");
            RegisterDTO validDto = new RegisterDTO("validUser", "password123", "password123", "Nguyen Van A", "0912345678");
            if (validDto.validate() != null) {
                System.err.println("[FAILED] Bao loi sai cho du lieu hoan toan hop le: " + validDto.validate());
                return false;
            }
            System.out.println("[PASS] RegisterDTO validate thanh cong 100%!");

            return true;
        } catch (Exception e) {
            System.err.println("[FAILED] Xay ra Exception trong RegisterDTOTest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
