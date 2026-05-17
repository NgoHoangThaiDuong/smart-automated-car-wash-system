# Internationalization (i18n) & Encoding Fix

## Goal
Chuyển đổi toàn bộ giao diện, thông báo lỗi (messages) và dữ liệu mẫu (seed data) sang **Tiếng Anh (English)** để giải quyết triệt để lỗi font chữ (Mojibake: `??ng nh?p`) và giúp đồ án trông chuyên nghiệp hơn, đúng chuẩn quốc tế theo yêu cầu thường thấy của các giảng viên FPT. Đồng thời thiết lập UTF-8 Filter để phòng ngừa lỗi encoding trong tương lai.

## Dependencies
- Toàn bộ source code hiện tại (JSP, Servlets, SQL).

---

## Tasks

### Phase 1 — Database & Core Settings
- [x] **T1** — Dịch file `sql/seed.sql` sang tiếng Anh:
  - Role/Tên người dùng: `Admin System`, `Washing Staff`, `VIP Customer`.
  - Tên dịch vụ: `Standard Snow Foam Wash`, `Wash & Interior Vacuum`, `Premium Ceramic Coating`, `Engine Bay Detailing`.
  → Verify: Chạy lại script SQL, các bảng không còn chứa dấu tiếng Việt.

- [x] **T2** — Bổ sung `CharacterEncodingFilter.java` (Tùy chọn nhưng rất quan trọng):
  - Tạo một Filter map với `/*` trong `web.xml` hoặc `@WebFilter("/*")` để force `request.setCharacterEncoding("UTF-8")` và `response.setCharacterEncoding("UTF-8")`.
  → Verify: Dù nhập tên user có dấu (như "Nguyễn Văn A") thì submit form xuống Servlet vẫn đọc đúng, không bị biến thành dấu hỏi `?`.

### Phase 2 — Controllers (Servlets)
- [x] **T3** — Dịch các thông báo lỗi trong `AuthServlet`:
  - `Tên đăng nhập hoặc mật khẩu sai` → `Invalid username or password`.
  - `Tài khoản đã tồn tại` → `Username already exists`.
  - `Vui lòng không để trống` → `Fields cannot be empty`.
  → Verify: Cố tình gõ sai pass, thông báo lỗi hiện lên bằng tiếng Anh chuẩn.

- [x] **T4** — Dịch các thông báo trong `OrderServlet` / `ProfileServlet` (nếu có):
  - Đảm bảo toàn bộ `request.setAttribute("error", ...)` hoặc `session.setAttribute("message", ...)` đều dùng tiếng Anh.

### Phase 3 — Views (JSP & UI)
- [x] **T5** — Dịch `web/view/layout/header.jsp` & `footer.jsp`:
  - Navbar: `Home`, `My Orders`, `Profile`, `Admin Panel`, `Login`, `Register`, `Logout`.
  → Verify: Header hiển thị 100% tiếng Anh.

- [x] **T6** — Dịch các trang Auth (`login.jsp`, `register.jsp`):
  - Label: `Username`, `Password`, `Full Name`, `Phone Number`.
  - Placeholder: `Enter your username`, v.v.
  - Nút bấm: `Sign In`, `Sign Up`, `Don't have an account?`.

- [x] **T7** — Dịch các trang Order (`book.jsp`, `list.jsp`) và Home (`index.jsp`):
  - `Đặt lịch rửa xe` → `Book an Appointment` hoặc `Order Service`.
  - Trạng thái: `Pending`, `Processing`, `Completed`, `Cancelled`.
  - Bảng danh sách: `Order ID`, `Service Name`, `Car Plate`, `Date`, `Status`.

---

## Done When
- [x] Lướt web từ đầu đến cuối không còn thấy bất kỳ một chữ Tiếng Việt nào.
- [x] Lỗi `??ng nh?p` (Mojibake) biến mất hoàn toàn.
- [x] Data trong CSDL cũng bằng tiếng Anh 100%.
