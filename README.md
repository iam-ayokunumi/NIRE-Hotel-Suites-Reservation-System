# NIRE Hotel and Suites — Advanced Database Systems Portfolio

**Course:** MIT 8103 - Advanced Database Systems  
**Institution:** MIVA Open University, School of Post Graduate Studies  
**Degree Program:** Master of Information Technology (MIT)  
**Session:** 2026/2027 Academic Session — First Semester Continuous Assessment  
**Student Name:** Samuel Orimolade  
**Student ID:** 301923593

**GitHub Repository:** [iam-ayokunumi/NIRE-Hotel-Suites-Reservation-System](https://github.com/iam-ayokunumi/NIRE-Hotel-Suites-Reservation-System)  

---

## 📋 Table of Contents
- [Executive Overview](#-executive-overview)
- [Semester Portfolio Roadmap](#-semester-portfolio-roadmap)
- [Repository Structure](#-repository-structure)
- [Entity-Relationship Architecture (ERD)](#-entity-relationship-architecture-erd)
- [Portfolio 1: Database Design & Modelling Deliverables](#-portfolio-1-database-design--modelling-deliverables)
- [Portfolio 2: Query Processing & Optimisation Deliverables](#-portfolio-2-query-processing--optimisation-deliverables)
- [Installation & Verification Guide](#-installation--verification-guide)
- [Individual Technical Reflection](#-individual-technical-reflection)
- [Academic Integrity & AI Use Declaration](#-academic-integrity--ai-use-declaration)

---

## 🏨 Executive Overview

**NIRE Hotel and Suites** is an upscale hospitality establishment operating in Abuja, Federal Capital Territory (FCT), Nigeria. This repository represents the progressive practical database portfolio developed throughout the semester for **MIT 8103: Advanced Database Systems**.

### System Scope & Core Operations:
* **Room Inventory Categorization:** Distinct room tiers (`Standard Room`, `Deluxe Room`, `Executive Suite`, `Presidential Suite`, `Family Suite`) spanning multiple physical floors with live status management (`AVAILABLE`, `OCCUPIED`, `RESERVED`, `MAINTENANCE`).
* **Guest Profiling & Statutory KYC:** Registration strictly aligned with Nigerian identity standards (`NIN`, `INTERNATIONAL_PASSPORT`, `DRIVERS_LICENSE`, `VOTERS_CARD`) with verified emergency contact records.
* **Reservation Lifecycle:** Single and multi-room bookings via a normalized junction entity (`reservation_rooms`) with arrival and departure scheduling.
* **Financial Ledger Auditing:** Settlements captured across Nigerian payment channels (`POS`, `BANK_TRANSFER`, `DEBIT_CARD`, `CASH`) with gateway transaction tracking and refund handling.

---

## 📊 Semester Portfolio Roadmap

| Portfolio Component | Activity Focus | Status | Deliverables Location |
| :--- | :--- | :---: | :--- |
| **Portfolio 1** | Database Design & Modelling | **Completed** | [`portfolio-1-database-design/`](portfolio-1-database-design/) |
| **Portfolio 2** | Query Processing & Optimisation | **Completed** | [`portfolio-2-query-optimisation/`](portfolio-2-query-optimisation/) |
| **Portfolio 3** | Transactions & Concurrency | Scheduled | *Upcoming Semester Activity* |
| **Portfolio 4** | NoSQL & Advanced Data Models | Scheduled | *Upcoming Semester Activity* |
| **Portfolio 5** | Distributed & Cloud Databases | Scheduled | *Upcoming Semester Activity* |

---

## 📁 Repository Structure

```text
advanced-database-portfolio/
├── portfolio-1-database-design/
│   ├── Orimolade_Samuel_301923593_schema.sql                # Complete relational DDL with constraints
│   ├── Orimolade_Samuel_301923593_seed_data.sql             # Realistic sample dataset (20 rooms, 12 guests, 15 bookings)
│   ├── Orimolade_Samuel_301923593_normalization_analysis.md # Step-by-step mathematical proof (UNF to BCNF)
│   ├── Orimolade_Samuel_301923593_database-design.jpeg      # Visual Entity-Relationship Diagram (ERD)
│   ├── Orimolade_Samuel_301923593_mermaid-erd.mmd           # Mermaid schema code definition
│   └── Orimolade_Samuel_301923593_README.md                 # Data dictionary and implementation guide
├── portfolio-2-query-optimisation/
│   ├── Orimolade_Samuel_301923593_analytical_queries.sql       # 5 advanced operational & analytical queries
│   ├── Orimolade_Samuel_301923593_indexes.sql                  # Strategic composite & foreign key B-Tree indexes
│   ├── Orimolade_Samuel_301923593_execution_plans_evidence.sql # Pre- and post-optimization EXPLAIN benchmarks
│   ├── Orimolade_Samuel_301923593_query_performance_analysis.md# Detailed technical analysis report
│   └── Orimolade_Samuel_301923593_README.md                    # Implementation guide and execution steps
└── README.md                                                # Portfolio overview and activity roadmap
```

---

## 📊 Entity-Relationship Architecture (ERD)

### Visual Diagram
![Entity Relationship Diagram](portfolio-1-database-design/Orimolade_Samuel_301923593_database-design.jpeg)

### Interactive Mermaid ERD
```mermaid
erDiagram
    ROOM_TYPES ||--o{ ROOMS : "categorises"
    GUESTS ||--o{ RESERVATIONS : "books"
    RESERVATIONS ||--|{ RESERVATION_ROOMS : "contains"
    ROOMS ||--o{ RESERVATION_ROOMS : "assigned_to"
    RESERVATIONS ||--o{ PAYMENTS : "settled_by"

    ROOM_TYPES {
        int room_type_id PK
        string type_name UK
        decimal base_rate
        int max_occupancy
        string bed_type
    }

    ROOMS {
        int room_id PK
        int room_type_id FK
        string room_number UK
        int floor_number
        string status
    }

    GUESTS {
        int guest_id PK
        string first_name
        string last_name
        string email UK
        string phone
        string identity_type
        string identity_number UK
        text residential_address
        string emergency_contact_name
        string emergency_contact_phone
        text emergency_contact_address
        timestamp created_at
    }

    RESERVATIONS {
        int reservation_id PK
        int guest_id FK
        date check_in_date
        date check_out_date
        string booking_status
        decimal total_amount
        timestamp created_at
    }

    RESERVATION_ROOMS {
        int reservation_room_id PK
        int reservation_id FK
        int room_id FK
        decimal nightly_rate
    }

    PAYMENTS {
        int payment_id PK
        int reservation_id FK
        timestamp payment_date
        decimal amount
        string payment_method
        string payment_status
        string transaction_reference UK
    }
```

---

## 🚀 Portfolio 1: Database Design & Modelling Deliverables

Portfolio 1 establishes the relational foundation of the reservation architecture:
1. **Relational Schema Definition ([`Orimolade_Samuel_301923593_schema.sql`](portfolio-1-database-design/Orimolade_Samuel_301923593_schema.sql)):** Fully normalized MySQL 8.0+ / MariaDB 10.4+ schema with InnoDB storage engine, primary/foreign keys, `CHECK` constraints, and cascading integrity policies.
2. **Seed Dataset ([`Orimolade_Samuel_301923593_seed_data.sql`](portfolio-1-database-design/Orimolade_Samuel_301923593_seed_data.sql)):** Comprehensive sample data populating 5 room types, 20 physical rooms across 4 floors, 12 guests with authentic Nigerian KYC credentials, 15 reservations, multi-room allocations, and payment receipts.
3. **Relational Normalization Proof ([`Orimolade_Samuel_301923593_normalization_analysis.md`](portfolio-1-database-design/Orimolade_Samuel_301923593_normalization_analysis.md)):** Mathematical functional dependency analysis demonstrating formal progression from Unnormalized Form (UNF) through 1NF, 2NF, 3NF, to **Boyce-Codd Normal Form (BCNF)**.
4. **Data Dictionary & Documentation ([`portfolio-1-database-design/Orimolade_Samuel_301923593_README.md`](portfolio-1-database-design/Orimolade_Samuel_301923593_README.md)):** Detailed entity definitions, domain rules, and verification outputs.

---

## 🚀 Portfolio 2: Query Processing & Optimisation Deliverables

Portfolio 2 demonstrates advanced SQL query processing, cost-based execution plan analysis (`EXPLAIN`), and B-Tree indexing optimization:
1. **Advanced Analytical Queries ([`Orimolade_Samuel_301923593_analytical_queries.sql`](portfolio-2-query-optimisation/Orimolade_Samuel_301923593_analytical_queries.sql)):** 5 complex queries addressing real-world hotel operations (room occupancy rates, payment collection efficiency, VIP guest ranking with `DENSE_RANK()`, housekeeping turnover scheduling, and unpaid balance reconciliation).
2. **Indexing Strategy ([`Orimolade_Samuel_301923593_indexes.sql`](portfolio-2-query-optimisation/Orimolade_Samuel_301923593_indexes.sql)):** Targeted composite and covering B-Tree indexes reducing full table scans to index lookups and range scans.
3. **Execution Plan Benchmarks ([`Orimolade_Samuel_301923593_execution_plans_evidence.sql`](portfolio-2-query-optimisation/Orimolade_Samuel_301923593_execution_plans_evidence.sql)):** `EXPLAIN` benchmarks comparing pre- and post-optimization access paths, row selectivity, and covering index utilization (`Using index`).
4. **Performance Analysis Report ([`Orimolade_Samuel_301923593_query_performance_analysis.md`](portfolio-2-query-optimisation/Orimolade_Samuel_301923593_query_performance_analysis.md)):** In-depth technical breakdown of query complexity, Cost-Based Optimizer (CBO) decisions, and empirical benchmark matrices.
5. **Portfolio 2 Guide ([`portfolio-2-query-optimisation/Orimolade_Samuel_301923593_README.md`](portfolio-2-query-optimisation/Orimolade_Samuel_301923593_README.md)):** Overview and step-by-step verification instructions.

---

## ⚡ Installation & Verification Guide

### Prerequisites
* MySQL 8.0+ or MariaDB 10.4+ (InnoDB engine)
* Client tool (MySQL CLI, MySQL Workbench, DBeaver, or phpMyAdmin)

### Execution Commands (PowerShell)
```powershell
# --- Portfolio 1: Database Setup & Verification ---
# 1. Execute DDL Schema
Get-Content "portfolio-1-database-design\Orimolade_Samuel_301923593_schema.sql" | & "C:\xampp\mysql\bin\mysql.exe" -u root

# 2. Populate Seed Dataset
Get-Content "portfolio-1-database-design\Orimolade_Samuel_301923593_seed_data.sql" | & "C:\xampp\mysql\bin\mysql.exe" -u root

# 3. Verify Table Row Counts
& "C:\xampp\mysql\bin\mysql.exe" -u root -e "USE nire_hotel_db; SELECT 'room_types' AS tbl, COUNT(*) AS count FROM room_types UNION ALL SELECT 'rooms', COUNT(*) FROM rooms UNION ALL SELECT 'guests', COUNT(*) FROM guests UNION ALL SELECT 'reservations', COUNT(*) FROM reservations UNION ALL SELECT 'reservation_rooms', COUNT(*) FROM reservation_rooms UNION ALL SELECT 'payments', COUNT(*) FROM payments;"

# --- Portfolio 2: Query Execution & Optimization ---
# 4. Execute Analytical Queries
Get-Content "portfolio-2-query-optimisation\Orimolade_Samuel_301923593_analytical_queries.sql" | & "C:\xampp\mysql\bin\mysql.exe" -u root

# 5. Run Baseline EXPLAIN Benchmarks (Before Indexing)
Get-Content "portfolio-2-query-optimisation\Orimolade_Samuel_301923593_execution_plans_evidence.sql" | & "C:\xampp\mysql\bin\mysql.exe" -u root

# 6. Apply Performance Indexes
Get-Content "portfolio-2-query-optimisation\Orimolade_Samuel_301923593_indexes.sql" | & "C:\xampp\mysql\bin\mysql.exe" -u root

# 7. Run Post-Optimization EXPLAIN Benchmarks (After Indexing)
Get-Content "portfolio-2-query-optimisation\Orimolade_Samuel_301923593_execution_plans_evidence.sql" | & "C:\xampp\mysql\bin\mysql.exe" -u root
```

**Portfolio 1 Verification Output:**
```text
+-------------------+-------+
| tbl               | count |
+-------------------+-------+
| room_types        |     5 |
| rooms             |    20 |
| guests            |    12 |
| reservations      |    15 |
| reservation_rooms |    15 |
| payments          |    15 |
+-------------------+-------+
```

---

## 💡 Individual Technical Reflection

* **Design Rationale (Portfolio 1):** Isolating historical nightly rates within the junction relation `reservation_rooms` (`nightly_rate DECIMAL(10,2)`) guarantees financial immutability. Base tariffs in `room_types` can fluctuate seasonally or increase due to inflation without retroactively altering historical reservation totals.
* **Integrity & Cascade Policies (Portfolio 1):** Restricting deletions on core entities (`ON DELETE RESTRICT` for `room_types`, `rooms`, and `guests`) prevents accidental operational disruption, while cascading cleanup (`ON DELETE CASCADE` for `reservation_rooms` and `payments`) ensures that purged bookings leave zero orphan records.
* **Regulatory Compliance (Portfolio 1):** Integrating Nigerian identity types (`NIN`, `INTERNATIONAL_PASSPORT`, `DRIVERS_LICENSE`, `VOTERS_CARD`) directly into domain check constraints ensures the database enforces KYC compliance at the storage engine level rather than relying solely on client-side validation.
* **Query Optimization Insights (Portfolio 2):** Benchmarking `EXPLAIN` execution plans demonstrated that defining covering composite indexes (such as `idx_resrooms_room_res` on `(room_id, reservation_id)`) allows the storage engine to resolve multi-table join operations directly from B-Tree leaf nodes (`Using index`), entirely bypassing clustered primary index lookups and minimizing I/O bottlenecks during peak reservation audits.

---

## 🛡️ Academic Integrity & AI Use Declaration

* **AI Tool Used:** Gemini and ChatGPT.
* **Verification & Testing Protocol:** All SQL DDL scripts, constraints, and seed data records were manually reviewed, executed, and tested on a live MariaDB 10.4.32 database instance running via XAMPP. Every table creation and data insertion was verified through direct command-line execution and integrity testing.
