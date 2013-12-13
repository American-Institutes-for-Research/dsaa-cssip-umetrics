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
-- Table structure for table `OrganizationGrantAward`
--

DROP TABLE IF EXISTS `OrganizationGrantAward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OrganizationGrantAward` (
  `OrganizationGrantAwardId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an OrganizationGrantAward.',
  `OrganizationId` int(11) unsigned NOT NULL COMMENT 'Foreign key to Organization table.',
  `GrantAwardId` int(11) unsigned NOT NULL COMMENT 'Foreign key to GrantAward table.',
  `RelationshipCode` enum('AWARDEE','GRANTOR') NOT NULL COMMENT 'Describes the organization''s relationship to the grant award.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
  PRIMARY KEY (`OrganizationGrantAwardId`),
  UNIQUE KEY `AK_OrganizationGrantAward` (`OrganizationId`,`GrantAwardId`,`RelationshipCode`),
  KEY `FK_OrganizationGrantAward_GrantAward` (`GrantAwardId`),
  KEY `FK_OrganizationGrantAward_Organization` (`OrganizationId`),
  CONSTRAINT `FK_OrganizationGrantAward_Organization` FOREIGN KEY (`OrganizationId`) REFERENCES `Organization` (`OrganizationId`),
  CONSTRAINT `FK_OrganizationGrantAward_GrantAward` FOREIGN KEY (`GrantAwardId`) REFERENCES `GrantAward` (`GrantAwardId`)
) ENGINE=InnoDB AUTO_INCREMENT=2168280 DEFAULT CHARSET=utf8 COMMENT='Relationships between an Organization and a GrantAward.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-11 11:58:13
