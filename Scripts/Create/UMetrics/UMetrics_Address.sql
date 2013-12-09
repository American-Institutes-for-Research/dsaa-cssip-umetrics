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
-- Table structure for table `Address`
--

DROP TABLE IF EXISTS `Address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Address` (
  `AddressId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an Address.',
  `Street1` varchar(100) DEFAULT NULL COMMENT 'First line of the street address.',
  `Street2` varchar(100) DEFAULT NULL COMMENT 'Second line of the street address.',
  `City` varchar(100) DEFAULT NULL COMMENT 'Name of the city.',
  `CountyEquivalent` varchar(100) DEFAULT NULL COMMENT 'This would be a high level subdivision of a state equivalent.  For example, a county, parish, or borough.',
  `StateEquivalent` varchar(100) DEFAULT NULL COMMENT 'This would be a highest level subdivision of a country.  For example, a state, territory, or province.',
  `PostalCode` varchar(100) DEFAULT NULL COMMENT 'ZIP Code in the United States (PLUS 4 or not).  Postal code in most of the rest of the world.',
  `CountryName` varchar(100) DEFAULT NULL COMMENT 'The full name of the country.',
  `FullAddress` text COMMENT 'A full address in cases where we are unsure of the address breakdown.',
  PRIMARY KEY (`AddressId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='An address.  Any address.  Person?  Place?  Thing?  No problem!  If it''s got an address, that address goes here.  It is possible for objects to share addresses since people and organizations move and sublet space.  Technically, an address is worthless if it has no attributes, so consider restricting what goes in this table to only valuable data.  Also, some addresses will be repeated many times in this table with slight variations.  Might want to consider a crawler type tool to clean addresses up behind the scenes in cases where we are 100% sure two addresses are the same.';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-06 10:56:21
