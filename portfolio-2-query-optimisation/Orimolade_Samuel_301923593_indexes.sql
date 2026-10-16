-- ============================================================================
-- MIT 8103 - Advanced Database Systems
-- Portfolio 2: Query Processing and Optimisation - Indexing Strategy
-- Case Study: NIRE Hotel and Suites - Abuja, FCT, Nigeria
-- ============================================================================

USE nire_hotel_db;

-- 1. Index on Reservations Date Range and Booking Status
-- Rationale: Accelerates stay period lookups, housekeeping overlap checks, and active reservation filters.
-- Transforms full table scans into index range scans.
CREATE INDEX idx_reservations_dates_status 
ON reservations (check_in_date, check_out_date, booking_status);

-- 2. Index on Reservations Guest Reference
-- Rationale: Crucial for foreign key join acceleration when aggregating guest lifetime value and historical bookings.
CREATE INDEX idx_reservations_guest 
ON reservations (guest_id);

-- 3. Composite Index on Payments Reservation & Settlement Status
-- Rationale: Optimizes subquery aggregations calculating total settled revenue per reservation,
-- avoiding filesorts and sequential table scans.
CREATE INDEX idx_payments_res_status 
ON payments (reservation_id, payment_status);

-- 4. Composite Index on Room Operational Status and Category
-- Rationale: Speeds up live room availability queries and tier-level inventory rollups.
CREATE INDEX idx_rooms_status_type 
ON rooms (status, room_type_id);

-- 5. Index on Reservation Rooms Physical Room ID
-- Rationale: Accelerates junction table traversal from rooms to active reservations for daily occupancy views.
CREATE INDEX idx_resrooms_room_res 
ON reservation_rooms (room_id, reservation_id);
