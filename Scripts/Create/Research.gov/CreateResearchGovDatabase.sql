-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com    Database: ResearchGov
-- ------------------------------------------------------
-- Server version 5.6.13-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `ResearchGov`
--

/*!40000 DROP DATABASE IF EXISTS `ResearchGov`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ResearchGov` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `ResearchGov`;

--
-- Table structure for table `Award`
--

DROP TABLE IF EXISTS `Award`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Award` (
  `AwardId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Awardee` varchar(300) DEFAULT NULL,
  `DoingBusinessAsName` varchar(300) DEFAULT NULL,
  `PDPIName` varchar(50) DEFAULT NULL,
  `PDPIPhone` varchar(20) DEFAULT NULL,
  `PDPIEmail` varchar(100) DEFAULT NULL,
  `CoPDsCoPIs` varchar(300) DEFAULT NULL,
  `AwardDate` date DEFAULT NULL,
  `EstimatedTotalAwardAmount` decimal(13,2) DEFAULT NULL,
  `FundsObligatedToDate` decimal(13,2) DEFAULT NULL,
  `AwardStartDate` date DEFAULT NULL,
  `AwardExpirationDate` date DEFAULT NULL,
  `TransactionType` varchar(25) DEFAULT NULL,
  `Agency` varchar(4) DEFAULT NULL,
  `AwardingAgencyCode` varchar(10) DEFAULT NULL,
  `FundingAgencyCode` varchar(10) DEFAULT NULL,
  `CFDANumber` varchar(10) DEFAULT NULL,
  `PrimaryProgramSource` varchar(50) DEFAULT NULL,
  `AwardTitleOrDescription` varchar(300) DEFAULT NULL,
  `FederalAwardIDNumber` varchar(20) DEFAULT NULL,
  `DUNSID` varchar(20) DEFAULT NULL,
  `ParentDUNSID` varchar(20) DEFAULT NULL,
  `Program` varchar(35) DEFAULT NULL,
  `ProgramOfficerName` varchar(50) DEFAULT NULL,
  `ProgramOfficerPhone` varchar(20) DEFAULT NULL,
  `ProgramOfficerEmail` varchar(100) DEFAULT NULL,
  `AwardeeStreet` varchar(100) DEFAULT NULL,
  `AwardeeCity` varchar(50) DEFAULT NULL,
  `AwardeeState` varchar(2) DEFAULT NULL,
  `AwardeeZIP` varchar(10) DEFAULT NULL,
  `AwardeeCounty` varchar(50) DEFAULT NULL,
  `AwardeeCountry` varchar(10) DEFAULT NULL,
  `AwardeeCongressionalDistrict` varchar(10) DEFAULT NULL,
  `PrimaryOrganizationName` varchar(100) DEFAULT NULL,
  `PrimaryStreet` varchar(100) DEFAULT NULL,
  `PrimaryCity` varchar(50) DEFAULT NULL,
  `PrimaryState` varchar(2) DEFAULT NULL,
  `PrimaryZIP` varchar(10) DEFAULT NULL,
  `PrimaryCounty` varchar(50) DEFAULT NULL,
  `PrimaryCountry` varchar(10) DEFAULT NULL,
  `PrimaryCongressionalDistrict` varchar(10) DEFAULT NULL,
  `AbstractAtTimeOfAward` text,
  `PublicationsProducedAsAResultOfThisResearch` text,
  `PublicationsProducedAsConferenceProceedings` text,
  `ProjectOutcomesReport` text,
  `UM_PDPIName_Prefix` varchar(50) DEFAULT NULL,
  `UM_PDPIName_GivenName` varchar(50) DEFAULT NULL,
  `UM_PDPIName_OtherName` varchar(50) DEFAULT NULL,
  `UM_PDPIName_FamilyName` varchar(50) DEFAULT NULL,
  `UM_PDPIName_Suffix` varchar(50) DEFAULT NULL,
  `UM_PDPIEmail_Corrected` varchar(100) DEFAULT NULL,
  `UM_ProgramOfficerName_Prefix` varchar(50) DEFAULT NULL,
  `UM_ProgramOfficerName_GivenName` varchar(50) DEFAULT NULL,
  `UM_ProgramOfficerName_OtherName` varchar(50) DEFAULT NULL,
  `UM_ProgramOfficerName_FamilyName` varchar(50) DEFAULT NULL,
  `UM_ProgramOfficerName_Suffix` varchar(50) DEFAULT NULL,
  `UM_ProgramOfficerEmail_Corrected` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`AwardId`),
  KEY `FederalAwardIDNumber` (`FederalAwardIDNumber`)
) ENGINE=MyISAM AUTO_INCREMENT=271518 DEFAULT CHARSET=utf8 COMMENT='Relatively raw grant award data downloaded from Research.gov';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
