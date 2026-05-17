# Auth & Profile - Automated Testing (TDD)

## Goal
Tự động hóa việc kiểm thử (Unit Test) cho toàn bộ logic của module Auth + Profile (DBContext, Repository, Service, DTO) trước khi test tay trên trình duyệt. AI sẽ tự viết test, tự chạy và tự sửa lỗi nếu có.

## Dependencies
- Các class trong `src/` (AuthService, UserRepository, DTOs) đã được code xong từ phase trước.
- Thư viện JUnit 4 (Mặc định được hỗ trợ sẵn trong NetBeans Ant project, nằm ở thư mục `test/`).
- Database đang chạy và có sẵn bảng `users`.

---

## Tasks

### Phase 1 — Test Setup & Foundation
- [ ] **T1** — Tạo thư mục `test/` (nếu chưa có) và cấu hình lại `build.xml` để hỗ trợ lệnh `ant test` (hoặc tạo một class `MainTestRunner` chạy bằng `javac` nếu không muốn dùng Ant mặc định).
  → Verify: Chạy thử file test rỗng bằng terminal không báo lỗi cú pháp.

- [ ] **T2** — Viết Unit Test cho `DBContextTest.java`
  - Test kết nối SQL Server thành công (không throw exception).
  - Test tính chất Singleton (2 lần gọi trả về cùng 1 cấu hình).
  → Verify: `ant test -Dtest=DBContextTest` trả về BUILD SUCCESSFUL.

### Phase 3 — Data & Business Logic Tests
- [ ] **T3** — Viết Unit Test cho `UserRepositoryTest.java`
  - Test `create()`: insert user ảo thành công.
  - Test `findByUsername()`: tìm đúng user vừa tạo.
  → Verify: Chạy test không lỗi, database ghi nhận bản ghi ảo. (Nên có hàm teardown xóa user test sau khi chạy xong).

- [ ] **T4** — Viết Unit Test cho `AuthServiceTest.java`
  - Test `hashMD5()`: "123456" phải ra đúng chuỗi hash "e10adc...".
  - Test `login()` đúng pass / sai pass / sai username.
  - Test `register()` báo lỗi nếu trùng username.
  → Verify: Các case assert đều pass xanh.

- [ ] **T5** — Viết Unit Test cho `LoginDTOTest` & `RegisterDTOTest`
  - Đưa data rỗng → expect lỗi báo "Không được để trống".
  - Đưa data hợp lệ → expect trả về `null` (không có lỗi).
  → Verify: Đạt 100% test coverage cho hàm `validate()`.

### Phase 4 — Execution & Auto-Correction
- [ ] **T6** — Chạy toàn bộ Test Suite và Fix Bug
  - AI sử dụng terminal chạy `ant test` (hoặc lệnh javac/java).
  - Đọc log lỗi (nếu có dấu ❌).
  - Tự động nhảy vào source code (`src/...`) sửa lại logic cho đến khi toàn bộ test pass 100%.
  → Verify: Console in ra "All tests passed" hoặc BUILD SUCCESSFUL.

---

## Done When
- [ ] AI đã chạy lệnh test trên terminal và báo cáo kết quả xanh (Pass).
- [ ] Không cần mở trình duyệt, logic mã hóa MD5, kết nối DB và validate DTO đã được chứng minh là chạy đúng.
- [ ] Người dùng vào test tay chỉ để kiểm tra UI/UX.

## Notes cho AI
- Nếu NetBeans Ant bị lỗi classpath với `ant test`, hãy linh hoạt chuyển sang viết một class `public static void main` gom tất cả các bài test lại và chạy trực tiếp bằng file `.bat` hoặc lệnh `java -cp`.
- **LUÔN LUÔN** dọn dẹp dữ liệu rác trong database sau khi chạy Unit Test xong (dùng khối `finally`).
