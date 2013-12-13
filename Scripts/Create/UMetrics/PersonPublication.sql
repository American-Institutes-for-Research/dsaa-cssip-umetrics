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
-- Table structure for table `PersonPublication`
--

DROP TABLE IF EXISTS `PersonPublication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PersonPublication` (
  `PersonPublicationId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for a PersonPublication.',
  `PersonId` int(11) unsigned NOT NULL COMMENT 'Foreign key of the Person that is related to this Publication.',
  `PublicationId` int(11) unsigned NOT NULL COMMENT 'Foreign key of the Publication that is related to the Person.',
  `RelationshipCode` enum('AUTHOR') NOT NULL COMMENT 'Describes the Person''s relation to the Publication.',
  PRIMARY KEY (`PersonPublicationId`),
  KEY `RelationshipCode` (`RelationshipCode`),
  KEY `FK_PersonPublication_Publication` (`PublicationId`),
  KEY `FK_PersonPublication_Person` (`PersonId`),
  CONSTRAINT `FK_PersonPublication_Publication` FOREIGN KEY (`PublicationId`) REFERENCES `Publication` (`PublicationId`),
  CONSTRAINT `FK_PersonPublication_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`)
) ENGINE=InnoDB AUTO_INCREMENT=64420906 DEFAULT CHARSET=utf8 COMMENT='Relationships between a Person and a Publication.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-11 11:58:13
