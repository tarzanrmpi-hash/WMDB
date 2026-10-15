<?php
// ==============================================================
// API BACKEND XAMPP - WATERMARKDB
// Endpoint untuk cek status database dan simpan log proses foto
// ==============================================================

require_once __DIR__ . '/db.php';

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

$action = isset($_GET['action']) ? $_GET['action'] : 'status';

if ($action === 'status') {
    if ($pdo) {
        // Cek jumlah data
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM watermark_presets");
        $presetsCount = $stmt->fetch()['count'] ?? 0;
        
        $stmtPhotos = $pdo->query("SELECT COUNT(*) as count FROM photo_records");
        $photosCount = $stmtPhotos->fetch()['count'] ?? 0;

        echo json_encode([
            'status' => 'connected',
            'database' => 'watermarkdb',
            'server' => $_SERVER['SERVER_ADDR'] ?? '172.16.2.23',
            'presets_count' => (int)$presetsCount,
            'photos_logged' => (int)$photosCount,
            'message' => 'Database MySQL XAMPP terhubung dengan sukses!'
        ]);
    } else {
        echo json_encode([
            'status' => 'not_connected',
            'database' => 'watermarkdb',
            'message' => 'MySQL belum aktif atau database watermarkdb belum diimpor.',
            'error' => $dbError ?? 'Unknown error'
        ]);
    }
    exit;
}

if ($action === 'log_photo' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    if (!$pdo) {
        echo json_encode(['success' => false, 'message' => 'Database not connected']);
        exit;
    }

    try {
        $stmt = $pdo->prepare("INSERT INTO photo_records 
            (batch_id, original_name, camera_raw_format, original_file_size, output_resolution, rotation_applied, detected_luma, adjustments_summary, output_filename)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        
        $stmt->execute([
            $input['batch_id'] ?? uniqid('batch_'),
            $input['original_name'] ?? 'unknown.raw',
            $input['camera_raw_format'] ?? 'RAW',
            $input['original_file_size'] ?? 0,
            $input['output_resolution'] ?? '1024x800',
            $input['rotation_applied'] ?? 0,
            $input['detected_luma'] ?? null,
            $input['adjustments_summary'] ?? '',
            $input['output_filename'] ?? 'output.jpg'
        ]);

        echo json_encode(['success' => true, 'id' => $pdo->lastInsertId()]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
    exit;
}

if ($action === 'presets') {
    if (!$pdo) {
        echo json_encode(['success' => false, 'presets' => []]);
        exit;
    }
    $stmt = $pdo->query("SELECT * FROM watermark_presets ORDER BY id ASC");
    echo json_encode(['success' => true, 'presets' => $stmt->fetchAll()]);
    exit;
}

echo json_encode(['error' => 'Invalid action']);
