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




-- =========================================================================
-- POPULATING DATABASE: SEEDING INITIAL RECORD SETS
-- =========================================================================

-- Populating the 'users' table
INSERT INTO users (user_id, full_name, email, role, phone_number)
VALUES
    (1, 'Tanvir Rahman', 'tanvir@mail.com',  'Football Fan',   '+8801711111111'),
    (2, 'Asif Haque',    'asif@mail.com',    'Football Fan',   '+8801722222222'),
    (3, 'Sajjad Rahman',  'sajjad@mail.com',  'Ticket Manager', '+8801733333333'),
    (4, 'Jannat Ara',    'jannat@mail.com',  'Football Fan',   NULL);

-- Populating the 'matches' table
INSERT INTO matches (match_id, fixture, tournament_category, base_ticket_price, match_status)
VALUES
    (101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
    (102, 'Man City vs Liverpool',     'Premier League',   120.00, 'Selling Fast'),
    (103, 'Bayern Munich vs PSG',     'Champions League', 130.00, 'Available'),
    (104, 'AC Milan vs Inter Milan',   'Serie A',           90.00,  'Sold Out'),
    (105, 'Juventus vs Roma',          'Serie A',           80.00,  'Available');

-- Populating the 'bookings' table
INSERT INTO bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost)
VALUES
    (501, 1, 101, 'A-12', 'Confirmed', 150.00),
    (502, 1, 102, 'B-04', 'Confirmed', 120.00),
    (503, 2, 101, 'A-13', 'Confirmed', 150.00),
    (504, 2, 101, NULL,   NULL,        150.00),
    (505, 3, 102, 'C-20', 'Pending',   120.00);





-- Query 1: Fetching active Champions League fixtures that are currently available
select 
    matches.match_id, 
    matches.fixture, 
    matches.base_ticket_price
from 
    matches
where 
    matches.tournament_category = 'Champions League'
    and matches.match_status = 'Available';



-- Query 2: Lookup users by specific name patterns (Case-Insensitive)
select 
    u.user_id, 
    u.full_name, 
    u.email
from 
    users as u
where 
    u.full_name ilike 'Tanvir%' 
    or u.full_name ilike '%Haque%';



