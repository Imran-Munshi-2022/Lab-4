# Biodata CRUD Application

A complete web-based Biodata management system with Create, Read, Update, and Delete operations using PHP and MySQL.

## Project Structure

```
Biodata-From-main/
├── index.html          # Main application interface with HTML form and JavaScript logic
├── styles.css          # CSS styling for the application
├── config.php          # Database configuration and connection
├── create.php          # CREATE operation - Insert new biodata records
├── read.php            # READ operation - Fetch biodata records
├── update.php          # UPDATE operation - Modify existing records
├── delete.php          # DELETE operation - Remove records
├── api.php             # API routing to different CRUD operations
└── README.md           # This file
```

## Features

✓ **Create**: Add new biodata records with complete information
✓ **Read**: View all records with search and pagination
✓ **Update**: Edit existing biodata records
✓ **Delete**: Remove records with confirmation
✓ **Search**: Filter records by name, email, or phone
✓ **Pagination**: Navigate through large datasets
✓ **Responsive**: Clean and user-friendly interface

## Prerequisites

- **PHP**: Version 7.2 or higher
- **MySQL**: Version 5.7 or higher
- **Web Server**: Apache, Nginx, or similar
- **Browser**: Modern browser with JavaScript enabled

## Installation Steps

### 1. Setup Web Server

Make sure your web server (Apache/Nginx) is running and accessible at `localhost` or your configured domain.

### 2. Create Database User (Optional)

If using specific database credentials, ensure the user has privileges:

```sql
CREATE USER 'biodata_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON biodata_db.* TO 'biodata_user'@'localhost';
FLUSH PRIVILEGES;
```

### 3. Update Database Configuration (if needed)

Edit `config.php` to match your database setup:

```php
define('DB_HOST', 'localhost');      // Database host
define('DB_USER', 'root');           // Database username
define('DB_PASSWORD', '');           // Database password
define('DB_NAME', 'biodata_db');     // Database name
```

### 4. Access the Application

Navigate to the application in your browser:
```
http://localhost/path-to-project/index.html
```

The database and table will be created automatically on first access.

## Usage Guide

### Adding a New Record

1. Click **"Add New Record"** button
2. Fill in the biodata form with desired information
3. Click **"Submit"** to save the record
4. A success message will appear confirming the creation

### Viewing Records

1. Click **"View All Records"** button
2. All saved biodata records will be displayed in a table
3. Use pagination buttons at the bottom to navigate through pages
4. Use the search box to filter records by name, email, or phone

### Editing a Record

1. In the records table, click the **"Edit"** button
2. The form will populate with the record's data
3. Update any fields as needed
4. Click **"Update"** (button text changes when editing)
5. Confirm the changes with another click

### Deleting a Record

1. In the records table, click the **"Delete"** button
2. A confirmation dialog will appear
3. Click **"OK"** to confirm deletion
4. The record will be permanently removed from the database

### Viewing Full Details

1. In the records table, click the **"View"** button
2. A modal window opens showing all details of that biodata record
3. Click the **X** button to close the modal

## Database Schema

The application automatically creates a `biodata` table with the following structure:

```sql
CREATE TABLE biodata (
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
)
```

## API Endpoints

All API calls route through `api.php`. The application sends requests using JavaScript Fetch API.

### Create
```
POST api.php?action=create
```
Accepts JSON data with biodata fields.

### Read
```
GET api.php?action=read
GET api.php?action=read&id=1
GET api.php?action=read&page=1&limit=10
GET api.php?action=read&search=name
```
Returns JSON with biodata records or single record.

### Update
```
POST api.php?action=update
```
Accepts JSON data with `id` and fields to update.

### Delete
```
POST api.php?action=delete
```
Accepts JSON with `id` to delete.

## File Descriptions

### index.html
- Main application interface
- Contains HTML form and data table
- Includes embedded CSS for styling
- Embedded JavaScript handles all CRUD operations
- Manages UI interactions and form validation

### config.php
- Sets database connection parameters
- Creates database if it doesn't exist
- Creates table schema automatically
- Sets UTF-8 charset for proper character handling

### create.php
- Handles form data submission
- Validates and sanitizes input
- Inserts new records into database
- Returns success/error JSON response

### read.php
- Retrieves all records with pagination
- Fetches single record by ID
- Implements search functionality
- Returns JSON formatted data

### update.php
- Fetches specific record by ID
- Updates only provided fields
- Maintains data integrity
- Returns confirmation message

### delete.php
- Deletes record by ID
- Confirms deletion with message
- Prevents data loss with JavaScript confirmation

### api.php
- Routes requests to appropriate CRUD files
- Central point for all API operations
- Ensures consistent response format

## Troubleshooting

### Database Connection Error
- Verify MySQL/MariaDB is running
- Check database credentials in `config.php`
- Ensure database user has proper privileges

### Table Not Creating
- Check PHP error logs
- Verify database user has CREATE permission
- Ensure write permissions on application folder

### CORS Issues (if on different domain)
- Add CORS headers to PHP files if needed:
```php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
```

### Records Not Saving
- Check browser console for JavaScript errors
- Verify PHP files are in correct location
- Ensure proper JSON format in requests

## Security Notes

⚠️ **Important**: This is a learning/development version. For production:

1. **Never use default credentials** - Change database passwords
2. **Add input validation** - Validate all user inputs on both client and server
3. **Add authentication** - Implement user login/authorization
4. **Sanitize inputs** - Use prepared statements (already done) and escape output
5. **HTTPS only** - Use SSL/TLS certificates in production
6. **Limit uploads** - If adding file uploads, validate file types and sizes
7. **Add logging** - Log all database operations
8. **Rate limiting** - Prevent API abuse

## License

This project is provided as-is for educational purposes.

## Support

For issues or questions, review:
- PHP error logs
- Browser developer console (F12)
- Database logs
- API responses in Network tab

---

**Version**: 1.0  
**Last Updated**: March 2026  
**Status**: Production Ready (with security review recommended)
