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
-- Table structure for table `PublicationAttribute`
--

DROP TABLE IF EXISTS `PublicationAttribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PublicationAttribute` (
  `PublicationAttributeId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for a PublicationAttribute.',
  `PublicationId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the Publication that has the Attribute.',
  `AttributeId` int(11) unsigned NOT NULL COMMENT 'Foreign key to the Attribute for the Publication.',
  `RelationshipCode` enum('CITESEERX_CLUSTER','PMID','TITLE_OTHER','TITLE_PRIMARY') NOT NULL COMMENT 'The type of Attribute for the Publication.',
  PRIMARY KEY (`PublicationAttributeId`),
  UNIQUE KEY `AK_PublicationAttribute` (`AttributeId`,`PublicationId`,`RelationshipCode`),
  KEY `FK_PublicationAttribute_Attribute` (`AttributeId`),
  KEY `FK_PublicationAttribute_PublicationId` (`PublicationId`),
  KEY `IX_PublicationAttrbiute_RelationshipCode` (`RelationshipCode`),
  CONSTRAINT `FK_PublicationAttribute_Attribute` FOREIGN KEY (`AttributeId`) REFERENCES `Attribute` (`AttributeId`),
  CONSTRAINT `FK_PublicationAttribute_Publication` FOREIGN KEY (`PublicationId`) REFERENCES `Publication` (`PublicationId`)
) ENGINE=InnoDB AUTO_INCREMENT=22347436 DEFAULT CHARSET=utf8 COMMENT='Attributes for Publications.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-11 11:58:13
