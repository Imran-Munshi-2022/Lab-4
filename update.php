<?php
header('Content-Type: application/json');
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    
    if (!isset($data['id'])) {
        echo json_encode(['status' => 'error', 'message' => 'ID is required']);
        exit;
    }
    
    $id = $data['id'];
    $updates = [];
    $values = [];
    
    $allowed_fields = ['name', 'gender', 'birthdate', 'birthTime', 'birthPlace', 'religion', 
                      'country', 'height', 'bloodGroup', 'fatherName', 'motherName', 
                      'email', 'phone', 'address', 'education', 'profession'];
    
    foreach ($allowed_fields as $field) {
        if (isset($data[$field])) {
            $updates[] = "$field = ?";
            $values[] = $data[$field];
        }
    }
    
    if (empty($updates)) {
        echo json_encode(['status' => 'error', 'message' => 'No data to update']);
        exit;
    }
    
    $values[] = $id;
    $update_list = implode(', ', $updates);
    $sql = "UPDATE biodata SET $update_list WHERE id = ?";
    
    $stmt = $conn->prepare($sql);
    
    if (!$stmt) {
        echo json_encode(['status' => 'error', 'message' => 'Prepare failed: ' . $conn->error]);
        exit;
    }
    
    // Build type string
    $types = '';
    foreach ($values as $value) {
        if (is_int($value)) {
            $types .= 'i';
        } elseif (is_float($value)) {
            $types .= 'd';
        } else {
            $types .= 's';
        }
    }
    
    $stmt->bind_param($types, ...$values);
    
    if ($stmt->execute()) {
        if ($stmt->affected_rows > 0) {
            echo json_encode([
                'status' => 'success',
                'message' => 'Biodata updated successfully'
            ]);
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'No changes made or record not found'
            ]);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error: ' . $stmt->error]);
    }
    
    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

$conn->close();
?>
