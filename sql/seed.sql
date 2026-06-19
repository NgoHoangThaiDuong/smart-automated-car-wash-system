-- =======================================================
-- SEED DATA FOR SMART AUTOMATED CAR WASH SYSTEM
-- =======================================================
USE AutoCarWash;
GO

-- 1. SEED TIERS (Member, Silver, Gold, Platinum)
IF NOT EXISTS (SELECT * FROM tiers WHERE name='Member')
BEGIN
    INSERT INTO tiers (name, point_multiplier, booking_window_days, min_washes, min_spend)
    VALUES ('Member', 1.00, 7, 0, 0);
END;
GO

IF NOT EXISTS (SELECT * FROM tiers WHERE name='Silver')
BEGIN
    INSERT INTO tiers (name, point_multiplier, booking_window_days, min_washes, min_spend)
    VALUES ('Silver', 1.10, 10, 5, 2000000);
END;
GO

IF NOT EXISTS (SELECT * FROM tiers WHERE name='Gold')
BEGIN
    INSERT INTO tiers (name, point_multiplier, booking_window_days, min_washes, min_spend)
    VALUES ('Gold', 1.20, 12, 15, 6000000);
END;
GO

IF NOT EXISTS (SELECT * FROM tiers WHERE name='Platinum')
BEGIN
    INSERT INTO tiers (name, point_multiplier, booking_window_days, min_washes, min_spend)
    VALUES ('Platinum', 1.30, 14, 30, 15000000);
END;
GO

-- 2. SEED USERS (Each tier has 1 user. Default password: '123456' -> 'e10adc3949ba59abbe56e057f20f883e')
IF NOT EXISTS (SELECT * FROM users WHERE username='member_user')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
    VALUES ('member_user', 'e10adc3949ba59abbe56e057f20f883e', N'Nguyễn Văn Thành Viên', '0911111111', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 1, 50000);
END;
GO

IF NOT EXISTS (SELECT * FROM users WHERE username='silver_user')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
    VALUES ('silver_user', 'e10adc3949ba59abbe56e057f20f883e', N'Trần Bạc', '0922222222', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 2450, 8, 2500000);
END;
GO

IF NOT EXISTS (SELECT * FROM users WHERE username='gold_user')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
    VALUES ('gold_user', 'e10adc3949ba59abbe56e057f20f883e', N'Lê Hoàng Vàng', '0933333333', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Gold'), 1500, 18, 7500000);
END;
GO

IF NOT EXISTS (SELECT * FROM users WHERE username='platinum_user')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
    VALUES ('platinum_user', 'e10adc3949ba59abbe56e057f20f883e', N'Phạm Bạch Kim', '0944444444', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Platinum'), 4500, 35, 18000000);
END;
GO

-- 3. SEED VEHICLES: 3 VEHICLES FOR EACH CUSTOMER
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30A-11111')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='member_user'), '30A-11111', N'Toyota', N'Vios', N'Đỏ', '/images/vehicles/vehicle-white.jpg');
END;
GO
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30A-11222')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='member_user'), '30A-11222', N'Honda', N'City', N'Xanh dương', '/images/vehicles/vehicle-blue.jpg');
END;
GO
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30A-11333')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='member_user'), '30A-11333', N'Mazda', N'CX-3', N'Đen', '/images/vehicles/vehicle-black.jpg');
END;
GO

IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='29B-22222')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='silver_user'), '29B-22222', N'Honda', N'CR-V', N'Trắng', '/images/vehicles/vehicle-white.jpg');
END;
GO
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='29B-22333')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='silver_user'), '29B-22333', N'Toyota', N'Camry', N'Xanh dương', '/images/vehicles/vehicle-blue.jpg');
END;
GO
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='29B-22444')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='silver_user'), '29B-22444', N'BMW', N'X5 xDrive40i', N'Đen', '/images/vehicles/vehicle-black.jpg');
END;
GO

IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30C-33333')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='gold_user'), '30C-33333', N'Mazda', N'CX-5', N'Đen', '/images/vehicles/vehicle-black.jpg');
END;
GO
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30C-33444')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='gold_user'), '30C-33444', N'Mercedes', N'C200', N'Trắng', '/images/vehicles/vehicle-white.jpg');
END;
GO
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30C-33555')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='gold_user'), '30C-33555', N'VinFast', N'VF 8', N'Xanh dương', '/images/vehicles/vehicle-blue.jpg');
END;
GO

IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30E-44444')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='platinum_user'), '30E-44444', N'Ford', N'Ranger', N'Xám', '/images/vehicles/vehicle-black.jpg');
END;
GO
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30E-44555')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='platinum_user'), '30E-44555', N'Porsche', N'Taycan 4S', N'Xanh dương', '/images/vehicles/vehicle-blue.jpg');
END;
GO
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30E-44666')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
    VALUES ((SELECT id FROM users WHERE username='platinum_user'), '30E-44666', N'Tesla', N'Model 3', N'Trắng', '/images/vehicles/vehicle-white.jpg');
END;
GO

-- 4. SEED ADMIN USER
IF NOT EXISTS (SELECT * FROM users WHERE username='admin')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
    VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', N'Quản Trị Viên', '0900000000', 'ADMIN', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0);
END;
GO

-- 5. SEED WASH SERVICES
IF NOT EXISTS (SELECT * FROM wash_services WHERE name=N'Rửa xe cơ bản')
BEGIN
    INSERT INTO wash_services (name, description, price, duration_minutes, is_active)
    VALUES (N'Rửa xe cơ bản', N'Rửa thân xe bên ngoài bằng nước và xà phòng', 50000, 20, 1);
END;
GO

IF NOT EXISTS (SELECT * FROM wash_services WHERE name=N'Rửa xe + Hút bụi nội thất')
BEGIN
    INSERT INTO wash_services (name, description, price, duration_minutes, is_active)
    VALUES (N'Rửa xe + Hút bụi nội thất', N'Rửa thân xe và hút bụi toàn bộ khoang nội thất', 100000, 35, 1);
END;
GO

IF NOT EXISTS (SELECT * FROM wash_services WHERE name=N'Rửa xe cao cấp (Wax + Đánh bóng)')
BEGIN
    INSERT INTO wash_services (name, description, price, duration_minutes, is_active)
    VALUES (N'Rửa xe cao cấp (Wax + Đánh bóng)', N'Rửa xe, đánh bóng và phủ wax bảo vệ sơn xe', 250000, 60, 1);
END;
GO

IF NOT EXISTS (SELECT * FROM wash_services WHERE name=N'Vệ sinh khoang máy')
BEGIN
    INSERT INTO wash_services (name, description, price, duration_minutes, is_active)
    VALUES (N'Vệ sinh khoang máy', N'Vệ sinh và làm sạch khoang động cơ', 150000, 30, 1);
END;
GO

IF NOT EXISTS (SELECT * FROM wash_services WHERE name=N'Gói chăm sóc toàn diện')
BEGIN
    INSERT INTO wash_services (name, description, price, duration_minutes, is_active)
    VALUES (N'Gói chăm sóc toàn diện', N'Rửa xe, hút bụi nội thất, vệ sinh khoang máy, đánh bóng và phủ wax', 400000, 90, 1);
END;
GO

-- 6. SEED BOOKINGS
IF NOT EXISTS (SELECT * FROM bookings WHERE user_id=(SELECT id FROM users WHERE username='member_user') AND booking_date='2026-06-15')
BEGIN
    INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, notes)
    VALUES (
        (SELECT id FROM users WHERE username='member_user'),
        (SELECT id FROM vehicles WHERE license_plate='30A-11111'),
        (SELECT id FROM wash_services WHERE name=N'Rửa xe cơ bản'),
        '2026-06-15', '09:00-09:30', 'CONFIRMED', 'UNPAID', NULL, 50000, 0, N'Khách yêu cầu rửa kỹ phần gầm xe'
    );
END;
GO

IF NOT EXISTS (SELECT * FROM bookings WHERE user_id=(SELECT id FROM users WHERE username='silver_user') AND booking_date='2026-06-12')
BEGIN
    INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, notes, completed_at)
    VALUES (
        (SELECT id FROM users WHERE username='silver_user'),
        (SELECT id FROM vehicles WHERE license_plate='29B-22222'),
        (SELECT id FROM wash_services WHERE name=N'Rửa xe + Hút bụi nội thất'),
        '2026-06-12', '14:00-14:35', 'COMPLETED', 'PAID', 'CASH', 100000, 110, NULL, '2026-06-12 14:35:00'
    );
END;
GO

IF NOT EXISTS (SELECT * FROM bookings WHERE user_id=(SELECT id FROM users WHERE username='gold_user') AND booking_date='2026-06-10')
BEGIN
    INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, notes, completed_at)
    VALUES (
        (SELECT id FROM users WHERE username='gold_user'),
        (SELECT id FROM vehicles WHERE license_plate='30C-33333'),
        (SELECT id FROM wash_services WHERE name=N'Rửa xe cao cấp (Wax + Đánh bóng)'),
        '2026-06-10', '10:00-11:00', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 250000, 300, N'Khách hàng VIP, ưu tiên xử lý', '2026-06-10 11:00:00'
    );
END;
GO

IF NOT EXISTS (SELECT * FROM bookings WHERE user_id=(SELECT id FROM users WHERE username='platinum_user') AND booking_date='2026-06-18')
BEGIN
    INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, notes)
    VALUES (
        (SELECT id FROM users WHERE username='platinum_user'),
        (SELECT id FROM vehicles WHERE license_plate='30E-44444'),
        (SELECT id FROM wash_services WHERE name=N'Gói chăm sóc toàn diện'),
        '2026-06-18', '08:00-09:30', 'CONFIRMED', 'UNPAID', NULL, 520000, 0, N'Đặt lịch định kỳ hàng tháng'
    );
END;
GO

IF NOT EXISTS (SELECT * FROM bookings WHERE user_id=(SELECT id FROM users WHERE username='member_user') AND booking_date='2026-05-20')
BEGIN
    INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, notes)
    VALUES (
        (SELECT id FROM users WHERE username='member_user'),
        (SELECT id FROM vehicles WHERE license_plate='30A-11111'),
        (SELECT id FROM wash_services WHERE name=N'Vệ sinh khoang máy'),
        '2026-05-20', '16:00-16:30', 'CANCELLED', 'UNPAID', NULL, 150000, 0, N'Khách hủy do bận đột xuất'
    );
END;
GO

-- 7. SEED WASH HISTORY (for completed bookings)
IF NOT EXISTS (SELECT * FROM wash_history WHERE booking_id=(SELECT id FROM bookings WHERE user_id=(SELECT id FROM users WHERE username='silver_user') AND booking_date='2026-06-12'))
BEGIN
    INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, amount_paid, points_earned, feedback)
    VALUES (
        (SELECT id FROM bookings WHERE user_id=(SELECT id FROM users WHERE username='silver_user') AND booking_date='2026-06-12'),
        (SELECT id FROM users WHERE username='silver_user'),
        (SELECT id FROM vehicles WHERE license_plate='29B-22222'),
        (SELECT id FROM wash_services WHERE name=N'Rửa xe + Hút bụi nội thất'),
        '2026-06-12 14:35:00', 100000, 110, N'Rửa sạch, nhân viên thân thiện'
    );
END;
GO

IF NOT EXISTS (SELECT * FROM wash_history WHERE booking_id=(SELECT id FROM bookings WHERE user_id=(SELECT id FROM users WHERE username='gold_user') AND booking_date='2026-06-10'))
BEGIN
    INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, amount_paid, points_earned, feedback)
    VALUES (
        (SELECT id FROM bookings WHERE user_id=(SELECT id FROM users WHERE username='gold_user') AND booking_date='2026-06-10'),
        (SELECT id FROM users WHERE username='gold_user'),
        (SELECT id FROM vehicles WHERE license_plate='30C-33333'),
        (SELECT id FROM wash_services WHERE name=N'Rửa xe cao cấp (Wax + Đánh bóng)'),
        '2026-06-10 11:00:00', 250000, 300, N'Xe bóng loáng, rất hài lòng'
    );
END;
GO
