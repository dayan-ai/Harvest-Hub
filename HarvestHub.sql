-- =============================================
-- 1. DATABASE REFRESH 
-- =============================================
USE master;
GO
-- Agar pehle se bana hai to delete kar do (Fresh Start)
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'HarvestHub')
BEGIN
    ALTER DATABASE HarvestHub SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HarvestHub;
END
GO
CREATE DATABASE HarvestHub;
GO
USE HarvestHub;
GO
-- =============================================
-- 2. TABLES CREATION
-- =============================================
-- Table: Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(MAX)
);
-- Table: Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description VARCHAR(MAX),
    image_url VARCHAR(255),
    weight_per_unit VARCHAR(50) DEFAULT '1 Kg',
    category_id INT,
    country_of_origin VARCHAR(100) DEFAULT 'Agro Farm',
    quality_type VARCHAR(50) DEFAULT 'Organic',
    min_weight_order VARCHAR(50) DEFAULT '250 gm',
    CONSTRAINT FK_Products_Categories FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
-- Table: Users (Login System)
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'customer'
);
-- Table: Customers (Shipping Info)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);
-- Table: Coupons
CREATE TABLE Coupons (
    coupon_id INT PRIMARY KEY IDENTITY(1,1),
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percentage DECIMAL(5, 2),
    is_active BIT DEFAULT 1
);
-- Table: Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    coupon_id INT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    subtotal DECIMAL(10, 2),
    tax_amount DECIMAL(10, 2),
    total_amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50) DEFAULT 'Pending',
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT FK_Orders_Coupons FOREIGN KEY (coupon_id) REFERENCES Coupons(coupon_id)
);
-- Table: Order_Items
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
-- =============================================
-- 3. INSERTING DATA 
-- =============================================
-- Step 1: Categories
INSERT INTO Categories (category_name, description) VALUES 
('Fruits', 'Fresh organic fruits from farm'), 
('Vegetables', 'Green and healthy vegetables');
-- Step 2: Users (Admin & Customer)
INSERT INTO Users (name, email, password, role) VALUES 
('Admin User', 'admin@harvest.com', 'admin123', 'admin'),
('Muhammad Dayan', 'datascientistdayan@gmail.com', '12345', 'customer');
-- Step 3: Products (Ab Categories exist karti hain to ye error nahi dega)
INSERT INTO Products (name, price, category_id, image_url) VALUES 
('Big Banana', 3.28, 1, 'vegetable-item-3.png'),
('Potatoes', 1.76, 2, 'vegetable-item-5.jpg'),
('Brocoli', 2.67, 2, 'vegetable-item-2.jpg'),
('Red Tomato', 1.99, 2, 'vegetable-item-1.jpg'),
('Fresh Parsely', 1.49, 2, 'vegetable-item-6.jpg'),
('Strawberry', 2.29, 1, 'featur-2.jpg'),
('Apple', 2.59, 1, 'featur-1.jpg'),
('Red Apple', 3.50, 1, 'baner-1.png'),
('Orange', 4.25, 1, 'best-product-1.jpg'),
('Cherry', 5.75, 1, 'best-product-2.jpg'),
('Apricots', 1.15, 1, 'best-product-4.jpg'),
('Grapes', 3.99, 1, 'best-product-5.jpg'),
('Bell Pepper', 6.05, 2, 'vegetable-item-4.jpg');
-- Step 4: Dummy Coupon
INSERT INTO Coupons (code, discount_percentage) VALUES ('SAVE10', 10.00);
INSERT INTO Coupons (code, discount_percentage) VALUES ('HARVEST20', 20.00);
INSERT INTO Coupons (code, discount_percentage) VALUES ('WELCOME50', 50.00);

PRINT 'Data Inserted Successfully!';
-- =============================================
-- 4. COMMANDS FOR TEACHER 
-- =============================================
-- A) SELECT Command 
SELECT * FROM Products;
SELECT * FROM Users;
-- B) UPDATE Command 
-- Changing Apple's Price to 3.00
UPDATE Products 
SET price = 3.00 
WHERE name = 'Apple';
-- C) INSERT Command 
INSERT INTO Users (name, email, password, role) 
VALUES ('Teacher Demo', 'teacher@uet.edu.pk', 'pass123', 'customer');
-- D) DELETE Command 
DELETE FROM Users 
WHERE email = 'teacher@uet.edu.pk';
-- E) JOIN Query
SELECT 
    P.name AS ProductName, 
    P.price, 
    C.category_name 
FROM Products P
INNER JOIN Categories C ON P.category_id = C.category_id;
-- F) AGGREGATE FUNCTION (For Counting)
SELECT COUNT(*) AS TotalProducts FROM Products;
-- G) ALTER Command (Table modifier)
ALTER TABLE Products 
ADD is_available BIT DEFAULT 1;
-- H) ORDER BY (Sorting)
SELECT * FROM Products ORDER BY price DESC;
--++++++++++++++++++++++++++++++++++++++++++++++
-- 1. Users (Login)
SELECT * FROM Users;

-- 2. Products (Showing at shop)
SELECT * FROM Products;

-- 3. Categories (Fruits/Vegs)
SELECT * FROM Categories;

-- 4. Customers (Who are placing oders)
SELECT * FROM Customers;

-- 5. Orders (Placed Oders)
SELECT * FROM Orders;

-- 6. Order Items (Item in)
SELECT * FROM Order_Items;

-- 7. Coupons
SELECT * FROM Coupons;
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRINT 'All SQL Operations Demonstrated Successfully!';
--hhhhhhhhhhhhhhhhhhhhhhhhhh
-- =============================================
-- 1. CLEANUP & DATABASE CREATION
-- =============================================
USE master;
GO

-- Agar database pehle se hai to delete kar do (Fresh Start)
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'HarvestHub')
BEGIN
    ALTER DATABASE HarvestHub SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HarvestHub;
END
GO

CREATE DATABASE HarvestHub;
GO

USE HarvestHub;
GO

-- =============================================
-- 2. CREATE TABLES
-- =============================================

-- Categories Table
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(MAX)
);

-- Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'customer'
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description VARCHAR(MAX),
    image_url VARCHAR(255),
    category_id INT,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    address VARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    total_amount DECIMAL(10, 2),
    order_date DATETIME DEFAULT GETDATE(),
    payment_method VARCHAR(50),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- =============================================
-- 3. INSERT DATA (Seed Data)
-- =============================================
-- Categories Insert
INSERT INTO Categories (category_name, description) VALUES 
('Fruits', 'Fresh organic fruits'), 
('Vegetables', 'Green vegetables');
-- Users Insert 
INSERT INTO Users (name, email, password, role) VALUES 
('Admin', 'admin@harvest.com', 'admin123', 'admin'),
('Dayan', 'dayan@gmail.com', '12345', 'customer');
-- Products Insert 
INSERT INTO Products (name, price, category_id, image_url) VALUES 
('Apple', 2.59, 1, 'featur-1.jpg'),
('Strawberry', 2.29, 1, 'featur-2.jpg'),
('Brocoli', 2.67, 2, 'vegetable-item-2.jpg'),
('Tomato', 1.99, 2, 'vegetable-item-1.jpg'),
('Banana', 3.28, 1, 'vegetable-item-3.png');
PRINT '✅ Database & Data Created Successfully!';
-- =============================================
-- 4. TEACHER DEMO COMMANDS (Run these to show Ma'am)
-- =============================================
-- A) UPDATE Command: Change apple price
UPDATE Products SET price = 3.50 WHERE name = 'Apple';
PRINT 'Cmd: Price Updated';
-- B) DELETE Command: Delete user
DELETE FROM Users WHERE email = 'dayan@gmail.com';
PRINT 'Cmd: User Deleted';
-- C) JOIN Command: show category name with product
SELECT P.name as ProductName, P.price, C.category_name 
FROM Products P
INNER JOIN Categories C ON P.category_id = C.category_id;
-- D) ALTER Command: Add new table in product
ALTER TABLE Products ADD stock_quantity INT DEFAULT 100;
PRINT 'Cmd: Column Added';
-- E) Check Final Data
SELECT * FROM Products;
SELECT * FROM Users;

--============================
USE HarvestHub;
GO

ALTER TABLE Customers 
ADD phone_number VARCHAR(20);

USE HarvestHub;
SELECT * FROM Customers;

USE HarvestHub;
GO

ALTER TABLE Orders
ADD subtotal DECIMAL(10, 2),
    tax_amount DECIMAL(10, 2);