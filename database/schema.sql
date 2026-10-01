create database delivery

use delivery

create table Users(
    user_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('Customer', 'StoreOwner', 'Driver', 'Admin')) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE StoreCategories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(50) NOT NULL
)

CREATE TABLE Stores (
    store_id INT PRIMARY KEY IDENTITY(1,1),
    owner_id INT FOREIGN KEY REFERENCES Users(user_id),
    store_name VARCHAR(100) NOT NULL,
    description TEXT,
    address TEXT NOT NULL,
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    category_id INT FOREIGN KEY REFERENCES StoreCategories(category_id),
    rating DECIMAL(3, 2) DEFAULT 0.0,
    delivery_fee DECIMAL(10, 2) DEFAULT 0.0,
    min_order DECIMAL(10, 2) DEFAULT 0.0,
    is_open BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE Products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    store_id INT FOREIGN KEY REFERENCES Stores(store_id),
    category_id INT, 
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(255),
    is_available BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE Addresses (
    address_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES Users(user_id),
    label VARCHAR(50), -- مثل: البيت، الشغل، الجامعة
    street TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    is_default BIT DEFAULT 0
)

CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    vehicle_type VARCHAR(50) NOT NULL, -- مثل: دراجة نارية، سكوتر، سيارة
    license_number VARCHAR(50) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Available', 'Busy', 'Offline')) DEFAULT 'Offline',
    current_latitude DECIMAL(9, 6),
    current_longitude DECIMAL(9, 6),
    rating DECIMAL(3, 2) DEFAULT 0.0,
    total_deliveries INT DEFAULT 0,
    earnings DECIMAL(10, 2) DEFAULT 0.0
    )

CREATE TABLE Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES Users(user_id),
    store_id INT FOREIGN KEY REFERENCES Stores(store_id),
    address_id INT FOREIGN KEY REFERENCES Addresses(address_id),
    total_amount DECIMAL(10, 2) NOT NULL,
    delivery_fee DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) DEFAULT 0.0,
    final_amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) CHECK (payment_status IN ('Pending', 'Paid', 'Failed', 'Refunded')) DEFAULT 'Pending',
    order_status VARCHAR(30) CHECK (order_status IN ('Pending', 'Confirmed', 'Preparing', 'Ready', 'Assigned', 'Picked Up', 'On The Way', 'Delivered', 'Cancelled')) DEFAULT 'Pending',
    estimated_delivery_time INT, -- بالدقائق
    created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT FOREIGN KEY REFERENCES Orders(order_id) ON DELETE CASCADE,
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL
)

CREATE TABLE Deliveries (
    delivery_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    driver_id INT FOREIGN KEY REFERENCES Drivers(driver_id),
    assigned_at DATETIME DEFAULT GETDATE(),
    picked_up_at DATETIME,
    delivered_at DATETIME,
    distance DECIMAL(6, 2), -- بالكيلومتر
    delivery_status VARCHAR(30) DEFAULT 'Assigned'
)

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    payment_method VARCHAR(30) CHECK (payment_method IN ('Cash on Delivery', 'Online Card', 'Wallet')) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Paid', 'Failed', 'Refunded')) DEFAULT 'Pending',
    transaction_id VARCHAR(100),
    paid_at DATETIME
)

CREATE TABLE Reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES Users(user_id),
    store_id INT FOREIGN KEY REFERENCES Stores(store_id),
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    rating INT CHECK (rating BETWEEN 1 AND 5) NOT NULL,
    comment TEXT,
    created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE Favorites (
    favorite_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES Users(user_id),
    store_id INT FOREIGN KEY REFERENCES Stores(store_id) NULL,
    product_id INT FOREIGN KEY REFERENCES Products(product_id) NULL,
    created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE Coupons (
    coupon_id INT PRIMARY KEY IDENTITY(1,1),
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_type VARCHAR(20) CHECK (discount_type IN ('Percentage', 'Fixed')) NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    min_order_amount DECIMAL(10, 2) DEFAULT 0.0,
    max_discount DECIMAL(10, 2),
    start_date DATETIME,
    end_date DATETIME,
    usage_limit INT,
    is_active BIT DEFAULT 1
)

CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    is_read BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
)

CREATE TABLE ProductCategories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(50) NOT NULL
)

ALTER TABLE Products
ADD CONSTRAINT FK_Products_ProductCategories
FOREIGN KEY (category_id)
REFERENCES ProductCategories(category_id);

ALTER TABLE Deliveries
ADD CONSTRAINT CK_Deliveries_Status
CHECK (delivery_status IN
('Assigned', 'Picked Up', 'On The Way', 'Delivered', 'Cancelled'))


CREATE TABLE OrderStatusHistory (
    history_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    status VARCHAR(30) NOT NULL,
    changed_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_OrderStatusHistory_Orders
    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id)
    ON DELETE CASCADE,

    CONSTRAINT CK_OrderStatusHistory_Status
    CHECK (status IN
    ('Pending', 'Confirmed', 'Preparing', 'Ready',
     'Assigned', 'Picked Up', 'On The Way',
     'Delivered', 'Cancelled'))
)

ALTER TABLE Favorites
ADD CONSTRAINT CK_Favorites_Target
CHECK (
    (store_id IS NOT NULL AND product_id IS NULL)
    OR
    (store_id IS NULL AND product_id IS NOT NULL)
);

ALTER TABLE Drivers
ADD CONSTRAINT UQ_Drivers_User
UNIQUE (user_id)

ALTER TABLE Deliveries
ADD CONSTRAINT UQ_Deliveries_Order
UNIQUE (order_id)

ALTER TABLE Reviews
ADD CONSTRAINT UQ_Reviews_Order
UNIQUE (order_id)

CREATE UNIQUE INDEX UX_Favorites_Customer_Store
ON Favorites(customer_id, store_id)
WHERE store_id IS NOT NULL;

CREATE UNIQUE INDEX UX_Favorites_Customer_Product
ON Favorites(customer_id, product_id)
WHERE product_id IS NOT NULL;

ALTER TABLE OrderItems
ADD CONSTRAINT CK_OrderItems_Quantity
CHECK (quantity > 0);

ALTER TABLE OrderItems
ADD CONSTRAINT CK_OrderItems_UnitPrice
CHECK (unit_price >= 0)

ALTER TABLE Products
ADD CONSTRAINT CK_Products_Price
CHECK (price >= 0)

ALTER TABLE Orders
ADD CONSTRAINT CK_Orders_Amounts
CHECK (
    total_amount >= 0
    AND delivery_fee >= 0
    AND discount >= 0
    AND final_amount >= 0
)

ALTER TABLE Stores
ADD CONSTRAINT CK_Stores_Rating
CHECK (rating BETWEEN 0 AND 5);

ALTER TABLE Drivers
ADD CONSTRAINT CK_Drivers_Rating
CHECK (rating BETWEEN 0 AND 5);


ALTER TABLE Coupons
ADD CONSTRAINT CK_Coupons_Discount
CHECK (discount_value >= 0)

CREATE TABLE DriverLocations (
    location_id INT PRIMARY KEY IDENTITY(1,1),
    driver_id INT NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    recorded_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_DriverLocations_Drivers
    FOREIGN KEY (driver_id)
    REFERENCES Drivers(driver_id)
)

