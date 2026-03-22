-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: phishguard_db
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'admin','$2b$12$IJqSUkNWJl.vRBV5a4LCiuoGqHATjKJhmRZuEYJk8acUAwtewqwyi','2026-01-18 15:25:14','2026-02-01 11:05:11',1);
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_scan_details`
--

DROP TABLE IF EXISTS `email_scan_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_scan_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `scan_id` int NOT NULL,
  `sender_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_scan_id` (`scan_id`),
  CONSTRAINT `email_scan_details_ibfk_1` FOREIGN KEY (`scan_id`) REFERENCES `scan_history` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_scan_details`
--

LOCK TABLES `email_scan_details` WRITE;
/*!40000 ALTER TABLE `email_scan_details` DISABLE KEYS */;
INSERT INTO `email_scan_details` VALUES (1,9,'pavanborkar04@gmail.com','pavanborkar04@gmail.com','dfdfdfdfdf'),(2,17,'raj@gamil.com','asbcdaas[','gg2bdyg\'ofoweu0fnfwbdc'),(3,18,'raj@gamil.com','asbcdaas[','gg2bdyg\'ofoweu0fnfwbdc\n\nhttps://bring-practices-where-reading.trycloudflare.com'),(4,33,'Attacter@gmail.com','Your Account Has Been Temporarily Restricted','Dear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using t...'),(5,46,'Attctor@gamil.com','Action Required: Complete KYC to Avoid Service Interruption','Dear User,\n\nAs per the latest RBI guidelines, your KYC is pending verification.\n\nFailure to complete KYC will result in suspension of UPI and wallet services.\n\nComplete your KYC now to continue uninte...'),(6,47,'Attctor@gamil.com','Complete KYC to Avoid Service Interruption','Dear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using t...'),(7,57,'Attactor@gmail.com','Your Account Has Been Temporarily Restricted','Dear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using t...'),(8,58,'Attactor@gmail.com','Your Account Has Been Temporarily Restricted','Dear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using t...'),(9,59,'N/A','Your Account Has Been Temporarily Restricted','Dear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using t...'),(10,60,'Attactor@gmail.com','Your Account Has Been Temporarily Restricted','N/A'),(11,61,'Attactor@gmail.com','N/A','Dear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using t...'),(12,84,'support@amazon.com','Your order has been shipped','Hello Chetan,\nYour recent order #124578 has been shipped and will arrive by Friday.\nYou can track your order in your Amazon account.'),(13,90,'support@amazon.com','Your order has been shipped','Hello Chetan,\nYour recent order #124578 has been shipped and will arrive by Friday.\nYou can track your order in your Amazon account.'),(14,91,'support-team@amaz0n-alert.xyz','Action required – account problem','Dear user,\nWe noticed unusual activity on your account.\nPlease verify your details to avoid suspension'),(15,92,'support-team@amaz0n-alert.xyz','Action required – account problem','Dear Customer,\nYour KYC is incomplete. Kindly update immediately to continue services.'),(16,93,'alerts@sbi-secure-login.xyz','Your SBI account will be suspended today','Dear Customer,\nYour account has been temporarily locked due to unusual activity.\nVerify immediately or your account will be permanently blocked.');
/*!40000 ALTER TABLE `email_scan_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scan_history`
--

DROP TABLE IF EXISTS `scan_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scan_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `scan_type` enum('url','email','message','banking') COLLATE utf8mb4_unicode_ci NOT NULL,
  `scan_subtype` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'For banking: credit-card or bank-account',
  `input_content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The content that was scanned',
  `risk_score` int NOT NULL,
  `status` enum('safe','suspicious','phishing') COLLATE utf8mb4_unicode_ci NOT NULL,
  `detection_reasons` json DEFAULT NULL COMMENT 'Array of reasons for the detection',
  `scan_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IPv4 or IPv6 address',
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_scan_type` (`scan_type`),
  KEY `idx_status` (`status`),
  KEY `idx_timestamp` (`scan_timestamp`),
  KEY `idx_risk_score` (`risk_score`),
  CONSTRAINT `scan_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `scan_history_chk_1` CHECK (((`risk_score` >= 0) and (`risk_score` <= 100)))
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scan_history`
--

LOCK TABLES `scan_history` WRITE;
/*!40000 ALTER TABLE `scan_history` DISABLE KEYS */;
INSERT INTO `scan_history` VALUES (1,NULL,'url',NULL,'http://suspicious-bank-login.com/verify',85,'phishing','[\"No HTTPS encryption detected\", \"Suspicious keyword: verify\", \"Unusual domain pattern\"]','2026-01-18 15:25:14',NULL,NULL),(2,NULL,'email',NULL,'Subject: Urgent Account Verification Required\nBody: Click here to verify your account immediately',75,'phishing','[\"Urgency tactic detected\", \"Clickbait detected\", \"Generic greeting\"]','2026-01-18 15:25:14',NULL,NULL),(3,NULL,'message',NULL,'Congratulations! You won $1,000,000. Send $500 for processing.',90,'phishing','[\"Prize scam detected\", \"Money request detected\"]','2026-01-18 15:25:14',NULL,NULL),(4,NULL,'url',NULL,'https://google.com',10,'safe','[]','2026-01-18 15:25:14',NULL,NULL),(5,NULL,'banking',NULL,'Card Number: 4532-1234-5678-9012\nCVV: 123',95,'phishing','[\"Card number pattern detected\", \"CVV request detected\"]','2026-01-18 15:25:14',NULL,NULL),(6,NULL,'url',NULL,'https://accounts.google.com',0,'safe','[]','2026-01-18 19:00:12','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(7,NULL,'url',NULL,'https://deogiricollege.org',0,'safe','[]','2026-01-18 19:11:09','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(8,NULL,'url',NULL,'https://github.com',0,'safe','[]','2026-01-20 10:10:50','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(9,NULL,'email',NULL,'From: pavanborkar04@gmail.com\nSubject: pavanborkar04@gmail.com\n\ndfdfdfdfdf',0,'safe','[]','2026-01-20 10:11:15','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(10,NULL,'url',NULL,'https://deogiricollege.org',0,'safe','[]','2026-01-21 08:27:03','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(11,NULL,'url',NULL,'hxxps://secure-paytm-verification[.]co/login-update',25,'safe','[\"No HTTPS\"]','2026-01-21 08:30:26','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(12,NULL,'url',NULL,'hxxps://upi-alert-confirm[.]top/update',25,'safe','[\"No HTTPS\"]','2026-01-21 08:31:25','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(13,NULL,'message','sms','“Your bank account has been temporarily suspended due to suspicious activity.\nVerify immediately to avoid permanent blocking:\nhxxp://secure-bank-verification[.]info\nRef ID: 847392”',0,'safe','[]','2026-01-21 08:32:32','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(14,NULL,'url',NULL,'://upi-alert-confirm[.]top/update',25,'safe','[\"No HTTPS\"]','2026-01-21 08:33:13','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(15,NULL,'url',NULL,'https://bring-practices-where-reading.trycloudflare.com',0,'safe','[]','2026-01-21 09:07:34','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(16,NULL,'url',NULL,'https://bring-practices-where-reading.trycloudflare.com',0,'safe','[]','2026-01-21 10:08:05','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(17,NULL,'email',NULL,'From: raj@gamil.com\nSubject: asbcdaas[\n\ngg2bdyg\'ofoweu0fnfwbdc',0,'safe','[]','2026-01-21 10:14:24','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(18,NULL,'email',NULL,'From: raj@gamil.com\nSubject: asbcdaas[\n\ngg2bdyg\'ofoweu0fnfwbdc\n\nhttps://bring-practices-where-reading.trycloudflare.com',0,'safe','[]','2026-01-21 10:15:04','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(19,NULL,'url',NULL,'hxxp://bankofindia-auth[.]info/verify',40,'suspicious','[\"No HTTPS encryption detected\", \"Suspicious keyword detected: verify\"]','2026-01-21 11:12:42','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(20,NULL,'url',NULL,'hxxps://amazon-refund-secure[.]co/signin',25,'safe','[\"No HTTPS encryption detected\"]','2026-01-21 11:13:09','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(21,NULL,'url',NULL,'hxxps://aadhaar-linking-alert[.]xyz/confirm',40,'suspicious','[\"No HTTPS encryption detected\", \"Suspicious keyword detected: confirm\"]','2026-01-21 11:13:42','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(22,NULL,'url',NULL,'hxxp://netbanking-secure-check[.]co/validate',25,'safe','[\"No HTTPS encryption detected\"]','2026-01-21 11:14:01','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(23,NULL,'url',NULL,'hxxps://delivery-failed-update[.]xyz/track',25,'safe','[\"No HTTPS encryption detected\"]','2026-01-21 11:14:16','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(24,NULL,'email',NULL,'From: goverment@gmail.com\nSubject: Your Account Has Been Temporarily Restricted\n\nDear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using the secure link below:\n\nhxxps://secure-bank-verification[.]info/login\n\nIf verification is not completed within 24 hours, your account may be permanently suspended.\n\nThank you for your prompt attention.\n\nSecurity Team\nYour Bank',65,'phishing','[\"Urgency tactic: immediately\", \"Generic greeting detected\", \"Threat language detected\"]','2026-01-21 11:16:41','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(25,NULL,'email',NULL,'From: mahadbt@gmail.com\nSubject: Complete KYC to Avoid Service Interruption\n\nDear User,\n\nAs per the latest RBI guidelines, your KYC is pending verification.\n\nFailure to complete KYC will result in suspension of UPI and wallet services.\n\nComplete your KYC now to continue uninterrupted services:\n\nhxxps://upi-kyc-update[.]xyz/verify\n\nRegards,\nCompliance Department\nDigital Payments Team',15,'safe','[\"Generic greeting detected\"]','2026-01-21 11:17:49','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(26,NULL,'url',NULL,'hxxps://delivery-failed-update[.]xyz/track',25,'safe','[\"No HTTPS\"]','2026-01-21 11:32:00','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(27,NULL,'url',NULL,'hxxps://delivery-failed-update[.]xyz/track',25,'safe','[\"No HTTPS\"]','2026-01-21 11:56:30','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(28,NULL,'url',NULL,'hxxps://delivery-failed-update[.]xyz/track',35,'suspicious','[\"⚠️ No HTTPS - Connection is not encrypted\", \"⚠️ Suspicious path: login/verify/account\"]','2026-01-21 15:38:21','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(29,NULL,'url',NULL,'https://bring-practices-where-reading.trycloudflare.com',8,'safe','[\"⚠️ Multiple hyphens in domain\"]','2026-01-21 15:39:15','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(30,NULL,'url',NULL,'http://bring-practices-where-reading.trycloudflare.com',28,'safe','[\"⚠️ No HTTPS - Connection is not encrypted\", \"⚠️ Multiple hyphens in domain\"]','2026-01-21 15:40:22','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(31,NULL,'url',NULL,'hxxps://amazon-refund-secure[.]co/signin',35,'suspicious','[\"⚠️ No HTTPS - Connection is not encrypted\", \"⚠️ Suspicious path: login/verify/account\"]','2026-01-21 15:57:46','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(32,NULL,'url',NULL,'https://bring-practices-where-reading.trycloudflare.com',88,'phishing','[\"? High-risk temporary hosting provider: trycloudflare.com\", \"? High-entropy subdomain (entropy=3.59)\", \"? Randomized multi-token subdomain detected\", \"⚠️ Multiple hyphens in domain\"]','2026-01-21 15:58:12','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(33,NULL,'email',NULL,'From: Attacter@gmail.com\nSubject: Your Account Has Been Temporarily Restricted\n\nDear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using the secure link below:\n\nhxxps://secure-bank-verification[.]info/login\n\nIf verification is not completed within 24 hours, your account may be permanently suspended.\n\nThank you for your prompt attention.\n\nSecurity Team\nYour Bank',100,'phishing','[\"? Official org using free email provider\", \"⚠️ Generic greeting - no personalization\", \"? CRITICAL: Requests sensitive credentials\", \"? Threatens account closure\", \"? CRITICAL: Urgency + Financial + Credential pattern\"]','2026-01-21 15:59:09','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(34,NULL,'message','sms','“Your bank account has been temporarily suspended due to suspicious activity.\nVerify immediately to avoid permanent blocking:\nhxxp://secure-bank-verification[.]info\nRef ID: 847392',40,'suspicious','[\"⚠️ Claims to be financial institution\", \"⚠️ Creates false urgency\"]','2026-01-21 15:59:29','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(35,NULL,'banking','credit-card','Card Number: 1234122132141\nCVV: 123\nMessage: ALERT: Your CREDIT CARD ending XXXX has been BLOCKED due to suspicious international usage of ₹42,900.\nVerify immediately to avoid permanent deactivation:\nhxxp://card-security-update[.]xyz\nRef: CC9821',60,'phishing','[\"? CRITICAL: CVV/security code request\", \"⚠️ Urgency tactics detected\"]','2026-01-21 16:01:28','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(36,NULL,'banking','account','Account Number: 12345678901\nRouting: 1234\nSSN: 11223344',85,'phishing','[\"? Bank account number detected\", \"? Routing number detected\"]','2026-01-21 16:02:01','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(37,NULL,'url',NULL,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com',88,'phishing','[\"? High-risk temporary hosting provider: trycloudflare.com\", \"? High-entropy subdomain (entropy=3.74)\", \"? Randomized multi-token subdomain detected\", \"⚠️ Multiple hyphens in domain\"]','2026-01-21 16:26:15','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(38,NULL,'url',NULL,'https://deogiricollege.org/',0,'safe','[\"✅ No threats detected\"]','2026-01-21 16:27:31','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(39,NULL,'url',NULL,'https://deogiricollege.org',0,'safe','[\"✅ No threats detected\"]','2026-01-21 16:27:39','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(40,NULL,'url',NULL,'hxxps://income-tax-refund[.]info/login',35,'suspicious','[\" No HTTPS - Connection is not encrypted\", \" Suspicious path: login/verify/account\"]','2026-01-22 04:59:39','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(41,NULL,'url',NULL,'hxxps://upi-alert-confirm[.]top/update',35,'suspicious','[\" No HTTPS - Connection is not encrypted\", \" Suspicious path: login/verify/account\"]','2026-01-22 04:59:56','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(42,NULL,'url',NULL,'https://bring-practices-where-reading.trycloudflare.com',88,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.59)\", \" Randomized multi-token subdomain detected\", \" Multiple hyphens in domain\"]','2026-01-22 05:00:41','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(43,NULL,'url',NULL,'http://bring-practices-where-reading.trycloudflare.com',100,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.59)\", \" Randomized multi-token subdomain detected\", \" No HTTPS - Connection is not encrypted\", \" Multiple hyphens in domain\"]','2026-01-22 05:00:56','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(44,NULL,'url',NULL,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com',88,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.74)\", \" Randomized multi-token subdomain detected\", \" Multiple hyphens in domain\"]','2026-01-22 05:01:24','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(45,NULL,'url',NULL,'http://triumph-illustrated-downloaded-endorsement.trycloudflare.com',100,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.74)\", \" Randomized multi-token subdomain detected\", \" No HTTPS - Connection is not encrypted\", \" Multiple hyphens in domain\"]','2026-01-22 05:01:34','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(46,NULL,'email',NULL,'From: Attctor@gamil.com\nSubject: Action Required: Complete KYC to Avoid Service Interruption\n\nDear User,\n\nAs per the latest RBI guidelines, your KYC is pending verification.\n\nFailure to complete KYC will result in suspension of UPI and wallet services.\n\nComplete your KYC now to continue uninterrupted services:\n\nhxxps://upi-kyc-update[.]xyz/verify\n\nRegards,\nCompliance Department\nDigital Payments Team',33,'suspicious','[\" Urgency tactics in subject\", \" Generic greeting - no personalization\"]','2026-01-22 05:02:40','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(47,NULL,'email',NULL,'From: Attctor@gamil.com\nSubject: Complete KYC to Avoid Service Interruption\n\nDear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using the secure link below:\n\nhxxps://secure-bank-verification[.]info/login\n\nIf verification is not completed within 24 hours, your account may be permanently suspended.\n\nThank you for your prompt attention.\n\nSecurity Team\nYour Bank',98,'phishing','[\" Generic greeting - no personalization\", \" CRITICAL: Requests sensitive credentials\", \" Threatens account closure\", \" CRITICAL: Urgency + Financial + Credential pattern\"]','2026-01-22 05:03:16','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(48,NULL,'message','sms','Your bank account has been temporarily suspended due to suspicious activity.\nVerify immediately to avoid permanent blocking:\nhxxp://secure-bank-verification[.]info\nRef ID: 847392',40,'suspicious','[\" Claims to be financial institution\", \" Creates false urgency\"]','2026-01-22 05:03:51','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(49,NULL,'banking','credit-card','Card Number: 1234122132141\nCVV: Abss\nMessage: ALERT: Your CREDIT CARD ending XXXX has been BLOCKED due to suspicious international usage of ₹42,900.\nVerify immediately to avoid permanent deactivation:\nhxxp://card-security-update[.]xyz\nRef: CC9821',60,'phishing','[\" CRITICAL: CVV/security code request\", \" Urgency tactics detected\"]','2026-01-22 05:04:36','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(50,NULL,'url',NULL,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com',88,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.74)\", \" Randomized multi-token subdomain detected\", \" Multiple hyphens in domain\"]','2026-01-22 08:31:46','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(51,NULL,'url',NULL,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com',88,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.74)\", \" Randomized multi-token subdomain detected\", \" Multiple hyphens in domain\"]','2026-01-22 08:34:24','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(52,NULL,'url',NULL,'http://triumph-illustrated-downloaded-endorsement.trycloudflare.com',100,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.74)\", \" Randomized multi-token subdomain detected\", \" No HTTPS - Connection is not encrypted\", \" Multiple hyphens in domain\"]','2026-01-22 08:34:33','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(53,NULL,'url',NULL,'hxxps://income-tax-refund[.]info/login',35,'suspicious','[\" No HTTPS - Connection is not encrypted\", \" Suspicious path: login/verify/account\"]','2026-01-22 08:35:34','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(54,NULL,'url',NULL,'hxxp://income-tax-refund[.]info/login',35,'suspicious','[\" No HTTPS - Connection is not encrypted\", \" Suspicious path: login/verify/account\"]','2026-01-22 08:36:09','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(55,NULL,'url',NULL,'hxxps://income-tax-refund[.]info/login',35,'suspicious','[\" No HTTPS - Connection is not encrypted\", \" Suspicious path: login/verify/account\"]','2026-01-22 08:36:18','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(56,NULL,'url',NULL,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com',88,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.74)\", \" Randomized multi-token subdomain detected\", \" Multiple hyphens in domain\"]','2026-01-22 08:36:45','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(57,NULL,'email',NULL,'From: Attactor@gmail.com\nSubject: Your Account Has Been Temporarily Restricted\n\nDear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using the secure link below:\n\nhxxps://secure-bank-verification[.]info/login\n\nIf verification is not completed within 24 hours, your account may be permanently suspended.\n\nThank you for your prompt attention.\n\nSecurity Team\nYour Bank',100,'phishing','[\" Official org using free email provider\", \" Generic greeting - no personalization\", \" CRITICAL: Requests sensitive credentials\", \" Threatens account closure\", \" CRITICAL: Urgency + Financial + Credential pattern\"]','2026-01-22 08:38:07','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(58,NULL,'email',NULL,'From: Attactor@gmail.com\nSubject: Your Account Has Been Temporarily Restricted\n\nDear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using the secure link below:\n\nhxxps://secure-bank-verification[.]info/login\n\nIf verification is not completed within 24 hours, your account may be permanently suspended.\n\nThank you for your prompt attention.\n\nSecurity Team\nYour Bank',100,'phishing','[\" Official org using free email provider\", \" Generic greeting - no personalization\", \" CRITICAL: Requests sensitive credentials\", \" Threatens account closure\", \" CRITICAL: Urgency + Financial + Credential pattern\"]','2026-01-22 08:38:55','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(59,NULL,'email',NULL,'From: \nSubject: Your Account Has Been Temporarily Restricted\n\nDear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using the secure link below:\n\nhxxps://secure-bank-verification[.]info/login\n\nIf verification is not completed within 24 hours, your account may be permanently suspended.\n\nThank you for your prompt attention.\n\nSecurity Team\nYour Bank',98,'phishing','[\" Generic greeting - no personalization\", \" CRITICAL: Requests sensitive credentials\", \" Threatens account closure\", \" CRITICAL: Urgency + Financial + Credential pattern\"]','2026-01-22 08:39:57','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(60,NULL,'email',NULL,'From: Attactor@gmail.com\nSubject: Your Account Has Been Temporarily Restricted\n\n',0,'safe','[\" No threats detected\"]','2026-01-22 08:40:26','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(61,NULL,'email',NULL,'From: Attactor@gmail.com\nSubject: \n\nDear Customer,\n\nWe detected unusual activity on your account and have temporarily restricted access for your protection.\n\nTo restore full access, please verify your account details immediately using the secure link below:\n\nhxxps://secure-bank-verification[.]info/login\n\nIf verification is not completed within 24 hours, your account may be permanently suspended.\n\nThank you for your prompt attention.\n\nSecurity Team\nYour Bank',100,'phishing','[\" Official org using free email provider\", \" Generic greeting - no personalization\", \" CRITICAL: Requests sensitive credentials\", \" Threatens account closure\", \" CRITICAL: Urgency + Financial + Credential pattern\"]','2026-01-22 08:40:45','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(62,NULL,'message','sms','Your bank account has been temporarily suspended due to suspicious activity.\nVerify immediately to avoid permanent blocking:\nhxxp://secure-bank-verification[.]info\nRef ID: 847392',40,'suspicious','[\" Claims to be financial institution\", \" Creates false urgency\"]','2026-01-22 08:41:27','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(63,NULL,'message','sms','Discover your Dream Home @ Marina Enclave, Malad (W), READY TO MOVE 1,2&3 BHK with World Class Lifestyle Amenities. Visit today. Call - 02241498045. T&C',0,'safe','[\" No threats detected\"]','2026-01-22 08:44:03','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(64,NULL,'message','sms','Personal Loan Offer Alert !  Starting @ Rs. 5000. Instant approval, No collateral through Vi finance. Apply Now : https://viapp.onelink.me/bSC3/pl1',20,'safe','[\" Contains link\"]','2026-01-22 08:45:50','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(65,NULL,'message','sms','Personal Loan Offer Alert !  Starting @ Rs. 5000. Instant approval, No collateral through Vi finance. Apply Now',0,'safe','[\" No threats detected\"]','2026-01-22 08:46:13','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(66,NULL,'banking','credit-card','Card Number: 1234122132141\nCVV: abcd\nMessage: ALERT: Your CREDIT CARD ending XXXX has been BLOCKED due to suspicious international usage of ₹42,900.\nVerify immediately to avoid permanent deactivation:\nhxxp://card-security-update[.]xyz\nRef: CC9821',60,'phishing','[\" CRITICAL: CVV/security code request\", \" Urgency tactics detected\"]','2026-01-22 08:47:59','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(67,NULL,'message','sms','Congratulations! You have won ₹25,00,000 in TATA Lucky Draw.\nClaim now by calling +91-XXXXXXXXXX.”',30,'suspicious','[\" Prize/lottery scam pattern\"]','2026-01-22 08:51:22','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(68,NULL,'url',NULL,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com',88,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.74)\", \" Randomized multi-token subdomain detected\", \" Multiple hyphens in domain\"]','2026-01-23 02:41:58','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(69,NULL,'url',NULL,'http://triumph-illustrated-downloaded-endorsement.trycloudflare.com',100,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.74)\", \" Randomized multi-token subdomain detected\", \" No HTTPS - Connection is not encrypted\", \" Multiple hyphens in domain\"]','2026-01-23 02:42:36','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),(70,NULL,'url',NULL,'https://bring-practices-where-reading.trycloudflare.com',88,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.59)\", \" Randomized multi-token subdomain detected\", \" Multiple hyphens in domain\"]','2026-01-27 10:57:32','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(71,NULL,'banking','credit-card','Card Number: 1234122132141\nCVV: asbc\nMessage: ALERT: Your CREDIT CARD ending XXXX has been BLOCKED due to suspicious international usage of ₹42,900.\nVerify immediately to avoid permanent deactivation:\nhxxp://card-security-update[.]xyz\nRef: CC9821',60,'phishing','[\" CRITICAL: CVV/security code request\", \" Urgency tactics detected\"]','2026-01-27 11:02:07','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(72,NULL,'banking','account','Account Number: 43100214392\nRouting: 600300333\nSSN: 4522',100,'phishing','[\" CRITICAL: Bank account number detected (2 pattern(s))\", \" CRITICAL: SSN (Social Security Number) detected\", \" CRITICAL: 1 valid routing number(s) detected\", \" CRITICAL: Complete banking details requested\", \" Detected: Valid routing number, Bank account number found, SSN found\"]','2026-01-27 11:50:44','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(73,NULL,'banking','credit-card','Card Number: 6528989408029381\nCVV: 6528\nMessage: ',75,'phishing','[\" CRITICAL: CVV/security code requested\", \" CRITICAL: CVV number provided in text\", \" Detected: CVV number found, CVV request detected\"]','2026-01-27 11:55:34','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(74,NULL,'banking','credit-card','Card Number: 6528989408029381\nCVV: 6528\nMessage: ₹3,250 spent on your Credit Card XXXX at AMAZON on 26-01-2026.\nIf not you, call customer care immediately.',100,'phishing','[\" CRITICAL: CVV/security code requested\", \" CRITICAL: CVV number provided in text\", \" Expiry date pattern detected\", \" Urgency tactics - pressure to act quickly\", \" Detected: Card expiry date found, CVV number found, CVV request detected\"]','2026-01-27 11:59:07','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(75,NULL,'banking','credit-card','Card Number: 6528989408029381\nCVV: 6528\nMessage: Your OTP for credit card transaction of ₹8,999 is 483921.\nDo not share this OTP with anyone. Valid for 5 minutes',75,'phishing','[\" CRITICAL: CVV/security code requested\", \" CRITICAL: CVV number provided in text\", \" Detected: CVV number found, CVV request detected\"]','2026-01-27 12:01:34','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(76,NULL,'banking','credit-card','Card Number: 6528989408029381\nCVV: 6528\nMessage: ',75,'phishing','[\" CRITICAL: CVV/security code requested\", \" CRITICAL: CVV number provided in text\", \" Detected: CVV number found, CVV request detected\"]','2026-01-27 15:47:20','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(77,NULL,'banking','credit-card','Card Number: 6528989408029381\nCVV: 654\nMessage: ',75,'phishing','[\" CRITICAL: CVV/security code requested\", \" CRITICAL: CVV number provided in text\", \" Detected: CVV number found, CVV request detected\"]','2026-01-27 15:53:27','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(78,NULL,'url',NULL,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com',88,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.74)\", \" Randomized multi-token subdomain detected\", \" Multiple hyphens in domain\"]','2026-01-28 07:31:12','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(79,NULL,'url',NULL,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com',88,'phishing','[\" High-risk temporary hosting provider: trycloudflare.com\", \" High-entropy subdomain (entropy=3.74)\", \" Randomized multi-token subdomain detected\", \" Multiple hyphens in domain\"]','2026-01-28 10:06:37','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(80,NULL,'url',NULL,'https://bring-practices-where-reading.trycloudflare.com',98,'phishing','[\"▸ High-risk temporary hosting provider: trycloudflare.com\", \"▸ High-entropy subdomain (entropy=3.59)\", \"▸ Randomized multi-token subdomain detected\", \" Multiple hyphens in domain\", \"▸ Character obfuscation detected: One/l/I substitution\"]','2026-02-02 02:28:29','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(81,NULL,'url',NULL,'http://secure-google-login.tk',56,'suspicious','[\"▸ No HTTPS - Connection is not encrypted\", \"▸ High-risk domain extension (.tk)\", \" Multiple hyphens in domain\", \"▸ Character obfuscation detected: One/l/I substitution\"]','2026-02-02 08:07:14','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(82,NULL,'url',NULL,'http://google-account-recovery-secure.tk/login',71,'phishing','[\"▸ No HTTPS - Connection is not encrypted\", \"▸ High-risk domain extension (.tk)\", \" Multiple hyphens in domain\", \" Suspicious path: login/verify/account\", \"▸ Character obfuscation detected: One/l/I substitution\"]','2026-02-02 08:07:28','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(83,NULL,'url',NULL,'https://www.amazon.com',0,'safe','[\"No major threats detected\"]','2026-02-02 08:07:46','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(84,NULL,'email',NULL,'From: support@amazon.com\nSubject: Your order has been shipped\n\nHello Chetan,\nYour recent order #124578 has been shipped and will arrive by Friday.\nYou can track your order in your Amazon account.',0,'safe','[\" No threats detected\"]','2026-02-02 08:18:57','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(85,NULL,'message','sms','ALERT: Your CREDIT CARD ending XXXX has been BLOCKED due to suspicious international usage of ₹42,900.\nVerify immediately to avoid permanent deactivation:\nhxxp://card-security-update[.]xyz\nRef: CC9821',18,'safe','[\" Creates false urgency\"]','2026-02-02 08:22:17','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(86,NULL,'message','sms','Congratulations! Your credit card XXXX is eligible for ₹5,000 cashback.\nClaim before expiry by confirming card details:\nhxxps://reward-claim-secure[.]c',30,'suspicious','[\" Prize/lottery scam pattern\"]','2026-02-02 08:31:33','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(87,NULL,'url',NULL,'http://amazon-account-update.ml',56,'suspicious','[\"▸ No HTTPS - Connection is not encrypted\", \"▸ High-risk domain extension (.ml)\", \" Multiple hyphens in domain\", \"▸ Character obfuscation detected: One/l/I substitution\"]','2026-02-03 08:03:42','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(88,NULL,'url',NULL,'https://www.github.com',0,'safe','[\"No major threats detected\"]','2026-02-03 08:04:09','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(89,NULL,'url',NULL,'http://amazon-refund-claim.ml/update',71,'phishing','[\"▸ No HTTPS - Connection is not encrypted\", \"▸ High-risk domain extension (.ml)\", \" Multiple hyphens in domain\", \" Suspicious path: login/verify/account\", \"▸ Character obfuscation detected: One/l/I substitution\"]','2026-02-03 08:04:31','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(90,NULL,'email',NULL,'From: support@amazon.com\nSubject: Your order has been shipped\n\nHello Chetan,\nYour recent order #124578 has been shipped and will arrive by Friday.\nYou can track your order in your Amazon account.',0,'safe','[\" No threats detected\"]','2026-02-03 08:05:48','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(91,NULL,'email',NULL,'From: support-team@amaz0n-alert.xyz\nSubject: Action required – account problem\n\nDear user,\nWe noticed unusual activity on your account.\nPlease verify your details to avoid suspension',33,'suspicious','[\" Urgency tactics in subject\", \" Generic greeting - no personalization\"]','2026-02-03 08:06:45','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(92,NULL,'email',NULL,'From: support-team@amaz0n-alert.xyz\nSubject: Action required – account problem\n\nDear Customer,\nYour KYC is incomplete. Kindly update immediately to continue services.',63,'phishing','[\" Urgency tactics in subject\", \" Generic greeting - no personalization\", \" CRITICAL: Urgency + Financial + Credential pattern\"]','2026-02-03 08:07:06','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(93,NULL,'email',NULL,'From: alerts@sbi-secure-login.xyz\nSubject: Your SBI account will be suspended today\n\nDear Customer,\nYour account has been temporarily locked due to unusual activity.\nVerify immediately or your account will be permanently blocked.',83,'phishing','[\" Urgency tactics in subject\", \" Generic greeting - no personalization\", \" Clickbait detected\", \" CRITICAL: Urgency + Financial + Credential pattern\"]','2026-02-03 08:08:09','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(94,NULL,'message','sms','“Your OTP for login is 483920. Do not share this code with anyone. – ABC Bank”',22,'safe','[\" Claims to be financial institution\"]','2026-02-03 08:08:41','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(95,NULL,'message','sms','“Dear customer, your account has unusual activity. Verify immediately at: www.abcbank-verify.in”',60,'phishing','[\" Claims to be financial institution\", \" Contains link\", \" Creates false urgency\"]','2026-02-03 08:08:57','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),(96,NULL,'message','sms','“FINAL WARNING: Your bank account will be blocked in 30 minutes. Update KYC now or face permanent suspension. Click link immediately.”',65,'phishing','[\" Claims to be financial institution\", \" Creates false urgency\", \" Threatens account suspension\"]','2026-02-03 08:09:22','127.0.0.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36');
/*!40000 ALTER TABLE `scan_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `url_scan_details`
--

DROP TABLE IF EXISTS `url_scan_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `url_scan_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `scan_id` int NOT NULL,
  `url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `domain` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `protocol` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_https` tinyint(1) DEFAULT '0',
  `url_length` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_scan_id` (`scan_id`),
  KEY `idx_domain` (`domain`),
  CONSTRAINT `url_scan_details_ibfk_1` FOREIGN KEY (`scan_id`) REFERENCES `scan_history` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `url_scan_details`
--

LOCK TABLES `url_scan_details` WRITE;
/*!40000 ALTER TABLE `url_scan_details` DISABLE KEYS */;
INSERT INTO `url_scan_details` VALUES (1,8,'https://github.com','github.com','https',1,18),(2,10,'https://deogiricollege.org','deogiricollege.org','https',1,26),(3,11,'hxxps://secure-paytm-verification[.]co/login-update','hxxps','http',0,51),(4,12,'hxxps://upi-alert-confirm[.]top/update','hxxps','http',0,38),(5,14,'://upi-alert-confirm[.]top/update','','http',0,33),(6,15,'https://bring-practices-where-reading.trycloudflare.com','bring-practices-where-reading.trycloudflare.com','https',1,55),(7,16,'https://bring-practices-where-reading.trycloudflare.com','bring-practices-where-reading.trycloudflare.com','https',1,55),(8,26,'hxxps://delivery-failed-update[.]xyz/track','hxxps','http',0,42),(9,27,'hxxps://delivery-failed-update[.]xyz/track','hxxps','http',0,42),(10,28,'hxxps://delivery-failed-update[.]xyz/track','hxxps','http',0,42),(11,29,'https://bring-practices-where-reading.trycloudflare.com','bring-practices-where-reading.trycloudflare.com','https',1,55),(12,30,'http://bring-practices-where-reading.trycloudflare.com','bring-practices-where-reading.trycloudflare.com','http',0,54),(13,31,'hxxps://amazon-refund-secure[.]co/signin','hxxps','http',0,40),(14,32,'https://bring-practices-where-reading.trycloudflare.com','bring-practices-where-reading.trycloudflare.com','https',1,55),(15,37,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','https',1,68),(16,38,'https://deogiricollege.org/','deogiricollege.org','https',1,27),(17,39,'https://deogiricollege.org','deogiricollege.org','https',1,26),(18,40,'hxxps://income-tax-refund[.]info/login','hxxps','http',0,38),(19,41,'hxxps://upi-alert-confirm[.]top/update','hxxps','http',0,38),(20,42,'https://bring-practices-where-reading.trycloudflare.com','bring-practices-where-reading.trycloudflare.com','https',1,55),(21,43,'http://bring-practices-where-reading.trycloudflare.com','bring-practices-where-reading.trycloudflare.com','http',0,54),(22,44,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','https',1,68),(23,45,'http://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','http',0,67),(24,50,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','https',1,68),(25,51,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','https',1,68),(26,52,'http://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','http',0,67),(27,53,'hxxps://income-tax-refund[.]info/login','hxxps','http',0,38),(28,54,'hxxp://income-tax-refund[.]info/login','hxxp','http',0,37),(29,55,'hxxps://income-tax-refund[.]info/login','hxxps','http',0,38),(30,56,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','https',1,68),(31,68,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','https',1,68),(32,69,'http://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','http',0,67),(33,70,'https://bring-practices-where-reading.trycloudflare.com','bring-practices-where-reading.trycloudflare.com','https',1,55),(34,78,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','https',1,68),(35,79,'https://triumph-illustrated-downloaded-endorsement.trycloudflare.com','triumph-illustrated-downloaded-endorsement.trycloudflare.com','https',1,68),(36,80,'','','https',0,0),(37,81,'','','http',0,0),(38,82,'','','http',0,0),(39,83,'','','https',0,0),(40,87,'','','http',0,0),(41,88,'','','https',0,0),(42,89,'','','http',0,0);
/*!40000 ALTER TABLE `url_scan_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `reset_otp` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp_expiry` datetime DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_email` (`email`),
  KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'pawan','borkar','pavanborkar04@gmail.com','pawan borkar','$2b$12$IJqSUkNWJl.vRBV5a4LCiuoGqHATjKJhmRZuEYJk8acUAwtewqwyi','2026-01-18 18:59:34','2026-02-23 16:13:07',1,'scrypt:32768:8:1$xFEku8SuFIv8z3U5$c272e3bebe38a3fa7c75e801239a93ed2e20c7432689357b1d164ff81c24c38bc268b90b2c70a541f3d1d0dfe32e883a774b583548ec004565ce024b2d10a57a','2026-01-20 16:26:15',0),(2,'vm','vm','vm04@gmail.com','Vam','$2b$12$EiQfCWFm57jSEMF8UBmX3eohK3EJDCTdaQpatU4IMXbXiY4c.gWFS','2026-01-27 16:03:46',NULL,1,NULL,NULL,0),(3,'vm','vm','vm05@gmail.com','Vmm','$2b$12$OmfSFBU3PdcRgZGAd43n0.QOhp2NXfq4ts2W.KC1CJsRx8ZirYW36','2026-01-27 16:04:54',NULL,1,NULL,NULL,0),(4,'ram','ram','ram@ram.ram','ram','$2b$12$UUwrqPwxktXVspv0pjIni.dFAyK8cZewDvnL1jYI9YGu.fVlFTdUC','2026-01-30 16:54:07',NULL,1,NULL,NULL,0),(5,'rohan','raj','r@r.com','rrr','$2b$12$E4Jp6VTO6G6NDjJyYQxojucKX6ixPRyC89JHZa6T6L6vtOwv/Rtwy','2026-01-30 16:58:42','2026-01-30 17:03:31',1,NULL,NULL,0),(6,'jon','ddd','d@d.com','jd3','$2b$12$aLU7FGiowYAv6DBmYWk.Hu2JX84X02fcbQzlcSZWJeWKkcuXl6.tm','2026-02-01 10:15:03','2026-02-01 10:15:37',1,NULL,NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_daily_scan_stats`
--

DROP TABLE IF EXISTS `v_daily_scan_stats`;
/*!50001 DROP VIEW IF EXISTS `v_daily_scan_stats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_daily_scan_stats` AS SELECT 
 1 AS `scan_date`,
 1 AS `total_scans`,
 1 AS `safe_scans`,
 1 AS `suspicious_scans`,
 1 AS `phishing_scans`,
 1 AS `avg_risk_score`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_recent_scans`
--

DROP TABLE IF EXISTS `v_recent_scans`;
/*!50001 DROP VIEW IF EXISTS `v_recent_scans`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_recent_scans` AS SELECT 
 1 AS `id`,
 1 AS `scan_type`,
 1 AS `scan_subtype`,
 1 AS `risk_score`,
 1 AS `status`,
 1 AS `scan_timestamp`,
 1 AS `username`,
 1 AS `email`,
 1 AS `input_preview`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_user_scan_stats`
--

DROP TABLE IF EXISTS `v_user_scan_stats`;
/*!50001 DROP VIEW IF EXISTS `v_user_scan_stats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_user_scan_stats` AS SELECT 
 1 AS `user_id`,
 1 AS `username`,
 1 AS `email`,
 1 AS `total_scans`,
 1 AS `safe_scans`,
 1 AS `suspicious_scans`,
 1 AS `phishing_scans`,
 1 AS `avg_risk_score`,
 1 AS `last_scan_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_daily_scan_stats`
--

/*!50001 DROP VIEW IF EXISTS `v_daily_scan_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_daily_scan_stats` AS select cast(`scan_history`.`scan_timestamp` as date) AS `scan_date`,count(0) AS `total_scans`,sum((case when (`scan_history`.`status` = 'safe') then 1 else 0 end)) AS `safe_scans`,sum((case when (`scan_history`.`status` = 'suspicious') then 1 else 0 end)) AS `suspicious_scans`,sum((case when (`scan_history`.`status` = 'phishing') then 1 else 0 end)) AS `phishing_scans`,avg(`scan_history`.`risk_score`) AS `avg_risk_score` from `scan_history` group by cast(`scan_history`.`scan_timestamp` as date) order by `scan_date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_recent_scans`
--

/*!50001 DROP VIEW IF EXISTS `v_recent_scans`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_recent_scans` AS select `sh`.`id` AS `id`,`sh`.`scan_type` AS `scan_type`,`sh`.`scan_subtype` AS `scan_subtype`,`sh`.`risk_score` AS `risk_score`,`sh`.`status` AS `status`,`sh`.`scan_timestamp` AS `scan_timestamp`,`u`.`username` AS `username`,`u`.`email` AS `email`,substr(`sh`.`input_content`,1,150) AS `input_preview` from (`scan_history` `sh` left join `users` `u` on((`sh`.`user_id` = `u`.`id`))) order by `sh`.`scan_timestamp` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_user_scan_stats`
--

/*!50001 DROP VIEW IF EXISTS `v_user_scan_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_user_scan_stats` AS select `u`.`id` AS `user_id`,`u`.`username` AS `username`,`u`.`email` AS `email`,count(`sh`.`id`) AS `total_scans`,sum((case when (`sh`.`status` = 'safe') then 1 else 0 end)) AS `safe_scans`,sum((case when (`sh`.`status` = 'suspicious') then 1 else 0 end)) AS `suspicious_scans`,sum((case when (`sh`.`status` = 'phishing') then 1 else 0 end)) AS `phishing_scans`,avg(`sh`.`risk_score`) AS `avg_risk_score`,max(`sh`.`scan_timestamp`) AS `last_scan_date` from (`users` `u` left join `scan_history` `sh` on((`u`.`id` = `sh`.`user_id`))) group by `u`.`id`,`u`.`username`,`u`.`email` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-23 22:03:23
