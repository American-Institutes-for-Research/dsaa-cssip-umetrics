-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com    Database: UMETRICS
-- ------------------------------------------------------
-- Server version	5.6.13-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `PersonAddress`
--

DROP TABLE IF EXISTS `PersonAddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PersonAddress` (
  `PersonAddressId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for a PersonAddress.',
  `PersonId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the Person table.',
  `AddressId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the Address table.',
  `RelationshipCode` enum('ALTERNATE','PRIMARY') NOT NULL COMMENT 'Describes the address''s relationship to the person.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
  PRIMARY KEY (`PersonAddressId`),
  UNIQUE KEY `AK_PersonAddress` (`PersonId`,`AddressId`,`RelationshipCode`),
  KEY `FK_PersonAddress_Person` (`PersonId`),
  KEY `FK_PersonAddress_Address` (`AddressId`),
  CONSTRAINT `FK_PersonAddress_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`),
  CONSTRAINT `FK_PersonAddress_Address` FOREIGN KEY (`AddressId`) REFERENCES `Address` (`AddressId`)
) ENGINE=InnoDB AUTO_INCREMENT=917491 DEFAULT CHARSET=utf8 COMMENT='Addresses associated with people.  We might need to consider dating addresses since, occasionally, people do indeed move.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-11 11:58:13
