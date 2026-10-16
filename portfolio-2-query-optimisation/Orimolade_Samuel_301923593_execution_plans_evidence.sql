-- ============================================================================
-- MIT 8103 - Advanced Database Systems
-- Portfolio 2: Query Execution Plans (Before vs After Indexing)
-- Case Study: NIRE Hotel and Suites - Abuja, FCT, Nigeria
-- ============================================================================

USE nire_hotel_db;

-- ============================================================================
-- BENCHMARK 1: Guest Stay Metrics & Lifetime Value (Query 3)
-- ============================================================================
SELECT '--- [BEFORE INDEXING] EXPLAIN FOR QUERY 3 ---' AS execution_benchmark;

EXPLAIN 
SELECT 
    g.guest_id,
    CONCAT(g.first_name, ' ', g.last_name) AS guest_full_name,
    COUNT(res.reservation_id) AS completed_stays,
    SUM(res.total_amount) AS lifetime_expenditure
FROM guests g
INNER JOIN reservations res ON g.guest_id = res.guest_id
WHERE res.booking_status IN ('CONFIRMED', 'COMPLETED')
GROUP BY g.guest_id;

-- ============================================================================
-- BENCHMARK 2: Housekeeping & Room Turnover Schedule (Query 4)
-- ============================================================================
SELECT '--- [BEFORE INDEXING] EXPLAIN FOR QUERY 4 ---' AS execution_benchmark;

EXPLAIN 
SELECT 
    r.room_number,
    rt.type_name,
    res.reservation_id,
    res.check_in_date,
    res.check_out_date
FROM rooms r
INNER JOIN room_types rt ON r.room_type_id = rt.room_type_id
LEFT JOIN reservation_rooms rr ON r.room_id = rr.room_id
LEFT JOIN reservations res ON rr.reservation_id = res.reservation_id 
    AND res.booking_status = 'CONFIRMED'
    AND '2026-10-14' BETWEEN res.check_in_date AND res.check_out_date;

-- ============================================================================
-- BENCHMARK 3: Outstanding Balance & Payment Reconciliation (Query 5)
-- ============================================================================
SELECT '--- [BEFORE INDEXING] EXPLAIN FOR QUERY 5 ---' AS execution_benchmark;

EXPLAIN 
SELECT 
    res.reservation_id,
    res.total_amount,
    COALESCE(paid.total_settled, 0.00) AS total_settled
FROM reservations res
LEFT JOIN (
    SELECT reservation_id, SUM(amount) AS total_settled
    FROM payments
    WHERE payment_status = 'SUCCESSFUL'
    GROUP BY reservation_id
) paid ON res.reservation_id = paid.reservation_id;
