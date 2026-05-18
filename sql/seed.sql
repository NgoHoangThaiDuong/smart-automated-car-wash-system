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

-- 2. SEED USERS (Default password: '123456' -> 'e10adc3949ba59abbe56e057f20f883e')
IF NOT EXISTS (SELECT * FROM users WHERE username='admin')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, lifetime_spent) 
    VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', 'System Administrator', '0901234567', 'ADMIN', (SELECT id FROM tiers WHERE name='Platinum'), 5000, 15000000);
END;
GO

IF NOT EXISTS (SELECT * FROM users WHERE username='staff1')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, lifetime_spent) 
    VALUES ('staff1', 'e10adc3949ba59abbe56e057f20f883e', 'John Washer', '0912345678', 'STAFF', (SELECT id FROM tiers WHERE name='Member'), 100, 200000);
END;
GO

IF NOT EXISTS (SELECT * FROM users WHERE username='staff2')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, lifetime_spent) 
    VALUES ('staff2', 'e10adc3949ba59abbe56e057f20f883e', 'Sarah Receptionist', '0987654321', 'STAFF', (SELECT id FROM tiers WHERE name='Member'), 50, 100000);
END;
GO

IF NOT EXISTS (SELECT * FROM users WHERE username='customer1')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, lifetime_spent) 
    VALUES ('customer1', 'e10adc3949ba59abbe56e057f20f883e', 'David VIP', '0999999999', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Gold'), 2500, 5000000);
END;
GO

IF NOT EXISTS (SELECT * FROM users WHERE username='customer2')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, lifetime_spent) 
    VALUES ('customer2', 'e10adc3949ba59abbe56e057f20f883e', 'Michael Customer', '0888888888', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 800, 1500000);
END;
GO

-- Update any existing users without a tier to Member
UPDATE users SET tier_id = (SELECT id FROM tiers WHERE name='Member') WHERE tier_id IS NULL;
GO

-- 3. SEED VEHICLES
IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='30A-12345')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, is_default)
    VALUES ((SELECT id FROM users WHERE username='customer1'), '30A-12345', 1);
END;
GO

IF NOT EXISTS (SELECT * FROM vehicles WHERE license_plate='29B-67890')
BEGIN
    INSERT INTO vehicles (user_id, license_plate, is_default)
    VALUES ((SELECT id FROM users WHERE username='customer2'), '29B-67890', 1);
END;
GO
