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
        role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
        tier_id INT FOREIGN KEY REFERENCES tiers(id),
        points_balance INT NOT NULL DEFAULT 0,
        total_washes INT NOT NULL DEFAULT 0,
        lifetime_spent DECIMAL(18,2) NOT NULL DEFAULT 0,
        is_deleted BIT NOT NULL DEFAULT 0,
        created_at DATETIME DEFAULT GETDATE()
    );
END;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vehicles' AND xtype='U')
BEGIN
    CREATE TABLE vehicles (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT FOREIGN KEY REFERENCES users(id) ON DELETE CASCADE,
        license_plate VARCHAR(20) UNIQUE NOT NULL,
        brand NVARCHAR(50),
        model NVARCHAR(50),
        color NVARCHAR(30),
        image_path VARCHAR(255),
        is_deleted BIT NOT NULL DEFAULT 0
    );
END;
GO
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='wash_services' AND xtype='U')
BEGIN
    CREATE TABLE wash_services (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        description NVARCHAR(500),
        price DECIMAL(18,2) NOT NULL,
        duration_minutes INT NOT NULL DEFAULT 30,
        is_active BIT DEFAULT 1,
        is_deleted BIT NOT NULL DEFAULT 0
    );
END;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='bookings' AND xtype='U')
BEGIN
    CREATE TABLE bookings (
        id INT IDENTITY(1,1) PRIMARY KEY,
        user_id INT FOREIGN KEY REFERENCES users(id),
        vehicle_id INT FOREIGN KEY REFERENCES vehicles(id),
        service_id INT FOREIGN KEY REFERENCES wash_services(id),
        booking_date DATE NOT NULL,
        time_slot VARCHAR(20) NOT NULL,
        booking_status VARCHAR(20) NOT NULL DEFAULT 'CONFIRMED',
        total_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
        points_earned INT DEFAULT 0,
        notes NVARCHAR(500),
        created_at DATETIME DEFAULT GETDATE(),
        completed_at DATETIME NULL,
        is_deleted BIT NOT NULL DEFAULT 0
    );
END;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='payments' AND xtype='U')
BEGIN
    CREATE TABLE payments (
        id INT IDENTITY(1,1) PRIMARY KEY,
        booking_id INT NOT NULL UNIQUE
            FOREIGN KEY REFERENCES bookings(id) ON DELETE CASCADE,
        user_id INT NOT NULL
            FOREIGN KEY REFERENCES users(id),
        amount DECIMAL(18,2) NOT NULL,
        payment_method VARCHAR(30),
        payment_status VARCHAR(20) NOT NULL DEFAULT 'UNPAID',
        paid_at DATETIME NULL,
        created_at DATETIME NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME NOT NULL DEFAULT GETDATE()
    );
END;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='wash_history' AND xtype='U')
BEGIN
    CREATE TABLE wash_history (
       id INT IDENTITY(1,1) PRIMARY KEY,
       booking_id INT FOREIGN KEY REFERENCES bookings(id),
       user_id INT FOREIGN KEY REFERENCES users(id),
       vehicle_id INT FOREIGN KEY REFERENCES vehicles(id),
       service_id INT FOREIGN KEY REFERENCES wash_services(id),
       wash_date DATETIME NOT NULL,
       amount_paid DECIMAL(18,2),
       points_earned INT DEFAULT 0,
       feedback NVARCHAR(500),
       created_at DATETIME DEFAULT GETDATE()
    );
END;
GO
