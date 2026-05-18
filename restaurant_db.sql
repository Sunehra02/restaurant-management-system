-- MySQL dump 10.13  Distrib 8.4.6, for Win64 (x86_64)
--
-- Host: localhost    Database: restaurant_db
-- ------------------------------------------------------
-- Server version	8.4.6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `user_id` varchar(10) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `admins_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES ('A001','Sara Hossain','sara@rms.com'),('A002','Faisal Kabir','faisal@rms.com');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `user_id` varchar(10) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES ('C0001','Rafiq Hossain','01711111111','rafiq@mail.com'),('C0002','Mahira Nizam','01722222222','mahira@mail.com'),('C0003','Sabrina Noor','01733333333','sabrina@mail.com'),('C0004','Kazi Sultana Sunehra','01888888888','sunehra@gmail.com'),('C0005','Kazi Sunehra','08129382938','sunehra@gmail.com'),('C0006','Rimjhim Tajriyan','39834703','rimjhim@gmail.com'),('C0007','Rimjhim Tajriyan','984304980','tajriyan@gmail.com');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `item_name` varchar(100) NOT NULL,
  `stock` int NOT NULL,
  `threshold` int DEFAULT '10',
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,'Rice',100,20),(2,'Flour',80,15),(3,'Eggs',200,50),(4,'Cheese',3,10),(5,'Potatoes',150,30),(6,'Chicken',100,20),(7,'Beef',70,15),(8,'Lettuce',90,25);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kitchen_staff`
--

DROP TABLE IF EXISTS `kitchen_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kitchen_staff` (
  `user_id` varchar(10) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `specialty` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `kitchen_staff_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kitchen_staff`
--

LOCK TABLES `kitchen_staff` WRITE;
/*!40000 ALTER TABLE `kitchen_staff` DISABLE KEYS */;
INSERT INTO `kitchen_staff` VALUES ('K001','Tanvir Rahman','Grill'),('K002','Nasima Akter','Desserts');
/*!40000 ALTER TABLE `kitchen_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_items`
--

DROP TABLE IF EXISTS `menu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_url` text,
  `description` text,
  `spicy` tinyint(1) DEFAULT '0',
  `special` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_items`
--

LOCK TABLES `menu_items` WRITE;
/*!40000 ALTER TABLE `menu_items` DISABLE KEYS */;
INSERT INTO `menu_items` VALUES (1,'Margherita Pizza',400.00,'https://ooni.com/cdn/shop/articles/20220211142347-margherita-9920_ba86be55-674e-4f35-8094-2067ab41a671.jpg?v=1737104576&width=1080','Classic cheese with tomato base with basils on top',0,0),(2,'Pepperoni Pizza',520.00,'https://saffronalley.com/cdn/shop/articles/Untitled_design_39_862d4cb1-2599-4b58-96a7-87f32d6a04ec_1000x1000.png?v=1749042168','Spicy beef pepperoni with mozzarella',1,1),(3,'BBQ Chicken Pizza',480.00,'https://media.istockphoto.com/id/1287923339/photo/pizza-with-chicken-and-barbeque-sauce-italian-pizza-on-dark-grey-black-slate-background.jpg?s=612x612&w=0&k=20&c=Da19rXvQp-kSD0GKSWKBg21yFXt7JtKOo6OsS-TutHE=','Grilled chicken with BBQ sauce',0,1),(4,'Spicy Beef Ramen',350.00,'https://static.vecteezy.com/system/resources/thumbnails/026/538/542/small_2x/beef-ramen-in-a-black-bowl-top-view-isolated-on-white-background-free-photo.jpg','Savory beef ramen served in a flavorful broth with egg and veggies',0,1),(5,'Chicken Cheese Burger',300.00,'https://www.shutterstock.com/image-photo/homemade-wagyu-beef-burger-chicken-600nw-2324763721.jpg','Chicken patty with cheese, tomato, lettuce and mayo',0,0),(6,'Crispy French Fries',150.00,'https://static.vecteezy.com/system/resources/thumbnails/039/655/363/small/ai-generated-freshly-fried-gourmet-french-fries-a-crunchy-and-unhealthy-snack-generated-by-ai-photo.jpg','Golden and crunchy potato fries',0,0),(7,'Spicy Wings (6 pcs)',280.00,'https://img.freepik.com/premium-photo/chicken-wings-plate-black-background-with-copy-space-viewed-from_908985-45639.jpg','Hot & spicy chicken wings',1,0),(8,'Chocolate Lava Cake',250.00,'https://media.istockphoto.com/id/544716244/photo/warm-chocolate-lava-cake-with-molten-center-and-red-currants.jpg?s=612x612&w=0&k=20&c=i1rRa1x7D1pu-INKabmC21BaU9MC8ZRQdcC7dBLdzUo=','Warm chocolate cake with gooey center',0,1),(9,'Chicken Momo',180.00,'https://b.zmtcdn.com/data/pictures/chains/9/19494349/3666dd2249cffd3af725adf4ca3ea37a.jpg?fit=around|750:500&crop=750:500;*,*','Filled with juicy minced meat and herbs, served with spicy dipping sauce',1,0),(10,'Chocolate Ice-cream',220.00,'https://www.wickedlywelsh.co.uk/cdn/shop/articles/choc_ice_1024x1024.webp?v=1727443743','Rich and creamy chocolate ice cream made with premium cocoa',0,1),(11,'Pistachio Ice-cream',260.00,'https://t4.ftcdn.net/jpg/15/15/52/31/360_F_1515523174_6eQyQYxxzsu8MBMjPTvYc8MIj1OLvpqf.jpg','With a nutty aroma and rich, creamy texture',0,1),(12,'Blue Berry Ice-cream',300.00,'https://www.shutterstock.com/image-photo/three-balls-blackberry-ice-cream-600nw-2551410821.jpg','Bursting with fruity flavor and a hint of tartness',0,1),(13,'Blue Heaven Mojito',220.00,'https://i.pinimg.com/736x/27/85/ef/2785efd1d4b0088cf768f2792f30e198.jpg','Infused with mint, lemon, and a splash of citrusy coolness',0,0),(14,'Cold Coffee',180.00,'https://www.milkmaid.in/sites/default/files/2024-05/Cold-Coffee-335x300.jpg','Chilled and creamy cold coffee blended to perfection with a hint of sweetness',0,0),(15,'Strawberry Milkshake',200.00,'https://static.vecteezy.com/system/resources/thumbnails/023/007/583/small/strawberry-milkshake-ai-generated-photo.jpg','Thick and creamy strawberry milkshake made with fresh strawberries and milk',0,0);
/*!40000 ALTER TABLE `menu_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `item_name` varchar(100) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,2,'Pepperoni Pizza',1,520.00),(2,3,'Margherita Pizza',2,800.00),(3,3,'Spicy Wings (6 pcs)',2,560.00),(4,3,'Chicken Momo',3,540.00),(5,3,'Blue Heaven Mojito',2,440.00),(6,4,'Margherita Pizza',2,800.00),(7,4,'Blue Heaven Mojito',2,440.00),(8,5,'Margherita Pizza',2,800.00),(9,5,'Pistachio Ice-cream',1,260.00),(10,5,'Blue Heaven Mojito',2,440.00),(11,6,'Margherita Pizza',3,1200.00),(12,6,'Pepperoni Pizza',1,520.00),(13,6,'Blue Heaven Mojito',2,440.00),(14,7,'Margherita Pizza',5,2000.00),(15,8,'Pepperoni Pizza',3,1560.00),(16,9,'Pepperoni Pizza',3,1560.00),(17,10,'Pepperoni Pizza',4,2080.00),(18,11,'Pepperoni Pizza',4,2080.00),(19,12,'Pepperoni Pizza',4,2080.00),(20,13,'Pepperoni Pizza',4,2080.00),(21,14,'Margherita Pizza',5,2000.00),(22,15,'Pepperoni Pizza',2,1040.00),(23,16,'Pepperoni Pizza',4,2080.00),(24,17,'Chicken Cheese Burger',1,300.00),(25,17,'Crispy French Fries',1,150.00),(26,17,'Chicken Momo',1,180.00),(27,17,'Pistachio Ice-cream',1,260.00),(28,17,'Blue Berry Ice-cream',1,300.00),(29,17,'Cold Coffee',1,180.00),(30,18,'Blue Berry Ice-cream',2,600.00),(31,19,'Chicken Cheese Burger',1,300.00),(32,19,'Crispy French Fries',1,150.00),(33,19,'Spicy Wings (6 pcs)',1,280.00),(34,19,'Chocolate Lava Cake',2,500.00),(35,19,'Chicken Momo',1,180.00),(36,19,'Blue Berry Ice-cream',1,300.00),(37,19,'Blue Heaven Mojito',1,220.00),(38,20,'Margherita Pizza',3,1200.00),(39,20,'Blue Heaven Mojito',3,660.00),(40,21,'Chicken Cheese Burger',3,900.00),(41,21,'Chicken Momo',2,360.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(10) DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `order_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('preparing','ready','delivered') DEFAULT 'preparing',
  `placed_by` varchar(10) DEFAULT NULL,
  `discount` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (2,'C0004',520.00,'2025-08-06 13:41:48','delivered',NULL,0.00),(3,'C0004',1989.00,'2025-08-06 13:42:08','delivered',NULL,351.00),(4,'C0003',1240.00,'2025-08-06 13:50:17','delivered','W001',0.00),(5,'C0001',1275.00,'2025-08-06 13:55:35','delivered','W001',225.00),(6,'C0001',1836.00,'2025-08-06 13:59:39','delivered','W001',324.00),(7,'C0001',1700.00,'2025-08-06 14:04:54','delivered','W001',300.00),(8,'C0001',1326.00,'2025-08-06 14:06:42','delivered','W001',234.00),(9,'C0001',1326.00,'2025-08-06 14:06:42','delivered','W001',234.00),(10,'C0001',1768.00,'2025-08-06 14:08:34','delivered','W001',312.00),(11,'C0001',1768.00,'2025-08-06 14:08:34','delivered','W001',312.00),(12,'C0001',1768.00,'2025-08-06 14:12:04','delivered','W001',312.00),(13,'C0002',1768.00,'2025-08-06 14:12:31','delivered','W001',312.00),(14,'C0002',1700.00,'2025-08-06 14:20:27','delivered','W001',300.00),(15,'C0005',1040.00,'2025-08-06 14:39:38','delivered',NULL,0.00),(16,'C0002',1768.00,'2025-08-06 14:40:58','delivered','W001',312.00),(17,'C0004',1370.00,'2025-08-06 15:08:27','delivered',NULL,0.00),(18,'C0004',600.00,'2025-08-06 15:14:34','delivered',NULL,0.00),(19,'C0007',1640.50,'2025-08-06 17:03:29','delivered',NULL,289.50),(20,'C0002',1581.00,'2025-08-06 17:05:42','preparing','W001',279.00),(21,'C0004',1260.00,'2026-02-11 09:42:21','preparing',NULL,0.00);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `user_id` varchar(10) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `status` enum('paid','unpaid','failed') DEFAULT 'unpaid',
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  KEY `order_id` (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,2,'C0004',520.00,'Card','paid','2025-08-06 13:41:48'),(2,3,'C0004',1989.00,'bKash','paid','2025-08-06 13:42:08'),(3,4,'C0003',1240.00,'not_selected','unpaid','2025-08-06 13:50:17'),(4,5,'C0001',1275.00,'not_selected','unpaid','2025-08-06 13:55:35'),(5,6,'C0001',1836.00,'not_selected','unpaid','2025-08-06 13:59:39'),(6,7,'C0001',1700.00,'not_selected','unpaid','2025-08-06 14:04:54'),(7,8,'C0001',1326.00,'not_selected','unpaid','2025-08-06 14:06:42'),(8,9,'C0001',1326.00,'not_selected','unpaid','2025-08-06 14:06:42'),(9,10,'C0001',1768.00,'not_selected','unpaid','2025-08-06 14:08:34'),(10,11,'C0001',1768.00,'not_selected','unpaid','2025-08-06 14:08:34'),(11,12,'C0001',1768.00,'not_selected','unpaid','2025-08-06 14:12:04'),(12,13,'C0002',1768.00,'not_selected','unpaid','2025-08-06 14:12:31'),(13,14,'C0002',1700.00,'not_selected','unpaid','2025-08-06 14:20:27'),(14,15,'C0005',1040.00,'Card','paid','2025-08-06 14:39:38'),(15,16,'C0002',1768.00,'not_selected','unpaid','2025-08-06 14:40:58'),(16,17,'C0004',1370.00,'bKash','paid','2025-08-06 15:08:27'),(17,18,'C0004',600.00,'Card','paid','2025-08-06 15:14:34'),(18,19,'C0007',1640.50,'bKash','paid','2025-08-06 17:03:29'),(19,20,'C0002',1581.00,'not_selected','unpaid','2025-08-06 17:05:42'),(20,21,'C0004',1260.00,'Cash','paid','2026-02-11 09:42:22');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` varchar(10) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` enum('admin','waiter','kitchen','customer') NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('A001','admin1','admin123','admin'),('A002','admin2','admin456','admin'),('C0001','customer1','cust123','customer'),('C0002','customer2','cust456','customer'),('C0003','customer3','cust789','customer'),('C0004','Sunehra','sunehra','customer'),('C0005','Kazi','kazi','customer'),('C0006','rimjhim','rimjhim','customer'),('C0007','Tajriyan','tajriyan','customer'),('K001','kitchen1','kitchen123','kitchen'),('K002','kitchen2','kitchen456','kitchen'),('W001','waiter1','waiter123','waiter'),('W002','waiter2','waiter456','waiter'),('W003','taz123','taz123','waiter');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waiters`
--

DROP TABLE IF EXISTS `waiters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `waiters` (
  `user_id` varchar(10) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `shift_time` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `waiters_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waiters`
--

LOCK TABLES `waiters` WRITE;
/*!40000 ALTER TABLE `waiters` DISABLE KEYS */;
INSERT INTO `waiters` VALUES ('W001','Imran Chowdhury','Morning'),('W002','Niloy Ahmed','Evening'),('W003','Tajwar Fairuz',NULL);
/*!40000 ALTER TABLE `waiters` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-11 16:32:59
