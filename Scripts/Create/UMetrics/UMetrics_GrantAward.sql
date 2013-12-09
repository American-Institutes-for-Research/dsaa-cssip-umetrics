CREATE DATABASE  IF NOT EXISTS `UMetrics` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `UMetrics`;
-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com    Database: UMetrics
-- ------------------------------------------------------
-- Server version	5.6.13-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `GrantAward`
--

DROP TABLE IF EXISTS `GrantAward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GrantAward` (
  `GrantAwardId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for a GrantAward.',
  `EffectiveDate` date DEFAULT NULL COMMENT 'The logical definition for this is the date the award was granted, however, the exact definition may vary a little from source to source.  For example, in ExPORTER, this is the date the official notice of approval was generated.',
  `StartDate` date DEFAULT NULL COMMENT 'Date work on this project began.',
  `ExpirationDate` date DEFAULT NULL COMMENT 'Date funds for this grant expired.',
  `Amount` decimal(13,2) DEFAULT NULL COMMENT 'The amount of the award.',
  `EstimatedAmount` decimal(13,2) DEFAULT NULL COMMENT 'The total estimated cost of the award.  This includes anticipated increments.',
  `ARRAAmount` decimal(13,2) DEFAULT NULL COMMENT 'The amount of the award attributed to the American Recovery and Reinvestment Act of 2009.',
  `Title` text COMMENT 'The title or description of the project.',
  PRIMARY KEY (`GrantAwardId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Money given by a granting institution for goods and services.  These monies are typically given from one organization to another for work to be performed by persons at the awardee institution, but these persons may not necessarily be employed by the recipient institution.  Also, money is frequently used to purchase external goods and services (those offered by third parties).  We are unable to obtain that information as of this writing, so for now, we are only concerned with the top leveling grant disbursement.';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-06 10:56:20
