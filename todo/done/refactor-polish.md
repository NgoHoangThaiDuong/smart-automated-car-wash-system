# Refactor & Polish (Code Quality & UI/UX) - HOÀN THÀNH

## Goal
Tái cấu trúc (Refactor) lại toàn bộ hệ thống để code "sạch" hơn (OOP, DRY), loại bỏ hardcode, chuẩn hóa luồng GET/POST theo nguyên tắc PRG (Post-Redirect-Get), và cải thiện trải nghiệm người dùng (UI/UX) cho sát thực tế.

## Tasks

### Phase 1 — Tách Data & Dọn dẹp Code
- [x] **T1** — Tạo file `sql/seed.sql` (và `sql/schema.sql` nếu cần):
  - Tách toàn bộ các câu lệnh `INSERT` (tạo admin mặc định, tạo services mẫu) ra khỏi source code Java hoặc Test.
- [x] **T2** — Xóa bỏ các comment rác, comment tự động (generated comments) trong toàn bộ thư mục `src/` và `web/`.

### Phase 2 — Tối ưu OOP & Giảm lặp code (DRY)
- [x] **T3** — Refactor Repository (Tạo Base/Abstract):
  - Abstract hóa việc lấy `Connection` và `PreparedStatement` bằng lớp `BaseRepository`.
- [x] **T4** — Gom các thành phần UI dùng chung (JSP Components):
  - Tách thông báo alert thành component dùng chung `web/view/components/alert.jsp`.

### Phase 3 — Audit Luồng Logic (GET/POST)
- [x] **T5** — Rà soát toàn bộ Servlets (AuthServlet, OrderServlet, HomeServlet, ProfileServlet):
  - Đảm bảo 100% nguyên tắc **PRG (Post-Redirect-Get)** bằng cơ chế Flash Session.

### Phase 4 — Cải thiện UI/UX Thực tế
- [x] **T6** — Validate chuẩn form số điện thoại VN & Password (`^0\d{9}$`).
- [x] **T7** — Thêm tính năng "Mắt nhìn mật khẩu" (Toggle Password Visibility) bằng Vanilla JS.

---

## Done When
- [x] Không còn comment rác trong source code.
- [x] Lệnh `INSERT` data nằm đúng chỗ ở file SQL.
- [x] Các Servlet tuân thủ 100% chuẩn PRG pattern.
- [x] Nút "ẩn/hiện mật khẩu" hoạt động mượt mà bằng JS thuần.
- [x] Form chặn ngay từ UI nếu số điện thoại không đúng chuẩn VN.
