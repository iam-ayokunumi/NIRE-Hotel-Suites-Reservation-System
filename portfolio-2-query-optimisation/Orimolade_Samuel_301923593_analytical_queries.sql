-- ============================================================================
-- MIT 8103 - Advanced Database Systems
-- Portfolio 2: Query Processing and Optimisation - Analytical Queries
-- Case Study: NIRE Hotel and Suites - Abuja, FCT, Nigeria
-- ============================================================================

USE nire_hotel_db;

-- ============================================================================
-- QUERY 1: Room Tier Utilization, Occupancy Rate & Inventory Distribution
-- Purpose: Analyzes operational occupancy percentages and availability across
--          hotel room categories to drive dynamic pricing strategies.
-- Advanced Concepts: Aggregations, GROUP BY, CASE statements, Percentage math.
-- ============================================================================
SELECT 
    rt.type_name AS room_category,
    COUNT(r.room_id) AS total_rooms,
    SUM(CASE WHEN r.status = 'OCCUPIED' THEN 1 ELSE 0 END) AS occupied_rooms,
    SUM(CASE WHEN r.status = 'RESERVED' THEN 1 ELSE 0 END) AS reserved_rooms,
    SUM(CASE WHEN r.status = 'AVAILABLE' THEN 1 ELSE 0 END) AS available_rooms,
    SUM(CASE WHEN r.status = 'MAINTENANCE' THEN 1 ELSE 0 END) AS maintenance_rooms,
    ROUND(
        (SUM(CASE WHEN r.status = 'OCCUPIED' THEN 1 ELSE 0 END) * 100.0) / COUNT(r.room_id), 
        2
    ) AS occupancy_rate_pct
FROM room_types rt
LEFT JOIN rooms r ON rt.room_type_id = r.room_type_id
GROUP BY rt.room_type_id, rt.type_name
ORDER BY occupancy_rate_pct DESC;

-- ============================================================================
-- QUERY 2: Channel Revenue Realization & Settlement Efficiency
-- Purpose: Evaluates revenue velocity, completed collections, and settlement
--          leakage across payment channels (POS, Bank Transfer, Card, Cash).
-- Advanced Concepts: Multi-table JOINs, filtering, financial aggregation.
-- ============================================================================
SELECT 
    p.payment_method,
    COUNT(p.payment_id) AS total_transactions,
    SUM(CASE WHEN p.payment_status = 'SUCCESSFUL' THEN p.amount ELSE 0.00 END) AS settled_revenue,
    SUM(CASE WHEN p.payment_status = 'PENDING' THEN p.amount ELSE 0.00 END) AS pending_revenue,
    SUM(CASE WHEN p.payment_status = 'REFUNDED' THEN p.amount ELSE 0.00 END) AS refunded_revenue,
    ROUND(
        (SUM(CASE WHEN p.payment_status = 'SUCCESSFUL' THEN p.amount ELSE 0.00 END) * 100.0) / 
        NULLIF(SUM(p.amount), 0), 
        2
    ) AS collection_efficiency_pct
FROM payments p
GROUP BY p.payment_method
ORDER BY settled_revenue DESC;

-- ============================================================================
-- QUERY 3: VIP Guest Lifetime Value & Stay Frequency (Window Function)
-- Purpose: Identifies high-value guests for loyalty tiering and targeted promotions.
-- Advanced Concepts: Common Table Expressions (CTE), Window Function (DENSE_RANK),
--                    HAVING clause, Grouping.
-- ============================================================================
WITH GuestStayMetrics AS (
    SELECT 
        g.guest_id,
        CONCAT(g.first_name, ' ', g.last_name) AS guest_full_name,
        g.email,
        g.phone,
        COUNT(res.reservation_id) AS completed_stays,
        SUM(res.total_amount) AS lifetime_expenditure
    FROM guests g
    INNER JOIN reservations res ON g.guest_id = res.guest_id
    WHERE res.booking_status IN ('CONFIRMED', 'COMPLETED')
    GROUP BY g.guest_id, g.first_name, g.last_name, g.email, g.phone
)
SELECT 
    guest_full_name,
    email,
    phone,
    completed_stays,
    lifetime_expenditure,
    DENSE_RANK() OVER (ORDER BY lifetime_expenditure DESC) AS revenue_rank,
    ROUND(lifetime_expenditure / completed_stays, 2) AS average_spend_per_stay
FROM GuestStayMetrics
ORDER BY revenue_rank ASC;

-- ============================================================================
-- QUERY 4: Housekeeping & Room Turnover Schedule (Correlated Logic)
-- Purpose: Daily operational report showing active arrivals, in-house guests,
--          and pending check-outs for housekeeping staff scheduling.
-- Advanced Concepts: Date boundary filtering, Multiple Joins, String aggregation.
-- ============================================================================
SELECT 
    r.room_number,
    rt.type_name AS room_type,
    r.status AS physical_room_status,
    res.reservation_id,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    res.check_in_date,
    res.check_out_date,
    DATEDIFF(res.check_out_date, CURRENT_DATE()) AS nights_remaining,
    res.booking_status
FROM rooms r
INNER JOIN room_types rt ON r.room_type_id = rt.room_type_id
LEFT JOIN reservation_rooms rr ON r.room_id = rr.room_id
LEFT JOIN reservations res ON rr.reservation_id = res.reservation_id 
    AND res.booking_status = 'CONFIRMED'
    AND CURRENT_DATE() BETWEEN res.check_in_date AND res.check_out_date
LEFT JOIN guests g ON res.guest_id = g.guest_id
ORDER BY r.floor_number ASC, r.room_number ASC;

-- ============================================================================
-- QUERY 5: Reservation Reconciliation & Unpaid Balance Audit
-- Purpose: Financial control query detecting bookings with discrepancies between
--          total invoiced room rate and actual settled payments.
-- Advanced Concepts: Subquery aggregation, COALESCE, outer joins, arithmetic checks.
-- ============================================================================
SELECT 
    res.reservation_id,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_name,
    g.phone,
    res.check_in_date,
    res.check_out_date,
    res.booking_status,
    res.total_amount AS total_invoiced,
    COALESCE(paid.total_settled, 0.00) AS total_settled,
    (res.total_amount - COALESCE(paid.total_settled, 0.00)) AS outstanding_balance
FROM reservations res
INNER JOIN guests g ON res.guest_id = g.guest_id
LEFT JOIN (
    SELECT 
        reservation_id, 
        SUM(amount) AS total_settled
    FROM payments
    WHERE payment_status = 'SUCCESSFUL'
    GROUP BY reservation_id
) paid ON res.reservation_id = paid.reservation_id
WHERE res.booking_status != 'CANCELLED'
ORDER BY outstanding_balance DESC, res.check_in_date ASC;
