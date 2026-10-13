-- NIRE Hotel and Suites - Abuja, FCT
-- Database Schema Definition (MariaDB / MySQL Compatible)

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS reservation_rooms;
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS guests;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS room_types;

SET FOREIGN_KEY_CHECKS = 1;

-- 1. Room Types Entity
CREATE TABLE room_types (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    base_rate DECIMAL(10, 2) NOT NULL CHECK (base_rate > 0),
    max_occupancy INT NOT NULL CHECK (max_occupancy > 0),
    bed_type VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- 2. Physical Rooms Entity
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_type_id INT NOT NULL,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    floor_number INT NOT NULL,
    status VARCHAR(20) DEFAULT 'AVAILABLE' 
        CHECK (status IN ('AVAILABLE', 'OCCUPIED', 'RESERVED', 'MAINTENANCE')),
    CONSTRAINT fk_rooms_room_type FOREIGN KEY (room_type_id) 
        REFERENCES room_types(room_type_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 3. Guests Entity
CREATE TABLE guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(25) NOT NULL,
    identity_type VARCHAR(30) NOT NULL 
        CHECK (identity_type IN ('NIN', 'INTERNATIONAL_PASSPORT', 'DRIVERS_LICENSE', 'VOTERS_CARD')),
    identity_number VARCHAR(50) NOT NULL UNIQUE,
    residential_address TEXT NOT NULL,
    emergency_contact_name VARCHAR(100) NOT NULL,
    emergency_contact_phone VARCHAR(25) NOT NULL,
    emergency_contact_address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 4. Reservations Entity
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'CONFIRMED' 
        CHECK (booking_status IN ('CONFIRMED', 'CANCELLED', 'COMPLETED', 'NO_SHOW')),
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00 CHECK (total_amount >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reservations_guest FOREIGN KEY (guest_id) 
        REFERENCES guests(guest_id) ON DELETE RESTRICT,
    CONSTRAINT chk_reservation_dates CHECK (check_out_date > check_in_date)
) ENGINE=InnoDB;

-- 5. Reservation Rooms Link Entity
CREATE TABLE reservation_rooms (
    reservation_room_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    room_id INT NOT NULL,
    nightly_rate DECIMAL(10, 2) NOT NULL CHECK (nightly_rate >= 0),
    CONSTRAINT fk_resrooms_reservation FOREIGN KEY (reservation_id) 
        REFERENCES reservations(reservation_id) ON DELETE CASCADE,
    CONSTRAINT fk_resrooms_room FOREIGN KEY (room_id) 
        REFERENCES rooms(room_id) ON DELETE RESTRICT,
    CONSTRAINT uq_reservation_room UNIQUE (reservation_id, room_id)
) ENGINE=InnoDB;

-- 6. Payments Entity
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(12, 2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR(30) NOT NULL 
        CHECK (payment_method IN ('DEBIT_CARD', 'BANK_TRANSFER', 'CASH', 'POS')),
    payment_status VARCHAR(20) DEFAULT 'SUCCESSFUL' 
        CHECK (payment_status IN ('SUCCESSFUL', 'PENDING', 'FAILED', 'REFUNDED')),
    transaction_reference VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT fk_payments_reservation FOREIGN KEY (reservation_id) 
        REFERENCES reservations(reservation_id) ON DELETE CASCADE
) ENGINE=InnoDB;