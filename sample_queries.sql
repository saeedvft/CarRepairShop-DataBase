-- 1. Add a Repair Shop
INSERT INTO repair_shops (ShopID, ShopName, Address, PhoneNumber, WorkingTime, Owner, ShopRating, Website, Details)  
VALUES (NEW_ID, 'New Repair Shop', 'City Address', '123-456-7890', '9:00 AM - 6:00 PM', 'Saeed Nourian', 8.7, 'saeednourian.com', 'details about repair shop');

-- 2. Remove a Repair Shop
DELETE FROM repair_shops  
WHERE ShopID = SPECIFIC_ID;

-- 3. List of Spare Parts Used from 3 Aban to 12 Azar in a Specific Repair Shop
SELECT sp.id, sp.Part_Name, sp.cost, sp.Category, sp.Description  
FROM spare_part sp  
JOIN task_catalogue tc ON sp.id = tc.id  
JOIN schedule s ON tc.id = s.id  
JOIN service_catalogue sc ON s.id = sc.id  
JOIN repair_shop rs ON sc.id = rs.id  
WHERE rs.id = 5
  AND s.schedule_date BETWEEN '1400-08-03' AND '1400-09-12';



-- 4. List of Customers Who Own Toyota Camry and Used Oil Change Services
SELECT DISTINCT c.id, c.name, c.phone_number  
FROM customer c  
JOIN vehicle v ON c.id = v.id  
JOIN schedule s ON v.id = s.id  
JOIN service_catalogue sc ON s.id = sc.id  
WHERE v.model = 'Toyota Camry' AND sc.name = 'Oil Change';

-- 5. Add New Spare Parts to Repair Shops in Isfahan, Shiraz, and Tabriz
INSERT INTO spare_parts (id, part_name, cost, Category, Description, Compatible_Models)  
SELECT NEW_PART_ID, 'Part Name', 100000, 'Category', 'Description', 'Compatible Models'  
FROM repair_shops rs  
WHERE rs.Address LIKE '%Isfahan%' OR rs.Address LIKE '%Shiraz%' OR rs.Address LIKE '%Tabriz%';

-- 6. List Customers with More Than 3 Different Cars, Visiting a Specific Repair Shop, with Invoices Over 500,000
SELECT c.id AS CustomerID, c.name AS CustomerName, COUNT(DISTINCT v.id) AS VehicleCount, SUM(i.total_price) AS TotalSpent
FROM Customer c
JOIN Vehicle v ON c.id = v.customer_id
JOIN Schedule s ON v.id = s.vehicle_id
JOIN Invoice i ON c.id = i.customer_id
WHERE s.id IN (
    SELECT s.id 
    FROM Schedule s
    JOIN Technician_Shops ts ON s.technician_id = ts.technician_id
    WHERE ts.repair_shop_id = 1
)
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT v.id) > 3 AND SUM(i.total_price) > 500000;


-- 7. List all technicians working in a specific repair shop along with their specialization and experience
SELECT t.id AS TechID, t.technician_name AS TechName, t.specialization, t.professional_experience_months, t.rating
FROM Technician t
JOIN Technician_Shops ts ON t.id = ts.technician_id
WHERE ts.repair_shop_id = 1;

-- 8. Retrieve the schedule of a specific vehicle, including the service and technician assigned
SELECT s.id AS ScheduleID, t.technician_name AS TechnicianName, s.schedule_date
FROM Schedule s
JOIN Technician t ON s.technician_id = t.id
WHERE s.vehicle_id = 2
ORDER BY s.schedule_date;

-- 9. Get the total revenue generated by a specific repair shop in a given time period
SELECT SUM(i.total_price) AS TotalRevenue
FROM Invoice i
WHERE i.id IN (
    SELECT s.id
    FROM Schedule s
    JOIN Technician_Shops ts ON s.technician_id = ts.technician_id
    WHERE ts.repair_shop_id = 1
)
AND i.date_time BETWEEN '2023-06-18 9:30:00' AND '2024-12-12 18:00:00';




-- 10. List all vehicles serviced in a specific repair shop, including the customer details
SELECT v.id AS VehicleID, v.model, v.production_year, c.name AS CustomerName, c.phone_number
FROM Vehicle v
JOIN Customer c ON v.customer_id = c.id
JOIN Schedule s ON v.id = s.vehicle_id
WHERE s.id IN (
    SELECT s.id 
    FROM Schedule s
    JOIN Technician_Shops ts ON s.technician_id = ts.technician_id
    WHERE ts.repair_shop_id = 1
);



-- 11. Retrieve the details of invoices with a discount applied
SELECT i.id AS InvoiceID, i.date_time, i.total_price, i.discount, i.payment_status, c.name AS CustomerName
FROM Invoice i
JOIN Customer c ON i.customer_id = c.id
WHERE i.discount > 0;


-- 12. Find the top 3 technicians based on their ratings
SELECT t.id AS TechID, t.technician_name AS TechName, t.rating, t.specialization
FROM Technician t
ORDER BY t.rating DESC
LIMIT 3;



-- 13. List all spare parts compatible with a specific car model
SELECT sp.id AS PartID, sp.part_name AS PartName, sp.cost AS Price, sp.category
FROM Spare_Part sp
WHERE sp.compatible_models LIKE '%Camry%';


-- 14. Retrieve the details of all pending schedules in a specific repair shop
SELECT s.id AS ScheduleID, s.schedule_date, t.technician_name AS TechnicianName
FROM Schedule s
JOIN Technician t ON s.technician_id = t.id
JOIN Technician_Shops ts ON t.id = ts.technician_id
WHERE ts.repair_shop_id = 1;


-- 15. Find customers whose last visit was more than a month ago
SELECT c.id AS CustomerID, c.name AS CustomerName, c.phone_number, c.last_visit
FROM Customer c
WHERE c.last_visit < DATE_SUB(CURDATE(), INTERVAL 1 MONTH);


-- 16. Find the top 10 frequently used spare part across all repair shops
SELECT sp.id AS PartID, sp.part_name AS PartName, SUM(vsp.count) AS UsageCount
FROM Spare_Part sp
JOIN Vehicle_Spare_Parts vsp ON sp.id = vsp.spare_part_id
GROUP BY sp.id, sp.part_name
ORDER BY UsageCount DESC
LIMIT 10;


