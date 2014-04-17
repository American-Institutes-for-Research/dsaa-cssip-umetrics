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
-- Table structure for table `GroupByStatistics`
--

DROP TABLE IF EXISTS `GroupByStatistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GroupByStatistics` (
  `GroupByStatisticsId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifer for this table',
  `DatabaseStatisticsRunId` int(10) unsigned NOT NULL COMMENT 'Foreign key to DatabaseStatisticsRun.DatabaseStatisticsRunId',
  `DatabaseName` varchar(64) NOT NULL COMMENT 'The name of the database for these statistics',
  `TableName` varchar(64) NOT NULL COMMENT 'The name of the table for these statistics',
  `ColumnName` varchar(64) NOT NULL COMMENT 'The name of the column for these statistics',
  `RowCount` int(10) unsigned NOT NULL COMMENT 'The total number of rows in the table',
  `MeanCount` float unsigned DEFAULT NULL COMMENT 'The average number of rows per unique ColumnName value',
  `MedianCount` int(11) unsigned DEFAULT NULL COMMENT 'The median number of rows per unique ColumnName value',
  `ModeCount` int(11) unsigned DEFAULT NULL COMMENT 'The mode of the number of rows per unique ColumnName value',
  `StdDevCount` float unsigned DEFAULT NULL COMMENT 'The standard deviation of the number of rows per unique ColumnName value',
  `VarianceCount` float unsigned DEFAULT NULL COMMENT 'The variance of the number of rows per unique ColumnName value',
  `MinimumCount` int(10) unsigned DEFAULT NULL COMMENT 'The minimum of the number of rows per unique ColumnName value',
  `MaximumCount` int(10) unsigned DEFAULT NULL COMMENT 'The maximum of the number of rows per unique ColumnName value',
  PRIMARY KEY (`GroupByStatisticsId`),
  KEY `DatabaseName_TableName_ColumnName` (`DatabaseName`,`TableName`,`ColumnName`),
  KEY `DatabaseStatisticsRunId` (`DatabaseStatisticsRunId`),
  CONSTRAINT `FK_GroupByStatistics_DatabaseStatisticsRun` FOREIGN KEY (`DatabaseStatisticsRunId`) REFERENCES `DatabaseStatisticsRun` (`DatabaseStatisticsRunId`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='Statistics for the row counts of a table when "grouped by" the ColumnName column. One row per column per table per database per "database statistics run". Generated using the CalcluateGroupByStatistics stored procedure.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
