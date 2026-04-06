-- ============================================================
--  BRS — Bus Reservation System
--  MySQL Database Schema
--  Run this file in MySQL Workbench or terminal:
--  mysql -u root -p < brs_schema.sql
-- ============================================================

-- Create and select the database
CREATE DATABASE IF NOT EXISTS brs_db;
USE brs_db;

-- ============================================================
-- TABLE 1: cities
-- Stores all supported city information
-- ============================================================
CREATE TABLE IF NOT EXISTS cities (
  city_id       VARCHAR(10)  PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  state         VARCHAR(100) NOT NULL,
  population    VARCHAR(20),
  terminal      VARCHAR(200),
  lat           DECIMAL(9,6),
  lng           DECIMAL(9,6),
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLE 2: operators
-- Stores bus company / operator information
-- ============================================================
CREATE TABLE IF NOT EXISTS operators (
  operator_id   VARCHAR(10)  PRIMARY KEY,
  name          VARCHAR(200) NOT NULL,
  founded       YEAR,
  rating        DECIMAL(3,1),
  fleet_size    INT,
  hq_city_id    VARCHAR(10),
  contact       VARCHAR(50),
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (hq_city_id) REFERENCES cities(city_id)
);

-- ============================================================
-- TABLE 3: buses
-- Main bus inventory table
-- ============================================================
CREATE TABLE IF NOT EXISTS buses (
  bus_id           VARCHAR(10)  PRIMARY KEY,
  name             VARCHAR(200) NOT NULL,
  operator_id      VARCHAR(10),
  type             ENUM('AC','Non-AC','Sleeper') NOT NULL,
  departure        TIME NOT NULL,
  arrival          TIME NOT NULL,
  price            INT  NOT NULL,
  available_seats  INT  NOT NULL,
  total_seats      INT  NOT NULL,
  amenities        TEXT,          -- stored as comma-separated: "WiFi,AC,Charging"
  created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (operator_id) REFERENCES operators(operator_id)
);

-- ============================================================
-- TABLE 4: routes
-- Stores origin-destination route pairs
-- ============================================================
CREATE TABLE IF NOT EXISTS routes (
  route_id      VARCHAR(10)  PRIMARY KEY,
  from_city_id  VARCHAR(10)  NOT NULL,
  to_city_id    VARCHAR(10)  NOT NULL,
  distance_km   INT,
  duration_hrs  INT,
  highway       VARCHAR(50),
  popular       BOOLEAN DEFAULT FALSE,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (from_city_id) REFERENCES cities(city_id),
  FOREIGN KEY (to_city_id)   REFERENCES cities(city_id)
);

-- ============================================================
-- TABLE 5: passengers
-- Stores passenger account information
-- ============================================================
CREATE TABLE IF NOT EXISTS passengers (
  passenger_id  VARCHAR(10)  PRIMARY KEY,
  name          VARCHAR(200) NOT NULL,
  email         VARCHAR(200) UNIQUE,
  phone         VARCHAR(20),
  city_id       VARCHAR(10),
  loyalty_pts   INT DEFAULT 0,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

-- ============================================================
-- TABLE 6: bookings
-- Stores all confirmed ticket bookings
-- ============================================================
CREATE TABLE IF NOT EXISTS bookings (
  booking_id    VARCHAR(20)  PRIMARY KEY,
  passenger_id  VARCHAR(10)  NOT NULL,
  bus_id        VARCHAR(10)  NOT NULL,
  from_city_id  VARCHAR(10)  NOT NULL,
  to_city_id    VARCHAR(10)  NOT NULL,
  travel_date   DATE         NOT NULL,
  seats         VARCHAR(100),
  total         INT          NOT NULL,
  status        ENUM('confirmed','cancelled','pending') DEFAULT 'confirmed',
  booked_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (passenger_id)  REFERENCES passengers(passenger_id),
  FOREIGN KEY (bus_id)        REFERENCES buses(bus_id),
  FOREIGN KEY (from_city_id)  REFERENCES cities(city_id),
  FOREIGN KEY (to_city_id)    REFERENCES cities(city_id)
);
