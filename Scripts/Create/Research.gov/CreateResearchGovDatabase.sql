-- --------------------------------------------------------
-- Host:                         mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com
-- Server version:               5.6.13-log - MySQL Community Server (GPL)
-- Server OS:                    Linux
-- HeidiSQL Version:             8.1.0.4545
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for ResearchGov
CREATE DATABASE IF NOT EXISTS `ResearchGov` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
USE `ResearchGov`;


-- Dumping structure for table ResearchGov.Award
CREATE TABLE IF NOT EXISTS `Award` (
  `Awardee` varchar(300) DEFAULT NULL,
  `DoingBusinessAsName` varchar(300) DEFAULT NULL,
  `PDPIName` varchar(50) DEFAULT NULL,
  `PDPIPhone` varchar(20) DEFAULT NULL,
  `PDPIEmail` varchar(100) DEFAULT NULL,
  `CoPDsCoPIs` varchar(200) DEFAULT NULL,
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
  `PublicationsProducedAsAResultsOfThisResearch` text,
  `PublicationsProducedAsConferenceProceedings` text,
  `ProjectOutcomesReport` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8 DEFAULT COLLATE utf8_general_ci COMMENT='Relatively raw grant award data downloaded from Research.gov';

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
