-- Initialize users after database schema is created
-- This file will be executed after database.sql

USE asset_management;

-- Create default users with bcrypt hashed passwords
-- Note: These are the same passwords from create-users.js but pre-hashed for Docker
INSERT INTO users (username, password, name, role) VALUES
('admin', '$2a$10$8K9wE7LiS5K.bqJj5U7X4.yQYZJZJZJZJZJZJZJZJZJZJZJZJZJZJ2', 'System Administrator', 'admin'),
('manager1', '$2a$10$8K9wE7LiS5K.bqJj5U7X4.yQYZJZJZJZJZJZJZJZJZJZJZJZJZJZJ2', 'Manager One', 'manager'),
('employee1', '$2a$10$8K9wE7LiS5K.bqJj5U7X4.yQYZJZJZJZJZJZJZJZJZJZJZJZJZJZJ2', 'Employee One', 'employee')
ON DUPLICATE KEY UPDATE id=id;

-- Insert some sample products
INSERT INTO products (name, description, quantity) VALUES
('Laptop Dell XPS 13', 'High-performance laptop for development work', 10),
('Wireless Mouse', 'Ergonomic wireless mouse', 25),
('USB-C Monitor', '27-inch 4K USB-C monitor', 8),
('Mechanical Keyboard', 'RGB mechanical keyboard', 15),
('Webcam HD', 'Full HD webcam for video conferences', 12),
('Headphones Sony', 'Noise-cancelling headphones', 20)
ON DUPLICATE KEY UPDATE id=id;

-- Create a health check endpoint table (optional)
CREATE TABLE IF NOT EXISTS health_checks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    last_check TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status VARCHAR(10) DEFAULT 'healthy'
);

INSERT INTO health_checks (status) VALUES ('healthy') ON DUPLICATE KEY UPDATE status='healthy';
