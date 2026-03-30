<?php
header('Content-Type: application/json');
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $id = isset($_GET['id']) ? $_GET['id'] : null;
    
    if ($id) {
        // Get single record
        $stmt = $conn->prepare("SELECT * FROM biodata WHERE id = ?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            echo json_encode([
                'status' => 'success',
                'data' => $row
            ]);
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'Record not found'
            ]);
        }
        $stmt->close();
    } else {
        // Get all records
        $search = isset($_GET['search']) ? $_GET['search'] : '';
        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 10;
        $offset = ($page - 1) * $limit;
        
        // Build query
        $where = '';
        if (!empty($search)) {
            $search = '%' . $conn->real_escape_string($search) . '%';
            $where = "WHERE name LIKE '$search' OR email LIKE '$search' OR phone LIKE '$search'";
        }
        
        $sql = "SELECT * FROM biodata $where ORDER BY created_at DESC LIMIT $limit OFFSET $offset";
        $result = $conn->query($sql);
        
        // Get total count
        $count_sql = "SELECT COUNT(*) as total FROM biodata $where";
        $count_result = $conn->query($count_sql);
        $count_row = $count_result->fetch_assoc();
        
        $data = [];
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $data[] = $row;
            }
        }
        
        echo json_encode([
            'status' => 'success',
            'data' => $data,
            'total' => $count_row['total'],
            'page' => $page,
            'limit' => $limit
        ]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

$conn->close();
?>
