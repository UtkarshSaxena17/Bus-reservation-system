# Bus Reservation System (RDBMS Mini Project)

A complete Bus Reservation System featuring a sleek web frontend, a Node.js REST API backend, and a MySQL relational database. The application allows users to search for buses, visually book seats, view live database statistics, and inspect the underlying database.

## Features
- **Bus Booking Interface**: Search routes, filter by bus types, and pick seats interactively using a dynamic UI layout.
- **Database Explorer**: Live dashboard showing real-time metrics and tabular data queried directly from MySQL.
- **RESTful API Engine**: A Node.js/Express backend communicating natively with the MySQL database.
- **Real-Time Data Sync**: Confirmed bookings instantly insert new passenger records, generate ticket IDs, and execute SQL updates to decrement available bus seats.

## Prerequisites
- **Node.js** (v14 or higher)
- **MySQL Server** (Running locally on default port 3306)

## Project Structure
- `brs_frontend.html` — The centralized frontend UI containing styles and frontend JS.
- `server.js` — Node.js Express RESTful API backend handling DB fetching and posting.
- `package.json` — Backend dependency configurations (`express`, `cors`, `mysql2`).
- `init_db.js` — Helper script to quickly initialize and populate the database via Node.
- `schema_codes/brs_schema.sql` — Raw SQL scripts for handling the `CREATE DATABASE` and `CREATE TABLE` setup constraints.
- `sql_codes/brs_data.sql` — Raw SQL scripts for populating tables via `INSERT` statements with mockup sample data and queries.

## Installation & Setup

1. **Install Dependencies**
   Ensure Node is installed. Open a terminal in the root folder and run:
   ```bash
   npm install
   ```

2. **Configure Database Credentials**
   If you change your MySQL password, you'll need to open `server.js` and modify the Database config block near the top:
   ```javascript
   const db = mysql.createConnection({
     host:     'localhost',
     user:     'root',
     password: 'YOUR_PASSWORD', // Update when needed
     database: 'brs_db'
   });
   ```
   *(Note: Remember to update `init_db.js` if you choose to use the initialization helper!)*

3. **Initialize the Database**
   You need to run the `.sql` scripts to create the tables and add sample data. You can either import them manually into a tool like MySQL Workbench, OR simply run the provided helper script:
   ```bash
   node init_db.js
   ```

## Running the Application

1. **Start the Backend Server**
   ```bash
   npm start
   ```
   *(Alternatively: `node server.js`)*
   This will kick off the application and open listening ports on `http://localhost:3000`.

2. **Open the Frontend**
   Directly double-click or drag the `brs_frontend.html` file into an open web browser. 
   When connected, you'll see a green "**MySQL Connected ✓**" status banner in the top right nav-bar. Navigate to the **Database Tab** to explore the data dynamically!
