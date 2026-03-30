<?php
// Database Configuration
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASSWORD', '');
define('DB_NAME', 'biodata_db');

// Create connection
$conn = new mysqli(DB_HOST, DB_USER, DB_PASSWORD);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

// Create database if not exists
$sql = "CREATE DATABASE IF NOT EXISTS " . DB_NAME;
$conn->query($sql);

// Select database
$conn->select_db(DB_NAME);

// Create table if not exists
$table_sql = "CREATE TABLE IF NOT EXISTS biodata (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    gender VARCHAR(20),
    birthdate DATE,
    birthTime TIME,
    birthPlace VARCHAR(100),
    religion VARCHAR(50),
    country VARCHAR(100),
    height VARCHAR(50),
    bloodGroup VARCHAR(10),
    fatherName VARCHAR(100),
    motherName VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    education VARCHAR(200),
    profession VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)";

$conn->query($table_sql);

// Set charset to utf8
$conn->set_charset("utf8");

?>
