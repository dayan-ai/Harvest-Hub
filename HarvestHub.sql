-- =============================================
-- 1. FRESH DATABASE START
-- =============================================
USE master;
GO
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
-- 1. Categories
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(MAX)
);
-- 2. Products
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
    stock_quantity INT DEFAULT 100, 
    CONSTRAINT FK_Products_Categories FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
-- 3. Users (Login)
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'customer'
);
-- 4. Customers (Fixed: Added phone_number directly)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),  -- 
    address VARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);
-- 5. Coupons (Added this table so coupons work)
CREATE TABLE Coupons (
    coupon_id INT PRIMARY KEY IDENTITY(1,1),
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percentage DECIMAL(5, 2),
    is_active BIT DEFAULT 1
);
-- 6. Orders (Fixed: Added subtotal & tax directly)
CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    coupon_id INT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    subtotal DECIMAL(10, 2),    -- <-- Added
    tax_amount DECIMAL(10, 2),  -- <-- Added
    total_amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50) DEFAULT 'Pending',
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT FK_Orders_Coupons FOREIGN KEY (coupon_id) REFERENCES Coupons(coupon_id)
);
-- 7. Order Items
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
-- 3. INSERT DATA (Seeding)
-- =============================================
-- Categories
INSERT INTO Categories (category_name, description) VALUES 
('Fruits', 'Fresh organic fruits from farm'), 
('Vegetables', 'Green and healthy vegetables');
-- Users
INSERT INTO Users (name, email, password, role) VALUES 
('Admin User', 'admin@harvest.com', 'admin123', 'admin'),
('Muhammad Dayan', 'datascientistdayan@gmail.com', '12345', 'customer');
-- Products (Full List)
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
-- Coupons 
INSERT INTO Coupons (code, discount_percentage) VALUES ('SAVE10', 10.00);
INSERT INTO Coupons (code, discount_percentage) VALUES ('HARVEST20', 20.00);
INSERT INTO Coupons (code, discount_percentage) VALUES ('WELCOME50', 50.00);
PRINT '✅ Database Fixed & Data Inserted Successfully!';
-- =============================================
-- 4. TEACHER DEMO 
-- =============================================
-- A) View Data
SELECT * FROM Products;
SELECT * FROM Users;
SELECT * FROM Coupons;
-- B) Update Logic
UPDATE Products SET price = 3.00 WHERE name = 'Apple';
-- C) Join Logic 
SELECT P.name, P.price, C.category_name 
FROM Products P 
INNER JOIN Categories C ON P.category_id = C.category_id;
PRINT 'All Demo Commands Ready!';

--===================
USE HarvestHub;
GO
-- Cheack it weather its a new customer
SELECT TOP 5 * FROM Customers ORDER BY customer_id DESC;
-- 2. Check oder is saved or not
SELECT TOP 5 * FROM Orders ORDER BY order_id DESC;
-- 3. For Joint
SELECT 
    O.order_id,
    C.full_name AS CustomerName,
    C.phone_number,
    O.total_amount,
    O.payment_method,
    O.order_date,
    COALESCE(CP.code, 'No Coupon') AS CouponUsed 
FROM Orders O
INNER JOIN Customers C ON O.customer_id = C.customer_id
LEFT JOIN Coupons CP ON O.coupon_id = CP.coupon_id
ORDER BY O.order_id DESC;