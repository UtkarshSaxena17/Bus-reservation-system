// ============================================================
//  BRS — Bus Reservation System
//  Node.js + Express Backend Server
//  Connects HTML frontend to MySQL database
//
//  SETUP INSTRUCTIONS:
//  1. Install Node.js from https://nodejs.org
//  2. Open terminal in this folder and run:
//       npm init -y
//       npm install express mysql2 cors
//  3. Edit DB CONFIG below with your MySQL credentials
//  4. Run: node server.js
//  5. Open brs_frontend.html in your browser
// ============================================================

const express = require('express');
const mysql   = require('mysql2');
const cors    = require('cors');

const app  = express();
const PORT = 3000;

// Allow frontend HTML to talk to this server
app.use(cors());
app.use(express.json());

// ── DB CONFIG — Change these to match your MySQL setup ──────
const db = mysql.createConnection({
  host:     'localhost',   // your MySQL host
  user:     'root',        // your MySQL username
  password: 'Utk@rsh17',   // your MySQL password
  database: 'brs_db'       // database name from the SQL file
});

// Connect to MySQL
db.connect(err => {
  if (err) {
    console.error('❌ MySQL connection failed:', err.message);
    console.log('👉 Make sure MySQL is running and credentials are correct.');
    process.exit(1);
  }
  console.log('✅ Connected to MySQL — brs_db');
  console.log(`🚌 BRS Server running at http://localhost:${PORT}`);
});

// ============================================================
// API ROUTES
// ============================================================

// ── GET /api/cities — Fetch all cities ──────────────────────
app.get('/api/cities', (req, res) => {
  db.query('SELECT * FROM cities ORDER BY name', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// ── GET /api/operators — Fetch all operators ─────────────────
app.get('/api/operators', (req, res) => {
  const sql = `
    SELECT o.*, c.name AS hq_city_name
    FROM operators o
    LEFT JOIN cities c ON o.hq_city_id = c.city_id
    ORDER BY o.name
  `;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// ── GET /api/buses — Fetch buses (optional ?type= filter) ────
app.get('/api/buses', (req, res) => {
  const { type } = req.query;
  let sql = `
    SELECT b.*, o.name AS operator_name, o.rating AS operator_rating
    FROM buses b
    LEFT JOIN operators o ON b.operator_id = o.operator_id
  `;
  const params = [];
  if (type && type !== '') {
    sql += ' WHERE b.type = ?';
    params.push(type);
  }
  sql += ' ORDER BY b.price';

  db.query(sql, params, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    // Convert amenities string to array
    results = results.map(b => ({
      ...b,
      amenities: b.amenities ? b.amenities.split(',').filter(Boolean) : []
    }));
    res.json(results);
  });
});

// ── GET /api/routes — Fetch all routes ──────────────────────
app.get('/api/routes', (req, res) => {
  const sql = `
    SELECT r.*,
           c1.name AS from_city_name,
           c2.name AS to_city_name
    FROM routes r
    JOIN cities c1 ON r.from_city_id = c1.city_id
    JOIN cities c2 ON r.to_city_id   = c2.city_id
    ORDER BY r.popular DESC
  `;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// ── GET /api/passengers — Fetch all passengers ───────────────
app.get('/api/passengers', (req, res) => {
  const sql = `
    SELECT p.*, c.name AS city_name
    FROM passengers p
    LEFT JOIN cities c ON p.city_id = c.city_id
    ORDER BY p.created_at DESC
  `;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// ── GET /api/bookings — Fetch all bookings (with JOINs) ──────
app.get('/api/bookings', (req, res) => {
  const sql = `
    SELECT bk.*,
           p.name  AS passenger_name,
           b.name  AS bus_name,
           b.type  AS bus_type,
           c1.name AS from_city_name,
           c2.name AS to_city_name
    FROM bookings bk
    JOIN passengers p  ON bk.passenger_id = p.passenger_id
    JOIN buses b       ON bk.bus_id       = b.bus_id
    JOIN cities c1     ON bk.from_city_id = c1.city_id
    JOIN cities c2     ON bk.to_city_id   = c2.city_id
    ORDER BY bk.booked_at DESC
  `;
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// ── POST /api/passengers — Add a new passenger ───────────────
app.post('/api/passengers', (req, res) => {
  const { passenger_id, name, email, phone, city_id, loyalty_pts } = req.body;
  const sql = 'INSERT INTO passengers (passenger_id, name, email, phone, city_id, loyalty_pts) VALUES (?, ?, ?, ?, ?, ?)';
  db.query(sql, [passenger_id, name, email, phone, city_id, loyalty_pts || 0], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ success: true, passenger_id });
  });
});

// ── POST /api/bookings — Create a new booking ────────────────
app.post('/api/bookings', (req, res) => {
  const { booking_id, passenger_id, bus_id, from_city_id, to_city_id, travel_date, seats, total } = req.body;

  // 1. Insert the booking
  const bookingSql = `
    INSERT INTO bookings (booking_id, passenger_id, bus_id, from_city_id, to_city_id, travel_date, seats, total, status)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'confirmed')
  `;

  db.query(bookingSql, [booking_id, passenger_id, bus_id, from_city_id, to_city_id, travel_date, seats, total], (err) => {
    if (err) return res.status(500).json({ error: err.message });

    // 2. Decrement available seats on the bus
    const seatCount = seats.split(',').length;
    const seatSql   = 'UPDATE buses SET available_seats = available_seats - ? WHERE bus_id = ?';
    db.query(seatSql, [seatCount, bus_id], (err2) => {
      if (err2) return res.status(500).json({ error: err2.message });
      res.json({ success: true, booking_id });
    });
  });
});

// ── PUT /api/bookings/:id/cancel — Cancel a booking ──────────
app.put('/api/bookings/:id/cancel', (req, res) => {
  const sql = "UPDATE bookings SET status = 'cancelled' WHERE booking_id = ?";
  db.query(sql, [req.params.id], (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ success: true });
  });
});

// ── GET /api/stats — Dashboard stats ─────────────────────────
app.get('/api/stats', (req, res) => {
  const queries = {
    buses:      'SELECT COUNT(*) AS count FROM buses',
    operators:  'SELECT COUNT(*) AS count FROM operators',
    routes:     'SELECT COUNT(*) AS count FROM routes',
    cities:     'SELECT COUNT(*) AS count FROM cities',
    passengers: 'SELECT COUNT(*) AS count FROM passengers',
    bookings:   'SELECT COUNT(*) AS count FROM bookings',
    revenue:    "SELECT COALESCE(SUM(total),0) AS count FROM bookings WHERE status='confirmed'",
  };

  const results = {};
  let pending = Object.keys(queries).length;

  Object.entries(queries).forEach(([key, sql]) => {
    db.query(sql, (err, rows) => {
      results[key] = err ? 0 : rows[0].count;
      if (--pending === 0) res.json(results);
    });
  });
});

// Start server
app.listen(PORT, () => {
  console.log('\n🚌 ================================');
  console.log('   BRS Server is running!');
  console.log(`   http://localhost:${PORT}`);
  console.log('================================\n');
});
