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
-- Table structure for table `EnumeratedStatistics`
--

DROP TABLE IF EXISTS `EnumeratedStatistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EnumeratedStatistics` (
  `EnumeratedStatisticsId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifer for this table',
  `DatabaseStatisticsRunId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to DatabaseStatisticsRun.DatabaseStatisticsRunId',
  `DatabaseName` varchar(64) NOT NULL DEFAULT '0' COMMENT 'The name of the database for these statistics',
  `TableName` varchar(64) NOT NULL DEFAULT '0' COMMENT 'The name of the table for these statistics',
  `ColumnName` varchar(64) NOT NULL DEFAULT '0' COMMENT 'The name of the column for these statistics',
  `DataType` varchar(64) NOT NULL DEFAULT '0' COMMENT 'The data type of the ColumnName column',
  `ValueRowCount` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The number of rows that has the value of ValueNumeric, BalueChar, or ValueDate',
  `ValueNumeric` float DEFAULT NULL COMMENT 'The enumerated value when DataType is a numeric type',
  `ValueChar` varchar(250) DEFAULT NULL COMMENT 'The enumerated value when DataType is a character type',
  `ValueDate` date DEFAULT NULL COMMENT 'The enumerated value when DataType is a date type',
  PRIMARY KEY (`EnumeratedStatisticsId`),
  KEY `DatabaseName_TableName_ColumnName` (`DatabaseName`,`TableName`,`ColumnName`)
) ENGINE=InnoDB AUTO_INCREMENT=1367 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
