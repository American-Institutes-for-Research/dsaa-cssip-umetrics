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
-- Table structure for table `GrantAwardAttribute`
--

DROP TABLE IF EXISTS `GrantAwardAttribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GrantAwardAttribute` (
  `GrantAwardAttributeId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an GrantAwardAttribute.',
  `GrantAwardId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the GrantAward.',
  `AttributeId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the Attribute.',
  `RelationshipCode` enum('CFDA_CODE','FOA_CODE','GRANTIDENTIFIER','NIH_APPLICATION_ID','NIH_CORE_PROJECT_NUM','NIH_FULL_PROJECT_NUM','NIH_SUBPROJECT_ID') NOT NULL COMMENT 'Describes the attribute''s relationship to the organization.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
  PRIMARY KEY (`GrantAwardAttributeId`),
  UNIQUE KEY `AK_GrantAwadAttribute` (`RelationshipCode`,`GrantAwardId`,`AttributeId`),
  KEY `FK_GrantAwardAttribute_GrantAward` (`GrantAwardId`),
  KEY `FK_GrantAwardAttribute_Attribute` (`AttributeId`),
  CONSTRAINT `FK_GrantAwardAttribute_Attribute` FOREIGN KEY (`AttributeId`) REFERENCES `Attribute` (`AttributeId`),
  CONSTRAINT `FK_GrantAwardAttribute_GrantAward` FOREIGN KEY (`GrantAwardId`) REFERENCES `GrantAward` (`GrantAwardId`)
) ENGINE=InnoDB AUTO_INCREMENT=5109467 DEFAULT CHARSET=utf8 COMMENT='Attributes for GrantAwards.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-11 11:58:13
