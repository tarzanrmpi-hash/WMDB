-- ==============================================================
-- DATABASE: `watermarkdb`
-- Untuk Server Lokal XAMPP (Apache + MySQL / MariaDB)
-- Host: localhost / 172.16.2.23
-- Akses URL: http://172.16.2.23/watermarkdb atau http://localhost/watermarkdb
-- ==============================================================

CREATE DATABASE IF NOT EXISTS `watermarkdb` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `watermarkdb`;

-- --------------------------------------------------------
-- 1. Tabel `watermark_presets`
-- Menyimpan template watermark teks dan logo
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `watermark_presets` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `type` ENUM('text', 'logo') DEFAULT 'text',
  `text_content` VARCHAR(255) DEFAULT '© TARZAN PHOTOGRAPHY',
  `font_family` VARCHAR(100) DEFAULT 'Plus Jakarta Sans',
  `font_size` INT DEFAULT 34,
  `color` VARCHAR(30) DEFAULT '#FFFFFF',
  `opacity` INT DEFAULT 85,
  `pos_x_percent` DECIMAL(5,2) DEFAULT 86.00,
  `pos_y_percent` DECIMAL(5,2) DEFAULT 88.00,
  `has_shadow` TINYINT(1) DEFAULT 1,
  `has_stroke` TINYINT(1) DEFAULT 1,
  `is_tiled` TINYINT(1) DEFAULT 0,
  `rotation` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 2. Tabel `batch_sessions`
-- Menyimpan sesi proses batch konversi RAW
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `batch_sessions` (
  `id` VARCHAR(64) PRIMARY KEY,
  `total_files` INT NOT NULL DEFAULT 0,
  `processed_files` INT NOT NULL DEFAULT 0,
  `target_resolution` VARCHAR(30) DEFAULT '1024x800',
  `auto_adjust_enabled` TINYINT(1) DEFAULT 1,
  `status` ENUM('pending', 'processing', 'completed', 'failed') DEFAULT 'completed',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 3. Tabel `photo_records`
-- Catatan histori setiap foto RAW yang dikonversi
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `photo_records` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `batch_id` VARCHAR(64) NULL,
  `original_name` VARCHAR(255) NOT NULL,
  `camera_raw_format` VARCHAR(20) NOT NULL COMMENT 'CR3, CR2, ARW, NEF, DNG, etc',
  `original_file_size` BIGINT NOT NULL,
  `output_resolution` VARCHAR(30) DEFAULT '1024x800',
  `rotation_applied` INT DEFAULT 0,
  `detected_luma` INT DEFAULT NULL,
  `adjustments_summary` VARCHAR(255) DEFAULT NULL,
  `output_filename` VARCHAR(255) NOT NULL,
  `processed_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_batch` (`batch_id`),
  INDEX `idx_format` (`camera_raw_format`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- 4. Tabel `app_settings`
-- Pengaturan global aplikasi offline
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `app_settings` (
  `setting_key` VARCHAR(50) PRIMARY KEY,
  `setting_value` TEXT NOT NULL,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================================================
-- DATA AWAL / PRESET DEFAULT
-- ==============================================================
INSERT INTO `watermark_presets` (`name`, `type`, `text_content`, `font_family`, `font_size`, `color`, `opacity`, `pos_x_percent`, `pos_y_percent`)
VALUES 
('Tarzan Photography Default', 'text', '© TARZAN PHOTOGRAPHY', 'Plus Jakarta Sans', 34, '#FFFFFF', 85, 86.00, 88.00),
('Sudut Kiri Bawah', 'text', 'TARZAN STUDIO RAW 1024x800', 'Montserrat', 28, '#FFFFFF', 80, 14.00, 88.00),
('Tengah Subtle', 'text', 'PREVIEW ONLY - TARZAN', 'Outfit', 40, '#FFFFFF', 40, 50.00, 50.00)
ON DUPLICATE KEY UPDATE `name`=`name`;

INSERT INTO `app_settings` (`setting_key`, `setting_value`) VALUES
('app_title', 'RAW Studio XAMPP Offline'),
('default_target_width', '1024'),
('default_target_height', '800'),
('default_quality', '92'),
('auto_adjust_intensity', '80'),
('offline_mode', 'true'),
('xampp_lan_ip', '172.16.2.23')
ON DUPLICATE KEY UPDATE `setting_value`=`setting_value`;
