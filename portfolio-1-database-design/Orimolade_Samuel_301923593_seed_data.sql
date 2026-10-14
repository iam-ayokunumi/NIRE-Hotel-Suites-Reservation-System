-- ============================================================================
-- MIT 8103 - Advanced Database Systems
-- Portfolio 1: Seed Data Script
-- Case Study: NIRE Hotel and Suites - Abuja, FCT, Nigeria
-- ============================================================================

USE nire_hotel_db;

-- 1. Seed Room Types
INSERT INTO room_types (room_type_id, type_name, base_rate, max_occupancy, bed_type, description) VALUES
(1, 'Standard Room', 45000.00, 2, 'Queen Bed', 'Cozy modern room with work desk, high-speed WiFi, and standard bathroom amenities.'),
(2, 'Deluxe Room', 75000.00, 2, 'King Bed', 'Spacious luxury room featuring city view, minibar, and premium bedding.'),
(3, 'Executive Suite', 120000.00, 3, 'King Bed + Sofa Bed', 'Lavish suite with dedicated sitting lounge, kitchenette, and executive lounge access.'),
(4, 'Presidential Suite', 350000.00, 4, 'Master King + Twin', 'Ultra-luxurious multi-room suite with private terrace, boardroom table, and jacuzzi.'),
(5, 'Family Suite', 160000.00, 5, 'Two Double Beds', 'Interconnected suite designed for families, featuring two en-suite bathrooms.');

-- 2. Seed Physical Rooms
INSERT INTO rooms (room_id, room_type_id, room_number, floor_number, status) VALUES
-- Floor 1: Standard & Deluxe
(101, 1, 'RM-101', 1, 'AVAILABLE'),
(102, 1, 'RM-102', 1, 'OCCUPIED'),
(103, 1, 'RM-103', 1, 'AVAILABLE'),
(104, 1, 'RM-104', 1, 'MAINTENANCE'),
(105, 2, 'RM-105', 1, 'OCCUPIED'),
(106, 2, 'RM-106', 1, 'AVAILABLE'),
-- Floor 2: Deluxe & Executive Suites
(201, 2, 'RM-201', 2, 'OCCUPIED'),
(202, 2, 'RM-202', 2, 'AVAILABLE'),
(203, 2, 'RM-203', 2, 'RESERVED'),
(204, 3, 'RM-204', 2, 'OCCUPIED'),
(205, 3, 'RM-205', 2, 'AVAILABLE'),
(206, 3, 'RM-206', 2, 'AVAILABLE'),
-- Floor 3: Executive & Family Suites
(301, 3, 'RM-301', 3, 'AVAILABLE'),
(302, 3, 'RM-302', 3, 'OCCUPIED'),
(303, 5, 'RM-303', 3, 'RESERVED'),
(304, 5, 'RM-304', 3, 'AVAILABLE'),
(305, 5, 'RM-305', 3, 'OCCUPIED'),
-- Floor 4: Penthouse / Presidential & Executive
(401, 4, 'RM-401', 4, 'OCCUPIED'),
(402, 4, 'RM-402', 4, 'AVAILABLE'),
(403, 3, 'RM-403', 4, 'AVAILABLE');

-- 3. Seed Guests (Authentic Nigerian Profiles & KYC Compliance)
INSERT INTO guests (guest_id, first_name, last_name, email, phone, identity_type, identity_number, residential_address, emergency_contact_name, emergency_contact_phone, emergency_contact_address) VALUES
(1, 'Chinedu', 'Okafor', 'chinedu.okafor@gmail.com', '+2348032110022', 'NIN', 'NIN-99283716201', 'Plot 12, Garki II, Abuja', 'Ngozi Okafor', '+2348032110023', 'Plot 12, Garki II, Abuja'),
(2, 'Amina', 'Bello', 'amina.bello@yahoo.com', '+2348029988771', 'DRIVERS_LICENSE', 'DL-ABJ-8827361A', '14 Zambezi Crescent, Maitama, Abuja', 'Usman Bello', '+2348029988770', '14 Zambezi Crescent, Maitama, Abuja'),
(3, 'Babatunde', 'Adeyemi', 'babatunde.adeyemi@outlook.com', '+2348145566778', 'INTERNATIONAL_PASSPORT', 'A08927163', '25 Admiralty Way, Lekki Phase 1, Lagos', 'Funke Adeyemi', '+2348145566779', '25 Admiralty Way, Lekki Phase 1, Lagos'),
(4, 'Nkechi', 'Eze', 'nkechi.eze@gmail.com', '+2347034455667', 'NIN', 'NIN-10293847561', '8 Trans-Amadi Road, Port Harcourt', 'Emeka Eze', '+2347034455668', '8 Trans-Amadi Road, Port Harcourt'),
(5, 'Ibrahim', 'Garba', 'ibrahim.garba@knt.ng', '+2348091122334', 'VOTERS_CARD', 'VIN-990182736451029', '5 Bompai Road, Kano', 'Fatima Garba', '+2348091122335', '5 Bompai Road, Kano'),
(6, 'Folake', 'Balogun', 'folake.balogun@fintech.ng', '+2348187766554', 'NIN', 'NIN-55667788990', '42 Isaac John Street, GRA Ikeja, Lagos', 'Tunde Balogun', '+2348187766555', '42 Isaac John Street, GRA Ikeja, Lagos'),
(7, 'David', 'Mark', 'david.mark@corporatemail.com', '+2348056677889', 'INTERNATIONAL_PASSPORT', 'B12938475', '3 Yakubu Gowon Way, Jos, Plateau', 'Sarah Mark', '+2348056677880', '3 Yakubu Gowon Way, Jos, Plateau'),
(8, 'Zainab', 'Mohammed', 'zainab.m@gov.ng', '+2348039911223', 'NIN', 'NIN-66778899001', '19 Shehu Shagari Way, Central Business District, Abuja', 'Aliyu Mohammed', '+2348039911224', '19 Shehu Shagari Way, Abuja'),
(9, 'Obinna', 'Nwosu', 'obinna.nwosu@techcorp.com', '+2347081122445', 'DRIVERS_LICENSE', 'DL-ENU-1192834B', '10 Independence Layout, Enugu', 'Chioma Nwosu', '+2347081122446', '10 Independence Layout, Enugu'),
(10, 'Halima', 'Suleiman', 'halima.suleiman@gmail.com', '+2348123344556', 'NIN', 'NIN-88990011223', '22 Sultan Abubakar Road, Sokoto', 'Kabir Suleiman', '+2348123344557', '22 Sultan Abubakar Road, Sokoto'),
(11, 'Kayode', 'Ogunleye', 'kayode.ogunleye@ventures.ng', '+2348021133557', 'INTERNATIONAL_PASSPORT', 'A19283746', '18 Ring Road, Ibadan, Oyo', 'Bisola Ogunleye', '+2348021133558', '18 Ring Road, Ibadan, Oyo'),
(12, 'Grace', 'Akpan', 'grace.akpan@oilgas.org', '+2348162233445', 'NIN', 'NIN-77889911224', '7 Oron Road, Uyo, Akwa Ibom', 'Etim Akpan', '+2348162233446', '7 Oron Road, Uyo, Akwa Ibom');

-- 4. Seed Reservations (Past, Current, and Upcoming Stays)
INSERT INTO reservations (reservation_id, guest_id, check_in_date, check_out_date, booking_status, total_amount, created_at) VALUES
(1001, 1, '2026-09-01', '2026-09-04', 'COMPLETED', 135000.00, '2026-08-25 09:30:00'),
(1002, 2, '2026-09-05', '2026-09-08', 'COMPLETED', 225000.00, '2026-08-28 14:15:00'),
(1003, 3, '2026-09-10', '2026-09-14', 'COMPLETED', 480000.00, '2026-09-02 11:00:00'),
(1004, 4, '2026-09-15', '2026-09-17', 'CANCELLED', 90000.00, '2026-09-12 16:45:00'),
(1005, 5, '2026-09-18', '2026-09-22', 'COMPLETED', 300000.00, '2026-09-14 10:20:00'),
(1006, 6, '2026-10-01', '2026-10-05', 'COMPLETED', 480000.00, '2026-09-25 18:00:00'),
(1007, 7, '2026-10-10', '2026-10-16', 'CONFIRMED', 2100000.00, '2026-10-05 08:30:00'), -- Presidential Suite
(1008, 8, '2026-10-12', '2026-10-17', 'CONFIRMED', 600000.00, '2026-10-08 13:40:00'),
(1009, 1, '2026-10-13', '2026-10-18', 'CONFIRMED', 375000.00, '2026-10-10 17:10:00'),
(1010, 9, '2026-10-14', '2026-10-17', 'CONFIRMED', 135000.00, '2026-10-11 12:00:00'),
(1011, 10, '2026-10-14', '2026-10-19', 'CONFIRMED', 800000.00, '2026-10-11 15:30:00'), -- Multi-Room Family
(1012, 11, '2026-10-20', '2026-10-24', 'CONFIRMED', 300000.00, '2026-10-12 09:15:00'),
(1013, 12, '2026-10-22', '2026-10-25', 'CONFIRMED', 135000.00, '2026-10-12 11:50:00'),
(1014, 3, '2026-10-25', '2026-10-28', 'CONFIRMED', 360000.00, '2026-10-13 16:00:00'),
(1015, 2, '2026-11-01', '2026-11-05', 'CONFIRMED', 300000.00, '2026-10-14 08:45:00');

-- 5. Seed Reservation Rooms (Junction Table demonstrating Single & Multi-Room allocation)
INSERT INTO reservation_rooms (reservation_room_id, reservation_id, room_id, nightly_rate) VALUES
(1, 1001, 101, 45000.00), -- 3 nights * 45k = 135k
(2, 1002, 105, 75000.00), -- 3 nights * 75k = 225k
(3, 1003, 204, 120000.00), -- 4 nights * 120k = 480k
(4, 1004, 103, 45000.00), -- Cancelled
(5, 1005, 201, 75000.00), -- 4 nights * 75k = 300k
(6, 1006, 302, 120000.00), -- 4 nights * 120k = 480k
(7, 1007, 401, 350000.00), -- 6 nights * 350k = 2.1M
(8, 1008, 204, 120000.00), -- 5 nights * 120k = 600k
(9, 1009, 105, 75000.00), -- 5 nights * 75k = 375k
(10, 1010, 102, 45000.00), -- 3 nights * 45k = 135k
(11, 1011, 305, 160000.00), -- 5 nights * 160k = 800k (Family Suite)
(12, 1012, 203, 75000.00), -- 4 nights * 75k = 300k
(13, 1013, 101, 45000.00), -- Future
(14, 1014, 301, 120000.00), -- Future
(15, 1015, 202, 75000.00);  -- Future

-- 6. Seed Payments (Transactions Across Multiple Gateways and Settlement States)
INSERT INTO payments (payment_id, reservation_id, payment_date, amount, payment_method, payment_status, transaction_reference) VALUES
(5001, 1001, '2026-08-25 09:35:00', 135000.00, 'DEBIT_CARD', 'SUCCESSFUL', 'PAY-NIRE-20260825-001'),
(5002, 1002, '2026-08-28 14:20:00', 225000.00, 'BANK_TRANSFER', 'SUCCESSFUL', 'PAY-NIRE-20260828-002'),
(5003, 1003, '2026-09-02 11:05:00', 480000.00, 'POS', 'SUCCESSFUL', 'PAY-NIRE-20260902-003'),
(5004, 1004, '2026-09-12 16:50:00', 90000.00, 'DEBIT_CARD', 'REFUNDED', 'PAY-NIRE-20260912-004'),
(5005, 1005, '2026-09-14 10:25:00', 300000.00, 'BANK_TRANSFER', 'SUCCESSFUL', 'PAY-NIRE-20260914-005'),
(5006, 1006, '2026-09-25 18:05:00', 480000.00, 'POS', 'SUCCESSFUL', 'PAY-NIRE-20260925-006'),
(5007, 1007, '2026-10-05 08:35:00', 2100000.00, 'BANK_TRANSFER', 'SUCCESSFUL', 'PAY-NIRE-20261005-007'),
(5008, 1008, '2026-10-08 13:45:00', 600000.00, 'DEBIT_CARD', 'SUCCESSFUL', 'PAY-NIRE-20261008-008'),
(5009, 1009, '2026-10-10 17:15:00', 375000.00, 'POS', 'SUCCESSFUL', 'PAY-NIRE-20261010-009'),
(5010, 1010, '2026-10-11 12:05:00', 135000.00, 'CASH', 'SUCCESSFUL', 'PAY-NIRE-20261011-010'),
(5011, 1011, '2026-10-11 15:35:00', 800000.00, 'BANK_TRANSFER', 'SUCCESSFUL', 'PAY-NIRE-20261011-011'),
(5012, 1012, '2026-10-12 09:20:00', 300000.00, 'DEBIT_CARD', 'SUCCESSFUL', 'PAY-NIRE-20261012-012'),
(5013, 1013, '2026-10-12 11:55:00', 135000.00, 'BANK_TRANSFER', 'PENDING', 'PAY-NIRE-20261012-013'),
(5014, 1014, '2026-10-13 16:05:00', 360000.00, 'DEBIT_CARD', 'SUCCESSFUL', 'PAY-NIRE-20261013-014'),
(5015, 1015, '2026-10-14 08:50:00', 300000.00, 'BANK_TRANSFER', 'SUCCESSFUL', 'PAY-NIRE-20261014-015');
