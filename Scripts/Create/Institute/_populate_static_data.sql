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

-- Dumping data for table Institute.institute: ~16 rows (approximately)
/*!40000 ALTER TABLE `institute` DISABLE KEYS */;
INSERT INTO `institute` (`InstituteID`, `Name`) VALUES
	(1, 'University of Chicago'),
	(2, 'University of Illinois'),
	(3, 'Indiana University'),
	(4, 'University of Iowa'),
	(5, 'University of Maryland'),
	(6, 'University of Michigan'),
	(7, 'Michigan State University'),
	(8, 'University of Minnesota'),
	(9, 'University of Nebraska-Lincoln'),
	(10, 'Northwestern University'),
	(11, 'Ohio State University'),
	(12, 'Pennsylvania State University'),
	(13, 'Purdue University'),
	(14, 'Rutgers University'),
	(15, 'University of Wisconsin-Madison'),
	(16, 'California Institute of Technology');
/*!40000 ALTER TABLE `institute` ENABLE KEYS */;

-- Dumping data for table Institute.alternatename: ~45 rows (approximately)
/*!40000 ALTER TABLE `alternatename` DISABLE KEYS */;
INSERT INTO `alternatename` (`AlternateNameID`, `InstituteID`, `Name`) VALUES
	(1, 1, 'University of Chicago'),
	(2, 2, 'University of Illinois'),
	(3, 3, 'Indiana University'),
	(4, 4, 'University of Iowa'),
	(5, 5, 'University of Maryland'),
	(6, 6, 'University of Michigan'),
	(7, 7, 'Michigan State University'),
	(8, 8, 'University of Minnesota'),
	(9, 9, 'University of Nebraska-Lincoln'),
	(10, 10, 'Northwestern University'),
	(11, 11, 'Ohio State University'),
	(12, 12, 'Pennsylvania State University'),
	(13, 13, 'Purdue University'),
	(14, 14, 'Rutgers University'),
	(15, 15, 'University of Wisconsin-Madison'),
	(16, 16, 'California Institute of Technology'),
	(36, 2, 'UNIV OF ILLINOIS AT URBANA-CHAMPAIGN'),
	(37, 2, 'Univ. Illinois'),
	(42, 2, 'UNIVERSITY OF ILLINOIS URBANA-CHAMPAIGN'),
	(45, 3, 'INDIANA UNIVERSITY BLOOMINGTON'),
	(47, 5, 'Univ Maryland'),
	(48, 5, 'UNIVERSITY OF MARYLAND COLLEGE PK CAMPUS'),
	(49, 6, 'UNIVERSITY OF MICHIGAN (INC)'),
	(50, 6, 'UNIVERSITY OF MICHIGAN /INC/'),
	(51, 7, 'MICHIGAN STATE UNIV'),
	(52, 8, 'MINNESOTA UNIV'),
	(53, 8, 'UNIVERSITY OF MINNESOTA (INC)'),
	(54, 8, 'UNIVERSITY OF MINNESOTA TWIN C'),
	(55, 8, 'UNIVERSITY OF MINNESOTA TWIN CITIES'),
	(56, 9, 'UNIVERSITY OF NEBRASKA LINCOLN'),
	(57, 10, 'NORTHWESTERN UNIVERSITY AT CHICAGO'),
	(58, 11, 'OHIO STATE UNIV'),
	(59, 11, 'OHIO STATE UNIVERSITY RESEARCH'),
	(60, 11, 'OHIO STATE UNIVERSITY RESEARCH FDN'),
	(61, 11, 'OHIO STATE UNIVERSITY RESEARCH FOUNDATIO'),
	(62, 12, 'PENNSYLVANIA STATE UNIV HERSHEY MED CTR'),
	(63, 12, 'PENNSYLVANIA STATE UNIVERSITY-UNIV PARK'),
	(64, 13, 'PURDUE UNIVERSITY WEST LAFAYETTE'),
	(65, 14, 'RUTGERS THE ST UNIV OF NJ NEW BRUNSWICK'),
	(66, 14, 'RUTGERS THE STATE UNIV OF NJ CAMDEN'),
	(67, 14, 'RUTGERS THE STATE UNIV OF NJ NEWARK'),
	(68, 14, 'RUTGERS THE STATE UNIVERSITY OF NJ'),
	(69, 15, 'UNIVERSITY OF WISCONSIN'),
	(70, 15, 'UNIVERSITY OF WISCONSIN - MAD'),
	(71, 15, 'UNIVERSITY OF WISCONSIN MADISON');
/*!40000 ALTER TABLE `alternatename` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
