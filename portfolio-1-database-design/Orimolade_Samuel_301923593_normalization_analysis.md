# Portfolio 1: Relational Normalization Analysis & Proof

**Course:** MIT 8103 - Advanced Database Systems  
**Institution:** MIVA Open University  
**Case Study:** NIRE Hotel and Suites - Reservation System (Abuja, FCT, Nigeria)

---

## 1. Theoretical Background & Objectives

Relational database normalization is the systematic formal technique for organizing attributes within relations to minimize data redundancy, prevent insertion, update, and deletion anomalies, and guarantee data consistency through lossless-join decomposition and functional dependency preservation.

For the **NIRE Hotel and Suites** enterprise architecture, the schema was designed through rigorous normalization from an **Unnormalized Form (UNF)** through to **Boyce-Codd Normal Form (BCNF)**.

---

## 2. Unnormalized Form (UNF) Analysis

In an unnormalized legacy hotel ledger, booking operations are logged as a single, multi-valued record containing repeating groups, redundant guest profiles, and concatenated room allocations:

$$\text{UNF\_RESERVATION\_LEDGER} = \{ \underline{\text{ReservationNumber}}, \text{GuestFirstName}, \text{GuestLastName}, \text{GuestEmail}, \text{GuestPhone}, \text{GuestNIN}, \text{GuestAddress}, \text{EmergencyContact}, \text{CheckInDate}, \text{CheckOutDate}, \{\text{RoomNumber}, \text{RoomType}, \text{Floor}, \text{NightlyRate}, \text{MaxOccupancy}, \text{BedType}\}^*, \text{TotalAmount}, \{\text{PaymentDate}, \text{AmountPaid}, \text{PaymentMethod}, \text{TxnRef}, \text{PaymentStatus}\}^* \}$$

### Anomalies Inherent in UNF:
1. **Insertion Anomaly:** A new room category (e.g., Presidential Suite) cannot be created unless an actual guest makes a reservation for it.
2. **Update Anomaly:** If a guest changes their contact telephone number, it must be updated across hundreds of past and current booking records. If any row is missed, data becomes inconsistent.
3. **Deletion Anomaly:** If a customer cancels their booking and the row is removed, historical room tariffs or guest profile data may be permanently lost.

---

## 3. First Normal Form (1NF)

### 1NF Criteria:
* Attributes must contain purely atomic (indivisible) values.
* Each relation must possess a designated primary key.
* Repeating groups or multi-valued attributes must be eliminated by creating separate relations.

### Transformation to 1NF:
We decompose the repeating groups of rooms and payments into discrete tuple representations, with composite primary keys.

* **REL_RESERVATIONS_1NF** ($\underline{\text{reservation\_id}}$, guest_first_name, guest_last_name, guest_email, guest_phone, guest_identity_type, guest_identity_number, residential_address, emergency_name, emergency_phone, emergency_address, check_in_date, check_out_date, booking_status, total_amount)
* **REL_RESERVATION_ROOMS_1NF** ($\underline{\text{reservation\_id}}, \underline{\text{room\_number}}$, room_type_name, floor_number, base_rate, max_occupancy, bed_type, nightly_rate)
* **REL_PAYMENTS_1NF** ($\underline{\text{payment\_id}}$, reservation_id, payment_date, amount, payment_method, payment_status, transaction_reference)

**Result:** All attribute values are atomic scalar values. 1NF is satisfied.

---

## 4. Second Normal Form (2NF)

### 2NF Criteria:
* The relation must already be in 1NF.
* Every non-prime attribute must be **fully functionally dependent** on the whole primary key (no partial functional dependencies on composite keys).

### Partial Dependency Analysis in `REL_RESERVATION_ROOMS_1NF`:
The candidate key is composite: $\{\text{reservation\_id}, \text{room\_number}\}$.
* $\text{reservation\_id}, \text{room\_number} \to \text{nightly\_rate}$ (Full dependency - Nightly rate charged depends on this specific booking for this room).
* $\text{room\_number} \to \text{floor\_number}, \text{room\_type\_name}, \text{base\_rate}, \text{max\_occupancy}, \text{bed\_type}$ (**Partial Dependency**: These attributes depend strictly on `room_number`, not on `reservation_id`!).

### 2NF Decomposition:
To eliminate partial dependencies, we extract room inventory into an independent entity:

1. **`rooms` Relation:**
   * Primary Key: `room_id` (with candidate key `room_number`).
   * Attributes: `room_id`, `room_number`, `floor_number`, `status`, `room_type_name`, `base_rate`, `max_occupancy`, `bed_type`.
2. **`reservation_rooms` Junction Relation:**
   * Primary Key: `reservation_room_id` (Composite Unique: $\{\text{reservation\_id}, \text{room\_id}\}$).
   * Functional Dependency: $\{\text{reservation\_id}, \text{room\_id}\} \to \text{nightly\_rate}$ (Full dependency).

**Result:** All partial dependencies are eliminated. 2NF is satisfied.

---

## 5. Third Normal Form (3NF)

### 3NF Criteria:
* The relation must already be in 2NF.
* There must be **no transitive functional dependencies** ($X \to Y$ and $Y \to Z$, where $X$ is the primary key and $Y$ is a non-prime attribute).

### Transitive Dependency Analysis:

#### Transitive Dependency 1 (In Guest Profile):
In `REL_RESERVATIONS`:
$$\text{reservation\_id} \to \text{guest\_id}$$
$$\text{guest\_id} \to \text{first\_name}, \text{last\_name}, \text{email}, \text{phone}, \text{identity\_type}, \text{identity\_number}, \dots$$
Therefore: $\text{reservation\_id} \xrightarrow{\text{transitive}} \text{first\_name}, \text{last\_name}, \dots$

**Solution:** Decompose into `guests` entity and `reservations` entity linked via Foreign Key `guest_id`.

#### Transitive Dependency 2 (In Room Inventory):
In `rooms`:
$$\text{room\_id} \to \text{room\_type\_id}$$
$$\text{room\_type\_id} \to \text{type\_name}, \text{base\_rate}, \text{max\_occupancy}, \text{bed\_type}$$
Therefore: $\text{room\_id} \xrightarrow{\text{transitive}} \text{base\_rate}, \text{max\_occupancy}, \text{bed\_type}$

**Solution:** Decompose into `room_types` entity and `rooms` entity linked via Foreign Key `room_type_id`.

### Final 3NF Normalized Relational Schema:
1. **`room_types`** ($\underline{\text{room\_type\_id}}$, type_name, base_rate, max_occupancy, bed_type)
2. **`rooms`** ($\underline{\text{room\_id}}$, room_type_id, room_number, floor_number, status)
3. **`guests`** ($\underline{\text{guest\_id}}$, first_name, last_name, email, phone, identity_type, identity_number, residential_address, emergency_contact_name, emergency_contact_phone, emergency_contact_address)
4. **`reservations`** ($\underline{\text{reservation\_id}}$, guest_id, check_in_date, check_out_date, booking_status, total_amount)
5. **`reservation_rooms`** ($\underline{\text{reservation\_room\_id}}$, reservation_id, room_id, nightly_rate)
6. **`payments`** ($\underline{\text{payment\_id}}$, reservation_id, payment_date, amount, payment_method, payment_status, transaction_reference)

---

## 6. Boyce-Codd Normal Form (BCNF) Evaluation

### BCNF Definition:
A relation $R$ is in BCNF if and only if for every non-trivial functional dependency $X \to Y$, the determinant $X$ is a **superkey** of $R$.

| Relation | Functional Dependency ($X \to Y$) | Determinant $X$ Status | BCNF Compliance |
| :--- | :--- | :--- | :---: |
| `room_types` | `room_type_id` $\to$ all attributes<br>`type_name` $\to$ all attributes | Superkey / Candidate Key<br>Candidate Key (`UNIQUE`) | ✅ Satisfied |
| `rooms` | `room_id` $\to$ all attributes<br>`room_number` $\to$ all attributes | Superkey / Candidate Key<br>Candidate Key (`UNIQUE`) | ✅ Satisfied |
| `guests` | `guest_id` $\to$ all attributes<br>`email` $\to$ all attributes<br>`identity_number` $\to$ all attributes | Superkey / Candidate Key<br>Candidate Key (`UNIQUE`)<br>Candidate Key (`UNIQUE`) | ✅ Satisfied |
| `reservations` | `reservation_id` $\to$ all attributes | Superkey / Candidate Key | ✅ Satisfied |
| `reservation_rooms` | `reservation_room_id` $\to$ all attributes<br>`{reservation_id, room_id}` $\to$ `nightly_rate` | Superkey / Candidate Key<br>Candidate Key (`UNIQUE`) | ✅ Satisfied |
| `payments` | `payment_id` $\to$ all attributes<br>`transaction_reference` $\to$ all attributes | Superkey / Candidate Key<br>Candidate Key (`UNIQUE`) | ✅ Satisfied |

### Conclusion on Normalization:
Since every determinant across all 6 tables is a candidate key (or primary superkey), **the NIRE Hotel and Suites schema strictly satisfies BCNF**.

* **Lossless-Join Guarantee:** The decomposition uses common attributes that form candidate keys in parent relations ($R_1 \cap R_2 \to R_1$ or $R_2$).
* **Dependency Preservation:** All functional dependencies from the original problem domain are enforced via primary keys, unique constraints, and foreign key relationships.
