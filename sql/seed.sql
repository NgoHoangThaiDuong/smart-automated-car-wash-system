-- =======================================================
-- SEED DATA: USERS (Default password: '123456' -> 'e10adc3949ba59abbe56e057f20f883e')
-- =======================================================

-- 1. System Administrator (ADMIN)
IF NOT EXISTS (SELECT * FROM users WHERE username='admin')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', 'System Administrator', '0901234567', 'ADMIN');
END;

-- 2. Staff Members (STAFF)
IF NOT EXISTS (SELECT * FROM users WHERE username='staff1')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('staff1', 'e10adc3949ba59abbe56e057f20f883e', 'John Washer', '0912345678', 'STAFF');
END;

IF NOT EXISTS (SELECT * FROM users WHERE username='staff2')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('staff2', 'e10adc3949ba59abbe56e057f20f883e', 'Sarah Receptionist', '0987654321', 'STAFF');
END;

-- 3. Customers (CUSTOMER)
IF NOT EXISTS (SELECT * FROM users WHERE username='customer1')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('customer1', 'e10adc3949ba59abbe56e057f20f883e', 'David VIP', '0999999999', 'CUSTOMER');
END;

IF NOT EXISTS (SELECT * FROM users WHERE username='customer2')
BEGIN
    INSERT INTO users (username, password, fullname, phone, role) 
    VALUES ('customer2', 'e10adc3949ba59abbe56e057f20f883e', 'Michael Customer', '0888888888', 'CUSTOMER');
END;

-- =======================================================
-- SEED DATA: SERVICES (Car wash services)
-- =======================================================

IF NOT EXISTS (SELECT * FROM services WHERE name='Standard Snow Foam Wash')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES ('Standard Snow Foam Wash', 50000, 'Underbody spray, full body snow foam wash, and microfiber towel dry.');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name='Wash & Interior Vacuum')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES ('Wash & Interior Vacuum', 80000, 'Exterior snow foam wash combined with full interior cabin and carpet vacuuming.');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name='Premium Ceramic Nano Coating')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES ('Premium Ceramic Nano Coating', 150000, 'Detailed wash, glass decontamination, and premium Ceramic coating for ultimate paint protection.');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name='Engine Bay Detailing')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES ('Engine Bay Detailing', 300000, 'Deep steam cleaning of engine compartment grease, finished with plastic and rubber dressing.');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name='Full Interior Detailing')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES ('Full Interior Detailing', 500000, 'Seat removal, upholstery & carpet shampooing, ozone odor elimination, and premium leather conditioning.');
END;

IF NOT EXISTS (SELECT * FROM services WHERE name='Glass Water Spot Removal & Headlight Restoration')
BEGIN
    INSERT INTO services (name, price, description) 
    VALUES ('Glass Water Spot Removal & Headlight Restoration', 200000, 'Elimination of hard water spots on windshield and dual headlight polish restoration.');
END;
