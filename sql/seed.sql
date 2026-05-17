-- Seed initial administrator account (MD5 password '123456')
IF NOT EXISTS (SELECT * FROM users WHERE username='admin')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', N'Quản trị viên', '0123456789', 'ADMIN');
END;

-- Seed default car wash services
IF NOT EXISTS (SELECT * FROM services WHERE name=N'Rửa xe bọt tuyết')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES (N'Rửa xe bọt tuyết', 50000, N'Rửa sạch bề mặt bằng bọt tuyết siêu cấp');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name=N'Rửa xe + Hút bụi')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES (N'Rửa xe + Hút bụi', 80000, N'Rửa bọt tuyết và dọn nội thất cơ bản');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name=N'Rửa xe + Phủ Ceramic')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES (N'Rửa xe + Phủ Ceramic', 150000, N'Rửa bọt tuyết và phủ bóng Ceramic bảo vệ sơn xe');
END;
