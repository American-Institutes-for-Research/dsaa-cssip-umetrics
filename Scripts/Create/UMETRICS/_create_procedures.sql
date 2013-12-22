-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com    Database: UMETRICS
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
-- Current Database: `UMETRICS`
--

USE `UMETRICS`;

--
-- Dumping routines for database 'UMETRICS'
--
/*!50003 DROP PROCEDURE IF EXISTS `ChangeAttributeValue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysqladmin`@`%` PROCEDURE `ChangeAttributeValue`(IN `attribute_id_of_changing_value` INT unsigned, IN `new_value` varchar(100), OUT `new_attribute_id_to_use` INT unsigned)
    COMMENT 'Changes the value of an Attribute, including correctly updating the Attribute and [entity]Attribute tables to maintain uniqueness.'
BEGIN
###############################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

	declare count_of_existing_values int;
	declare count_of_pairs int;
	
	set new_attribute_id_to_use = attribute_id_of_changing_value;

	# If the caller sent in an AttributeId and value pair that already exists,
	# then we aren't going to do anything since it's not really a change.
	select count(AttributeId) into count_of_pairs
		from UMETRICS.Attribute where AttributeId=attribute_id_of_changing_value and Attribute like new_value;
	if count_of_pairs = 0 then
		# If the value doesn't already exist in the Attribute table, then simply update the existing
		# attribute record with the new value.		
		select count(AttributeId) into count_of_existing_values from UMETRICS.Attribute where Attribute like new_value;
		if count_of_existing_values = 0 then
			update UMETRICS.Attribute set Attribute=new_value where AttributeId=attribute_id_of_changing_value;
		# Otherwise we need to repoint all existing [entity]Attribute records that were
		# referencing the old value to now use the new value.
		else
			# Get the AttributeId of any of the Attribute records that already has this new value.
			# Doesn't matter which one, although there should only be one.
			select AttributeId into new_attribute_id_to_use from UMETRICS.Attribute where Attribute like new_value limit 1;
			
			start transaction;
			
			# Update all PersonAttribute records that used the old attribute to use
			# the already existing one we found. Use 'ignore' so as not to create duplicates.
			# Then we will delete any PersonAttribute records that still have
			# the old attribute id and weren't updated because of the 'ignore'.
			update ignore UMETRICS.PersonAttribute set AttributeId=new_attribute_id_to_use
				where AttributeId=attribute_id_of_changing_value;
			delete from UMETRICS.PersonAttribute where AttributeId=attribute_id_of_changing_value;
			
			# Do the same update and delete for OrganizationAttribute, PublicationAttribute,
			# and GrantAwardAttribute.
			update ignore UMETRICS.OrganizationAttribute set AttributeId=new_attribute_id_to_use
				where AttributeId=attribute_id_of_changing_value;
			delete from UMETRICS.OrganizationAttribute where AttributeId=attribute_id_of_changing_value;

			update ignore UMETRICS.PublicationAttribute set AttributeId=new_attribute_id_to_use
				where AttributeId=attribute_id_of_changing_value;
			delete from UMETRICS.PublicationAttribute where AttributeId=attribute_id_of_changing_value;
			
			update ignore UMETRICS.GrantAwardAttribute set AttributeId=new_attribute_id_to_use
				where AttributeId=attribute_id_of_changing_value;
			delete from UMETRICS.GrantAwardAttribute where AttributeId=attribute_id_of_changing_value;
			
			# Now delete the old record since it is no longer referenced.
			delete from UMETRICS.Attribute where AttributeId=attribute_id_of_changing_value;

			commit;
		end if;
	end if;
END ;;
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
