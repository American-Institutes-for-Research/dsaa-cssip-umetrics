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

-- Dumping database structure for ExPORTER
CREATE DATABASE IF NOT EXISTS `ExPORTER` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
USE `ExPORTER`;


-- Dumping structure for table ExPORTER.Abstract
CREATE TABLE IF NOT EXISTS `Abstract` (
  `APPLICATION_ID` int(11) DEFAULT NULL,
  `ABSTRACT_TEXT` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8 DEFAULT COLLATE utf8_general_ci;

-- Data exporting was unselected.


-- Dumping structure for table ExPORTER.Patent
CREATE TABLE IF NOT EXISTS `Patent` (
  `PATENT_ID` varchar(10) DEFAULT NULL,
  `PATENT_TITLE` varchar(300) DEFAULT NULL,
  `PROJECT_ID` varchar(15) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 DEFAULT COLLATE utf8_general_ci;

-- Data exporting was unselected.


-- Dumping structure for table ExPORTER.Project
CREATE TABLE IF NOT EXISTS `Project` (
  `APPLICATION_ID` int(11) DEFAULT NULL,
  `ACTIVITY` char(3) DEFAULT NULL,
  `ADMINISTERING_IC` char(2) DEFAULT NULL,
  `APPLICATION_TYPE` char(1) DEFAULT NULL,
  `ARRA_FUNDED` bit(1) DEFAULT NULL,
  `AWARD_NOTICE_DATE` date DEFAULT NULL,
  `BUDGET_START` date DEFAULT NULL,
  `BUDGET_END` date DEFAULT NULL,
  `CFDA_CODE` char(3) DEFAULT NULL,
  `CORE_PROJECT_NUM` varchar(30) DEFAULT NULL,
  `ED_INST_TYPE` varchar(35) DEFAULT NULL,
  `FOA_NUMBER` varchar(15) DEFAULT NULL,
  `FULL_PROJECT_NUM` varchar(30) DEFAULT NULL,
  `FUNDING_ICs` varchar(400) DEFAULT NULL,
  `FUNDING_MECHANISM` varchar(25) DEFAULT NULL,
  `FY` smallint(6) DEFAULT NULL,
  `IC_NAME` varchar(100) DEFAULT NULL,
  `NIH_SPENDING_CATS` varchar(1000) DEFAULT NULL,
  `ORG_CITY` varchar(50) DEFAULT NULL,
  `ORG_COUNTRY` varchar(20) DEFAULT NULL,
  `ORG_DEPT` varchar(50) DEFAULT NULL,
  `ORG_DISTRICT` varchar(5) DEFAULT NULL,
  `ORG_DUNS` varchar(20) DEFAULT NULL,
  `ORG_FIPS` char(2) DEFAULT NULL,
  `ORG_NAME` varchar(100) DEFAULT NULL,
  `ORG_STATE` char(2) DEFAULT NULL,
  `ORG_ZIPCODE` varchar(9) DEFAULT NULL,
  `PHR` text,
  `PI_IDS` varchar(300) DEFAULT NULL,
  `PI_NAMEs` text,
  `PROGRAM_OFFICER_NAME` varchar(50) DEFAULT NULL,
  `PROJECT_START` date DEFAULT NULL,
  `PROJECT_END` date DEFAULT NULL,
  `PROJECT_TERMS` text,
  `PROJECT_TITLE` varchar(200) DEFAULT NULL,
  `SERIAL_NUMBER` mediumint(9) DEFAULT NULL,
  `STUDY_SECTION` varchar(4) DEFAULT NULL,
  `STUDY_SECTION_NAME` varchar(100) DEFAULT NULL,
  `SUBPROJECT_ID` smallint(6) DEFAULT NULL,
  `SUFFIX` varchar(4) DEFAULT NULL,
  `SUPPORT_YEAR` tinyint(4) DEFAULT NULL,
  `TOTAL_COST` decimal(13,2) DEFAULT NULL,
  `TOTAL_COST_SUB_PROJECT` decimal(13,2) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 DEFAULT COLLATE utf8_general_ci;

-- Data exporting was unselected.


-- Dumping structure for table ExPORTER.Publication
CREATE TABLE IF NOT EXISTS `Publication` (
  `AFFILIATION` text,
  `AUTHOR_LIST` text,
  `COUNTRY` varchar(30) DEFAULT NULL,
  `ISSN` char(9) DEFAULT NULL,
  `JOURNAL_ISSUE` varchar(50) DEFAULT NULL,
  `JOURNAL_TITLE` varchar(500) DEFAULT NULL,
  `JOURNAL_TITLE_ABBR` varchar(200) DEFAULT NULL,
  `JOURNAL_VOLUME` varchar(50) DEFAULT NULL,
  `LANG` varchar(5) DEFAULT NULL,
  `PAGE_NUMBER` varchar(200) DEFAULT NULL,
  `PMC_ID` int(11) DEFAULT NULL,
  `PMID` int(11) DEFAULT NULL,
  `PUB_DATE` varchar(50) DEFAULT NULL,
  `PUB_TITLE` varchar(1000) DEFAULT NULL,
  `PUB_YEAR` smallint(6) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 DEFAULT COLLATE utf8_general_ci;

-- Data exporting was unselected.


-- Dumping structure for table ExPORTER.PublicationProject
CREATE TABLE IF NOT EXISTS `PublicationProject` (
  `PMID` int(11) DEFAULT NULL,
  `CORE_PROJECT_NUM` varchar(30) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 DEFAULT COLLATE utf8_general_ci;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
