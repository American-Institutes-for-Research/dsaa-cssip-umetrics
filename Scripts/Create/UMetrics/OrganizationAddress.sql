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
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `OrganizationAddress`
--

DROP TABLE IF EXISTS `OrganizationAddress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrganizationAddress` (
  `OrganizationAddressId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an OrganizationAddress.',
  `OrganizationId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the Organization table.',
  `AddressId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the Address table.',
  `RelationshipCode` enum('ALTERNATE','PRIMARY') NOT NULL COMMENT 'Describes the address''s relationship to the organization.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
  PRIMARY KEY (`OrganizationAddressId`),
  UNIQUE KEY `AK_OrganizationAddress` (`OrganizationId`,`AddressId`,`RelationshipCode`),
  KEY `FK_OrganizationAddress_Address` (`AddressId`),
  KEY `FK_OrganizationAddress_Organization` (`OrganizationId`),
  CONSTRAINT `FK_OrganizationAddress_Organization` FOREIGN KEY (`OrganizationId`) REFERENCES `Organization` (`OrganizationId`),
  CONSTRAINT `FK_OrganizationAddress_Address` FOREIGN KEY (`AddressId`) REFERENCES `Address` (`AddressId`)
) ENGINE=InnoDB AUTO_INCREMENT=20800 DEFAULT CHARSET=utf8 COMMENT='Addresses associated with organizations.  We might need to consider dating addresses since, occasionally, organizations do indeed move and/or expand.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-11 11:58:13
