-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com    Database: Institute
-- ------------------------------------------------------
-- Server version	5.6.13-log

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
-- Current Database: `Institute`
--

USE `Institute`;

--
-- Dumping routines for database 'Institute'
--
/*!50003 DROP PROCEDURE IF EXISTS `PopulateCICOrganizations` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `PopulateCICOrganizations`()
    SQL SECURITY INVOKER
    COMMENT 'No surprise here I guess, but this stored procedure will populate the CICOrganizations table.  Please see internal comments for a more thorough explanation.'
begin

	/*
		Institute.institute contains the list of CIC institutions.  Institute.alternatename
		contains the list of known aliases for these institutions.  The goal here is to identify
		UMETRICS.Organizations that are in the CIC.  To do this, we will match
		UMETRICS.OrganizationNames to Institute.alternatenames.

		To complete this list, we will also need to walk the OrganizationOrganization tree to
		identify child institutions of the CIC institutions.  These would typically be
		departments within an institution, but they could also be linked to other "stuff" so
		we need to grab them.  We will be taking a shortcut with the OrganizationOrganization
		tree since we know ahead of time that, for Phase 0, there is only one level below an
		Organization, so no need for anything fancy.

		Import fact: All of the Institute.institute names are in the Institute.alternatename
		table, so we only need to join Organization names to alternatenames.

		select count(*) from Institute.institute where name not in (select name from Institute.alternatename); -- 0
	*/

	truncate table CICOrganizations;

	insert into CICOrganizations
	(
		OrganizationId,
		InstitutionId
	)
	select
		onn.OrganizationId,
		an.InstituteId
	from
		Institute.alternatename an
		inner join UMETRICS.OrganizationName onn on
		onn.Name = an.Name;

	insert into CICOrganizations
	(
		OrganizationId,
		InstitutionId
	)
	select
		oo.OrganizationBId,
		cico.InstitutionId
	from
		CICOrganizations cico
		inner join UMETRICS.OrganizationOrganization oo on
		oo.OrganizationAId = cico.OrganizationId;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed
