CREATE SCHEMA `repairshop`;
USE `repairshop`;

CREATE TABLE Task_Catalogue (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    task_name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,  
    estimated_time DATETIME NOT NULL, 
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0), 
    priority ENUM('Low', 'Medium', 'High') NOT NULL DEFAULT 'Medium'
);  

CREATE TABLE Technician (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    technician_name VARCHAR(255) NOT NULL,  
    phone_number VARCHAR(15) NOT NULL, 
    rating INT NOT NULL CHECK (rating >= 0 AND rating <= 10), 
    professional_experience_months INT NOT NULL CHECK (professional_experience_months >= 0), 
    specialization VARCHAR(255)  
);  

CREATE TABLE Customer (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    name VARCHAR(255) NOT NULL,  
    address VARCHAR(255) NOT NULL,  
    phone_number VARCHAR(15) NOT NULL,  
    last_visit DATETIME DEFAULT NULL
);

CREATE TABLE Vehicle (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    customer_id INT NOT NULL,  
    color VARCHAR(20) NOT NULL,  
    engine VARCHAR(10) NOT NULL,  
    mileage INT NOT NULL CHECK(mileage > -1),  
    model VARCHAR(50) NOT NULL,  
    production_year INT NOT NULL CHECK (production_year >= 1970),  
    plate VARCHAR(50) NOT NULL UNIQUE,  
    FOREIGN KEY (customer_id) REFERENCES Customer(id) ON DELETE CASCADE
);  

CREATE TABLE Repair_Shop (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    name VARCHAR(100) NOT NULL,  
    address VARCHAR(255) NOT NULL,  
    phone_number VARCHAR(15) NOT NULL,  
    owner VARCHAR(50) NOT NULL,  
    website VARCHAR(100) DEFAULT NULL,  
    details TEXT DEFAULT NULL,
    rating INT NOT NULL CHECK (rating >= 0 AND rating <= 10), 
    working_time VARCHAR(100) DEFAULT NULL
);  

CREATE TABLE Service_Catalogue (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    name VARCHAR(100) NOT NULL,  
    description TEXT DEFAULT NULL, 
    category VARCHAR(50) NOT NULL,  
    cost DECIMAL(10, 2) NOT NULL CHECK (cost >= 0)
);
  

CREATE TABLE Spare_Part (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    part_name VARCHAR(255) NOT NULL,  
    compatible_models VARCHAR(255) NOT NULL,
    description TEXT DEFAULT NULL, 
    category VARCHAR(50) NOT NULL,  
    cost DECIMAL(10, 2) NOT NULL CHECK (cost >= 0)
);  

CREATE TABLE Invoice (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    customer_id INT NOT NULL,
    date_time DATETIME NOT NULL,  
    discount DECIMAL(5, 2) DEFAULT 0.00 CHECK (discount >= 0), 
    payment_status ENUM('Pending', 'Paid', 'Cancelled', 'Refunded') DEFAULT 'Pending',
    total_price DECIMAL(10, 2) NOT NULL CHECK (total_price >= 0),
    FOREIGN KEY (customer_id) REFERENCES Customer(id) ON DELETE CASCADE
);


CREATE TABLE Schedule (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    schedule_date DATETIME NOT NULL,
    technician_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    task_id INT NOT NULL,
    FOREIGN KEY (technician_id) REFERENCES Technician(id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id) ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES Task_Catalogue(id) ON DELETE CASCADE
);  

-- Middle tables  

CREATE TABLE Technician_Tasks (  
    technician_id INT NOT NULL,  
    task_catalogue_id INT NOT NULL,  
    fee DECIMAL(10, 2) CHECK (fee >= 0) DEFAULT 0.00,
    PRIMARY KEY (technician_id, task_catalogue_id),  
    FOREIGN KEY (technician_id) REFERENCES Technician(id) ON DELETE CASCADE,
    FOREIGN KEY (task_catalogue_id) REFERENCES Task_Catalogue(id) ON DELETE CASCADE  
);  

CREATE TABLE Technician_Shops (  
    technician_id INT NOT NULL,
    repair_shop_id INT NOT NULL, 
    when_hired DATE NOT NULL,  
    PRIMARY KEY (technician_id, repair_shop_id),  
    FOREIGN KEY (technician_id) REFERENCES Technician(id) ON DELETE CASCADE, 
    FOREIGN KEY (repair_shop_id) REFERENCES Repair_Shop(id) ON DELETE CASCADE
);  

CREATE TABLE Repair_Shop_Tasks (  
    repair_shop_id INT NOT NULL,  
    task_catalogue_id INT  NOT NULL, 
    PRIMARY KEY (repair_shop_id, task_catalogue_id),  
    FOREIGN KEY (repair_shop_id) REFERENCES Repair_Shop(id) ON DELETE CASCADE,
    FOREIGN KEY (task_catalogue_id) REFERENCES Task_Catalogue(id) ON DELETE CASCADE
);  

CREATE TABLE Repair_Shop_Customers (  
    repair_shop_id INT NOT NULL,
    customer_id INT NOT NULL,
    join_date DATE NOT NULL, 
    PRIMARY KEY (repair_shop_id, customer_id),  
    FOREIGN KEY (repair_shop_id) REFERENCES Repair_Shop(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(id) ON DELETE CASCADE 
);  

CREATE TABLE Repair_Shop_Spare_Parts (  
    repair_shop_id INT NOT NULL,
    spare_part_id INT NOT NULL,
    inventory INT NOT NULL CHECK (inventory >= 0),
    PRIMARY KEY (repair_shop_id, spare_part_id),  
    FOREIGN KEY (repair_shop_id) REFERENCES Repair_Shop(id) ON DELETE CASCADE,  
    FOREIGN KEY (spare_part_id) REFERENCES Spare_Part(id) ON DELETE CASCADE  
);  

CREATE TABLE Vehicle_Spare_Parts (  
    vehicle_id INT NOT NULL,
    spare_part_id INT NOT NULL,
    count INT NOT NULL CHECK (count >= 0),
    PRIMARY KEY (vehicle_id, spare_part_id),  
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id) ON DELETE CASCADE, 
    FOREIGN KEY (spare_part_id) REFERENCES Spare_Part(id) ON DELETE CASCADE
);

CREATE TABLE Service_tasks (  
    service_id INT NOT NULL,
    task_id INT NOT NULL,
    PRIMARY KEY (service_id, task_id),  
    FOREIGN KEY (service_id) REFERENCES Service_Catalogue(id) ON DELETE CASCADE, 
    FOREIGN KEY (task_id) REFERENCES Task_Catalogue(id) ON DELETE CASCADE
);

CREATE TABLE log_table (
    id INT PRIMARY KEY AUTO_INCREMENT,              -- Auto-incrementing ID for each log entry
    log_time DATETIME NOT NULL,                     -- Timestamp when the log entry was created
    action VARCHAR(255) NOT NULL,                   -- Action performed (e.g., 'Add Schedule')
    details TEXT,                                   -- Additional details about the action
    created_by VARCHAR(255) DEFAULT NULL            -- Optional: Track the user/technician who performed the action
);