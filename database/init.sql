-- Création de la base de données
CREATE DATABASE IF NOT EXISTS yourcaryourway_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE yourcaryourway_db;

-- Table des utilisateurs
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    status ENUM('pending', 'active', 'suspended') DEFAULT 'pending',
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    last_login DATETIME(6),
    preferred_language VARCHAR(5) DEFAULT 'fr',
    preferred_currency VARCHAR(3) DEFAULT 'EUR',
    INDEX idx_user_status (status),
    INDEX idx_user_email (email)
) ENGINE=InnoDB;

-- Table des profils utilisateurs
CREATE TABLE user_profiles (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    phone_number VARCHAR(20),
    address JSON,
    driver_license_number VARCHAR(50),
    license_upload_id CHAR(36),
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_profile_user (user_id)
) ENGINE=InnoDB;

-- Table des agences
CREATE TABLE agencies (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(200) NOT NULL,
    country_code VARCHAR(2) NOT NULL,
    address JSON NOT NULL,
    gps_coordinates POINT SRID 4326,
    opening_hours JSON,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(20),
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    INDEX idx_agency_country (country_code),
    SPATIAL INDEX idx_agency_coordinates (gps_coordinates)
) ENGINE=InnoDB;

-- Table des catégories de véhicules (norme ACRISS)
CREATE TABLE vehicle_categories (
    code VARCHAR(4) PRIMARY KEY,
    description VARCHAR(200) NOT NULL,
    vehicle_type VARCHAR(50),
    transmission_type ENUM('manual', 'automatic'),
    fuel_type ENUM('petrol', 'diesel', 'electric', 'hybrid'),
    air_conditioning BOOLEAN DEFAULT FALSE,
    bag_capacity INTEGER,
    passenger_capacity INTEGER,
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6)
) ENGINE=InnoDB;

-- Table des véhicules
CREATE TABLE vehicles (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    agency_id CHAR(36) NOT NULL,
    category_code VARCHAR(4) NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INTEGER,
    features JSON,
    daily_rate DECIMAL(10,2) NOT NULL,
    status ENUM('available', 'rented', 'maintenance', 'unavailable') DEFAULT 'available',
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    FOREIGN KEY (agency_id) REFERENCES agencies(id),
    FOREIGN KEY (category_code) REFERENCES vehicle_categories(code),
    INDEX idx_vehicle_agency (agency_id),
    INDEX idx_vehicle_category (category_code),
    INDEX idx_vehicle_status (status)
) ENGINE=InnoDB;

-- Table des réservations
CREATE TABLE reservations (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL,
    vehicle_id CHAR(36) NOT NULL,
    pickup_agency_id CHAR(36) NOT NULL,
    return_agency_id CHAR(36) NOT NULL,
    start_date DATETIME(6) NOT NULL,
    end_date DATETIME(6) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'EUR',
    status ENUM('confirmed', 'pending', 'cancelled', 'completed') DEFAULT 'confirmed',
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (pickup_agency_id) REFERENCES agencies(id),
    FOREIGN KEY (return_agency_id) REFERENCES agencies(id),
    INDEX idx_reservation_user (user_id),
    INDEX idx_reservation_dates (start_date, end_date),
    INDEX idx_reservation_status (status)
) ENGINE=InnoDB;

-- Table des paiements
CREATE TABLE payments (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    reservation_id CHAR(36) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'EUR',
    status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    stripe_payment_id VARCHAR(255),
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
    INDEX idx_payment_reservation (reservation_id),
    INDEX idx_payment_status (status)
) ENGINE=InnoDB;

-- Table des messages de chat (pour le service client)
CREATE TABLE chat_messages (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    conversation_id VARCHAR(100) NOT NULL,
    sender_id CHAR(36), -- Peut être NULL pour les messages système
    sender_type ENUM('customer', 'agent', 'system') NOT NULL,
    content TEXT NOT NULL,
    timestamp DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    read_status BOOLEAN DEFAULT FALSE,
    INDEX idx_chat_conversation (conversation_id),
    INDEX idx_chat_timestamp (timestamp),
    INDEX idx_chat_sender (sender_id)
) ENGINE=InnoDB;

-- Table des conversations de chat
CREATE TABLE chat_conversations (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id CHAR(36) NOT NULL,
    agent_id CHAR(36), -- NULL si pas encore assigné
    status ENUM('open', 'closed', 'pending') DEFAULT 'open',
    subject VARCHAR(200),
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    closed_at DATETIME(6),
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_conversation_user (user_id),
    INDEX idx_conversation_status (status)
) ENGINE=InnoDB;

-- Insertion des données de base

-- Catégories de véhicules ACRISS
INSERT INTO vehicle_categories (code, description, vehicle_type, transmission_type, fuel_type, air_conditioning, bag_capacity, passenger_capacity) VALUES
('ECAR', 'Economy 2/4 Door', 'Economy', 'manual', 'petrol', TRUE, 2, 4),
('CDAR', 'Compact 2/4 Door', 'Compact', 'manual', 'petrol', TRUE, 2, 5),
('IDAR', 'Intermediate 2/4 Door', 'Intermediate', 'automatic', 'petrol', TRUE, 3, 5),
('SDAR', 'Standard 2/4 Door', 'Standard', 'automatic', 'petrol', TRUE, 3, 5),
('FDAR', 'Fullsize 2/4 Door', 'Fullsize', 'automatic', 'petrol', TRUE, 4, 5);

-- Agences exemple
INSERT INTO agencies (id, name, country_code, address, contact_email, contact_phone) VALUES
(UUID(), 'Paris Centre', 'FR', '{"street": "12 Rue de Rivoli", "city": "Paris", "postalCode": "75001", "country": "France"}', 'paris@yourcaryourway.com', '+33123456789'),
(UUID(), 'Lyon Part-Dieu', 'FR', '{"street": "5 Rue de la République", "city": "Lyon", "postalCode": "69003", "country": "France"}', 'lyon@yourcaryourway.com', '+33456789012'),
(UUID(), 'London Heathrow', 'UK', '{"street": "Heathrow Airport", "city": "London", "postalCode": "TW6", "country": "United Kingdom"}', 'london@yourcaryourway.com', '+442012345678');

-- Véhicules exemple
INSERT INTO vehicles (id, agency_id, category_code, make, model, year, features, daily_rate) VALUES
(UUID(), (SELECT id FROM agencies WHERE name = 'Paris Centre' LIMIT 1), 'ECAR', 'Renault', 'Clio', 2023, '{"airbag": 6, "gps": true, "bluetooth": true}', 45.00),
(UUID(), (SELECT id FROM agencies WHERE name = 'Paris Centre' LIMIT 1), 'CDAR', 'Peugeot', '208', 2023, '{"airbag": 6, "gps": true, "bluetooth": true, "cruiseControl": true}', 55.00),
(UUID(), (SELECT id FROM agencies WHERE name = 'Lyon Part-Dieu' LIMIT 1), 'IDAR', 'Volkswagen', 'Golf', 2023, '{"airbag": 8, "gps": true, "bluetooth": true, "cruiseControl": true, "parkingSensors": true}', 65.00);

-- Utilisateur de test
INSERT INTO users (id, email, password_hash, status, preferred_language, preferred_currency) VALUES
(UUID(), 'client@test.com', '$2a$10$exampleHash', 'active', 'fr', 'EUR');

-- Message de chat exemple
INSERT INTO chat_messages (conversation_id, sender_type, content) VALUES
('conv_demo', 'system', 'Bienvenue sur le service client de Your Car Your Way! Comment pouvons-nous vous aider?');

-- Affichage des informations de la base créée
SELECT 'Database yourcaryourway_db created successfully!' as Status;
SELECT COUNT(*) as 'Number of vehicle categories' FROM vehicle_categories;
SELECT COUNT(*) as 'Number of agencies' FROM agencies;
SELECT COUNT(*) as 'Number of vehicles' FROM vehicles;