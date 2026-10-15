<?php
// ==============================================================
// KONEKSI DATABASE MYSQL XAMPP
// Database: watermarkdb
// ==============================================================

header('Content-Type: application/json; charset=utf-8');

$dbHost = '127.0.0.1';
$dbPort = '3306';
$dbName = 'watermarkdb';
$dbUser = 'root';
$dbPass = '';

try {
    $pdo = new PDO("mysql:host={$dbHost};port={$dbPort};dbname={$dbName};charset=utf8mb4", $dbUser, $dbPass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);
} catch (PDOException $e) {
    // Database belum diimport atau MySQL belum aktif di XAMPP
    $pdo = null;
    $dbError = $e->getMessage();
}
