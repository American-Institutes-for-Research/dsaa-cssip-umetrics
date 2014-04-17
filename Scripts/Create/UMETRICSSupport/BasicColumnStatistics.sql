-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com    Database: UMETRICSSupport
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
-- Table structure for table `BasicColumnStatistics`
--

DROP TABLE IF EXISTS `BasicColumnStatistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BasicColumnStatistics` (
  `BasicColumnStatisticsId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for the table',
  `DatabaseStatisticsRunId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Foreign key to DatabaseStatisticsRun.DatabaseStatisticsRunId',
  `DatabaseName` varchar(64) NOT NULL DEFAULT '0' COMMENT 'The name of the database for these statistics',
  `TableName` varchar(64) NOT NULL DEFAULT '0' COMMENT 'The name of the table for these statistics',
  `ColumnName` varchar(64) NOT NULL DEFAULT '0' COMMENT 'The name of the column for these statistics',
  `DataType` varchar(20) NOT NULL DEFAULT '0' COMMENT 'The data type of ColumnName',
  `RowCount` int(10) unsigned DEFAULT NULL COMMENT 'Total rows in the table',
  `NotNullCount` int(10) unsigned DEFAULT NULL COMMENT 'Total rows for which ColumnName is not null',
  `DistinctCount` int(10) unsigned DEFAULT NULL COMMENT 'Total distinct values for ColumnName',
  `MinimumValueNumeric` float DEFAULT NULL COMMENT 'Minimum value for ColumnName when DataType is a numeric type',
  `MaximumValueNumeric` float DEFAULT NULL COMMENT 'Maximum value for ColumnName when DataType is a numeric type',
  `AverageValueNumeric` float DEFAULT NULL COMMENT 'Average value for ColumnName when DataType is a numeric type',
  `StandardDeviation` float DEFAULT NULL COMMENT 'Standard deviation for ColumnName when DataType is a numeric type',
  `MinimumLength` int(10) unsigned DEFAULT NULL COMMENT 'Minimum length of ColumnName when DataType is a character type',
  `MaximumLength` int(10) unsigned DEFAULT NULL COMMENT 'Maximum length of ColumnName when DataType is a character type',
  `AverageLength` float unsigned DEFAULT NULL COMMENT 'Average length of ColumnName when DataType is a character type',
  `MinimumValueChar` varchar(250) DEFAULT NULL COMMENT 'Minimum value of ColumnName when DataType is a character type',
  `MaximumValueChar` varchar(250) DEFAULT NULL COMMENT 'Maximum value of ColumnName when DataType is a character type',
  `MinimumValueDate` date DEFAULT NULL COMMENT 'Minimum value of ColumnName when DataType is a date type',
  `MaximumValueDate` date DEFAULT NULL COMMENT 'Maximum value of ColumnName when DataType is a date type',
  `AverageValueDate` date DEFAULT NULL COMMENT 'Average value of ColumnName when DataType is a date type',
  PRIMARY KEY (`BasicColumnStatisticsId`),
  KEY `DatabaseName_TableName_ColumnName` (`DatabaseName`,`TableName`,`ColumnName`),
  KEY `DatabaseStatisticsRunId` (`DatabaseStatisticsRunId`),
  CONSTRAINT `FK_BasicColumnStatistics_DatabaseStatisticsRun` FOREIGN KEY (`DatabaseStatisticsRunId`) REFERENCES `DatabaseStatisticsRun` (`DatabaseStatisticsRunId`)
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8 COMMENT='Basic statistics for column values in any database. One row per column per table per database per "database statistics run".';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
