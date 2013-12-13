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
-- Table structure for table `OrganizationName`
--

DROP TABLE IF EXISTS `OrganizationName`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrganizationName` (
  `OrganizationNameId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an OrganizationName.',
  `OrganizationId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the Organization table.  Each organization can have more than one name, but must have at least one.',
  `RelationshipCode` enum('ALIAS','PRIMARY_ACRONYM','PRIMARY_FULL') NOT NULL COMMENT 'Describes the name''s relationship to the organization.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
  `Name` varchar(200) NOT NULL COMMENT 'A name of the Organization.  Organizations can have more than one.',
  PRIMARY KEY (`OrganizationNameId`),
  KEY `FK_OrganizationName_Organization` (`OrganizationId`),
  KEY `IX_OrganizationName_Name_RelationshipCode_OrganizationId` (`Name`,`RelationshipCode`,`OrganizationId`),
  CONSTRAINT `FK_OrganizationName_Organization` FOREIGN KEY (`OrganizationId`) REFERENCES `Organization` (`OrganizationId`)
) ENGINE=InnoDB AUTO_INCREMENT=33283 DEFAULT CHARSET=utf8 COMMENT='A company, university, or other institution name.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-11 11:58:13
