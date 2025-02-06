CREATE DATABASE  IF NOT EXISTS `repairshopdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `repairshopdb`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: repairshopdb
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `last_visit` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Alice Blue','123 Main St','1234567890','2024-12-01 10:00:00'),(2,'Bob Red','456 Elm St','0987654321','2024-11-30 14:00:00'),(3,'Charlie Yellow','789 Oak St','1112223334','2024-11-29 12:00:00'),(4,'Diana Green','321 Pine St','5556667778','2024-12-01 16:00:00'),(5,'Eve Purple','654 Maple St','9998887776','2024-11-28 09:00:00'),(6,'Frank White','987 Birch St','2223334445','2024-11-30 13:00:00'),(7,'Grace Black','741 Cedar St','4445556667','2024-12-02 11:00:00'),(8,'Hank Orange','852 Spruce St','8889990001','2024-12-03 15:00:00');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `date_time` datetime NOT NULL,
  `discount` decimal(5,2) DEFAULT '0.00',
  `payment_status` enum('Pending','Paid','Cancelled','Refunded') DEFAULT 'Pending',
  `total_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoice_chk_1` CHECK ((`discount` >= 0)),
  CONSTRAINT `invoice_chk_2` CHECK ((`total_price` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (1,1,'2024-12-01 10:00:00',5.00,'Paid',95.00),(2,2,'2024-12-01 12:00:00',0.00,'Pending',50.00),(3,3,'2024-12-02 14:00:00',10.00,'Paid',190.00),(4,4,'2024-12-02 16:00:00',0.00,'Cancelled',0.00),(5,5,'2024-12-03 11:00:00',0.00,'Pending',150.00),(6,6,'2024-12-03 13:00:00',20.00,'Paid',130.00),(7,7,'2024-12-04 09:00:00',15.00,'Paid',105.00),(8,8,'2024-12-04 15:00:00',0.00,'Refunded',0.00),(9,1,'2025-01-01 11:00:00',0.00,'Paid',50.00),(10,2,'2023-01-01 17:00:00',0.00,'Paid',85.00);
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `UpdateInventoryOnInvoiceInsert` AFTER INSERT ON `invoice` FOR EACH ROW BEGIN
    -- Declare variables
    DECLARE partID INT;
    DECLARE quantityUsed INT;
    DECLARE done INT DEFAULT 0;

    -- Declare a cursor to retrieve spare parts used in the service (from vehicle_spare_parts)
    DECLARE sparePartsCursor CURSOR FOR
        SELECT vsp.spare_part_id, vsp.count
        FROM Vehicle_Spare_Parts vsp
        JOIN Schedule s ON vsp.vehicle_id = s.vehicle_id
        WHERE s.id = NEW.id;

    -- Declare a handler to handle when the cursor reaches the end
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN sparePartsCursor;

    update_loop: LOOP
        -- Fetch the next spare part and quantity used
        FETCH sparePartsCursor INTO partID, quantityUsed;

        -- Exit the loop if there are no more rows
        IF done THEN
            LEAVE update_loop;
        END IF;

        -- Update the inventory for the shop by reducing the quantity of the spare part used
        UPDATE Repair_Shop_Spare_Parts
        SET inventory = inventory - quantityUsed
        WHERE spare_part_id = partID AND repair_shop_id = NEW.id;

        -- Ensure the inventory does not go below zero
        UPDATE Repair_Shop_Spare_Parts
        SET inventory = 0
        WHERE spare_part_id = partID AND repair_shop_id = NEW.id AND inventory < 0;
    END LOOP;
	
    INSERT INTO log_table (log_time, action, details)
	VALUES (NOW(), 'Trigger Fired', 'Inventory update on invoice insert');

    
    -- Close the cursor
    CLOSE sparePartsCursor;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `log_table`
--

DROP TABLE IF EXISTS `log_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_table` (
  `id` int NOT NULL AUTO_INCREMENT,
  `log_time` datetime NOT NULL,
  `action` varchar(255) NOT NULL,
  `details` text,
  `created_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_table`
--

LOCK TABLES `log_table` WRITE;
/*!40000 ALTER TABLE `log_table` DISABLE KEYS */;
INSERT INTO `log_table` VALUES (1,'2025-01-03 22:58:39','Add Schedule','New schedule added for Technician ID: 1, Vehicle ID: 2',NULL),(2,'2025-01-03 23:30:34','Trigger Fired','Inventory update on invoice insert',NULL),(3,'2025-01-03 23:37:39','Trigger Fired','Update the mileage of the vehicle by adding 500 after a service is completed',NULL),(4,'2025-01-03 23:39:29','Trigger Fired','Update the mileage of the vehicle by adding 500 after a service is completed',NULL),(5,'2025-01-03 23:42:15','Trigger Fired','Update the mileage of the vehicle by adding 500 after a service is completed',NULL);
/*!40000 ALTER TABLE `log_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_shop`
--

DROP TABLE IF EXISTS `repair_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_shop` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `owner` varchar(50) NOT NULL,
  `website` varchar(100) DEFAULT NULL,
  `details` text,
  `rating` int NOT NULL,
  `working_time` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `repair_shop_chk_1` CHECK (((`rating` >= 0) and (`rating` <= 10)))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_shop`
--

LOCK TABLES `repair_shop` WRITE;
/*!40000 ALTER TABLE `repair_shop` DISABLE KEYS */;
INSERT INTO `repair_shop` VALUES (1,'Fix-It Shop','123 Main St','1234567890','John Doe','www.fixit.com','Specializes in engine repairs',9,'8 AM - 6 PM'),(2,'Quick Repair','456 Elm St','0987654321','Jane Smith',NULL,'Affordable services',8,'9 AM - 5 PM'),(3,'Auto Masters','789 Oak St','1112223334','Alice Johnson','www.automasters.com','High-quality repairs',10,'7 AM - 7 PM'),(4,'Brake Center','321 Pine St','5556667778','Bob Brown',NULL,'Brake and tire repairs',7,'8 AM - 6 PM'),(5,'Cool Air','654 Maple St','9998887776','Charlie White','www.coolair.com','AC specialists',8,'8 AM - 4 PM'),(6,'Paint Pro','987 Birch St','2223334445','Diana Gray',NULL,'Professional paint jobs',9,'8 AM - 6 PM'),(7,'Fix-All','741 Cedar St','4445556667','Eve Black','www.fixall.com','General repairs',8,'8 AM - 6 PM'),(8,'Suspension Experts','852 Spruce St','8889990001','Frank Green',NULL,'Suspension specialists',10,'7 AM - 7 PM'),(9,'Afra shop','3 farjam St, Isfahan, Iran','09395523711','Saeed Nourian',NULL,'Winner, Winner, Chicken Dinner!',10,'7 AM - 6 PM');
/*!40000 ALTER TABLE `repair_shop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_shop_customers`
--

DROP TABLE IF EXISTS `repair_shop_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_shop_customers` (
  `repair_shop_id` int NOT NULL,
  `customer_id` int NOT NULL,
  `join_date` date NOT NULL,
  PRIMARY KEY (`repair_shop_id`,`customer_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `repair_shop_customers_ibfk_1` FOREIGN KEY (`repair_shop_id`) REFERENCES `repair_shop` (`id`) ON DELETE CASCADE,
  CONSTRAINT `repair_shop_customers_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_shop_customers`
--

LOCK TABLES `repair_shop_customers` WRITE;
/*!40000 ALTER TABLE `repair_shop_customers` DISABLE KEYS */;
INSERT INTO `repair_shop_customers` VALUES (1,1,'2024-11-01'),(1,2,'2024-11-02'),(1,3,'2024-11-03'),(1,4,'2024-11-04'),(1,5,'2024-11-05'),(1,6,'2024-11-06'),(1,7,'2024-11-07'),(1,8,'2024-11-08');
/*!40000 ALTER TABLE `repair_shop_customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_shop_spare_parts`
--

DROP TABLE IF EXISTS `repair_shop_spare_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_shop_spare_parts` (
  `repair_shop_id` int NOT NULL,
  `spare_part_id` int NOT NULL,
  `inventory` int NOT NULL,
  PRIMARY KEY (`repair_shop_id`,`spare_part_id`),
  KEY `spare_part_id` (`spare_part_id`),
  CONSTRAINT `repair_shop_spare_parts_ibfk_1` FOREIGN KEY (`repair_shop_id`) REFERENCES `repair_shop` (`id`) ON DELETE CASCADE,
  CONSTRAINT `repair_shop_spare_parts_ibfk_2` FOREIGN KEY (`spare_part_id`) REFERENCES `spare_part` (`id`) ON DELETE CASCADE,
  CONSTRAINT `repair_shop_spare_parts_chk_1` CHECK ((`inventory` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_shop_spare_parts`
--

LOCK TABLES `repair_shop_spare_parts` WRITE;
/*!40000 ALTER TABLE `repair_shop_spare_parts` DISABLE KEYS */;
INSERT INTO `repair_shop_spare_parts` VALUES (1,1,50),(1,2,20),(1,3,30),(1,4,40),(1,5,15),(1,6,25),(1,7,10),(1,8,35);
/*!40000 ALTER TABLE `repair_shop_spare_parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_shop_tasks`
--

DROP TABLE IF EXISTS `repair_shop_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_shop_tasks` (
  `repair_shop_id` int NOT NULL,
  `task_catalogue_id` int NOT NULL,
  PRIMARY KEY (`repair_shop_id`,`task_catalogue_id`),
  KEY `task_catalogue_id` (`task_catalogue_id`),
  CONSTRAINT `repair_shop_tasks_ibfk_1` FOREIGN KEY (`repair_shop_id`) REFERENCES `repair_shop` (`id`) ON DELETE CASCADE,
  CONSTRAINT `repair_shop_tasks_ibfk_2` FOREIGN KEY (`task_catalogue_id`) REFERENCES `task_catalogue` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_shop_tasks`
--

LOCK TABLES `repair_shop_tasks` WRITE;
/*!40000 ALTER TABLE `repair_shop_tasks` DISABLE KEYS */;
INSERT INTO `repair_shop_tasks` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8);
/*!40000 ALTER TABLE `repair_shop_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `schedule_date` datetime NOT NULL,
  `technician_id` int NOT NULL,
  `vehicle_id` int NOT NULL,
  `task_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `technician_id` (`technician_id`),
  KEY `vehicle_id` (`vehicle_id`),
  KEY `task_id` (`task_id`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`technician_id`) REFERENCES `technician` (`id`) ON DELETE CASCADE,
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicle` (`id`) ON DELETE CASCADE,
  CONSTRAINT `schedule_ibfk_3` FOREIGN KEY (`task_id`) REFERENCES `task_catalogue` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1,'2024-12-08 10:00:00',1,1,1),(2,'2024-12-08 12:00:00',2,2,2),(3,'2024-12-08 14:00:00',3,3,3),(4,'2024-12-09 09:00:00',4,4,4),(5,'2024-12-09 11:00:00',5,5,5),(6,'2024-12-09 13:00:00',6,6,6),(7,'2024-12-10 10:00:00',7,7,7),(8,'2024-12-10 14:00:00',8,8,8),(9,'2025-01-10 10:00:00',1,2,3),(10,'2025-01-10 10:00:00',1,2,3),(11,'2025-01-10 10:00:00',1,3,2),(12,'2025-01-10 10:00:00',2,5,3),(14,'2025-01-10 10:00:00',4,2,3);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `UpdateMileageAfterService` AFTER INSERT ON `schedule` FOR EACH ROW BEGIN
    -- Update the mileage of the vehicle by adding 500 after a service is completed
    UPDATE Vehicle
    SET mileage = mileage + 500
    WHERE id = NEW.vehicle_id;
    INSERT INTO log_table (log_time, action, details)
	VALUES (NOW(), 'Trigger Fired', 'Update the mileage of the vehicle by adding 500 after a service is completed');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `service_catalogue`
--

DROP TABLE IF EXISTS `service_catalogue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_catalogue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `category` varchar(50) NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `service_catalogue_chk_1` CHECK ((`cost` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_catalogue`
--

LOCK TABLES `service_catalogue` WRITE;
/*!40000 ALTER TABLE `service_catalogue` DISABLE KEYS */;
INSERT INTO `service_catalogue` VALUES (1,'Oil Change','Replace engine oil','Maintenance',50.00),(2,'Tire Replacement','Replace all tires','Repair',200.00),(3,'Battery Replacement','Replace vehicle battery','Repair',150.00),(4,'Brake Inspection','Inspect and repair brake system','Maintenance',70.00),(5,'Engine Diagnosis','Full engine checkup','Diagnosis',100.00),(6,'Paint Touch-Up','Touch up vehicle paint','Cosmetic',80.00),(7,'AC Repair','Fix AC issues','Repair',120.00),(8,'Suspension Repair','Repair suspension system','Repair',150.00);
/*!40000 ALTER TABLE `service_catalogue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_tasks`
--

DROP TABLE IF EXISTS `service_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_tasks` (
  `service_id` int NOT NULL,
  `task_id` int NOT NULL,
  PRIMARY KEY (`service_id`,`task_id`),
  KEY `task_id` (`task_id`),
  CONSTRAINT `service_tasks_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `service_catalogue` (`id`) ON DELETE CASCADE,
  CONSTRAINT `service_tasks_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `task_catalogue` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_tasks`
--

LOCK TABLES `service_tasks` WRITE;
/*!40000 ALTER TABLE `service_tasks` DISABLE KEYS */;
INSERT INTO `service_tasks` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8);
/*!40000 ALTER TABLE `service_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spare_part`
--

DROP TABLE IF EXISTS `spare_part`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spare_part` (
  `id` int NOT NULL AUTO_INCREMENT,
  `part_name` varchar(255) NOT NULL,
  `compatible_models` varchar(255) NOT NULL,
  `description` text,
  `category` varchar(50) NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `spare_part_chk_1` CHECK ((`cost` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spare_part`
--

LOCK TABLES `spare_part` WRITE;
/*!40000 ALTER TABLE `spare_part` DISABLE KEYS */;
INSERT INTO `spare_part` VALUES (1,'Oil Filter','Toyota Camry, Honda Civic','High-quality oil filter','Engine',15.00),(2,'Tire Set','Ford Mustang, BMW X5','Durable tire set','Wheels',500.00),(3,'Battery','Chevrolet Malibu, Audi A4','Long-lasting battery','Electrical',100.00),(4,'Brake Pads','Nissan Altima, Hyundai Sonata','Reliable brake pads','Brakes',60.00),(5,'AC Compressor','Toyota Camry, Honda Civic','Efficient AC compressor','Cooling',200.00),(6,'Suspension Springs','Ford Mustang, BMW X5','High-quality springs','Suspension',150.00),(7,'Paint Kit','All models','Professional paint kit','Cosmetic',50.00),(8,'Timing Belt','Nissan Altima, Audi A4','Durable timing belt','Engine',80.00);
/*!40000 ALTER TABLE `spare_part` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_catalogue`
--

DROP TABLE IF EXISTS `task_catalogue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_catalogue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `estimated_time` datetime NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `priority` enum('Low','Medium','High') NOT NULL DEFAULT 'Medium',
  PRIMARY KEY (`id`),
  CONSTRAINT `task_catalogue_chk_1` CHECK ((`price` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_catalogue`
--

LOCK TABLES `task_catalogue` WRITE;
/*!40000 ALTER TABLE `task_catalogue` DISABLE KEYS */;
INSERT INTO `task_catalogue` VALUES (1,'Engine Diagnosis','Diagnose engine issues','2024-12-08 10:00:00',100.00,'High'),(2,'Oil Change','Replace engine oil','2024-12-09 12:00:00',50.00,'Medium'),(3,'Tire Replacement','Replace all tires','2024-12-10 14:00:00',200.00,'High'),(4,'Battery Check','Check battery status','2024-12-11 09:00:00',30.00,'Low'),(5,'Brake Inspection','Inspect brake system','2024-12-12 13:00:00',70.00,'Medium'),(6,'Suspension Repair','Repair suspension system','2024-12-13 11:00:00',150.00,'High'),(7,'Air Conditioning','Fix AC issues','2024-12-14 15:00:00',120.00,'Medium'),(8,'Paint Touch-Up','Touch up vehicle paint','2024-12-15 16:00:00',80.00,'Low');
/*!40000 ALTER TABLE `task_catalogue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technician`
--

DROP TABLE IF EXISTS `technician`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technician` (
  `id` int NOT NULL AUTO_INCREMENT,
  `technician_name` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `rating` int NOT NULL,
  `professional_experience_months` int NOT NULL,
  `specialization` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `technician_chk_1` CHECK (((`rating` >= 0) and (`rating` <= 10))),
  CONSTRAINT `technician_chk_2` CHECK ((`professional_experience_months` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technician`
--

LOCK TABLES `technician` WRITE;
/*!40000 ALTER TABLE `technician` DISABLE KEYS */;
INSERT INTO `technician` VALUES (1,'John Doe','1234567890',8,60,'Engine Specialist'),(2,'Jane Smith','0987654321',7,48,'Tire Specialist'),(3,'Alice Johnson','1112223334',9,72,'Battery Specialist'),(4,'Bob Brown','5556667778',6,36,'Brake Specialist'),(5,'Charlie White','9998887776',10,96,'AC Specialist'),(6,'Diana Gray','2223334445',7,48,'Paint Specialist'),(7,'Eve Black','4445556667',5,24,'General Repairs'),(8,'Frank Green','8889990001',8,60,'Suspension Specialist');
/*!40000 ALTER TABLE `technician` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technician_shops`
--

DROP TABLE IF EXISTS `technician_shops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technician_shops` (
  `technician_id` int NOT NULL,
  `repair_shop_id` int NOT NULL,
  `when_hired` date NOT NULL,
  PRIMARY KEY (`technician_id`,`repair_shop_id`),
  KEY `repair_shop_id` (`repair_shop_id`),
  CONSTRAINT `technician_shops_ibfk_1` FOREIGN KEY (`technician_id`) REFERENCES `technician` (`id`) ON DELETE CASCADE,
  CONSTRAINT `technician_shops_ibfk_2` FOREIGN KEY (`repair_shop_id`) REFERENCES `repair_shop` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technician_shops`
--

LOCK TABLES `technician_shops` WRITE;
/*!40000 ALTER TABLE `technician_shops` DISABLE KEYS */;
INSERT INTO `technician_shops` VALUES (1,1,'2024-12-04'),(2,1,'2023-08-24'),(3,1,'2018-02-17'),(4,1,'2013-07-19'),(5,1,'2024-12-05'),(6,1,'2018-02-18'),(7,1,'2018-02-19'),(8,1,'2013-07-20');
/*!40000 ALTER TABLE `technician_shops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `technician_tasks`
--

DROP TABLE IF EXISTS `technician_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `technician_tasks` (
  `technician_id` int NOT NULL,
  `task_catalogue_id` int NOT NULL,
  `fee` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`technician_id`,`task_catalogue_id`),
  KEY `task_catalogue_id` (`task_catalogue_id`),
  CONSTRAINT `technician_tasks_ibfk_1` FOREIGN KEY (`technician_id`) REFERENCES `technician` (`id`) ON DELETE CASCADE,
  CONSTRAINT `technician_tasks_ibfk_2` FOREIGN KEY (`task_catalogue_id`) REFERENCES `task_catalogue` (`id`) ON DELETE CASCADE,
  CONSTRAINT `technician_tasks_chk_1` CHECK ((`fee` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `technician_tasks`
--

LOCK TABLES `technician_tasks` WRITE;
/*!40000 ALTER TABLE `technician_tasks` DISABLE KEYS */;
INSERT INTO `technician_tasks` VALUES (1,1,0.00),(2,2,0.00),(3,3,0.00),(4,4,0.00),(5,5,0.00),(6,6,0.00),(7,7,0.00),(8,8,0.00);
/*!40000 ALTER TABLE `technician_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle`
--

DROP TABLE IF EXISTS `vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `color` varchar(20) NOT NULL,
  `engine` varchar(10) NOT NULL,
  `mileage` int NOT NULL,
  `model` varchar(50) NOT NULL,
  `production_year` int NOT NULL,
  `plate` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `vehicle_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vehicle_chk_1` CHECK ((`mileage` > -(1))),
  CONSTRAINT `vehicle_chk_2` CHECK ((`production_year` >= 1970))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle`
--

LOCK TABLES `vehicle` WRITE;
/*!40000 ALTER TABLE `vehicle` DISABLE KEYS */;
INSERT INTO `vehicle` VALUES (1,1,'Blue','V6',50000,'Toyota Camry',2018,'ABC123'),(2,2,'Red','V4',40500,'Honda Civic',2020,'DEF456'),(3,3,'Yellow','V8',30000,'Ford Mustang',2019,'GHI789'),(4,4,'Green','V6',60000,'Chevrolet Malibu',2017,'JKL012'),(5,5,'Purple','V4',20000,'Nissan Altima',2021,'MNO345'),(6,6,'White','V6',45000,'Hyundai Sonata',2018,'PQR678'),(7,7,'Black','V8',55000,'BMW X5',2019,'STU901'),(8,8,'Orange','V6',35000,'Audi A4',2020,'VWX234');
/*!40000 ALTER TABLE `vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_spare_parts`
--

DROP TABLE IF EXISTS `vehicle_spare_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_spare_parts` (
  `vehicle_id` int NOT NULL,
  `spare_part_id` int NOT NULL,
  `count` int NOT NULL,
  PRIMARY KEY (`vehicle_id`,`spare_part_id`),
  KEY `spare_part_id` (`spare_part_id`),
  CONSTRAINT `vehicle_spare_parts_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicle` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vehicle_spare_parts_ibfk_2` FOREIGN KEY (`spare_part_id`) REFERENCES `spare_part` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vehicle_spare_parts_chk_1` CHECK ((`count` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_spare_parts`
--

LOCK TABLES `vehicle_spare_parts` WRITE;
/*!40000 ALTER TABLE `vehicle_spare_parts` DISABLE KEYS */;
INSERT INTO `vehicle_spare_parts` VALUES (1,1,1),(1,2,4),(2,3,1),(3,4,1),(4,5,1),(5,6,1),(6,7,1),(7,8,1),(8,1,2);
/*!40000 ALTER TABLE `vehicle_spare_parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'repairshopdb'
--

--
-- Dumping routines for database 'repairshopdb'
--
/*!50003 DROP FUNCTION IF EXISTS `GetCustomerTotalCost` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetCustomerTotalCost`(customerID INT) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE totalCost DECIMAL(10, 2);

    -- Calculate the total cost of invoices for the specified customer
    SELECT SUM(i.total_price) -- Adjusted column name to fit your schema
    INTO totalCost
    FROM invoice i            -- Adjusted table name to fit your schema
    WHERE i.customer_id = customerID; -- Adjusted column name to fit your schema

    -- Return the total cost, or 0 if no invoices exist
    RETURN IFNULL(totalCost, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddScheduleEntry` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddScheduleEntry`(
    IN p_schedule_date DATETIME,
    IN p_technician_id INT,
    IN p_vehicle_id INT,
    IN p_task_id INT
)
BEGIN
    -- Insert a new schedule entry
    INSERT INTO schedule (schedule_date, technician_id, vehicle_id, task_id)
    VALUES (p_schedule_date, p_technician_id, p_vehicle_id, p_task_id);

    -- Log the action (assuming there's a log table)
    INSERT INTO log_table (log_time, action, details)
    VALUES (NOW(), 'Add Schedule', CONCAT('New schedule added for Technician ID: ', p_technician_id, ', Vehicle ID: ', p_vehicle_id));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-03 23:46:05
