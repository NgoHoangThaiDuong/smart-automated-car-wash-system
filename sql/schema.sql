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


