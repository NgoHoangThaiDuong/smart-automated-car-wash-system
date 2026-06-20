-- =======================================================
-- SEED DATA FOR SMART AUTOMATED CAR WASH SYSTEM
-- =======================================================
USE AutoCarWash;
GO

-- Clear existing data in correct FK dependency order
DELETE FROM wash_history;
DELETE FROM bookings;
DELETE FROM vehicles;
DELETE FROM users;
DELETE FROM wash_services;
DELETE FROM tiers;
GO

DBCC CHECKIDENT ('tiers', RESEED, 0);
DBCC CHECKIDENT ('users', RESEED, 0);
DBCC CHECKIDENT ('vehicles', RESEED, 0);
DBCC CHECKIDENT ('wash_services', RESEED, 0);
DBCC CHECKIDENT ('bookings', RESEED, 0);
DBCC CHECKIDENT ('wash_history', RESEED, 0);
GO

-- 1. SEED TIERS
INSERT INTO tiers (name, point_multiplier, booking_window_days, min_washes, min_spend)
VALUES 
('Member', 1.00, 7, 0, 0),
('Silver', 1.10, 10, 5, 2000000),
('Gold', 1.20, 12, 15, 6000000),
('Platinum', 1.30, 14, 30, 15000000);
GO

-- 2. SEED USERS
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('admin', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Admin', '0900000000', 'ADMIN', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('ducphucdn2006', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Phạm Đức Phúc', '0912000001', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 100, 1, 100000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('tanbaobadao123', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Dương Duy Lợi', '0912000002', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 400, 4, 400000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('jahanne1911', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Phạm Gia Hân', '0912000003', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('luongkhuongduyitt', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Lương Khương Duy', '0912000004', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('Hikarilong', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Lê Hoàng Long', '0912000005', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 300, 3, 300000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('tahuunguyen60', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Tạ Hữu Nguyên', '0912000006', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 300, 3, 300000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('hxt14102004', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Hồ Xuân Thanh', '0912000007', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 400, 4, 400000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('trumclone7778', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Tô Gia Bảo', '0912000008', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 400, 4, 400000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('nguyenthaotien0809', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Thảo Tiên', '0912000009', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('luohuang300506', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Hoàng Duy Lưu', '0912000010', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('duonghuuviet218', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Dương Hữu Việt', '0912000011', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('nguyenhuukiet7a2', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Hữu Kiệt', '0912000012', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('vantho2607', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Phu Vạn Thọ', '0912000013', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 200, 2, 200000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('thanhsu.tb.cl.tg.vn', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Đặng Trang Thanh Sử', '0912000014', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 300, 3, 300000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('duytanpham2311', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Phạm Duy Tân', '0912000015', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('phuocnguyentuan399', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Tuấn Phước', '0912000016', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 300, 3, 300000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('quangthainguyenhoang', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Hoàng Quang Thái', '0912000017', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 200, 2, 200000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('leesinnnmain1234', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Hoàng Phương', '0912000018', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('mphng2004', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Minh Phương', '0912000019', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 400, 4, 400000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('vuminhthien3012', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Vũ Minh Thiện', '0912000020', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 400, 4, 400000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('tannnse162108', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Nhựt Tân', '0912000021', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 0, 0, 0.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('ddqcuong.12a4.c3tqcap', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Đặng Đình Quốc Cường', '0912000022', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 100, 1, 100000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('binhndtse182321', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Dương Thanh Bình', '0912000023', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 300, 3, 300000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('nguyennamthang56', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Nam Thắng', '0912000024', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 200, 2, 200000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('hhieuu0205', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Phạm Huy Hoàng Hiếu', '0912000025', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 100, 1, 100000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('hienthai26052005', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Thái Thảo Hiền', '0912000026', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 200, 2, 200000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('thiennhan7972', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Thiện Nhân', '0912000027', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 300, 3, 300000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('quynhbong345', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Quỳnh Anh', '0912000028', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 300, 3, 300000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('minhhuynhc1502', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Trần Minh Huy', '0912000029', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 400, 4, 400000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('danghaibui6', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Bùi Hải Đăng', '0912000030', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Member'), 200, 2, 200000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('billphan50', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Phan Trọng Nguyên', '0912000031', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 2650, 11, 2650000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('takedo03377', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Trần Thành Đạt', '0912000032', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 2050, 7, 2050000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('le5169851', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Lê Minh Đăng', '0912000033', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 2500, 10, 2500000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('tainguyentan0908', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Tấn Tài', '0912000034', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 2200, 8, 2200000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('tankhai15406', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Lưu Nguyễn Tấn Khải', '0912000035', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 2650, 11, 2650000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('muichirou31', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn An Duy', '0912000036', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 2650, 11, 2650000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('huynhqiabao2718', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Huỳnh Gia Bảo', '0912000037', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 3100, 14, 3100000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('duykhanh20220601', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Duy Khanh', '0912000038', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 2500, 10, 2500000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('denprovc321', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Minh Tường', '0912000039', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 2500, 10, 2500000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('daothingoctram0604', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Đào Thị Ngọc Trâm', '0912000040', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Silver'), 2650, 11, 2650000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('vohoanganhkiet2006', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Võ Hoàng Anh Kiệt', '0912000041', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Gold'), 8400, 27, 8400000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('triluong0166', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Lương Quang Trí', '0912000042', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Gold'), 6000, 15, 6000000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('lethanhdinh37', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Lê Thanh Định', '0912000043', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Gold'), 6000, 15, 6000000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('ducthachhong', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Thạch Hồng Tấn Đức', '0912000044', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Gold'), 8600, 28, 8600000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('phamnhatduyanh01345', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Phạm Nhật Duy Anh', '0912000045', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Gold'), 6200, 16, 6200000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('minhduc040302', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Nguyễn Đặng Minh Đức', '0912000046', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Platinum'), 16800, 36, 16800000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('tcp352006', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Phan Chí Thuận', '0912000047', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Platinum'), 16500, 35, 16500000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('lnam.phong57', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Lê Nam Phong', '0912000048', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Platinum'), 18900, 43, 18900000.0);
INSERT INTO users (username, password, fullname, phone, role, tier_id, points_balance, total_washes, lifetime_spent)
VALUES ('taiphuc08102005', '$2a$10$PyQGSM5ISXUsH3P7VPqpSu8J89yCQg2P6ydQHZ.bYXojx6SB0Mzvi', N'Trịnh Nguyễn Phúc Tài', '0912000049', 'CUSTOMER', (SELECT id FROM tiers WHERE name='Platinum'), 17100, 37, 17100000.0);
GO

-- 3. SEED VEHICLES
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (2, '51G-367.24', N'Honda', N'City', N'Xanh dương', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (3, '30A-949.88', N'Ford', N'Ranger', N'Đen', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (3, '30A-504.16', N'Toyota', N'Camry', N'Đen', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (4, '30A-663.62', N'Kia', N'Cerato', N'Đỏ', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (4, '51G-436.99', N'BMW', N'520i', N'Đỏ', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (5, '51H-909.59', N'BMW', N'520i', N'Trắng', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (6, '75A-158.95', N'Mercedes-Benz', N'C200', N'Xám', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (7, '51H-404.24', N'Honda', N'CR-V', N'Bạc', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (8, '30A-304.89', N'Mazda', N'CX-5', N'Vàng cát', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (9, '51H-838.38', N'Hyundai', N'Accent', N'Đỏ', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (9, '51H-406.74', N'Kia', N'Morning', N'Bạc', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (10, '30A-518.46', N'Hyundai', N'Accent', N'Xám', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (10, '43A-594.16', N'Mazda', N'Mazda 6', N'Bạc', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (11, '75A-744.62', N'VinFast', N'Fadil', N'Đỏ', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (12, '51H-178.47', N'Ford', N'Everest', N'Đỏ', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (13, '51G-376.76', N'Mercedes-Benz', N'E300', N'Bạc', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (14, '51H-159.63', N'VinFast', N'VF 9', N'Đỏ', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (15, '43A-413.99', N'Hyundai', N'Tucson', N'Bạc', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (16, '43A-587.94', N'Kia', N'Morning', N'Vàng cát', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (17, '51G-502.99', N'Mercedes-Benz', N'C200', N'Trắng', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (18, '51G-168.18', N'Honda', N'City', N'Xanh dương', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (18, '51G-629.74', N'BMW', N'320i', N'Vàng cát', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (19, '29B-463.28', N'Toyota', N'Vios', N'Đỏ', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (20, '75A-824.28', N'Mazda', N'CX-5', N'Xám', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (21, '75A-705.55', N'VinFast', N'VF e34', N'Đen', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (22, '30A-124.69', N'Mazda', N'Mazda 6', N'Xanh dương', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (23, '43A-798.79', N'BMW', N'X5', N'Xanh dương', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (24, '43A-898.59', N'Honda', N'City', N'Đen', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (25, '29B-179.89', N'BMW', N'520i', N'Đen', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (25, '51H-264.75', N'VinFast', N'Lux A2.0', N'Đen', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (26, '29B-272.38', N'Honda', N'CR-V', N'Xám', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (27, '43A-450.95', N'BMW', N'X5', N'Vàng cát', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (28, '75A-767.31', N'Toyota', N'Vios', N'Đen', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (29, '43A-840.63', N'Hyundai', N'Santa Fe', N'Trắng', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (30, '51G-727.90', N'Hyundai', N'Elantra', N'Bạc', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (30, '51H-489.19', N'Toyota', N'Camry', N'Bạc', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (31, '43A-970.60', N'Mazda', N'Mazda 3', N'Trắng', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (32, '30A-856.79', N'Mazda', N'CX-5', N'Đen', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (32, '75A-768.78', N'Hyundai', N'Accent', N'Bạc', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (33, '51G-504.58', N'Kia', N'Seltos', N'Vàng cát', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (34, '29B-314.70', N'Ford', N'Explorer', N'Xanh dương', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (35, '43A-853.91', N'VinFast', N'VF 9', N'Đen', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (36, '51H-898.13', N'BMW', N'320i', N'Đen', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (36, '75A-236.29', N'Ford', N'Everest', N'Đen', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (37, '51G-388.67', N'Hyundai', N'Elantra', N'Đỏ', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (37, '51H-189.71', N'BMW', N'X5', N'Đỏ', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (38, '29B-700.55', N'Kia', N'Morning', N'Trắng', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (39, '29B-171.62', N'Mazda', N'Mazda 3', N'Vàng cát', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (40, '75A-779.41', N'Ford', N'Ranger', N'Trắng', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (41, '30A-393.36', N'Mercedes-Benz', N'C200', N'Đen', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (42, '51G-253.84', N'Mazda', N'CX-8', N'Vàng cát', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (43, '43A-507.43', N'Mazda', N'Mazda 6', N'Vàng cát', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (44, '75A-500.44', N'Kia', N'Seltos', N'Vàng cát', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (45, '29B-579.43', N'Hyundai', N'Accent', N'Đen', '/images/vehicles/vehicle-white.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (46, '30A-980.17', N'VinFast', N'Fadil', N'Xám', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (47, '43A-930.51', N'Honda', N'Civic', N'Xám', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (48, '51H-256.78', N'Hyundai', N'Accent', N'Vàng cát', '/images/vehicles/vehicle-blue.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (49, '29B-928.40', N'Kia', N'Morning', N'Trắng', '/images/vehicles/vehicle-black.jpg');
INSERT INTO vehicles (user_id, license_plate, brand, model, color, image_path)
VALUES (50, '75A-831.46', N'BMW', N'X5', N'Đỏ', '/images/vehicles/vehicle-white.jpg');
GO

-- 4. SEED WASH SERVICES
INSERT INTO wash_services (name, description, price, duration_minutes, is_active)
VALUES (N'Rửa xe cơ bản', N'Rửa thân xe bên ngoài bằng nước và xà phòng', 50000, 20, 1);
INSERT INTO wash_services (name, description, price, duration_minutes, is_active)
VALUES (N'Rửa xe + Hút bụi nội thất', N'Rửa thân xe và hút bụi toàn bộ khoang nội thất', 100000, 35, 1);
INSERT INTO wash_services (name, description, price, duration_minutes, is_active)
VALUES (N'Rửa xe cao cấp (Wax + Đánh bóng)', N'Rửa xe, đánh bóng và phủ wax bảo vệ sơn xe', 250000, 60, 1);
INSERT INTO wash_services (name, description, price, duration_minutes, is_active)
VALUES (N'Vệ sinh khoang máy', N'Vệ sinh và làm sạch khoang động cơ', 150000, 30, 1);
INSERT INTO wash_services (name, description, price, duration_minutes, is_active)
VALUES (N'Gói chăm sóc toàn diện', N'Rửa xe, hút bụi nội thất, vệ sinh khoang máy, đánh bóng và phủ wax', 400000, 90, 1);
GO

-- 5. SEED BOOKINGS & WASH HISTORY
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (9, 11, 2, DATEADD(day, -10, CAST(GETDATE() AS DATE)), '16:00-16:30', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 100000, 100, DATEADD(minute, 77, DATEADD(day, -10, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 9, 11, 2, DATEADD(minute, 77, DATEADD(day, -10, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 100000, 100, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (8, 9, 1, DATEADD(day, -4, CAST(GETDATE() AS DATE)), '09:00-09:35', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 50000, 50, DATEADD(minute, 39, DATEADD(day, -4, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 8, 9, 1, DATEADD(minute, 39, DATEADD(day, -4, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 50000, 50, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (46, 55, 4, DATEADD(day, -12, CAST(GETDATE() AS DATE)), '16:00-16:30', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 150000, 150, DATEADD(minute, 44, DATEADD(day, -12, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 46, 55, 4, DATEADD(minute, 44, DATEADD(day, -12, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 150000, 150, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (24, 28, 2, DATEADD(day, -12, CAST(GETDATE() AS DATE)), '10:00-10:30', 'COMPLETED', 'PAID', 'CASH', 100000, 100, DATEADD(minute, 57, DATEADD(day, -12, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 24, 28, 2, DATEADD(minute, 57, DATEADD(day, -12, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 100000, 100, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (29, 34, 2, DATEADD(day, -8, CAST(GETDATE() AS DATE)), '16:00-16:30', 'COMPLETED', 'PAID', 'CASH', 100000, 100, DATEADD(minute, 33, DATEADD(day, -8, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 29, 34, 2, DATEADD(minute, 33, DATEADD(day, -8, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 100000, 100, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (43, 52, 2, DATEADD(day, -3, CAST(GETDATE() AS DATE)), '11:00-11:30', 'COMPLETED', 'PAID', 'CASH', 100000, 100, DATEADD(minute, 47, DATEADD(day, -3, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 43, 52, 2, DATEADD(minute, 47, DATEADD(day, -3, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 100000, 100, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (18, 22, 5, DATEADD(day, -8, CAST(GETDATE() AS DATE)), '08:00-08:30', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 400000, 400, DATEADD(minute, 21, DATEADD(day, -8, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 18, 22, 5, DATEADD(minute, 21, DATEADD(day, -8, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 400000, 400, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (27, 32, 5, DATEADD(day, -12, CAST(GETDATE() AS DATE)), '08:00-08:30', 'COMPLETED', 'PAID', 'CASH', 400000, 400, DATEADD(minute, 76, DATEADD(day, -12, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 27, 32, 5, DATEADD(minute, 76, DATEADD(day, -12, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 400000, 400, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (7, 8, 1, DATEADD(day, -10, CAST(GETDATE() AS DATE)), '14:00-14:35', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 50000, 50, DATEADD(minute, 72, DATEADD(day, -10, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 7, 8, 1, DATEADD(minute, 72, DATEADD(day, -10, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 50000, 50, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (28, 33, 3, DATEADD(day, -12, CAST(GETDATE() AS DATE)), '09:00-09:35', 'COMPLETED', 'PAID', 'CASH', 250000, 250, DATEADD(minute, 78, DATEADD(day, -12, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 28, 33, 3, DATEADD(minute, 78, DATEADD(day, -12, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 250000, 250, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (38, 47, 3, DATEADD(day, -7, CAST(GETDATE() AS DATE)), '16:00-16:30', 'NO_SHOW', 'UNPAID', NULL, 250000, 250, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (8, 9, 2, DATEADD(day, -10, CAST(GETDATE() AS DATE)), '11:00-11:30', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 100000, 100, DATEADD(minute, 48, DATEADD(day, -10, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 8, 9, 2, DATEADD(minute, 48, DATEADD(day, -10, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 100000, 100, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (20, 24, 5, DATEADD(day, -7, CAST(GETDATE() AS DATE)), '15:00-15:30', 'COMPLETED', 'PAID', 'CASH', 400000, 400, DATEADD(minute, 47, DATEADD(day, -7, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 20, 24, 5, DATEADD(minute, 47, DATEADD(day, -7, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 400000, 400, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (44, 53, 5, DATEADD(day, -14, CAST(GETDATE() AS DATE)), '14:00-14:35', 'COMPLETED', 'PAID', 'CASH', 400000, 400, DATEADD(minute, 28, DATEADD(day, -14, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 44, 53, 5, DATEADD(minute, 28, DATEADD(day, -14, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 400000, 400, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (29, 34, 5, DATEADD(day, -11, CAST(GETDATE() AS DATE)), '14:00-14:35', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 400000, 400, DATEADD(minute, 42, DATEADD(day, -11, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 29, 34, 5, DATEADD(minute, 42, DATEADD(day, -11, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 400000, 400, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (45, 54, 5, DATEADD(day, -11, CAST(GETDATE() AS DATE)), '16:00-16:30', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 400000, 400, DATEADD(minute, 52, DATEADD(day, -11, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 45, 54, 5, DATEADD(minute, 52, DATEADD(day, -11, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 400000, 400, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (7, 8, 3, DATEADD(day, -6, CAST(GETDATE() AS DATE)), '09:00-09:35', 'CANCELLED', 'UNPAID', NULL, 250000, 250, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (41, 50, 2, DATEADD(day, -11, CAST(GETDATE() AS DATE)), '08:00-08:30', 'CANCELLED', 'UNPAID', NULL, 100000, 100, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (36, 43, 1, DATEADD(day, -15, CAST(GETDATE() AS DATE)), '16:00-16:30', 'COMPLETED', 'PAID', 'CASH', 50000, 50, DATEADD(minute, 89, DATEADD(day, -15, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 36, 43, 1, DATEADD(minute, 89, DATEADD(day, -15, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 50000, 50, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (42, 51, 1, DATEADD(day, -6, CAST(GETDATE() AS DATE)), '10:00-10:30', 'CANCELLED', 'UNPAID', NULL, 50000, 50, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (37, 45, 5, DATEADD(day, -7, CAST(GETDATE() AS DATE)), '11:00-11:30', 'COMPLETED', 'PAID', 'CASH', 400000, 400, DATEADD(minute, 53, DATEADD(day, -7, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 37, 45, 5, DATEADD(minute, 53, DATEADD(day, -7, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 400000, 400, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (32, 38, 1, DATEADD(day, -11, CAST(GETDATE() AS DATE)), '11:00-11:30', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 50000, 50, DATEADD(minute, 83, DATEADD(day, -11, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 32, 38, 1, DATEADD(minute, 83, DATEADD(day, -11, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 50000, 50, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (19, 23, 5, DATEADD(day, -11, CAST(GETDATE() AS DATE)), '10:00-10:30', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 400000, 400, DATEADD(minute, 86, DATEADD(day, -11, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 19, 23, 5, DATEADD(minute, 86, DATEADD(day, -11, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 400000, 400, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (39, 48, 2, DATEADD(day, -7, CAST(GETDATE() AS DATE)), '11:00-11:30', 'NO_SHOW', 'UNPAID', NULL, 100000, 100, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (3, 3, 3, DATEADD(day, -15, CAST(GETDATE() AS DATE)), '09:00-09:35', 'COMPLETED', 'PAID', 'CASH', 250000, 250, DATEADD(minute, 39, DATEADD(day, -15, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 3, 3, 3, DATEADD(minute, 39, DATEADD(day, -15, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 250000, 250, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (12, 15, 5, DATEADD(day, -8, CAST(GETDATE() AS DATE)), '15:00-15:30', 'CANCELLED', 'UNPAID', NULL, 400000, 400, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (36, 44, 5, DATEADD(day, -15, CAST(GETDATE() AS DATE)), '08:00-08:30', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 400000, 400, DATEADD(minute, 37, DATEADD(day, -15, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 36, 44, 5, DATEADD(minute, 37, DATEADD(day, -15, CAST(GETDATE() AS DATETIME))), 'BANK_TRANSFER', 'PAID', 400000, 400, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (43, 52, 1, DATEADD(day, -4, CAST(GETDATE() AS DATE)), '15:00-15:30', 'CANCELLED', 'UNPAID', NULL, 50000, 50, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (25, 29, 2, DATEADD(day, -3, CAST(GETDATE() AS DATE)), '09:00-09:35', 'COMPLETED', 'PAID', 'CASH', 100000, 100, DATEADD(minute, 86, DATEADD(day, -3, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 25, 29, 2, DATEADD(minute, 86, DATEADD(day, -3, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 100000, 100, N'Dịch vụ tốt, phục vụ chu đáo');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (9, 11, 3, DATEADD(day, -5, CAST(GETDATE() AS DATE)), '10:00-10:30', 'COMPLETED', 'PAID', 'CASH', 250000, 250, DATEADD(minute, 28, DATEADD(day, -5, CAST(GETDATE() AS DATETIME))));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 9, 11, 3, DATEADD(minute, 28, DATEADD(day, -5, CAST(GETDATE() AS DATETIME))), 'CASH', 'PAID', 250000, 250, N'Dịch vụ tốt, phục vụ chu đáo');
GO

-- 6. SEED TODAY'S BOOKINGS
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (38, 47, 5, CAST(GETDATE() AS DATE), '08:00-08:20', 'COMPLETED', 'PAID', 'BANK_TRANSFER', 400000, 400, DATEADD(minute, 57, CAST(GETDATE() AS DATETIME)));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 38, 47, 5, DATEADD(minute, 57, CAST(GETDATE() AS DATETIME)), 'BANK_TRANSFER', 'PAID', 400000, 400, N'Rửa nhanh sạch đẹp');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (26, 31, 3, CAST(GETDATE() AS DATE), '08:30-08:50', 'COMPLETED', 'PAID', 'CASH', 250000, 250, DATEADD(minute, 24, CAST(GETDATE() AS DATETIME)));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 26, 31, 3, DATEADD(minute, 24, CAST(GETDATE() AS DATETIME)), 'CASH', 'PAID', 250000, 250, N'Rửa nhanh sạch đẹp');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (11, 14, 3, CAST(GETDATE() AS DATE), '09:00-09:20', 'COMPLETED', 'PAID', 'CASH', 250000, 250, DATEADD(minute, 37, CAST(GETDATE() AS DATETIME)));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 11, 14, 3, DATEADD(minute, 37, CAST(GETDATE() AS DATETIME)), 'CASH', 'PAID', 250000, 250, N'Rửa nhanh sạch đẹp');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (35, 42, 1, CAST(GETDATE() AS DATE), '09:30-09:50', 'COMPLETED', 'PAID', 'CASH', 50000, 50, DATEADD(minute, 48, CAST(GETDATE() AS DATETIME)));
INSERT INTO wash_history (booking_id, user_id, vehicle_id, service_id, wash_date, payment_method, payment_status, amount_paid, points_earned, feedback)
VALUES ((SELECT MAX(id) FROM bookings), 35, 42, 1, DATEADD(minute, 48, CAST(GETDATE() AS DATETIME)), 'CASH', 'PAID', 50000, 50, N'Rửa nhanh sạch đẹp');
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (47, 56, 1, CAST(GETDATE() AS DATE), '10:00-10:20', 'IN_PROGRESS', 'PAID', 'BANK_TRANSFER', 50000, 50, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (28, 33, 5, CAST(GETDATE() AS DATE), '10:30-10:50', 'IN_PROGRESS', 'UNPAID', NULL, 400000, 400, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (18, 22, 3, CAST(GETDATE() AS DATE), '11:00-11:20', 'IN_PROGRESS', 'PAID', 'CASH', 250000, 250, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (40, 49, 3, CAST(GETDATE() AS DATE), '11:30-11:50', 'IN_PROGRESS', 'UNPAID', NULL, 250000, 250, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (20, 24, 1, CAST(GETDATE() AS DATE), '13:00-13:20', 'CONFIRMED', 'UNPAID', NULL, 50000, 50, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (36, 44, 5, CAST(GETDATE() AS DATE), '13:30-13:50', 'CONFIRMED', 'UNPAID', NULL, 400000, 400, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (34, 41, 4, CAST(GETDATE() AS DATE), '14:00-14:20', 'CONFIRMED', 'UNPAID', NULL, 150000, 150, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (22, 26, 4, CAST(GETDATE() AS DATE), '14:30-14:50', 'CONFIRMED', 'UNPAID', NULL, 150000, 150, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (40, 49, 3, CAST(GETDATE() AS DATE), '15:00-15:20', 'CONFIRMED', 'UNPAID', NULL, 250000, 250, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (40, 49, 4, CAST(GETDATE() AS DATE), '15:30-15:50', 'CONFIRMED', 'UNPAID', NULL, 150000, 150, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (12, 15, 2, CAST(GETDATE() AS DATE), '16:00-16:20', 'NO_SHOW', 'UNPAID', NULL, 100000, 100, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (20, 24, 2, CAST(GETDATE() AS DATE), '16:30-16:50', 'NO_SHOW', 'UNPAID', NULL, 100000, 100, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (44, 53, 4, CAST(GETDATE() AS DATE), '17:00-17:20', 'NO_SHOW', 'UNPAID', NULL, 150000, 150, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (41, 50, 5, CAST(GETDATE() AS DATE), '17:30-17:50', 'CANCELLED', 'UNPAID', NULL, 400000, 400, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (22, 26, 2, CAST(GETDATE() AS DATE), '18:00-18:20', 'CANCELLED', 'UNPAID', NULL, 100000, 100, NULL);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned, completed_at)
VALUES (24, 28, 1, CAST(GETDATE() AS DATE), '18:30-18:50', 'CANCELLED', 'UNPAID', NULL, 50000, 50, NULL);
GO

-- 7. SEED FUTURE BOOKINGS
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned)
VALUES (42, 51, 3, DATEADD(day, 2, CAST(GETDATE() AS DATE)), '11:00-11:30', 'CONFIRMED', 'UNPAID', NULL, 250000, 250);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned)
VALUES (50, 59, 3, DATEADD(day, 5, CAST(GETDATE() AS DATE)), '15:00-15:30', 'CONFIRMED', 'UNPAID', NULL, 250000, 250);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned)
VALUES (34, 41, 5, DATEADD(day, 5, CAST(GETDATE() AS DATE)), '09:00-09:30', 'CONFIRMED', 'UNPAID', NULL, 400000, 400);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned)
VALUES (2, 1, 3, DATEADD(day, 2, CAST(GETDATE() AS DATE)), '15:00-15:30', 'CONFIRMED', 'UNPAID', NULL, 250000, 250);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned)
VALUES (35, 42, 1, DATEADD(day, 1, CAST(GETDATE() AS DATE)), '11:00-11:30', 'CONFIRMED', 'UNPAID', NULL, 50000, 50);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned)
VALUES (29, 34, 5, DATEADD(day, 1, CAST(GETDATE() AS DATE)), '09:00-09:30', 'CONFIRMED', 'UNPAID', NULL, 400000, 400);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned)
VALUES (44, 53, 5, DATEADD(day, 4, CAST(GETDATE() AS DATE)), '09:00-09:30', 'CONFIRMED', 'UNPAID', NULL, 400000, 400);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned)
VALUES (19, 23, 5, DATEADD(day, 2, CAST(GETDATE() AS DATE)), '11:00-11:30', 'CONFIRMED', 'UNPAID', NULL, 400000, 400);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned)
VALUES (49, 58, 1, DATEADD(day, 3, CAST(GETDATE() AS DATE)), '11:00-11:30', 'CONFIRMED', 'UNPAID', NULL, 50000, 50);
INSERT INTO bookings (user_id, vehicle_id, service_id, booking_date, time_slot, booking_status, payment_status, payment_method, total_amount, points_earned)
VALUES (17, 20, 1, DATEADD(day, 5, CAST(GETDATE() AS DATE)), '15:00-15:30', 'CONFIRMED', 'UNPAID', NULL, 50000, 50);
GO
