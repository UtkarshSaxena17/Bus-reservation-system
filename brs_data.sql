-- ============================================================
-- SAMPLE DATA FOR BRS DATABASE
-- Run this after creating the schema:
-- mysql -u root -p < brs_data.sql
-- ============================================================
USE brs_db;

-- ============================================================
-- SAMPLE DATA — TABLE 1: cities
-- ============================================================
INSERT INTO cities (city_id, name, state, population, terminal, lat, lng) VALUES
('C001', 'Delhi',     'Delhi',          '32M', 'Kashmere Gate ISBT',  28.613900, 77.209000),
('C002', 'Mumbai',    'Maharashtra',    '21M', 'Mumbai Central Bus',  19.076000, 72.877700),
('C003', 'Bangalore', 'Karnataka',      '12M', 'Majestic Bus Stand',  12.971600, 77.594600),
('C004', 'Chennai',   'Tamil Nadu',     '11M', 'CMBT Bus Terminal',   13.082700, 80.270700),
('C005', 'Hyderabad', 'Telangana',      '10M', 'Mahatma Gandhi Bus',  17.385000, 78.486700),
('C006', 'Kolkata',   'West Bengal',    '15M', 'Esplanade Bus Stand', 22.572600, 88.363900),
('C007', 'Jaipur',    'Rajasthan',      '4M',  'Sindhi Camp Bus',     26.912400, 75.787300),
('C008', 'Pune',      'Maharashtra',    '7M',  'Shivajinagar Bus',    18.520400, 73.856700);

-- ============================================================
-- SAMPLE DATA — TABLE 2: operators
-- ============================================================
INSERT INTO operators (operator_id, name, founded, rating, fleet_size, hq_city_id, contact) VALUES
('OP001', 'Rajdhani Travels Pvt Ltd',  1998, 4.7, 45, 'C001', '1800-111-222'),
('OP002', 'Star Highway Group',         2005, 4.2, 32, 'C002', '1800-222-333'),
('OP003', 'Royal Sleeper Lines',         2010, 4.8, 20, 'C003', '1800-333-444'),
('OP004', 'Shyam Travels VIP',           2002, 4.5, 28, 'C001', '1800-444-555'),
('OP005', 'Greenline Bus Services',       2015, 4.0, 60, 'C004', '1800-555-666'),
('OP006', 'NightOwl Express',             2012, 4.6, 15, 'C005', '1800-666-777');

-- ============================================================
-- SAMPLE DATA — TABLE 3: buses
-- ============================================================
INSERT INTO buses (bus_id, name, operator_id, type, departure, arrival, price, available_seats, total_seats, amenities) VALUES
('B001', 'Rajdhani Express',    'OP001', 'AC',      '06:00', '14:00', 850,  32, 40, 'WiFi,Charging,AC,Water'),
('B002', 'Star Economy Plus',   'OP002', 'Non-AC',  '08:30', '17:30', 450,  20, 44, 'TV,Snacks'),
('B003', 'Royal Night Sleeper', 'OP003', 'Sleeper', '22:00', '06:00', 1100, 14, 30, 'WiFi,Blanket,AC,Charging'),
('B004', 'Shyam VIP Cruiser',   'OP004', 'AC',      '10:00', '18:30', 950,  8,  36, 'WiFi,AC,Charging,Snacks'),
('B005', 'Greenline Saver',      'OP005', 'Non-AC',  '13:00', '21:00', 400,  30, 44, 'TV'),
('B006', 'NightOwl Premium',     'OP006', 'Sleeper', '23:30', '08:00', 1250, 6,  28, 'WiFi,Blanket,AC,Charging,Snacks'),
('B007', 'Rajdhani Volvo Lux',  'OP001', 'AC',      '07:00', '15:30', 1050, 18, 36, 'WiFi,AC,Charging,Water'),
('B008', 'Greenline Budget',     'OP005', 'Non-AC',  '05:30', '13:00', 350,  40, 44, '');

-- ============================================================
-- SAMPLE DATA — TABLE 4: routes
-- ============================================================
INSERT INTO routes (route_id, from_city_id, to_city_id, distance_km, duration_hrs, highway, popular) VALUES
('R001', 'C001', 'C002', 1421, 22, 'NH48',  TRUE),
('R002', 'C001', 'C007', 282,  5,  'NH48',  TRUE),
('R003', 'C002', 'C008', 153,  3,  'NH48',  TRUE),
('R004', 'C003', 'C004', 346,  6,  'NH44',  TRUE),
('R005', 'C003', 'C005', 570,  9,  'NH44',  TRUE),
('R006', 'C004', 'C005', 626,  10, 'NH65',  FALSE),
('R007', 'C001', 'C003', 2150, 36, 'NH44',  FALSE),
('R008', 'C006', 'C001', 1490, 24, 'NH19',  TRUE);

-- ============================================================
-- SAMPLE DATA — TABLE 5: passengers
-- ============================================================
INSERT INTO passengers (passenger_id, name, email, phone, city_id, loyalty_pts) VALUES
('P001', 'Aarav Sharma',  'aarav@email.com',  '9876543210', 'C001', 450),
('P002', 'Priya Mehta',   'priya@email.com',  '9876543211', 'C002', 820),
('P003', 'Rohan Verma',   'rohan@email.com',  '9876543212', 'C003', 200),
('P004', 'Sanya Kapoor',  'sanya@email.com',  '9876543213', 'C004', 660),
('P005', 'Karan Singh',   'karan@email.com',  '9876543214', 'C005', 110);

-- ============================================================
-- SAMPLE DATA — TABLE 6: bookings
-- ============================================================
INSERT INTO bookings (booking_id, passenger_id, bus_id, from_city_id, to_city_id, travel_date, seats, total, status) VALUES
('RR00001', 'P001', 'B001', 'C001', 'C002', '2025-07-10', '3,7',   1700, 'confirmed'),
('RR00002', 'P002', 'B003', 'C003', 'C005', '2025-07-12', '11',    1100, 'confirmed'),
('RR00003', 'P003', 'B005', 'C002', 'C008', '2025-07-14', '5,6,9', 1200, 'cancelled'),
('RR00004', 'P004', 'B004', 'C001', 'C007', '2025-07-15', '2',     950,  'confirmed'),
('RR00005', 'P005', 'B006', 'C004', 'C005', '2025-07-18', '14,15', 2500, 'confirmed');

-- ============================================================
-- USEFUL QUERIES TO TEST YOUR DATABASE
-- ============================================================

-- View all buses with operator names (JOIN)
-- SELECT b.bus_id, b.name, b.type, b.price, o.name AS operator
-- FROM buses b JOIN operators o ON b.operator_id = o.operator_id;

-- View all bookings with passenger and bus details (multi JOIN)
-- SELECT bk.booking_id, p.name AS passenger, b.name AS bus,
--        c1.name AS from_city, c2.name AS to_city,
--        bk.travel_date, bk.seats, bk.total, bk.status
-- FROM bookings bk
-- JOIN passengers p  ON bk.passenger_id = p.passenger_id
-- JOIN buses b       ON bk.bus_id = b.bus_id
-- JOIN cities c1     ON bk.from_city_id = c1.city_id
-- JOIN cities c2     ON bk.to_city_id = c2.city_id;

-- Search buses by type
-- SELECT * FROM buses WHERE type = 'AC' AND available_seats > 0;

-- Get total revenue
-- SELECT SUM(total) AS total_revenue FROM bookings WHERE status = 'confirmed';
