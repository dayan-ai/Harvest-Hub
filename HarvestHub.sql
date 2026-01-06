-- 1. Database Setup
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

-- 2. Tables Creation (Group Mate Schema)
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(MAX)
);

CREATE TABLE Coupons (
    coupon_id INT PRIMARY KEY IDENTITY(1,1),
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percentage DECIMAL(5, 2),
    is_active BIT DEFAULT 1
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description VARCHAR(MAX),
    image_url VARCHAR(255),
    category_id INT,
    CONSTRAINT FK_Products_Categories FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

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

-- 3. DUMMY DATA INSERTION (Zaroori hai taake Order Place ho sake)
-- Pehle Categories dalte hain
INSERT INTO Categories (category_name) VALUES ('Fruits'), ('Vegetables');

-- Ab wo saray Products dalte hain jo tumhari Website par hain (Name match hona zaroori hai)
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
('Cheery', 5.75, 1, 'best-product-2.jpg'),
('Apricots', 1.15, 1, 'best-product-4.jpg'),
('Grapes', 3.99, 1, 'best-product-5.jpg'),
('Bell Pepper', 6.05, 2, 'vegetable-item-4.jpg');

PRINT 'Database Created and Products Inserted Successfully!';
USE HarvestHub; -- Make sure hum sahi database mein hain

-- 1. Customers (s lagana zaroori hai)
SELECT * FROM Customers;

-- 2. Orders (s lagana zaroori hai)
SELECT * FROM Orders;

-- 3. Order Items (Beech mein underscore _ aur end mein s)
SELECT * FROM Order_Items;

-- 4. Products
SELECT * FROM Products;
USE HarvestHub;
SELECT * FROM Users;