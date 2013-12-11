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
-- Table structure for table `OrganizationOrganization`
--

DROP TABLE IF EXISTS `OrganizationOrganization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrganizationOrganization` (
  `OrganizationOrganizationId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an OrganizationOrganization.',
  `OrganizationAId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the first organization in the relationship.',
  `OrganizationBId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the second organization in the relationship.',
  `RelationshipCode` enum('PARENT') NOT NULL COMMENT 'Describes organization a''s relationship to organization b.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
  PRIMARY KEY (`OrganizationOrganizationId`),
  UNIQUE KEY `AK_OrganizationOrganization` (`OrganizationAId`,`OrganizationBId`,`RelationshipCode`),
  KEY `FK_OrganizationOrganization_Organization_2` (`OrganizationBId`),
  KEY `FK_OrganizationOrganization_Organization` (`OrganizationAId`),
  CONSTRAINT `FK_OrganizationOrganization_Organization_2` FOREIGN KEY (`OrganizationBId`) REFERENCES `Organization` (`OrganizationId`),
  CONSTRAINT `FK_OrganizationOrganization_Organization` FOREIGN KEY (`OrganizationAId`) REFERENCES `Organization` (`OrganizationId`)
) ENGINE=InnoDB AUTO_INCREMENT=8280 DEFAULT CHARSET=utf8 COMMENT='Describes relationships between organizations.  For example, NHLBI is an IC for the NIH.  That relationship could be modeled here.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-11 11:58:13
