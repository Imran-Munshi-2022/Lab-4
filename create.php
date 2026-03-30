<?php
header('Content-Type: application/json');
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    
    // Prepare arrays
    $fields = [];
    $values = [];
    $placeholders = [];
    
    // Collect non-empty fields
    $allowed_fields = ['name', 'gender', 'birthdate', 'birthTime', 'birthPlace', 'religion', 
                      'country', 'height', 'bloodGroup', 'fatherName', 'motherName', 
                      'email', 'phone', 'address', 'education', 'profession'];
    
    foreach ($allowed_fields as $field) {
        if (isset($data[$field]) && !empty($data[$field])) {
            $fields[] = $field;
            $values[] = $data[$field];
            $placeholders[] = '?';
        }
    }
    
    if (empty($fields)) {
        echo json_encode(['status' => 'error', 'message' => 'No data provided']);
        exit;
    }
    
    // Build INSERT query
    $field_list = implode(', ', $fields);
    $placeholder_list = implode(', ', $placeholders);
    $sql = "INSERT INTO biodata ($field_list) VALUES ($placeholder_list)";
    
    // Prepare statement
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
    
    // Bind parameters
    $stmt->bind_param($types, ...$values);
    
    // Execute
    if ($stmt->execute()) {
        echo json_encode([
            'status' => 'success', 
            'message' => 'Biodata created successfully',
            'id' => $stmt->insert_id
        ]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error: ' . $stmt->error]);
    }
    
    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

$conn->close();
?>
