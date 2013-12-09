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
-- Table structure for table `PersonName`
--

DROP TABLE IF EXISTS `PersonName`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PersonName` (
  `PersonNameId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for a PersonName.',
  `PersonId` int(11) unsigned NOT NULL COMMENT 'Foreign key of the person to whom this name belongs.',
  `RelationshipCode` enum('ALIAS','PRIMARY') NOT NULL COMMENT 'Describes the name''s relationship to the person.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
  `FullName` varchar(200) DEFAULT NULL COMMENT 'A full name in cases where we are unsure of the name breakdown.',
  `Prefix` varchar(100) DEFAULT NULL COMMENT 'Typically an honorific like Mr, Dr, Honorable, etc.',
  `GivenName` varchar(100) DEFAULT NULL COMMENT 'Given name of a person (usually first name in most European style names).',
  `OtherName` varchar(100) DEFAULT NULL COMMENT 'Room for other name components such as middle name(s).',
  `FamilyName` varchar(100) DEFAULT NULL COMMENT 'Family name of a person (usually last name in most European style names).',
  `Suffix` varchar(100) DEFAULT NULL COMMENT 'Typical suffixes include Jr, Sr, III, PhD, MD, etc.  May include degree information.',
  `Nickname` varchar(100) DEFAULT NULL COMMENT 'An alternate name for this person.  Frequently this is not their given name but a name by which they are commonly referred.',
  PRIMARY KEY (`PersonNameId`),
  KEY `FK_PersonName_Person` (`PersonId`),
  CONSTRAINT `FK_PersonName_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Name information for a Person.  The idea is that a person can have many names and their names can take many forms.  If we attach every version of every name we have for a person to a Person, it might help with matching.';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-06 10:56:23
