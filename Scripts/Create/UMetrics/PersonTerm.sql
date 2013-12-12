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
-- Table structure for table `PersonTerm`
--

DROP TABLE IF EXISTS `PersonTerm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PersonTerm` (
  `PersonTermId` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of a PersonTerm.',
  `PersonId` int(11) unsigned NOT NULL COMMENT 'Foreign key of the Person that has a relationship with the Term.',
  `TermId` int(11) unsigned NOT NULL COMMENT 'Foreign key of the Term that is related to the Person.',
  `RelationshipCode` enum('AFFILIATION','JOURNAL','MESH','TITLEWORD') NOT NULL COMMENT 'Describes the relationship between a Person and a Term.',
  `Weight` int(10) unsigned DEFAULT NULL COMMENT 'The weight of the relationship. The meaning of this will vary depending on the RelationshipCode. It could be a count of occurences, a confidence factor, or any other weighting scheme.',
  PRIMARY KEY (`PersonTermId`),
  UNIQUE KEY `AK_PersonTerm_Multi` (`PersonId`,`TermId`,`RelationshipCode`),
  KEY `FK_PersonTerm_Term` (`TermId`),
  KEY `FK_PersonTerm_Person` (`PersonId`),
  KEY `IX_PersonTerm_RelationshipCode` (`RelationshipCode`),
  CONSTRAINT `FK_PersonTerm_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`),
  CONSTRAINT `FK_PersonTerm_Term` FOREIGN KEY (`TermId`) REFERENCES `Term` (`TermId`)
) ENGINE=InnoDB AUTO_INCREMENT=110492011 DEFAULT CHARSET=utf8 COMMENT='Relationships between a Person and a Term.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-11 11:58:13
