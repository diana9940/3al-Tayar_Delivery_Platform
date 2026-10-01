use delivery

USE delivery;
GO

-- =========================================
-- 1. USERS
-- =========================================

INSERT INTO Users
(name, email, password_hash, phone, role)
VALUES
('Diana Emil', 'diana@3altayer.com', 'hashed_password_1', '01000000001', 'Customer'),
('Ahmed Hassan', 'ahmed@3altayer.com', 'hashed_password_2', '01000000002', 'Customer'),
('Pizza House Owner', 'pizza@3altayer.com', 'hashed_password_3', '01000000003', 'StoreOwner'),
('Burger Hub Owner', 'burger@3altayer.com', 'hashed_password_4', '01000000004', 'StoreOwner'),
('Mohamed Driver', 'driver@3altayer.com', 'hashed_password_5', '01000000005', 'Driver'),
('Admin', 'admin@3altayer.com', 'hashed_password_6', '01000000006', 'Admin');

-- =========================================
-- 2. STORE CATEGORIES
-- =========================================

INSERT INTO StoreCategories
(category_name)
VALUES
('Restaurants'),
('Fast Food'),
('Desserts');

-- =========================================
-- 3. STORES
-- =========================================

INSERT INTO Stores
(owner_id, store_name, description, address,
 latitude, longitude, category_id,
 rating, delivery_fee, min_order, is_open)
VALUES
(
    3,
    'Pizza House',
    'Fresh pizza and Italian food',
    'Alexandria, Egypt',
    31.2001,
    29.9187,
    1,
    4.70,
    20.00,
    50.00,
    1
),
(
    4,
    'Burger Hub',
    'Burgers, fries and drinks',
    'Alexandria, Egypt',
    31.2156,
    29.9553,
    2,
    4.50,
    15.00,
    40.00,
    1
);

-- =========================================
-- 4. PRODUCT CATEGORIES
-- =========================================

INSERT INTO ProductCategories
(category_name)
VALUES
('Pizza'),
('Burgers'),
('Drinks'),
('Desserts');

-- =========================================
-- 5. PRODUCTS
-- =========================================

INSERT INTO Products
(store_id, category_id, name, description,
 price, image_url, is_available)
VALUES
(
    1,
    1,
    'Margherita Pizza',
    'Classic tomato and mozzarella pizza',
    120.00,
    'margherita.jpg',
    1
),
(
    1,
    1,
    'Chicken Pizza',
    'Pizza with grilled chicken',
    160.00,
    'chicken_pizza.jpg',
    1
),
(
    1,
    3,
    'Pepsi',
    'Cold soft drink',
    25.00,
    'pepsi.jpg',
    1
),
(
    2,
    2,
    'Classic Burger',
    'Beef burger with cheese',
    110.00,
    'classic_burger.jpg',
    1
),
(
    2,
    2,
    'Chicken Burger',
    'Crispy chicken burger',
    100.00,
    'chicken_burger.jpg',
    1
),
(
    2,
    3,
    'Cola',
    'Cold soft drink',
    25.00,
    'cola.jpg',
    1
);

-- =========================================
-- 6. ADDRESSES
-- =========================================

INSERT INTO Addresses
(customer_id, label, street, city,
 latitude, longitude, is_default)
VALUES
(
    1,
    'Home',
    '123 Alexandria Street',
    'Alexandria',
    31.2057,
    29.9245,
    1
),
(
    2,
    'Home',
    '45 El Horreya Road',
    'Alexandria',
    31.2089,
    29.9092,
    1
);

-- =========================================
-- 7. DRIVER
-- =========================================

INSERT INTO Drivers
(user_id, vehicle_type, license_number,
 status, current_latitude, current_longitude,
 rating, total_deliveries, earnings)
VALUES
(
    5,
    'Motorcycle',
    'LIC-10001',
    'Available',
    31.2100,
    29.9200,
    4.80,
    25,
    3500.00
);

-- =========================================
-- CHECK DATA
-- =========================================

SELECT * FROM Users;

SELECT * FROM Stores;

SELECT * FROM Products;

SELECT * FROM Addresses;

SELECT * FROM Drivers;
