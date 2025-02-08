# Car Repair Shop Database  

This project implements a **Car Repair Shop Management System** using **MySQL**. The database stores information about repair shops, customers, vehicles, services, technicians, spare parts, and invoices.  

## Features  
- Manage **repair shops**, **technicians**, **customers**, and **vehicles**.  
- Track **services**, **tasks**, and **spare parts usage**.  
- Generate **invoices** with applied discounts.  
- Schedule **appointments** for customers.  
- Maintain **inventory** and manage spare parts consumption.  

---

## Database Schema  
The main entities in the database:  
1. **repair_shops** – Stores details about repair shops.  
2. **customers** – Contains customer details and contact information.  
3. **vehicles** – Stores customer vehicles and specifications.  
4. **service_catalogues** – Defines available services and costs.  
5. **task_catalogues** – Stores tasks related to services.  
6. **schedules** – Manages service appointments.  
7. **technicians** – Stores information about repair technicians.  
8. **spare_parts** – Contains inventory and spare part details.  
9. **invoices** – Tracks customer payments and applied discounts.  

---

## Setup Instructions  

### 1️ Install MySQL  
Ensure **MySQL Server** is installed and running.  

### 2️ Create Database  
Run the following command in MySQL:  
```sql
CREATE DATABASE CarRepairShop;
USE CarRepairShop;
```

### 3️ Import Tables  
Execute the provided SQL schema file:  
```sql
SOURCE path/to/schema.sql;
```

### 4️ Insert Sample Data (Optional)  
To populate the database with test data:  
```sql
SOURCE path/to/sample_data.sql;
```

---

## Sample Queries  

### 1️ Add a New Repair Shop  
```sql
INSERT INTO repair_shops (ShopName, Address, PhoneNumber, WorkingTime)
VALUES ('AutoFix Center', '123 Main St, City', '123-456-7890', '9 AM - 6 PM');
```

### 2️ Retrieve All Services for a Specific Repair Shop  
```sql
SELECT ServiceName, Cost FROM service_catalogues WHERE ShopID = 1;
```

### 3️ Get Customer Invoices Over $500  
```sql
SELECT c.CustomerName, i.TotalPrice
FROM invoices i
JOIN customers c ON i.CustomerID = c.CustomerID
WHERE i.TotalPrice > 500;
```

---

## Stored Procedure Example  

### **Retrieve Services and Tasks for a Repair Shop**
```sql
DELIMITER $$

CREATE PROCEDURE GetShopServices(IN shopID INT)
BEGIN
    SELECT rs.ShopName, sc.ServiceName, sc.Cost, tc.TaskName, tc.EstimatedTime
    FROM repair_shops rs
    JOIN service_catalogues sc ON rs.ShopID = sc.ShopID
    JOIN task_catalogues tc ON sc.ServiceID = tc.ServiceID
    WHERE rs.ShopID = shopID;
END$$

DELIMITER ;
```

**Usage:**  
```sql
CALL GetShopServices(1);
```
