const fs = require('fs');
const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'Utk@rsh17',
  multipleStatements: true
});

connection.connect(err => {
  if (err) throw err;
  console.log('Connected to MySQL server.');

  const schemaSql = fs.readFileSync('schema_codes/brs_schema.sql', 'utf8');
  const dataSql = fs.readFileSync('sql_codes/brs_data.sql', 'utf8');

  connection.query(schemaSql, (err) => {
    if (err) throw err;
    console.log('Schema created successfully.');
    
    connection.query(dataSql, (err) => {
      if (err) throw err;
      console.log('Data populated successfully.');
      connection.end();
    });
  });
});
