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

-- Dumping database structure for NSF
CREATE DATABASE IF NOT EXISTS `NSF` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `NSF`;


-- Dumping structure for table NSF.Award
CREATE TABLE IF NOT EXISTS `Award` (
  `AwardID` varchar(10) NOT NULL,
  `AwardTitle` varchar(200) DEFAULT NULL,
  `AwardEffectiveDate` date DEFAULT NULL,
  `AwardExpirationDate` date DEFAULT NULL,
  `AwardAmount` decimal(13,2) DEFAULT NULL,
  `AwardInstrument` varchar(50) DEFAULT NULL,
  `AwardInstrumentCode` varchar(50) DEFAULT NULL,
  `OrganizationCode` int(11) DEFAULT NULL,
  `Directorate` varchar(100) DEFAULT NULL,
  `DirectorateAbbreviation` varchar(50) DEFAULT NULL,
  `DirectorateCode` varchar(50) DEFAULT NULL,
  `Division` varchar(100) DEFAULT NULL,
  `DivisionAbbreviation` varchar(50) DEFAULT NULL,
  `DivisionCode` varchar(50) DEFAULT NULL,
  `ProgramOfficer` varchar(50) DEFAULT NULL,
  `AbstractNarration` text,
  `MinAmdLetterDate` date DEFAULT NULL,
  `MaxAmdLetterDate` date DEFAULT NULL,
  `ARRAAmount` decimal(13,2) DEFAULT NULL,
  `IsHistoricalAward` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table NSF.FOAInformation
CREATE TABLE IF NOT EXISTS `FOAInformation` (
  `AwardID` varchar(10) NOT NULL,
  `Code` int(11) DEFAULT NULL,
  `Name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table NSF.Institution
CREATE TABLE IF NOT EXISTS `Institution` (
  `AwardID` varchar(10) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `CityName` varchar(50) DEFAULT NULL,
  `ZipCode` varchar(10) DEFAULT NULL,
  `PhoneNumber` varchar(15) DEFAULT NULL,
  `StreetAddress` varchar(50) DEFAULT NULL,
  `CountryName` varchar(20) DEFAULT NULL,
  `StateName` varchar(25) DEFAULT NULL,
  `StateCode` varchar(2) DEFAULT NULL,
  `EmailAddress` varchar(50) DEFAULT NULL,
  `CountryFlag` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table NSF.Investigator
CREATE TABLE IF NOT EXISTS `Investigator` (
  `AwardID` varchar(10) NOT NULL,
  `FirstName` varchar(50) DEFAULT NULL,
  `LastName` varchar(50) DEFAULT NULL,
  `EmailAddress` varchar(100) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `RoleCode` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table NSF.ProgramElement
CREATE TABLE IF NOT EXISTS `ProgramElement` (
  `AwardID` varchar(10) NOT NULL,
  `Code` char(4) DEFAULT NULL,
  `Text` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table NSF.ProgramReference
CREATE TABLE IF NOT EXISTS `ProgramReference` (
  `AwardID` varchar(10) NOT NULL,
  `Code` char(4) DEFAULT NULL,
  `Text` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
