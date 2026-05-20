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
    VALUES ('Silver', 1.10, 10, 5, 1000000);
END;
GO

IF NOT EXISTS (SELECT * FROM tiers WHERE name='Gold')
BEGIN
    INSERT INTO tiers (name, point_multiplier, booking_window_days, min_washes, min_spend)
    VALUES ('Gold', 1.20, 12, 15, 3000000);
END;
GO

IF NOT EXISTS (SELECT * FROM tiers WHERE name='Platinum')
BEGIN
    INSERT INTO tiers (name, point_multiplier, booking_window_days, min_washes, min_spend)
    VALUES ('Platinum', 1.30, 14, 30, 10000000);
END;
GO

-- 2. SEED USERS (Each tier has 1 user. Default password: '123456' -> 'e10adc3949ba59abbe56e057f20f883e')
IF NOT EXISTS (SELECT * FROM users WHERE username='member_user')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, lifetime_spent) 
    VALUES ('member_user', 'e10adc3949ba59abbe56e057f20f883e', N'Nguyễn Văn Thành Viên', '0911111111', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 0);
END;
GO

IF NOT EXISTS (SELECT * FROM users WHERE username='silver_user')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, lifetime_spent) 
    VALUES ('silver_user', 'e10adc3949ba59abbe56e057f20f883e', N'Trần Bạc', '0922222222', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 500, 1200000);
END;
GO

IF NOT EXISTS (SELECT * FROM users WHERE username='gold_user')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, lifetime_spent) 
    VALUES ('gold_user', 'e10adc3949ba59abbe56e057f20f883e', N'Lê Hoàng Vàng', '0933333333', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Gold'), 1500, 4500000);
END;
GO

IF NOT EXISTS (SELECT * FROM users WHERE username='platinum_user')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, lifetime_spent) 
    VALUES ('platinum_user', 'e10adc3949ba59abbe56e057f20f883e', N'Phạm Bạch Kim', '0944444444', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Platinum'), 4500, 12000000);
END;
GO

-- 3. SEED VEHICLES FOR EACH USER
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30A-11111')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, vehicle_type, color)
    VALUES ((SELECT id FROM users WHERE username='member_user'), '30A-11111', N'Sedan', N'Đỏ');
END;
GO

IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='29B-22222')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, vehicle_type, color)
    VALUES ((SELECT id FROM users WHERE username='silver_user'), '29B-22222', N'SUV', N'Trắng');
END;
GO

IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30C-33333')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, vehicle_type, color)
    VALUES ((SELECT id FROM users WHERE username='gold_user'), '30C-33333', N'Crossover', N'Đen');
END;
GO

IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30E-44444')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, vehicle_type, color)
    VALUES ((SELECT id FROM users WHERE username='platinum_user'), '30E-44444', N'Bán tải', N'Xám');
END;
GO
