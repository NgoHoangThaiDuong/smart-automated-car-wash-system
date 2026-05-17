public class MainTestRunner {
    public static void main(String[] args) {
        System.out.println("[TEST RUNNER] Bắt đầu chạy bộ kiểm thử Unit Test...");

        int totalTests = 2;
        int passedTests = 0;

        if (DBContextTest.runTests()) {
            passedTests++;
        }

        if (UserRepositoryTest.runTests()) {
            passedTests++;
        }

        System.out.println("\n========================================");
        System.out.println("[TEST RUNNER] KẾT QUẢ TỔNG QUAN: " + passedTests + "/" + totalTests + " test suites PASSED.");
        if (passedTests == totalTests) {
            System.out.println("[TEST RUNNER] ALL TESTS PASSED!");
        } else {
            System.err.println("[TEST RUNNER] CÓ TEST SUITE THẤT BẠI (FAILED)!");
            System.exit(1);
        }
    }
}
