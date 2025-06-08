-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: test_medicalrecord
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `cage`
--

DROP TABLE IF EXISTS `cage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cage` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `size` varchar(30) NOT NULL,
  `start_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT 'AVAILABLE',
  `type` varchar(50) NOT NULL,
  `pet_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK91w5oiti7u21t7ryc43jiosgu` (`pet_id`),
  CONSTRAINT `FKiwwro9ywbogpxka5dbf1kcra0` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cage`
--

/*!40000 ALTER TABLE `cage` DISABLE KEYS */;
INSERT INTO `cage` VALUES (2,'2025-06-01 15:36:35.362594','2025-06-01 15:36:38.433548',NULL,'Medium','2025-06-01','OCCUPIED','DOG',1),(3,'2025-06-08 03:35:12.149229','2025-06-08 03:35:16.125966',NULL,'Medium','2025-06-08','OCCUPIED','DOG',3),(4,'2025-06-08 16:48:30.366776','2025-06-08 16:48:30.366776','2025-06-11','Medium','2025-06-08','OCCUPIED','REPTILE',4);
/*!40000 ALTER TABLE `cage` ENABLE KEYS */;

--
-- Table structure for table `medical_record`
--

DROP TABLE IF EXISTS `medical_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `diagnosis` text NOT NULL,
  `next_meeting_date` date DEFAULT NULL,
  `notes` text,
  `prescription` text,
  `pet_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKbhn8ua3wkghyv8hsmbrangqeh` (`pet_id`),
  KEY `FK6ew6wrpw92slj8rggrcijwrrb` (`user_id`),
  CONSTRAINT `FK6ew6wrpw92slj8rggrcijwrrb` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `FKbhn8ua3wkghyv8hsmbrangqeh` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_record`
--

/*!40000 ALTER TABLE `medical_record` DISABLE KEYS */;
INSERT INTO `medical_record` VALUES (1,'2025-06-01 15:37:09.794301','2025-06-01 15:37:09.794301','Illness',NULL,'','Antibiotics',1,1),(2,'2025-06-08 02:58:55.120974','2025-06-08 02:58:55.120974','Sick','2025-06-08','Nothing','Medicine',3,1),(3,'2025-06-08 13:37:28.924110','2025-06-08 13:37:28.924110','Illness',NULL,'HEhe','Drugh',1,3),(4,'2025-06-08 15:12:32.351928','2025-06-08 15:12:32.351928','Sick Dog',NULL,'No note','Aspirin',1,3),(5,'2025-06-08 15:18:33.045839','2025-06-08 15:18:33.045839','Homesick','2025-06-08','No note','Aspirin',1,3),(6,'2025-06-08 15:23:56.098829','2025-06-08 15:23:56.098829','Abc problem','2025-06-08','No notes','Homesick',1,4),(7,'2025-06-08 16:35:38.588599','2025-06-08 16:35:38.588599','Homesick Just A Bit','2025-06-04','No notes','Aspirin',3,4),(8,'2025-06-08 16:48:03.409289','2025-06-08 16:48:03.409289','Blue Color','2025-06-08','No notes','Red dye',4,3);
/*!40000 ALTER TABLE `medical_record` ENABLE KEYS */;

--
-- Table structure for table `pet`
--

DROP TABLE IF EXISTS `pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pet` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `gender` enum('FEMALE','MALE') DEFAULT NULL,
  `health_info` text,
  `name` varchar(100) NOT NULL,
  `species` varchar(50) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKhg3enfwsufxjb6enqetxx2ku0` (`user_id`),
  CONSTRAINT `FKhg3enfwsufxjb6enqetxx2ku0` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pet`
--

/*!40000 ALTER TABLE `pet` DISABLE KEYS */;
INSERT INTO `pet` VALUES (1,'2025-06-01 13:56:26.473225','2025-06-01 13:56:26.473225','2024-06-01','Red','MALE','Strong','Trie','Dog',2),(3,'2025-06-03 13:11:54.595573','2025-06-03 13:11:54.595573','2024-06-03','White','MALE','OK','Cat','Cat',2),(4,'2025-06-08 16:47:45.124148','2025-06-08 16:47:45.124148','2025-06-08','Red','MALE','No health problems','Tree','Reptile',2);
/*!40000 ALTER TABLE `pet` ENABLE KEYS */;

--
-- Table structure for table `service_booking`
--

DROP TABLE IF EXISTS `service_booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_booking` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `notes` text,
  `start_date` date NOT NULL,
  `status` varchar(20) DEFAULT 'PENDING',
  `service_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKt3w9ltn327g2ogxprap5t8lg7` (`service_id`),
  KEY `FKtq47nakfc2onfthrftgmq90bt` (`user_id`),
  CONSTRAINT `FKt3w9ltn327g2ogxprap5t8lg7` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`),
  CONSTRAINT `FKtq47nakfc2onfthrftgmq90bt` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_booking`
--

/*!40000 ALTER TABLE `service_booking` DISABLE KEYS */;
INSERT INTO `service_booking` VALUES (1,'2025-06-01 23:41:52.722103','2025-06-01 23:41:52.722103',NULL,'Very good','2025-09-01','PENDING',2,2),(2,'2025-06-03 13:12:49.752314','2025-06-08 16:58:41.473181','2025-06-05','Tiem Vaccine Dai','2025-06-04','COMPLETED',2,2),(3,'2025-06-03 13:13:13.082029','2025-06-03 13:13:13.082029',NULL,'Cat tia long meo','2025-06-04','PENDING',5,2),(4,'2025-06-08 16:59:17.506529','2025-06-08 16:59:17.506529','2025-06-11','Nothing','2025-06-08','PENDING',2,2);
/*!40000 ALTER TABLE `service_booking` ENABLE KEYS */;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `category` enum('CARE','EMERGENCY','HEALTH','MEDICAL') DEFAULT NULL,
  `description` text,
  `name` varchar(100) NOT NULL,
  `price` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (1,'2025-06-01 16:11:04.163481','2025-06-01 16:11:04.163481','HEALTH','Comprehensive health check-up for your pet including physical examination, vital signs check, and basic health assessment.','Pet Health Examination',75),(2,'2025-06-01 16:11:04.198166','2025-06-01 16:11:04.198166','HEALTH','Complete vaccination service for pets including consultation and vaccine administration.','Vaccination Service',50),(3,'2025-06-01 16:11:04.219074','2025-06-01 16:11:04.219074','CARE','Professional pet boarding service with comfortable accommodation, daily care, feeding, and exercise.','Pet Boarding Service',45),(4,'2025-06-01 16:11:04.232938','2025-06-01 16:11:04.232938','CARE','Daily pet care service for working pet owners, includes feeding, exercise, and socialization.','Pet Daycare',35),(5,'2025-06-01 16:11:04.260817','2025-06-01 16:11:04.260817','CARE','Complete grooming service including bathing, brushing, nail trimming, and styling.','Pet Grooming Service',60),(6,'2025-06-01 16:11:04.267734','2025-06-01 16:11:04.267734','HEALTH','Professional dental cleaning and oral health examination for pets.','Dental Cleaning',120),(7,'2025-06-01 16:11:04.288628','2025-06-01 16:11:04.288628','EMERGENCY','24/7 emergency medical treatment for urgent pet health issues.','Emergency Treatment',200),(8,'2025-06-01 16:11:04.302322','2025-06-01 16:11:04.302322','MEDICAL','Pre-surgery consultation and planning with experienced veterinary surgeons.','Surgery Consultation',150);
/*!40000 ALTER TABLE `services` ENABLE KEYS */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `roles` varchar(20) DEFAULT 'OWNER',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK6dotkott2kjsp8vw4d0m25fb7` (`email`),
  UNIQUE KEY `UKdu5v5sr43g5bfnji4vb8hg5s3` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'2025-05-31 19:03:25.211119','2025-05-31 19:03:25.211119','admin@example.com','Admin','$2a$10$lEllMb1X8Pk0m4MLIleSce.OgydT7sDkTvx9xMRSNNGg0UI879fUq','0123456789','ADMIN'),(2,'2025-05-31 19:03:25.310643','2025-05-31 19:03:25.310643','owner@example.com','Owner','$2a$10$N2cP0bNgoX.J8oWfUm1m6OK8LsEaNOZIbhFfy5vybxLthc1EMngSO','0123456790','OWNER'),(3,'2025-05-31 19:03:25.377573','2025-05-31 19:03:25.377573','staff@example.com','Staff','$2a$10$l.BfldtrmUjuBD/Axow2FeIA0S/FzlvvMgV8ZLe9HOAU0LCQUlXly','0123456791','STAFF'),(4,'2025-05-31 19:03:25.445173','2025-05-31 19:03:25.445173','doctor@example.com','Doctor','$2a$10$dOY/fOZSSx9lPW/1KfFDVum3ZMBRIcK3yI7I3OA3r.zGo2AnK8no.','0123456792','DOCTOR');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

--
-- Dumping routines for database 'test_medicalrecord'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-08 17:12:08
