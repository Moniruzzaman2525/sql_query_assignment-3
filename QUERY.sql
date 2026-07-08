-- =========================================================================
-- DATABASE SETUP: Stadium Ticket Reservation System
-- =========================================================================

-- Dropping existing tables to clean up schema
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS matches CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- -------------------------------------------------------------------------
-- 1. CLIENTS / USERS TABLE
-- -------------------------------------------------------------------------
CREATE TABLE users (
    user_id SERIAL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    phone_number VARCHAR(20),
    
    -- Explicit constraints for uniqueness and validation
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT uq_user_email UNIQUE (email),
    CONSTRAINT chk_user_role CHECK (role IN ('Football Fan', 'Ticket Manager'))
);

-- -------------------------------------------------------------------------
-- 2. FIXTURES / MATCHES TABLE
-- -------------------------------------------------------------------------
CREATE TABLE matches (
    match_id SERIAL,
    fixture VARCHAR(200),
    tournament_category VARCHAR(200),
    base_ticket_price DECIMAL(10, 2) NOT NULL,
    match_status VARCHAR(20) NOT NULL,
    
    -- Explicit constraints for business rules
    CONSTRAINT pk_matches PRIMARY KEY (match_id),
    CONSTRAINT chk_positive_price CHECK (base_ticket_price >= 0.00),
    CONSTRAINT chk_valid_status CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);

-- -------------------------------------------------------------------------
-- 3. RESERVATIONS / BOOKINGS TABLE
-- -------------------------------------------------------------------------
CREATE TABLE bookings (
    booking_id SERIAL,
    user_id INT,
    match_id INT,
    seat_number VARCHAR(20),
    payment_status VARCHAR(20),
    total_cost DECIMAL(10, 2) NOT NULL,
    
    -- Key and check constraints
    CONSTRAINT pk_bookings PRIMARY KEY (booking_id),
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_match FOREIGN KEY (match_id) REFERENCES matches (match_id) ON DELETE CASCADE,
    CONSTRAINT chk_positive_cost CHECK (total_cost >= 0.00),
    CONSTRAINT chk_payment_status CHECK (payment_status IN ('Confirmed', 'Pending', 'Refunded', 'Cancelled'))
);