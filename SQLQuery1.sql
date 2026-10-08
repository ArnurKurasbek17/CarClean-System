CREATE DATABASE СarСlean;
GO

USE СarСlean;
GO

CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('client', 'administrator', 'washer', 'manager')) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE car_washes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    rating DECIMAL(3, 2) DEFAULT 5.00,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE services (
    id INT IDENTITY(1,1) PRIMARY KEY,
    car_wash_id INT REFERENCES car_washes(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

CREATE TABLE boxes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    car_wash_id INT REFERENCES car_washes(id) ON DELETE CASCADE,
    number INT NOT NULL,
    status VARCHAR(20) DEFAULT 'free' CHECK (status IN ('free', 'busy', 'maintenance'))
);

CREATE TABLE bookings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT REFERENCES users(id),
    car_wash_id INT REFERENCES car_washes(id),
    service_id INT REFERENCES services(id),
    box_id INT NULL REFERENCES boxes(id),
    washer_id INT NULL REFERENCES users(id),
    car_model VARCHAR(100) NOT NULL,
    plate_number VARCHAR(20) NOT NULL,
    appointment_time DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'booked' CHECK (status IN ('booked', 'in_progress', 'completed', 'cancelled')),
    qr_code VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE payments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    booking_id INT REFERENCES bookings(id),
    amount DECIMAL(10, 2) NOT NULL,
    method VARCHAR(20) CHECK (method IN ('online', 'cash')) NOT NULL,
    washer_commission DECIMAL(10, 2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'paid')),
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE reviews (
    id INT IDENTITY(1,1) PRIMARY KEY,
    car_wash_id INT REFERENCES car_washes(id) ON DELETE CASCADE,
    client_id INT REFERENCES users(id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at DATETIME DEFAULT GETDATE()
);

INSERT INTO users (full_name, phone, password_hash, role) VALUES 
('Асқар Админов', '+77011112233', 'hash_pass_1', 'administrator'),
('Қайрат Жуушы', '+77022223344', 'hash_pass_2', 'washer'),
('Арнур Клиент', '+77073334455', 'hash_pass_3', 'client');

INSERT INTO car_washes (name, city, address, rating) VALUES 
('CarClean Almaty', 'Алматы', 'Абай даңғылы 150', 4.90);

INSERT INTO services (car_wash_id, name, price, description) VALUES 
(1, 'Тек сырты (Кузов)', 1500.00, 'Көліктің сыртын шампуньмен жуу және кептіру'),
(1, 'Іші және сырты (Комплекс)', 3500.00, 'Салонды шаңсорғышпен тазалау, шынылар және сыртын жуу'),
(1, 'Толық люкс (Химчистка + Полировка)', 12000.00, 'Толық премиум тазалау');

INSERT INTO boxes (car_wash_id, number, status) VALUES 
(1, 1, 'free'),
(1, 2, 'free');

INSERT INTO bookings (client_id, car_wash_id, service_id, box_id, washer_id, car_model, plate_number, appointment_time, status, qr_code) VALUES 
(3, 1, 2, 1, 2, 'Toyota Camry 70', '777 AAA 02', '2026-06-10 14:30:00', 'booked', 'QR_CODE_STRING_123');

INSERT INTO payments (booking_id, amount, method, washer_commission, status) VALUES 
(1, 3500.00, 'online', 1050.00, 'paid');