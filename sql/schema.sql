-- DDL Schema definition for Smart Automated Car Wash System
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'AutoCarWash')
BEGIN
    CREATE DATABASE AutoCarWash;
END;
GO

USE AutoCarWash;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='tiers' AND xtype='U')
BEGIN
    CREATE TABLE tiers (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name VARCHAR(20) UNIQUE NOT NULL,
        point_multiplier DECIMAL(3,2) NOT NULL DEFAULT 1.00,
        booking_window_days INT NOT NULL DEFAULT 7,
        min_washes INT NOT NULL DEFAULT 0,
        min_spend DECIMAL(18,2) NOT NULL DEFAULT 0
    );
END;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
BEGIN
    CREATE TABLE users (
        id INT IDENTITY(1,1) PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        fullname NVARCHAR(100),
        phone VARCHAR(20),
        role VARCHAR(20) DEFAULT 'CUSTOMER',
        tier_id INT FOREIGN KEY REFERENCES tiers(id),
        points_balance INT DEFAULT 0,
        lifetime_spent DECIMAL(18,2) DEFAULT 0,
        created_at DATETIME DEFAULT GETDATE()
    );
END;
GO

IF COL_LENGTH('users', 'tier_id') IS NULL
BEGIN
    ALTER TABLE users ADD tier_id INT FOREIGN KEY REFERENCES tiers(id);
END;
GO

IF COL_LENGTH('users', 'points_balance') IS NULL
BEGIN
    ALTER TABLE users ADD points_balance INT DEFAULT 0;
END;
GO

IF COL_LENGTH('users', 'lifetime_spent') IS NULL
BEGIN
    ALTER TABLE users ADD lifetime_spent DECIMAL(18,2) DEFAULT 0;
END;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='services' AND xtype='U')
BEGIN
    CREATE TABLE services (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        price DECIMAL(10,2) NOT NULL,
        description NVARCHAR(255)
    );
END;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='promotions' AND xtype='U')
BEGIN
    CREATE TABLE promotions (
        id INT IDENTITY(1,1) PRIMARY KEY,
        code VARCHAR(50) UNIQUE NOT NULL,
        discount_percent INT NOT NULL,
        min_tier_id INT FOREIGN KEY REFERENCES tiers(id),
        is_active BIT DEFAULT 1
    );
END;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='orders' AND xtype='U')
BEGIN
    CREATE TABLE orders (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT FOREIGN KEY REFERENCES users(id),
        service_id INT FOREIGN KEY REFERENCES services(id),
        promotion_id INT FOREIGN KEY REFERENCES promotions(id),
        car_plate VARCHAR(20) NOT NULL,
        book_date DATETIME NOT NULL,
        status NVARCHAR(20) DEFAULT 'PENDING',
        points_used INT DEFAULT 0,
        final_price DECIMAL(18,2)
    );
END;
GO

IF COL_LENGTH('orders', 'promotion_id') IS NULL
BEGIN
    ALTER TABLE orders ADD promotion_id INT FOREIGN KEY REFERENCES promotions(id);
END;
GO

IF COL_LENGTH('orders', 'points_used') IS NULL
BEGIN
    ALTER TABLE orders ADD points_used INT DEFAULT 0;
END;
GO

IF COL_LENGTH('orders', 'final_price') IS NULL
BEGIN
    ALTER TABLE orders ADD final_price DECIMAL(18,2);
END;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vehicles' AND xtype='U')
BEGIN
    CREATE TABLE vehicles (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT FOREIGN KEY REFERENCES users(id),
        license_plate VARCHAR(20) UNIQUE NOT NULL,
        is_default BIT DEFAULT 0
    );
END;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='loyalty_history' AND xtype='U')
BEGIN
    CREATE TABLE loyalty_history (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT FOREIGN KEY REFERENCES users(id),
        points_changed INT NOT NULL,
        points_remaining INT NOT NULL,
        reason NVARCHAR(255),
        created_at DATETIME DEFAULT GETDATE(),
        expires_at DATETIME
    );
END;
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_UserId' AND object_id = OBJECT_ID('orders'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Orders_UserId ON orders(user_id);
END;
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Orders_Status_Date' AND object_id = OBJECT_ID('orders'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_Orders_Status_Date ON orders(status, book_date);
END;
GO
