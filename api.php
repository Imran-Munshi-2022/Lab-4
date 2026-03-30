<?php
header('Content-Type: application/json');
require_once 'config.php';

$action = isset($_GET['action']) ? $_GET['action'] : '';

switch ($action) {
    case 'create':
        include 'create.php';
        break;
    case 'read':
        include 'read.php';
        break;
    case 'update':
        include 'update.php';
        break;
    case 'delete':
        include 'delete.php';
        break;
    default:
        echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
}
?>
