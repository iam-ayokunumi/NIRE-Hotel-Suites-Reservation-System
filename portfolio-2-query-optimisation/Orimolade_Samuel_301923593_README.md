# Portfolio 2: Query Processing and Optimisation

**Course:** MIT 8103 - Advanced Database Systems  
**Institution:** MIVA Open University  
**Case Study:** NIRE Hotel and Suites - Reservation System (Abuja, FCT, Nigeria)

---

## 1. Overview & Objectives

Portfolio 2 demonstrates advanced SQL query processing, cost-based execution plan analysis (`EXPLAIN`), and B-Tree indexing optimization for **NIRE Hotel and Suites**. The implementation evaluates:
1. Multi-table joins, subqueries, and Common Table Expressions (CTE).
2. Advanced analytical aggregations and Window Functions (`DENSE_RANK() OVER (...)`).
3. Comparative execution plans highlighting access paths (`ALL` vs `ref` vs `range`), covering index usage (`Using index`), and cost reduction.

---

## 2. Directory Structure

```text
portfolio-2-query-optimisation/
├── Orimolade_Samuel_301923593_analytical_queries.sql       # 5 advanced operational & analytical queries
├── Orimolade_Samuel_301923593_indexes.sql                  # Strategic composite & foreign key B-Tree indexes
├── Orimolade_Samuel_301923593_execution_plans_evidence.sql # Pre- and post-optimization EXPLAIN benchmarks
├── Orimolade_Samuel_301923593_query_performance_analysis.md# Detailed technical analysis report
└── Orimolade_Samuel_301923593_README.md                    # Implementation guide and execution steps
```

---

## 3. Query Overview

| Query | Focus Area | Advanced SQL Techniques Used |
| :--- | :--- | :--- |
| **Query 1** | Room Tier Utilization & Occupancy Rate | `LEFT JOIN`, conditional `SUM(CASE ...)`, percentage arithmetic, `GROUP BY`. |
| **Query 2** | Channel Revenue & Collection Efficiency | Financial aggregations, `NULLIF` divide-by-zero protection, channel grouping. |
| **Query 3** | VIP Guest Ranking & Lifetime Value | Common Table Expression (CTE), `DENSE_RANK() OVER (...)` window function. |
| **Query 4** | Daily Housekeeping Turnover Schedule | Multi-table joins across 4 entities, temporal interval checks (`BETWEEN`). |
| **Query 5** | Unpaid Balance & Reconciliation Audit | Correlated subquery aggregation, `COALESCE`, outer joins, discrepancy filters. |

---

## 4. Execution & Verification Guide

Execute the analytical suite and benchmark scripts using MariaDB / MySQL:

```powershell
# 1. Execute Analytical Queries
Get-Content "portfolio-2-query-optimisation\Orimolade_Samuel_301923593_analytical_queries.sql" | & "C:\xampp\mysql\bin\mysql.exe" -u root

# 2. Run Baseline EXPLAIN Benchmarks
Get-Content "portfolio-2-query-optimisation\Orimolade_Samuel_301923593_execution_plans_evidence.sql" | & "C:\xampp\mysql\bin\mysql.exe" -u root

# 3. Apply Performance Indexes
Get-Content "portfolio-2-query-optimisation\Orimolade_Samuel_301923593_indexes.sql" | & "C:\xampp\mysql\bin\mysql.exe" -u root

# 4. Run Post-Optimization EXPLAIN Benchmarks
Get-Content "portfolio-2-query-optimisation\Orimolade_Samuel_301923593_execution_plans_evidence.sql" | & "C:\xampp\mysql\bin\mysql.exe" -u root
```

Detailed performance tables and execution plan breakdowns are recorded in [`Orimolade_Samuel_301923593_query_performance_analysis.md`](Orimolade_Samuel_301923593_query_performance_analysis.md).
