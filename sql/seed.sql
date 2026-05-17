-- =======================================================
-- SEED DATA: USERS (Mật khẩu mặc định: '123456' -> 'e10adc3949ba59abbe56e057f20f883e')
-- =======================================================

-- 1. Quản trị viên (ADMIN)
IF NOT EXISTS (SELECT * FROM users WHERE username='admin')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', N'Quản trị viên Hệ thống', '0901234567', 'ADMIN');
END;

-- 2. Nhân viên (STAFF)
IF NOT EXISTS (SELECT * FROM users WHERE username='staff1')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('staff1', 'e10adc3949ba59abbe56e057f20f883e', N'Nguyễn Văn Thợ', '0912345678', 'STAFF');
END;

IF NOT EXISTS (SELECT * FROM users WHERE username='staff2')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('staff2', 'e10adc3949ba59abbe56e057f20f883e', N'Trần Thị Lễ Tân', '0987654321', 'STAFF');
END;

-- 3. Khách hàng (CUSTOMER)
IF NOT EXISTS (SELECT * FROM users WHERE username='customer1')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('customer1', 'e10adc3949ba59abbe56e057f20f883e', N'Lê Đại Gia (VIP)', '0999999999', 'CUSTOMER');
END;

IF NOT EXISTS (SELECT * FROM users WHERE username='customer2')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('customer2', 'e10adc3949ba59abbe56e057f20f883e', N'Phạm Khách Hàng', '0888888888', 'CUSTOMER');
END;

-- =======================================================
-- SEED DATA: SERVICES (Dịch vụ rửa xe)
-- =======================================================

IF NOT EXISTS (SELECT * FROM services WHERE name=N'Rửa xe bọt tuyết cơ bản')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES (N'Rửa xe bọt tuyết cơ bản', 50000, N'Xịt gầm, rửa bọt tuyết toàn thân xe và lau khô chuyên dụng.');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name=N'Rửa xe + Hút bụi nội thất')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES (N'Rửa xe + Hút bụi nội thất', 80000, N'Rửa bọt tuyết ngoại thất kèm hút bụi toàn bộ ghế và thảm sàn.');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name=N'Rửa xe + Phủ Ceramic Nano')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES (N'Rửa xe + Phủ Ceramic Nano', 150000, N'Rửa xe chi tiết, tẩy ố mốc kính và phủ dung dịch bóng Ceramic siêu cấp bảo vệ sơn.');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name=N'Vệ sinh khoang máy chuyên sâu')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES (N'Vệ sinh khoang máy chuyên sâu', 300000, N'Làm sạch dầu mỡ khoang động cơ bằng hơi nước nóng, dưỡng nhựa và cao su.');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name=N'Dọn nội thất toàn diện')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES (N'Dọn nội thất toàn diện', 500000, N'Tháo ghế, giặt thảm trần, khử mùi ozone và dưỡng da cao cấp toàn bộ xe.');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name=N'Tẩy ố kính & Đánh bóng đèn pha')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES (N'Tẩy ố kính & Đánh bóng đèn pha', 200000, N'Loại bỏ cặn canxi trên kính lái, đánh bóng phục hồi đèn pha ố vàng.');
END;
