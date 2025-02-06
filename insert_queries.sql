-- Insert into Task_Catalogue
INSERT INTO Task_Catalogue (task_name, description, estimated_time, price, priority) VALUES
('Engine Diagnosis', 'Diagnose engine issues', '2024-12-08 10:00:00', 100.00, 'High'),
('Oil Change', 'Replace engine oil', '2024-12-09 12:00:00', 50.00, 'Medium'),
('Tire Replacement', 'Replace all tires', '2024-12-10 14:00:00', 200.00, 'High'),
('Battery Check', 'Check battery status', '2024-12-11 09:00:00', 30.00, 'Low'),
('Brake Inspection', 'Inspect brake system', '2024-12-12 13:00:00', 70.00, 'Medium'),
('Suspension Repair', 'Repair suspension system', '2024-12-13 11:00:00', 150.00, 'High'),
('Air Conditioning', 'Fix AC issues', '2024-12-14 15:00:00', 120.00, 'Medium'),
('Paint Touch-Up', 'Touch up vehicle paint', '2024-12-15 16:00:00', 80.00, 'Low');

-- Insert into Technician
INSERT INTO Technician (technician_name, phone_number, rating, professional_experience_months, specialization) VALUES
('John Doe', '1234567890', 8, 60, 'Engine Specialist'),
('Jane Smith', '0987654321', 7, 48, 'Tire Specialist'),
('Alice Johnson', '1112223334', 9, 72, 'Battery Specialist'),
('Bob Brown', '5556667778', 6, 36, 'Brake Specialist'),
('Charlie White', '9998887776', 10, 96, 'AC Specialist'),
('Diana Gray', '2223334445', 7, 48, 'Paint Specialist'),
('Eve Black', '4445556667', 5, 24, 'General Repairs'),
('Frank Green', '8889990001', 8, 60, 'Suspension Specialist');

-- Insert into Customer
INSERT INTO Customer (name, address, phone_number, last_visit) VALUES
('Alice Blue', '123 Main St', '1234567890', '2024-12-01 10:00:00'),
('Bob Red', '456 Elm St', '0987654321', '2024-11-30 14:00:00'),
('Charlie Yellow', '789 Oak St', '1112223334', '2024-11-29 12:00:00'),
('Diana Green', '321 Pine St', '5556667778', '2024-12-01 16:00:00'),
('Eve Purple', '654 Maple St', '9998887776', '2024-11-28 09:00:00'),
('Frank White', '987 Birch St', '2223334445', '2024-11-30 13:00:00'),
('Grace Black', '741 Cedar St', '4445556667', '2024-12-02 11:00:00'),
('Hank Orange', '852 Spruce St', '8889990001', '2024-12-03 15:00:00');

-- Insert into Vehicle
INSERT INTO Vehicle (customer_id, color, engine, mileage, model, production_year, plate) VALUES
(1, 'Blue', 'V6', 50000, 'Toyota Camry', 2018, 'ABC123'),
(2, 'Red', 'V4', 40000, 'Honda Civic', 2020, 'DEF456'),
(3, 'Yellow', 'V8', 30000, 'Ford Mustang', 2019, 'GHI789'),
(4, 'Green', 'V6', 60000, 'Chevrolet Malibu', 2017, 'JKL012'),
(5, 'Purple', 'V4', 20000, 'Nissan Altima', 2021, 'MNO345'),
(6, 'White', 'V6', 45000, 'Hyundai Sonata', 2018, 'PQR678'),
(7, 'Black', 'V8', 55000, 'BMW X5', 2019, 'STU901'),
(8, 'Orange', 'V6', 35000, 'Audi A4', 2020, 'VWX234');

-- Insert into Repair_Shop
INSERT INTO Repair_Shop (name, address, phone_number, owner, website, details, rating, working_time) VALUES
('Fix-It Shop', '123 Main St', '1234567890', 'John Doe', 'www.fixit.com', 'Specializes in engine repairs', 9, '8 AM - 6 PM'),
('Quick Repair', '456 Elm St', '0987654321', 'Jane Smith', NULL, 'Affordable services', 8, '9 AM - 5 PM'),
('Auto Masters', '789 Oak St', '1112223334', 'Alice Johnson', 'www.automasters.com', 'High-quality repairs', 10, '7 AM - 7 PM'),
('Brake Center', '321 Pine St', '5556667778', 'Bob Brown', NULL, 'Brake and tire repairs', 7, '8 AM - 6 PM'),
('Cool Air', '654 Maple St', '9998887776', 'Charlie White', 'www.coolair.com', 'AC specialists', 8, '8 AM - 4 PM'),
('Paint Pro', '987 Birch St', '2223334445', 'Diana Gray', NULL, 'Professional paint jobs', 9, '8 AM - 6 PM'),
('Fix-All', '741 Cedar St', '4445556667', 'Eve Black', 'www.fixall.com', 'General repairs', 8, '8 AM - 6 PM'),
('Suspension Experts', '852 Spruce St', '8889990001', 'Frank Green', NULL, 'Suspension specialists', 10, '7 AM - 7 PM');

-- Insert into Service_Catalogue
INSERT INTO Service_Catalogue (name, description, category, cost) VALUES
('Oil Change', 'Replace engine oil', 'Maintenance', 50.00),
('Tire Replacement', 'Replace all tires', 'Repair', 200.00),
('Battery Replacement', 'Replace vehicle battery', 'Repair', 150.00),
('Brake Inspection', 'Inspect and repair brake system', 'Maintenance', 70.00),
('Engine Diagnosis', 'Full engine checkup', 'Diagnosis', 100.00),
('Paint Touch-Up', 'Touch up vehicle paint', 'Cosmetic', 80.00),
('AC Repair', 'Fix AC issues', 'Repair', 120.00),
('Suspension Repair', 'Repair suspension system', 'Repair', 150.00);

-- Insert into Spare_Part
INSERT INTO Spare_Part (part_name, compatible_models, description, category, cost) VALUES
('Oil Filter', 'Toyota Camry, Honda Civic', 'High-quality oil filter', 'Engine', 15.00),
('Tire Set', 'Ford Mustang, BMW X5', 'Durable tire set', 'Wheels', 500.00),
('Battery', 'Chevrolet Malibu, Audi A4', 'Long-lasting battery', 'Electrical', 100.00),
('Brake Pads', 'Nissan Altima, Hyundai Sonata', 'Reliable brake pads', 'Brakes', 60.00),
('AC Compressor', 'Toyota Camry, Honda Civic', 'Efficient AC compressor', 'Cooling', 200.00),
('Suspension Springs', 'Ford Mustang, BMW X5', 'High-quality springs', 'Suspension', 150.00),
('Paint Kit', 'All models', 'Professional paint kit', 'Cosmetic', 50.00),
('Timing Belt', 'Nissan Altima, Audi A4', 'Durable timing belt', 'Engine', 80.00);

-- Insert into Invoice
INSERT INTO Invoice (customer_id, date_time, discount, payment_status, total_price) VALUES
(1, '2024-12-01 10:00:00', 5.00, 'Paid', 95.00),
(2, '2024-12-01 12:00:00', 0.00, 'Pending', 50.00),
(3, '2024-12-02 14:00:00', 10.00, 'Paid', 190.00),
(4, '2024-12-02 16:00:00', 0.00, 'Cancelled', 0.00),
(5, '2024-12-03 11:00:00', 0.00, 'Pending', 150.00),
(6, '2024-12-03 13:00:00', 20.00, 'Paid', 130.00),
(7, '2024-12-04 09:00:00', 15.00, 'Paid', 105.00),
(8, '2024-12-04 15:00:00', 0.00, 'Refunded', 0.00);

-- Insert into Schedule
INSERT INTO Schedule (schedule_date, technician_id, vehicle_id, task_id) VALUES
('2024-12-08 10:00:00', 1, 1, 1),
('2024-12-08 12:00:00', 2, 2, 2),
('2024-12-08 14:00:00', 3, 3, 3),
('2024-12-09 09:00:00', 4, 4, 4),
('2024-12-09 11:00:00', 5, 5, 5),
('2024-12-09 13:00:00', 6, 6, 6),
('2024-12-10 10:00:00', 7, 7, 7),
('2024-12-10 14:00:00', 8, 8, 8);


INSERT INTO Technician_Shops (technician_id, repair_shop_id, when_hired) VALUES 
(1, 1, '2024-12-04'),
 (2, 1, '2023-8-24'),
 (3, 1, '2018-02-17'),
 (4, 1, '2013-07-19'),
 (5, 1, '2024-12-05'),
 (6, 1, '2018-02-18'),
 (7, 1, '2018-02-19'),
 (8, 1, '2013-07-20');


INSERT INTO Vehicle_Spare_Parts (vehicle_id, spare_part_id, count) VALUES
(1, 1, 1),
(1, 2, 4),
(2, 3, 1),
(3, 4, 1),
(4, 5, 1),
(5, 6, 1),
(6, 7, 1),
(7, 8, 1),
(8, 1, 2);


INSERT INTO Technician_Tasks (technician_id, task_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);


INSERT INTO Service_Tasks (service_id, task_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8);


INSERT INTO Repair_Shop_Tasks (repair_shop_id, task_id) VALUES
(1, 1), -- Engine Diagnosis
(1, 2), -- Oil Change
(1, 3), -- Tire Replacement
(1, 4), -- Battery Check
(1, 5), -- Brake Inspection
(1, 6), -- Suspension Repair
(1, 7), -- Air Conditioning
(1, 8); -- Paint Touch-Up


INSERT INTO Repair_Shop_Spare_Parts (repair_shop_id, spare_part_id, inventory) VALUES
(1, 1, 50), -- Oil Filter
(1, 2, 20), -- Tire Set
(1, 3, 30), -- Battery
(1, 4, 40), -- Brake Pads
(1, 5, 15), -- AC Compressor
(1, 6, 25), -- Suspension Springs
(1, 7, 10), -- Paint Kit
(1, 8, 35); -- Timing Belt


INSERT INTO Repair_Shop_Customers (repair_shop_id, customer_id, join_date) VALUES
(1, 1, '2024-11-01'), -- Alice Blue
(1, 2, '2024-11-02'), -- Bob Red
(1, 3, '2024-11-03'), -- Charlie Yellow
(1, 4, '2024-11-04'), -- Diana Green
(1, 5, '2024-11-05'), -- Eve Purple
(1, 6, '2024-11-06'), -- Frank White
(1, 7, '2024-11-07'), -- Grace Black
(1, 8, '2024-11-08'); -- Hank Orange

