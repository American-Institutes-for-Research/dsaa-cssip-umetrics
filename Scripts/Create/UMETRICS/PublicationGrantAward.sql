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
-- Table structure for table `PublicationGrantAward`
--

DROP TABLE IF EXISTS `PublicationGrantAward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PublicationGrantAward` (
  `PublicationGrantAwardId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an PublicationGrantAward.',
  `PublicationId` int(11) unsigned NOT NULL COMMENT 'Foreign key to Publication table.',
  `GrantAwardId` int(11) unsigned NOT NULL COMMENT 'Foreign key to GrantAward table.',
  `RelationshipCode` enum('CITED') NOT NULL COMMENT 'Describes the publication''s relationship to the grant award.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
  PRIMARY KEY (`PublicationGrantAwardId`),
  UNIQUE KEY `AK_PublicationGrantAward` (`PublicationId`,`GrantAwardId`,`RelationshipCode`),
  KEY `FK_PublicationGrantAward_GrantAward` (`GrantAwardId`),
  KEY `FK_PublicationGrantAward_Person` (`PublicationId`),
  CONSTRAINT `PublicationGrantAward_ibfk_1` FOREIGN KEY (`GrantAwardId`) REFERENCES `GrantAward` (`GrantAwardId`),
  CONSTRAINT `PublicationGrantAward_ibfk_2` FOREIGN KEY (`PublicationId`) REFERENCES `Publication` (`PublicationId`)
) ENGINE=InnoDB AUTO_INCREMENT=92404351 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='Relationships between a Publication and a GrantAward.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
