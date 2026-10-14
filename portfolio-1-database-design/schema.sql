-- ============================================================================
-- MIT 8103 - Advanced Database Systems
-- Portfolio 1: Database Design and Modelling
-- Case Study: NIRE Hotel and Suites - Abuja, FCT, Nigeria
-- Target DBMS: MySQL 8.0+ / MariaDB 10.4+ (InnoDB Storage Engine)
-- ============================================================================

CREATE DATABASE IF NOT EXISTS nire_hotel_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE nire_hotel_db;

-- Temporarily disable foreign key checks during schema re-creation
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS reservation_rooms;
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS guests;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS room_types;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- 1. Table: room_types
-- Description: Stores hotel room classification tiers, capacity, and baseline pricing.
-- Normal Form: 3NF / BCNF compliant (No transitive or partial dependencies).
-- ============================================================================
CREATE TABLE room_types (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    base_rate DECIMAL(10, 2) NOT NULL CHECK (base_rate > 0),
    max_occupancy INT NOT NULL CHECK (max_occupancy > 0),
    bed_type VARCHAR(50) NOT NULL,
    description TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================================
-- 2. Table: rooms
-- Description: Physical hotel room inventory and operational maintenance state.
-- Normal Form: 3NF / BCNF compliant.
-- ============================================================================
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_type_id INT NOT NULL,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    floor_number INT NOT NULL CHECK (floor_number >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE' 
        CHECK (status IN ('AVAILABLE', 'OCCUPIED', 'RESERVED', 'MAINTENANCE')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_rooms_room_type 
        FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================================
-- 3. Table: guests
-- Description: Registered client profiles, KYC identification, and emergency contact details.
-- Normal Form: 3NF / BCNF compliant.
-- ============================================================================
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

-- ============================================================================
-- 4. Table: reservations
-- Description: Master booking agreements recording booking duration and monetary totals.
-- Normal Form: 3NF / BCNF compliant.
-- ============================================================================
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    booking_status VARCHAR(20) NOT NULL DEFAULT 'CONFIRMED' 
        CHECK (booking_status IN ('CONFIRMED', 'CANCELLED', 'COMPLETED', 'NO_SHOW')),
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00 CHECK (total_amount >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reservations_guest 
        FOREIGN KEY (guest_id) REFERENCES guests(guest_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_reservation_dates 
        CHECK (check_out_date > check_in_date)
) ENGINE=InnoDB;

-- ============================================================================
-- 5. Table: reservation_rooms (Junction Entity)
-- Description: Resolves M:N relationship between reservations and physical rooms,
--              locking in the historical nightly rate per room booked.
-- Normal Form: 3NF / BCNF compliant.
-- ============================================================================
CREATE TABLE reservation_rooms (
    reservation_room_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    room_id INT NOT NULL,
    nightly_rate DECIMAL(10, 2) NOT NULL CHECK (nightly_rate >= 0),
    CONSTRAINT fk_resrooms_reservation 
        FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_resrooms_room 
        FOREIGN KEY (room_id) REFERENCES rooms(room_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_reservation_room 
        UNIQUE (reservation_id, room_id)
) ENGINE=InnoDB;

-- ============================================================================
-- 6. Table: payments
-- Description: Financial ledger capturing settlement transactions, channels, and audit refs.
-- Normal Form: 3NF / BCNF compliant.
-- ============================================================================
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(12, 2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR(30) NOT NULL 
        CHECK (payment_method IN ('DEBIT_CARD', 'BANK_TRANSFER', 'CASH', 'POS')),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'SUCCESSFUL' 
        CHECK (payment_status IN ('SUCCESSFUL', 'PENDING', 'FAILED', 'REFUNDED')),
    transaction_reference VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT fk_payments_reservation 
        FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
