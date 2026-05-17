# User Authentication + Profile

## Goal
Build the complete auth foundation: DB connection, User CRUD, Register/Login/Logout/Profile — đủ để các module sau (Order, Admin) kế thừa.

## Dependencies (làm trước, không skip)
- Schema SQL đã chốt với team
- `sqljdbc4.jar` đã có trong `lib/`
- Tomcat 9 đã config trong NetBeans

---

## Tasks

### Phase 1 — Infrastructure (làm trước nhất)

- [ ] **T1** — Tạo bảng `users` trong SQL Server
  ```sql
  CREATE TABLE users (
      id INT IDENTITY(1,1) PRIMARY KEY,
      username NVARCHAR(50) UNIQUE NOT NULL,
      password NVARCHAR(255) NOT NULL,
      fullname NVARCHAR(100),
      phone NVARCHAR(20),
      role NVARCHAR(20) DEFAULT 'CUSTOMER'
  );
  ```
  → Verify: Chạy SELECT * FROM users trong SQL Server Management Studio, không lỗi.

- [ ] **T2** — Tạo `src/config/DBContext.java` (Singleton connection)
  → Verify: Class compile được, không lỗi import.

- [ ] **T3** — Tạo `src/model/User.java` (POJO khớp bảng users)
  → Verify: Có đủ fields: id, username, password, fullname, phone, role + getters/setters.

- [ ] **T4** — Tạo `src/exception/AppException.java` + subclasses (AuthException, NotFoundException)
  → Verify: Compile được, AuthException extends AppException.

### Phase 2 — Data Access

- [ ] **T5** — Tạo `src/repository/UserRepository.java`
  - `findByUsername(String username): User`
  - `create(String username, String hashedPassword, String role): void`
  - `findById(int id): User`

  → Verify: Gọi `findByUsername("nonexistent")` trả về null, không throw exception.

### Phase 3 — Business Logic

- [ ] **T6** — Tạo `src/service/AuthService.java`
  - `login(username, password): User` — so sánh MD5 hash
  - `register(username, password, fullname, phone): void` — check trùng username
  - `static hashMD5(String input): String` — dùng MessageDigest

  → Verify: `hashMD5("123456")` trả về `"e10adc3949ba59abbe56e057f20f883e"`.

### Phase 4 — DTO

- [ ] **T7** — Tạo `src/dto/LoginDTO.java` và `RegisterDTO.java`
  - Mỗi DTO có `validate(): String` — trả về null nếu hợp lệ, error message nếu không.

  → Verify: `new LoginDTO("", "123").validate()` trả về non-null string.

### Phase 5 — Controllers

- [ ] **T8** — Tạo `src/controller/AuthServlet.java` (`@WebServlet("/auth/*")`)
  - GET `/auth/login` → forward `view/auth/login.jsp`
  - GET `/auth/register` → forward `view/auth/register.jsp`
  - POST `/auth/login` → validate DTO → AuthService.login → set session → redirect `/order/list`
  - POST `/auth/register` → validate DTO → AuthService.register → redirect `/auth/login`
  - POST `/auth/logout` → session.invalidate() → redirect `/auth/login`

  → Verify: POST `/auth/login` với sai password → vẫn ở trang login, có `${error}` hiện ra.

- [ ] **T9** — Tạo `src/controller/ProfileServlet.java` (`@WebServlet("/profile/*")`)
  - GET `/profile/view` → lấy user từ session → forward `view/profile/view.jsp`

  → Verify: Vào `/profile/view` khi đã login → thấy username hiển thị đúng.

### Phase 6 — Auth Guard

- [ ] **T10** — Tạo `src/filter/AuthFilter.java` (`@WebFilter({"/profile/*", "/order/*"}`)
  - Kiểm tra `session.getAttribute("currentUser")` != null
  - Nếu null → redirect `/auth/login`

  → Verify: Truy cập `/profile/view` khi chưa login → tự redirect về `/auth/login`.

### Phase 7 — Views (JSP)

- [ ] **T11** — Tạo `web/view/layout/header.jsp` (navigation + session check)
  → Verify: Include vào trang khác không báo lỗi, hiển thị tên user khi đã login.

- [ ] **T12** — Tạo `web/view/auth/login.jsp` (form POST `/auth/login`)
  → Verify: Submit form trống → hiện error message, không redirect.

- [ ] **T13** — Tạo `web/view/auth/register.jsp` (form POST `/auth/register`)
  → Verify: Register thành công → redirect về login page.

- [ ] **T14** — Tạo `web/view/profile/view.jsp` (hiển thị thông tin từ session)
  → Verify: `${sessionScope.currentUser.username}` hiện đúng tên người dùng.

---

## Done When
- [ ] Đăng ký tài khoản mới → không lỗi, redirect về login
- [ ] Đăng nhập đúng → vào được `/profile/view`, thấy tên mình
- [ ] Đăng nhập sai → ở lại login, thấy thông báo lỗi
- [ ] Truy cập `/profile/view` khi chưa login → bị đẩy về login
- [ ] Logout → session xóa, redirect về login

## Notes
- Password LUÔN hash MD5 trước khi lưu — không lưu plain text
- `DBContext.getConnection()` dùng Singleton — không tạo connection mới mỗi request
- Mọi SQL dùng PreparedStatement — không nối string
- Sau POST thành công LUÔN `sendRedirect`, không `forward`
