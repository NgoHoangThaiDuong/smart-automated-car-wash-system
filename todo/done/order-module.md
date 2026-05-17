# Order Module & Home Dashboard

## Goal
Tạo một trang chủ (Home) chuyên nghiệp làm nơi đón khách sau khi đăng nhập. Xây dựng luồng Đặt lịch rửa xe (Order) với các dịch vụ có sẵn (Services), cho phép khách hàng xem lịch sử đơn hàng.

## Dependencies
- Module Auth đã hoàn thiện.
- Đã có tài khoản đang đăng nhập trong Session.

---

## Tasks

### Phase 1 — Fix Luồng Auth & Tạo Home Page
- [ ] **T1** — Sửa file `AuthServlet.java`:
  - Tìm dòng `response.sendRedirect(request.getContextPath() + "/order/list");`
  - Đổi thành `response.sendRedirect(request.getContextPath() + "/home");`
  → Verify: Đăng nhập lại, thấy trình duyệt chuyển hướng về `/home` thay vì báo lỗi 404.

- [ ] **T2** — Tạo `src/controller/HomeServlet.java` (`@WebServlet("/home")`):
  - Xử lý GET request, forward tới `view/home/index.jsp`.
  → Verify: Truy cập `/home` không báo lỗi 404.

- [ ] **T3** — Tạo giao diện `web/view/home/index.jsp`:
  - Giao diện Landing Page xịn xò (Welcome user, hiển thị các nút "Đặt lịch rửa xe", "Xem lịch sử").
  - Sử dụng chung layout header/footer.
  → Verify: Giao diện hiển thị đẹp, chào đúng tên user đang đăng nhập.

### Phase 2 — Database & Models
- [ ] **T4** — Chạy lệnh SQL tạo bảng `services` và `orders`:
  ```sql
  CREATE TABLE services (
      id INT IDENTITY(1,1) PRIMARY KEY,
      name NVARCHAR(100) NOT NULL,
      price DECIMAL(10,2) NOT NULL,
      description NVARCHAR(255)
  );
  
  CREATE TABLE orders (
      id INT IDENTITY(1,1) PRIMARY KEY,
      user_id INT FOREIGN KEY REFERENCES users(id),
      service_id INT FOREIGN KEY REFERENCES services(id),
      car_plate VARCHAR(20) NOT NULL,
      book_date DATETIME NOT NULL,
      status NVARCHAR(20) DEFAULT 'PENDING'
  );
  
  -- Insert vài dịch vụ mẫu
  INSERT INTO services (name, price, description) VALUES (N'Rửa xe bọt tuyết', 50000, N'Rửa sạch bề mặt bằng bọt tuyết siêu cấp');
  INSERT INTO services (name, price, description) VALUES (N'Rửa xe + Hút bụi', 80000, N'Rửa bọt tuyết và dọn nội thất cơ bản');
  ```
  → Verify: Bảng được tạo thành công trong CSDL.

- [ ] **T5** — Tạo POJO `model/Service.java` và `model/Order.java`.
  → Verify: Khớp với các field trong CSDL.

### Phase 3 — Repository & Business Logic
- [ ] **T6** — Tạo `repository/ServiceRepository.java` (chỉ cần hàm `findAll()` để lấy danh sách dịch vụ ra form chọn).
- [ ] **T7** — Tạo `repository/OrderRepository.java` (hàm `createOrder()` và `findByUserId()`).
- [ ] **T8** — Tạo `service/OrderBusinessService.java`:
  - Xử lý logic tính tiền, kiểm tra xe biển số hợp lệ trước khi đẩy xuống Repository.
  → Verify: Tầng logic không báo lỗi cú pháp.

### Phase 4 — Controller & Views
- [ ] **T9** — Tạo `controller/OrderServlet.java` (`@WebServlet("/order/*")`):
  - GET `/order/book`: Load danh sách services -> forward sang `view/order/book.jsp`.
  - POST `/order/book`: Lấy data từ form -> gọi OrderBusinessService -> redirect về `/order/list`.
  - GET `/order/list`: Lấy danh sách order của user đang login -> forward sang `view/order/list.jsp`.

- [ ] **T10** — Tạo giao diện `web/view/order/book.jsp`:
  - Form chọn loại dịch vụ (Select box đồ họa đẹp), nhập biển số xe, chọn ngày giờ.

- [ ] **T11** — Tạo giao diện `web/view/order/list.jsp`:
  - Bảng Table CSS bo góc, hiển thị lịch sử đơn hàng, có badge màu sắc cho Status (Ví dụ: PENDING là màu vàng, COMPLETED màu xanh).

---

## Done When
- [ ] Login xong được đưa về trang chủ cực đẹp, không bị lỗi 404.
- [ ] Khách hàng bấm "Đặt lịch" -> Điền form -> Chuyển về trang Lịch sử đơn hàng thấy đơn vừa đặt.
- [ ] Layout đồng bộ hoàn toàn với Module Auth.
