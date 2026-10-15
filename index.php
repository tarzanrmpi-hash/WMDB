<?php
// ==============================================================
// RAW Studio - Offline XAMPP Entry Point
// Akses: http://172.16.2.23/watermarkdb atau http://localhost/watermarkdb
// ==============================================================

if (file_exists(__DIR__ . '/index.html')) {
    include_once __DIR__ . '/index.html';
} else {
    echo "<h1>RAW Studio</h1><p>index.html tidak ditemukan. Pastikan file diekstrak lengkap.</p>";
}
