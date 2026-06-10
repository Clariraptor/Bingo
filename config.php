<?php
// Database Configuration - PostgreSQL
define('DB_HOST', 'localhost');
define('DB_PORT', '5432');
define('DB_NAME', 'bingo_db');
define('DB_USER', 'postgres');
define('DB_PASS', 'tu_password');

// Create connection
function getDBConnection() {
    $conn_string = "host=" . DB_HOST . " port=" . DB_PORT . " dbname=" . DB_NAME . " user=" . DB_USER . " password=" . DB_PASS;
    $conn = pg_connect($conn_string);
    
    if (!$conn) {
        die(json_encode(['error' => 'Connection failed']));
    }
    
    return $conn;
}

// Helper function to return JSON response
function jsonResponse($data, $status = 200) {
    http_response_code($status);
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}

// Helper to sanitize input
function sanitize($input) {
    return pg_escape_string($input);
}
