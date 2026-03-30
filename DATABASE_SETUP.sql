-- BIODATA CRUD - DATABASE SETUP REFERENCE
-- Created: March 2026
-- This file contains SQL commands for manual database setup (optional)
-- Note: config.php auto-creates the database and table on first access

-- ============================================================
-- CREATE DATABASE
-- ============================================================
CREATE DATABASE IF NOT EXISTS biodata_db;
USE biodata_db;

-- ============================================================
-- CREATE BIODATA TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS biodata (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- CREATE DATABASE USER (Optional - for security)
-- ============================================================
-- If you want to create a specific user instead of using root:
CREATE USER IF NOT EXISTS 'biodata_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON biodata_db.* TO 'biodata_user'@'localhost';
FLUSH PRIVILEGES;

-- ============================================================
-- SAMPLE INSERT STATEMENTS (for testing)
-- ============================================================
INSERT INTO biodata (
    name, gender, birthdate, birthTime, birthPlace, religion, country,
    height, bloodGroup, email, phone, education, profession,
    fatherName, motherName, address
) VALUES (
    'John Doe', 'Male', '1990-05-15', '09:30:00', 'New York', 'Christianity', 'USA',
    '5 ft 10 in', 'A+', 'john@example.com', '1234567890', 'Bachelor of Science', 'Software Engineer',
    'James Doe', 'Jane Doe', '123 Main Street, New York, USA'
);

INSERT INTO biodata (
    name, gender, birthdate, birthTime, birthPlace, religion, country,
    height, bloodGroup, email, phone, education, profession,
    fatherName, motherName, address
) VALUES (
    'Aisha Khan', 'Female', '1992-08-22', '14:15:00', 'Dhaka', 'Islam', 'Bangladesh',
    '5 ft 5 in', 'B+', 'aisha@example.com', '9876543210', 'Bachelor of Commerce', 'Business Analyst',
    'Ali Khan', 'Fatima Khan', '456 Oak Avenue, Dhaka, Bangladesh'
);

-- ============================================================
-- USEFUL QUERIES FOR MAINTENANCE
-- ============================================================

-- View all records
SELECT * FROM biodata;

-- Count total records
SELECT COUNT(*) as total_records FROM biodata;

-- View records by gender
SELECT * FROM biodata WHERE gender = 'Male';
SELECT * FROM biodata WHERE gender = 'Female';

-- View records by religion
SELECT * FROM biodata WHERE religion = 'Islam';

-- Search by name (contains)
SELECT * FROM biodata WHERE name LIKE '%John%';

-- View records created in last 30 days
SELECT * FROM biodata WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY);

-- View most recently updated records
SELECT * FROM biodata ORDER BY updated_at DESC LIMIT 10;

-- Count records by blood group
SELECT bloodGroup, COUNT(*) as count FROM biodata GROUP BY bloodGroup;

-- Count records by country
SELECT country, COUNT(*) as count FROM biodata GROUP BY country ORDER BY count DESC;

-- View records with NULL emails
SELECT * FROM biodata WHERE email IS NULL OR email = '';

-- Get average age (requires birthdate calculation)
SELECT AVG(YEAR(NOW()) - YEAR(birthdate)) as average_age FROM biodata;

-- ============================================================
-- DATABASE MAINTENANCE QUERIES
-- ============================================================

-- Backup table structure
CREATE TABLE biodata_backup LIKE biodata;

-- Backup data
INSERT INTO biodata_backup SELECT * FROM biodata;

-- Delete all records (use with caution!)
-- DELETE FROM biodata;

-- Delete records older than 1 year
-- DELETE FROM biodata WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- Update a specific record
UPDATE biodata SET 
    email = 'newemail@example.com',
    phone = '1111111111'
WHERE id = 1;

-- Add new column (if needed)
ALTER TABLE biodata ADD COLUMN marital_status VARCHAR(50) AFTER gender;

-- Drop column (if needed)
ALTER TABLE biodata DROP COLUMN marital_status;

-- ============================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================

-- Indexes are already created in the table definition above
-- Additional indexes if needed:

-- Create index on email for faster searches
CREATE INDEX IF NOT EXISTS idx_email ON biodata(email);

-- Create index on phone for faster searches
CREATE INDEX IF NOT EXISTS idx_phone ON biodata(phone);

-- Create index on created_at for chronological sorting
CREATE INDEX IF NOT EXISTS idx_created_at ON biodata(created_at);

-- ============================================================
-- VIEWS (Optional - for common queries)
-- ============================================================

-- Create a view for recent records
CREATE OR REPLACE VIEW recent_biodata AS
SELECT * FROM biodata 
ORDER BY created_at DESC 
LIMIT 50;

-- Create a view for statistics
CREATE OR REPLACE VIEW biodata_statistics AS
SELECT 
    COUNT(*) as total_records,
    COUNT(CASE WHEN gender = 'Male' THEN 1 END) as male_count,
    COUNT(CASE WHEN gender = 'Female' THEN 1 END) as female_count,
    COUNT(DISTINCT country) as countries,
    COUNT(DISTINCT religion) as religions
FROM biodata;

-- ============================================================
-- TRIGGERS (Optional - for audit logging)
-- ============================================================

-- Create audit table
CREATE TABLE IF NOT EXISTS biodata_audit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    biodata_id INT,
    action VARCHAR(20),
    old_data JSON,
    new_data JSON,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger for insert audit
DELIMITER //
CREATE TRIGGER biodata_insert_audit
AFTER INSERT ON biodata
FOR EACH ROW
BEGIN
    INSERT INTO biodata_audit (biodata_id, action, new_data)
    VALUES (NEW.id, 'INSERT', JSON_OBJECT('name', NEW.name, 'email', NEW.email));
END //
DELIMITER ;

-- Trigger for update audit
DELIMITER //
CREATE TRIGGER biodata_update_audit
AFTER UPDATE ON biodata
FOR EACH ROW
BEGIN
    INSERT INTO biodata_audit (biodata_id, action, old_data, new_data)
    VALUES (NEW.id, 'UPDATE', 
            JSON_OBJECT('name', OLD.name, 'email', OLD.email),
            JSON_OBJECT('name', NEW.name, 'email', NEW.email));
END //
DELIMITER ;

-- ============================================================
-- USER PERMISSIONS (for production)
-- ============================================================

-- Create user with only SELECT, INSERT, UPDATE, DELETE (no DROP/CREATE)
CREATE USER IF NOT EXISTS 'biodata_app'@'localhost' IDENTIFIED BY 'app_password_123';
GRANT SELECT, INSERT, UPDATE, DELETE ON biodata_db.* TO 'biodata_app'@'localhost';
FLUSH PRIVILEGES;

-- Create read-only user
CREATE USER IF NOT EXISTS 'biodata_reader'@'localhost' IDENTIFIED BY 'reader_password_123';
GRANT SELECT ON biodata_db.* TO 'biodata_reader'@'localhost';
FLUSH PRIVILEGES;

-- ============================================================
-- NOTES FOR DEVELOPERS
-- ============================================================
/*
1. The biodata application auto-creates the database and table
2. Manual setup with this SQL is optional
3. Ensure MySQL/MariaDB version 5.7 or higher
4. UTF-8 encoding is used for international character support
5. Indexes are created for frequently searched fields
6. Timestamps auto-update for data tracking
7. No foreign keys in basic setup (keep it simple)
8. For production, implement proper backup strategy
9. For audit requirements, uncomment trigger creation
10. Regular backups recommended: mysqldump -u root -p biodata_db > backup.sql
*/

-- ============================================================
-- RESTORE FROM BACKUP
-- ============================================================
-- mysql -u root -p biodata_db < backup.sql

-- ============================================================
-- DATABASE CHARSET AND COLLATION
-- ============================================================
-- Current: utf8mb4 COLLATE utf8mb4_unicode_ci
-- This supports all Unicode characters including emojis
-- Recommended for international applications

-- ============================================================
-- EXPORT DATA
-- ============================================================
-- SELECT * FROM biodata
-- INTO OUTFILE '/var/lib/mysql/biodata_export.csv'
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n';

-- ============================================================
-- END OF DATABASE SETUP
-- ============================================================
