# Cloud SQL Database Setup Script for GCP
# This SQL script sets up the Cloud SQL instance for the Asset Management System

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS asset_management;
USE asset_management;

-- Create application user
CREATE USER IF NOT EXISTS 'app-user'@'%' IDENTIFIED BY 'your-secure-password';
GRANT ALL PRIVILEGES ON asset_management.* TO 'app-user'@'%';
FLUSH PRIVILEGES;

-- Create tables (same as local database.sql)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role ENUM('admin', 'manager', 'employee') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    quantity INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    reason TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    approved_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP NULL,
    returned BOOLEAN DEFAULT FALSE,
    returned_at TIMESTAMP NULL,
    FOREIGN KEY (employee_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (approved_by) REFERENCES users(id)
);

-- Insert default users (with hashed passwords)
INSERT INTO users (username, password, name, role) VALUES
('admin', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'admin'),
('manager1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John Manager', 'manager'),
('employee1', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jane Employee', 'employee')
ON DUPLICATE KEY UPDATE username=username;

-- Insert sample products
INSERT INTO products (name, description, quantity) VALUES
('Laptop', 'Dell Inspiron 15 3000', 10),
('Mouse', 'Wireless optical mouse', 25),
('Keyboard', 'USB keyboard', 20),
('Monitor', '24 inch LED monitor', 8),
('Printer', 'HP LaserJet printer', 3)
ON DUPLICATE KEY UPDATE name=name;
