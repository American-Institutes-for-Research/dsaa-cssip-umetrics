-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: localhost    Database: UMETRICSSupport
-- ------------------------------------------------------
-- Server version	5.6.15

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
-- Current Database: `UMETRICSSupport`
--

USE `UMETRICSSupport`;

--
-- Dumping routines for database 'UMETRICSSupport'
--
/*!50003 DROP PROCEDURE IF EXISTS `CalculatePersonAttributeStatistics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`developer`@`%` PROCEDURE `CalculatePersonAttributeStatistics`()
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Stored procedure to calculate statistics for the PersonAttribute table.  These statistics are used for disambiguation.'
begin


	################################################################################
	# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
	# All rights reserved.
	# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
	# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	################################################################################


	declare _overall_person_count int(11) unsigned;
	declare _overall_person_attribute_count int(11) unsigned;


	select count(*) into _overall_person_count from UMETRICS.Person;
	select count(*) into _overall_person_attribute_count from UMETRICS.PersonAttribute;


	drop table if exists PersonAttributeStatistics;


	create table PersonAttributeStatistics
	(
		OverallPersonCount int unsigned not null,
		OverallPersonAttributeCount int unsigned not null,
		PersonCountPerRelationshipCode int unsigned not null,
		AttributeCountPerRelationshipCode int unsigned not null,
		PersonAttributeCountPerRelationshipCode int unsigned not null,
		RelationshipCodeWeight float unsigned not null comment 'Currently calculated as (PersonCountPerRelationshipCode / PersonAttributeCountPerRelationshipCode) * (AttributeCountPerRelationshipCode / PersonAttributeCountPerRelationshipCode).  See CalculatePersonAttributeStatistics stored procedure for more details.',
		primary key (RelationshipCode)
	)

	select distinct
		RelationshipCode,
		_overall_person_count OverallPersonCount,
		_overall_person_attribute_count OverallPersonAttributeCount,
		(select count(distinct PersonId) from UMETRICS.PersonAttribute where RelationshipCode = t.RelationshipCode) PersonCountPerRelationshipCode,
		(select count(distinct AttributeId) from UMETRICS.PersonAttribute where RelationshipCode = t.RelationshipCode) AttributeCountPerRelationshipCode,
		(select count(*) from UMETRICS.PersonAttribute where RelationshipCode = t.RelationshipCode) PersonAttributeCountPerRelationshipCode,
		0.0 RelationshipCodeWeight

	from
		(
			select distinct
				RelationshipCode

			from
				UMETRICS.PersonAttribute

		) t;


	update
		PersonAttributeStatistics

	set
		RelationshipCodeWeight = (PersonCountPerRelationshipCode / PersonAttributeCountPerRelationshipCode) * (AttributeCountPerRelationshipCode / PersonAttributeCountPerRelationshipCode);


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

-- Dump completed on 2013-12-19 19:32:50
