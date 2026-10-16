# Portfolio 2: Query Processing and Optimisation Report

**Course:** MIT 8103 - Advanced Database Systems  
**Institution:** MIVA Open University  
**Case Study:** NIRE Hotel and Suites - Reservation System (Abuja, FCT, Nigeria)

---

## 1. Executive Summary

This report documents the design, execution, and performance analysis of complex analytical queries engineered for the **NIRE Hotel and Suites** relational database. Utilizing **MariaDB 10.4 / MySQL (InnoDB)**, execution plans were captured via `EXPLAIN` to assess access paths, join algorithms, and the impact of custom B-Tree indexing.

---

## 2. Advanced Analytical Queries & Execution Results

### Query 1: Room Tier Utilization & Operational Occupancy Rate
* **Objective:** Computes live occupancy percentages, available inventory, and maintenance down-time across room categories.
* **SQL Constructs:** `LEFT JOIN`, `COUNT`, conditional `SUM(CASE ...)`, `ROUND`, `GROUP BY`.

**Execution Output:**
```text
+--------------------+-------------+----------------+----------------+-----------------+-------------------+--------------------+
| room_category      | total_rooms | occupied_rooms | reserved_rooms | available_rooms | maintenance_rooms | occupancy_rate_pct |
+--------------------+-------------+----------------+----------------+-----------------+-------------------+--------------------+
| Presidential Suite |           2 |              1 |              0 |               1 |                 0 |              50.00 |
| Deluxe Room        |           5 |              2 |              1 |               2 |                 0 |              40.00 |
| Executive Suite    |           6 |              2 |              0 |               4 |                 0 |              33.33 |
| Family Suite       |           3 |              1 |              1 |               1 |                 0 |              33.33 |
| Standard Room      |           4 |              1 |              0 |               2 |                 1 |              25.00 |
+--------------------+-------------+----------------+----------------+-----------------+-------------------+--------------------+
```

---

### Query 2: Revenue Realization & Settlement Efficiency
* **Objective:** Evaluates financial throughput across channels (`POS`, `BANK_TRANSFER`, `DEBIT_CARD`, `CASH`) and identifies collection efficiency.

**Execution Output:**
```text
+----------------+--------------------+-----------------+-----------------+------------------+---------------------------+
| payment_method | total_transactions | settled_revenue | pending_revenue | refunded_revenue | collection_efficiency_pct |
+----------------+--------------------+-----------------+-----------------+------------------+---------------------------+
| BANK_TRANSFER  |                  6 |      3725000.00 |       135000.00 |             0.00 |                     96.50 |
| DEBIT_CARD     |                  5 |      1395000.00 |            0.00 |         90000.00 |                     93.94 |
| POS            |                  3 |      1335000.00 |            0.00 |             0.00 |                    100.00 |
| CASH           |                  1 |       135000.00 |            0.00 |             0.00 |                    100.00 |
+----------------+--------------------+-----------------+-----------------+------------------+---------------------------+
```

---

### Query 3: VIP Guest Stay Frequency & Lifetime Value (Window Function)
* **Objective:** Profiles top spenders using Common Table Expressions (CTE) and the `DENSE_RANK() OVER (...)` analytical window function.

**Execution Output:**
```text
+-------------------+------------------------------+----------------+-----------------+----------------------+--------------+------------------------+
| guest_full_name   | email                        | phone          | completed_stays | lifetime_expenditure | revenue_rank | average_spend_per_stay |
+-------------------+------------------------------+----------------+-----------------+----------------------+--------------+------------------------+
| David Mark        | david.mark@corporatemail.com | +2348056677889 |               1 |           2100000.00 |            1 |             2100000.00 |
| Babatunde Adeyemi | babatunde.adeyemi@outlook.com| +2348145566778 |               2 |            840000.00 |            2 |              420000.00 |
| Halima Suleiman   | halima.suleiman@gmail.com    | +2348123344556 |               1 |            800000.00 |            3 |              800000.00 |
| Zainab Mohammed   | zainab.m@gov.ng              | +2348039911223 |               1 |            600000.00 |            4 |              600000.00 |
| Amina Bello       | amina.bello@yahoo.com        | +2348029988771 |               2 |            525000.00 |            5 |              262500.00 |
| Chinedu Okafor    | chinedu.okafor@gmail.com     | +2348032110022 |               2 |            510000.00 |            6 |              255000.00 |
+-------------------+------------------------------+----------------+-----------------+----------------------+--------------+------------------------+
```

---

### Query 4: Daily Operational Housekeeping & Room Turnover Schedule
* **Objective:** Correlates room inventory, active guest stays, and remaining nights for housekeeping staff coordination.

---

### Query 5: Financial Reconciliation & Outstanding Balance Audit
* **Objective:** Pinpoints reservations with payment discrepancies or pending collections.

**Execution Output (Excerpt):**
```text
+----------------+---------------+----------------+---------------+----------------+----------------+----------------+---------------+---------------------+
| reservation_id | guest_name    | phone          | check_in_date | check_out_date | booking_status | total_invoiced | total_settled | outstanding_balance |
+----------------+---------------+----------------+---------------+----------------+----------------+----------------+---------------+---------------------+
|           1013 | Grace Akpan   | +2348162233445 | 2026-10-22    | 2026-10-25     | CONFIRMED      |      135000.00 |          0.00 |           135000.00 |
|           1001 | Chinedu Okafor| +2348032110022 | 2026-09-01    | 2026-09-04     | COMPLETED      |      135000.00 |     135000.00 |                0.00 |
+----------------+---------------+----------------+---------------+----------------+----------------+----------------+---------------+---------------------+
```

---

## 3. Query Execution Plans (`EXPLAIN`) & Index Optimization

### Applied Indexing Strategy ([`Orimolade_Samuel_301923593_indexes.sql`](Orimolade_Samuel_301923593_indexes.sql))
1. `idx_reservations_dates_status`: Composite on `(check_in_date, check_out_date, booking_status)`.
2. `idx_reservations_guest`: Foreign key index on `reservations(guest_id)`.
3. `idx_payments_res_status`: Composite index on `payments(reservation_id, payment_status)`.
4. `idx_rooms_status_type`: Composite index on `rooms(status, room_type_id)`.
5. `idx_resrooms_room_res`: Composite covering index on `reservation_rooms(room_id, reservation_id)`.

### Quantitative Comparative Benchmark Table

| Metric / Query Component | Baseline (Before Indexing) | Optimized (After Indexing) | Technical Benefit & Access Path |
| :--- | :--- | :--- | :--- |
| **Query 4: `rr` Junction Join** | `type: ref`<br>`key: fk_resrooms_room`<br>`Extra: NULL` | `type: ref`<br>`key: idx_resrooms_room_res`<br>`Extra: Using index` | **Covering Index Optimization:** All required columns resolved directly from B-Tree leaf nodes; eliminates row-data disk reads. |
| **Query 4: `res` Join Access** | `possible_keys: PRIMARY` | `possible_keys: PRIMARY, idx_reservations_dates_status` | Multiple candidate access paths available to the query optimizer for selective date filtering. |
| **Date Range Filter Scan** | `type: ALL` (Full Table Scan)<br>`rows: 15` | `type: range`<br>`key: idx_reservations_dates_status`<br>`Extra: Using where; Using index` | **Range Scan Optimization:** Replaces sequential page reads with logarithmic B-Tree range traversal ($O(\log N)$). |
| **Payment Grouping Aggregate** | `possible_keys: fk_payments_reservation` | `possible_keys: idx_payments_res_status` | Multi-column index provides direct resolution for reservation ID grouping and settlement status filtering. |

### Technical Analysis of Cost-Based Optimizer (CBO) Decisions:
1. **Cardinality vs. Scan Overhead:** In micro-datasets, the optimizer correctly defaults to sequential scans when reading pages sequentially into the InnoDB Buffer Pool is cheaper than pointer lookups.
2. **Covering Indexes (`Using index`):** By defining `idx_resrooms_room_res(room_id, reservation_id)`, the DBMS avoids accessing the clustered primary index (`PRIMARY`), reducing I/O latency.
3. **Multi-Column Index Selectivity:** Placing high-cardinality date ranges alongside status attributes ensures fast index filtering during peak reservation lookups.
