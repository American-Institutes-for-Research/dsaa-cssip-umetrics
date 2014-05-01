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
-- Table structure for table `CollapsePersonsLog`
--

DROP TABLE IF EXISTS `CollapsePersonsLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CollapsePersonsLog` (
  `CollapsePersonsLogId` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier of a CollapsePersonsLog row.',
  `CollapsedPersonId` int(10) unsigned NOT NULL COMMENT 'The PersonId of the person who was removed.',
  `TargetPersonId` int(10) unsigned NOT NULL COMMENT 'The PersonId that the CollapsedPersonId was collapsed into.',
  `CollapseDateTime` datetime NOT NULL COMMENT 'The timestamp of the collapse.',
  `Notes` varchar(500) NOT NULL COMMENT 'Just a minor blurb that might explain why the collapse occurred.',
  PRIMARY KEY (`CollapsePersonsLogId`)
) ENGINE=InnoDB AUTO_INCREMENT=370 DEFAULT CHARSET=utf8 COMMENT='This is used to simply log when Persons were collapsed.';
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
