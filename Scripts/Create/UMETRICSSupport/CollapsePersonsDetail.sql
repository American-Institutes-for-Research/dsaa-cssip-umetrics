-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: localhost    Database: UMETRICSSupport
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
-- Table structure for table `CollapsePersonsDetail`
--

DROP TABLE IF EXISTS `CollapsePersonsDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CollapsePersonsDetail` (
  `CollapsePersonsDetailId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of a CollapsePersonsDetail record.',
  `CollapsePersonsLogId` int(10) unsigned NOT NULL COMMENT 'Foreign key to CollapsePersonsLog.',
  `OrderNumber` int(10) unsigned NOT NULL COMMENT 'A serial number for tracking the order in which collapse details occurred.',
  `TableName` enum('Person','PersonAddress','PersonAttribute','PersonGrantAward','PersonName','PersonPublication','PersonTerm') NOT NULL COMMENT 'The name of the table affected.  While not strictly necessary, it would help with sorting if these ENUMs were maintained in alphabetical order as new tables are added.',
  `TableId` int(10) unsigned NOT NULL COMMENT 'The identifier of the record affected.  The assumption here, of course, is that each table has but a single unsigned integer identifier.',
  `Event` enum('DELETED','REASSIGNED') NOT NULL COMMENT 'A record of what happened to this record.  There are really only two things; the row can be deleted because it would have caused a duplication or the row can be reassigned to its new PersonId.',
  `Snapshot` varchar(500) NOT NULL COMMENT 'Let''s call this a safety net.  It''s essentially a snapshot of records before they were collapsed.',
  PRIMARY KEY (`CollapsePersonsDetailId`),
  KEY `FK_CollapsePersonsDetail_CollapsePersonsLog` (`CollapsePersonsLogId`),
  CONSTRAINT `FK_CollapsePersonsDetail_CollapsePersonsLog` FOREIGN KEY (`CollapsePersonsLogId`) REFERENCES `CollapsePersonsLog` (`CollapsePersonsLogId`)
) ENGINE=InnoDB AUTO_INCREMENT=11615 DEFAULT CHARSET=utf8 COMMENT='Verbose details about exactly what was done during a Person collapse.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
