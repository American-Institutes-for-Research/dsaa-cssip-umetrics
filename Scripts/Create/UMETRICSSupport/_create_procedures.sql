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
/*!50003 DROP PROCEDURE IF EXISTS `CalculateBasicColumnStatistics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysqladmin`@`%` PROCEDURE `CalculateBasicColumnStatistics`(IN `_DatabaseStatisticsRunId` INT, IN `_database_name` VARCHAR(64), IN `_keyed_columns_only` BIT)
    COMMENT 'Stored procedure to calculate the basic statistics for all columns for all tables in a specified database and add them to the BasicColumnStatistics table.'
BEGIN


	################################################################################
	# Copyright (c) 2014, AMERICAN INSTITUTES FOR RESEARCH
	# All rights reserved.
	# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
	# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	################################################################################

	DECLARE done INT DEFAULT FALSE;
	declare t_schema, t_name, c_name, d_type varchar(64);
	# We'll use this cursor when _keyed_column_only is false - i.e. when we want to do this for all columns in the table
	declare cur1 cursor for select table_schema, table_name, column_name, data_type from information_schema.COLUMNS where table_schema=_database_name;
	# We'll use this cursor when _keyed_column_only is true - i.e. when we only want to do this for columns that are in an index/key
	declare cur2 cursor for select table_schema, table_name, column_name, data_type from information_schema.COLUMNS where table_schema=_database_name and column_key<>'';
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	if _keyed_columns_only then
		open cur2;
	else
		open cur1;
	end if;
	
	# We'll iterate for each column for each table for the specific database. Each time we'll create a prepared SQL statement.
	# We can't do this without a prepared statement becuse we need to dynamically decide on the database, table, and column.
	# We'll then execute the statement, which will insert a row into the BasicColumnStatistics table.
	read_loop: LOOP
		if _keyed_columns_only then
			fetch cur2 into t_schema, t_name, c_name, d_type;
		else
			fetch cur1 into t_schema, t_name, c_name, d_type;
		end if;
		if done then
			leave read_loop;
		end if;
		case
			when (d_type = 'VARCHAR') or
					(d_type = 'CHAR') or
					(d_type = 'TEXT') then
				# You'll see lots of double-quotes around replacement variables. That's because some folks think it is ok
				# to have column names that are keywords, so they need the quotes in order to pass SQL syntax checking and
				# function as expected.
				set @stmt = 'insert into BasicColumnStatistics (DatabaseStatisticsRunId, DatabaseName, TableName, ColumnName, DataType,
									RowCount, NotNullCount, DistinctCount, MinimumValueChar, MaximumValueChar, MinimumLength, MaximumLength, AverageLength) 
								select %database_statistics_run_id%, "%t_schema%", "%t_name%", "%c_name%", "%d_type%", count(*), count(%t_name%.%c_name%),
									count(distinct %t_name%.%c_name%), min(%t_name%.%c_name%), max(%t_name%.%c_name%), min(length(%t_name%.%c_name%)), max(length(%t_name%.%c_name%)),
									avg(length(%t_name%.%c_name%))
									from %t_schema%.%t_name%;';
			when (d_type = 'INT') or
					(d_type = 'BIGINT') or
					(d_type = 'MEDIUMINT') or
					(d_type = 'SMALLINT') or
					(d_type = 'TINYINT') or
					(d_type = 'DECIMAL') or
					(d_type = 'DOUBLE') or
					(d_type = 'FLOAT') then
				set @stmt = 'insert into BasicColumnStatistics (DatabaseStatisticsRunId, DatabaseName, TableName, ColumnName, DataType,
									RowCount, NotNullCount, DistinctCount, MinimumValueNumeric, MaximumValueNumeric, AverageValueNumeric) 
								select %database_statistics_run_id%, "%t_schema%", "%t_name%", "%c_name%", "%d_type%", count(*), count(%t_name%.%c_name%),
									count(distinct %t_name%.%c_name%), min(%t_name%.%c_name%), max(%t_name%.%c_name%), avg(%t_name%.%c_name%)
									from %t_schema%.%t_name%;';
			when (d_type = 'DATE') or
					(d_type = 'TIME') or
					(d_type = 'TIMESTAMP') or
					(d_type = 'YEAR') then
				set @stmt = 'insert into BasicColumnStatistics (DatabaseStatisticsRunId, DatabaseName, TableName, ColumnName, DataType,
									RowCount, NotNullCount, DistinctCount, MinimumValueDate, MaximumValueDate, AverageValueDate) 
								select %database_statistics_run_id%, "%t_schema%", "%t_name%", "%c_name%", "%d_type%", count(*), count(%t_name%.%c_name%),
									count(distinct %t_name%.%c_name%), min(%t_name%.%c_name%), max(%t_name%.%c_name%), from_unixtime(avg(unix_timestamp(%t_name%.%c_name%)))
									from %t_schema%.%t_name%;';
			else
				set @stmt = 'insert into BasicColumnStatistics (DatabaseStatisticsRunId, DatabaseName, TableName, ColumnName, DataType,
									RowCount, NotNullCount, DistinctCount)
								select %database_statistics_run_id%, "%t_schema%", "%t_name%", "%c_name%", "%d_type%", count(*), count(%t_name%.%c_name%),
									count(distinct %t_name%.%c_name%)
									from %t_schema%.%t_name%;';
		end case;
		if @stmt <> '' then
	      set @stmt = replace(@stmt, '%c_name%', c_name);
	      set @stmt = replace(@stmt, '%t_name%', t_name);
	      set @stmt = replace(@stmt, '%t_schema%', t_schema);
	      set @stmt = replace(@stmt, '%d_type%', d_type);
	      set @stmt = replace(@stmt, '%database_statistics_run_id%', _DatabaseStatisticsRunId);
	      prepare stmt from @stmt;
	      execute stmt;
	      deallocate prepare stmt;
	   end if;
	END LOOP;
		
	if _keyed_columns_only then
		close cur2;
	else
		close cur1;
	end if;
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CalculateEnumeratedStatistics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysqladmin`@`%` PROCEDURE `CalculateEnumeratedStatistics`(IN `_DatabaseStatisticsRunId` INT, IN `_database_name` VARCHAR(64), IN `_table_name` VARCHAR(64), IN `_column_name` VARCHAR(64))
    COMMENT 'Stored procedure to calculate the row counts for each unique value in a specified column in a specific table in a specified database and add them to the EnumeratedStatistics table.'
BEGIN


	################################################################################
	# Copyright (c) 2014, AMERICAN INSTITUTES FOR RESEARCH
	# All rights reserved.
	# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
	# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	################################################################################


	declare d_type varchar(64);
	
	select data_type into d_type from information_schema.columns where table_schema=_database_name and table_name=_table_name and column_name=_column_name;
	
	case
		when (d_type = 'VARCHAR') or
				(d_type = 'CHAR') or
				(d_type = 'TEXT') then
			set @stmt = 'insert into EnumeratedStatistics (DatabaseStatisticsRunId, DatabaseName, TableName, ColumnName, DataType,
								ValueRowCount, ValueChar)
							select %database_statistics_run_id%, "%t_schema%", "%t_name%", "%c_name%", "%d_type%", count(*), %t_name%.%c_name%
									from %t_schema%.%t_name%
									group by %t_schema%.%t_name%.%c_name%;';
		when (d_type = 'INT') or
				(d_type = 'BIGINT') or
				(d_type = 'MEDIUMINT') or
				(d_type = 'SMALLINT') or
				(d_type = 'TINYINT') or
				(d_type = 'DECIMAL') or
				(d_type = 'DOUBLE') or
				(d_type = 'FLOAT') then
			set @stmt = 'insert into EnumeratedStatistics (DatabaseStatisticsRunId, DatabaseName, TableName, ColumnName, DataType, 
								ValueRowCount, ValueNumeric)
							select %database_statistics_run_id%, "%t_schema%", "%t_name%", "%c_name%", "%d_type%", count(*), %t_name%.%c_name%
									from %t_schema%.%t_name%
									group by %t_schema%.%t_name%.%c_name%;';
		when (d_type = 'DATE') or
				(d_type = 'TIME') or
				(d_type = 'TIMESTAMP') or
				(d_type = 'YEAR') then
			set @stmt = 'insert into EnumeratedStatistics (DatabaseStatisticsRunId, DatabaseName, TableName, ColumnName, DataType,
								ValueRowCount, ValueDate)
							select %database_statistics_run_id%, "%t_schema%", "%t_name%", "%c_name%", "%d_type%", count(*), %t_name%.%c_name%
									from %t_schema%.%t_name%
									group by %t_schema%.%t_name%.%c_name%;';
		else
			set @stmt = 'insert into EnumeratedStatistics (DatabaseStatisticsRunId, DatabaseName, TableName, ColumnName, DataType,
								ValueRowCount, ValueChar)
							select %database_statistics_run_id%, "%t_schema%", "%t_name%", "%c_name%", "%d_type%", count(*), %t_name%.%c_name%
									from %t_schema%.%t_name%
									group by %t_schema%.%t_name%.%c_name%;';
	end case;
	
	if @stmt <> '' then
      set @stmt = replace(@stmt, '%c_name%', _column_name);
      set @stmt = replace(@stmt, '%t_name%', _table_name);
      set @stmt = replace(@stmt, '%t_schema%', _database_name);
      set @stmt = replace(@stmt, '%d_type%', d_type);
      set @stmt = replace(@stmt, '%database_statistics_run_id%', _DatabaseStatisticsRunId);
      prepare stmt from @stmt;
      execute stmt;
      deallocate prepare stmt;
   end if;
		
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CalculateGroupByStatistics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysqladmin`@`%` PROCEDURE `CalculateGroupByStatistics`(IN `_DatabaseStatisticsRunId` INT, IN `_database_name` VARCHAR(64), IN `_table_name` VARCHAR(64), IN `_column_name` VARCHAR(64))
    COMMENT 'Stored procedure to calculate the statistics of the row counts for a specified table in a specified database when the rows are grouped by a specified column, and add them to the GroupByStatistics table.'
BEGIN

	################################################################################
	# Copyright (c) 2014, AMERICAN INSTITUTES FOR RESEARCH
	# All rights reserved.
	# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
	# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	################################################################################


	declare sum_count, median_count, mode_count, minimum_count, maximum_count int;
	declare mean_count, stddev_count, variance_count float;

	set @stmt = 'create temporary table temp_rowcounts
						select count(*) as rowcount
						from %t_schema%.%t_name%
						group by %t_name%.%c_name%;';
   set @stmt = replace(@stmt, '%c_name%', _column_name);
   set @stmt = replace(@stmt, '%t_name%', _table_name);
   set @stmt = replace(@stmt, '%t_schema%', _database_name);
   prepare stmt from @stmt;
   execute stmt;
   deallocate prepare stmt;
   
	set @stmt = 'create temporary table temp_rowcounts2
						select count(*) as rowcount
						from %t_schema%.%t_name%
						group by %t_name%.%c_name%;';
   set @stmt = replace(@stmt, '%c_name%', _column_name);
   set @stmt = replace(@stmt, '%t_name%', _table_name);
   set @stmt = replace(@stmt, '%t_schema%', _database_name);
   prepare stmt from @stmt;
   execute stmt;
   deallocate prepare stmt;
      
		
	select sum(rowcount), min(rowcount), max(rowcount), avg(rowcount), stddev(rowcount), variance(rowcount)
		into sum_count, minimum_count, maximum_count, mean_count, stddev_count, variance_count
		from temp_rowcounts x;

	select rowcount
		into mode_count
		from temp_rowcounts x
			group by rowcount
			order by count(rowcount) desc
			limit 1;
		
	SELECT avg(t1.rowcount) as median_val
		into median_count
		FROM (
				SELECT @rownum:=@rownum+1 as `row_number`, d.rowcount
				  FROM temp_rowcounts d,
				  (SELECT @rownum:=0) r
					  WHERE 1
					  -- put some where clause here
					  ORDER BY d.rowcount
				) as t1, 
				(
				SELECT count(*) as total_rows
				  FROM temp_rowcounts2 d
				WHERE 1
				-- put same where clause here
				) as t2
		WHERE 1
			AND t1.row_number in ( floor((total_rows+1)/2), floor((total_rows+2)/2) );


	drop temporary table temp_rowcounts;
	drop temporary table temp_rowcounts2;

	set @stmt = 'insert into GroupByStatistics (DatabaseStatisticsRunId, DatabaseName, TableName, ColumnName,
						RowCount, MeanCount, MedianCount, ModeCount, StddevCount, VarianceCount,
						MinimumCount, MaximumCount)
					select %database_statistics_run_id%, "%t_schema%", "%t_name%", "%c_name%",
						%sum_count%, %mean_count%, %median_count%, %mode_count%, %stddev_count%, %variance_count%,
						%minimum_count%, %maximum_count%;';

	if @stmt <> '' then
      set @stmt = replace(@stmt, '%c_name%', _column_name);
      set @stmt = replace(@stmt, '%t_name%', _table_name);
      set @stmt = replace(@stmt, '%t_schema%', _database_name);
      set @stmt = replace(@stmt, '%database_statistics_run_id%', _DatabaseStatisticsRunId);
      set @stmt = replace(@stmt, '%sum_count%', sum_count);
      set @stmt = replace(@stmt, '%mean_count%', mean_count);
      set @stmt = replace(@stmt, '%median_count%', median_count);
      set @stmt = replace(@stmt, '%mode_count%', mode_count);
      set @stmt = replace(@stmt, '%stddev_count%', stddev_count);
      set @stmt = replace(@stmt, '%variance_count%', variance_count);
      set @stmt = replace(@stmt, '%minimum_count%', minimum_count);
      set @stmt = replace(@stmt, '%maximum_count%', maximum_count);
      prepare stmt from @stmt;
      execute stmt;
      deallocate prepare stmt;
   end if;
		
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
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
CREATE DEFINER=`mysqladmin`@`%` PROCEDURE `CalculatePersonAttributeStatistics`()
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


	declare _overall_person_count int unsigned;
	declare _overall_person_attribute_count int unsigned;


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
/*!50003 DROP PROCEDURE IF EXISTS `CollapsePersons` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysqladmin`@`%` PROCEDURE `CollapsePersons`(IN `person_a_id` int unsigned, IN `person_b_id` int unsigned, IN `notes` varchar(500))
    MODIFIES SQL DATA
    SQL SECURITY INVOKER
    COMMENT 'Collapses two People records and all of their supporting baggage.'
begin


	################################################################################
	# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
	# All rights reserved.
	# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
	# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	################################################################################


	declare _older_person_id int unsigned;
	declare _newer_person_id int unsigned;
	declare _person_collapse_log_id int unsigned;


	# Perform some sanity checking.
	if person_a_id is null then
		signal sqlstate '45000' set message_text = 'person_a_id is required';
	elseif not exists (select PersonId from UMETRICS.Person where PersonId = person_a_id) then
		signal sqlstate '45000' set message_text = 'person_a_id does not exist in the Person table';
	elseif person_b_id is null then
		signal sqlstate '45000' set message_text = 'person_b_id is required';
	elseif not exists (select PersonId from UMETRICS.Person where PersonId = person_b_id) then
		signal sqlstate '45000' set message_text = 'person_b_id does not exist in the Person table';
	elseif person_a_id = person_b_id then
		signal sqlstate '45000' set message_text = 'person_a_id may not equal person_b_id';
	end if;


	# The assumption here is that, since PersonIds are assigned serially, the lower the
	# PersonId, the longer the Person has been in the database.  For consistency and to
	# cause PersonIds to be a bit more static, we will always collapse down into an older
	# Persons.
	if person_a_id < person_b_id then
		set _older_person_id = person_a_id;
		set _newer_person_id = person_b_id;
	else
		set _older_person_id = person_b_id;
		set _newer_person_id = person_a_id;
	end if;


	# The following tables will be affected for collapses:
	#
	#    Person
	#    PersonAddress
	#    PersonAttribute
	#    PersonGrantAward
	#    PersonName
	#    PersonPublication
	#    PersonTerm
	#
	# For every table above except Person, we are going to renumber the new PersonId to the
	# older PersonId.  We will have to check ahead of time to ensure that certain records
	# don't already exist.  Duplicates will be deleted.  Once everything is collapsed, we
	# will remove the newer person.
	#
	# We will also log everything that was collapsed, for posterity.


	# Create an anchor point for our collapse.
	insert into UMETRICSSupport.CollapsePersonsLog
	(
		CollapsedPersonId,
		TargetPersonId,
		CollapseDateTime,
		Notes
	)
	values
	(
		_newer_person_id,
		_older_person_id,
		now(),
		notes
	);

	set _person_collapse_log_id = last_insert_id();


	# Each of these sections is going to work pretty much the same way:
	#
	#   1 - log upcoming deletes
	#   2 - perform deletes
	#   3 - log upcoming reassignments
	#   4 - perform reassignment


	set @counter = 0;


	###### PersonAddress


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonAddress',
		a.PersonAddressId,
		'DELETED',
		concat_ws('', '<PersonAddress><PersonAddressId>', a.PersonAddressId, '</PersonAddressId><PersonId>', a.PersonId, '</PersonId><AddressId>', a.AddressId, '</AddressId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonAddress>')

	from
		UMETRICS.PersonAddress a

		inner join UMETRICS.PersonAddress b on
		b.PersonId = _older_person_id and
		b.AddressId = a.AddressId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	delete
		a

	from
		UMETRICS.PersonAddress a

		inner join UMETRICS.PersonAddress b on
		b.PersonId = _older_person_id and
		b.AddressId = a.AddressId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonAddress',
		a.PersonAddressId,
		'REASSIGNED',
		concat_ws('', '<PersonAddress><PersonAddressId>', a.PersonAddressId, '</PersonAddressId><PersonId>', a.PersonId, '</PersonId><AddressId>', a.AddressId, '</AddressId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonAddress>')

	from
		UMETRICS.PersonAddress a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonAddress

	set
		PersonId = _older_person_id,
		RelationshipCode = if(RelationshipCode = 'PRIMARY', 'ALTERNATE', RelationshipCode) # Multiple PRIMARY addresses can be problematic.

	where
		PersonId = _newer_person_id;


	###### PersonAttribute


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonAttribute',
		a.PersonAttributeId,
		'DELETED',
		concat_ws('', '<PersonAttribute><PersonAttributeId>', a.PersonAttributeId, '</PersonAttributeId><PersonId>', a.PersonId, '</PersonId><AttributeId>', a.AttributeId, '</AttributeId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonAttribute>')

	from
		UMETRICS.PersonAttribute a

		inner join UMETRICS.PersonAttribute b on
		b.PersonId = _older_person_id and
		b.AttributeId = a.AttributeId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	delete
		a

	from
		UMETRICS.PersonAttribute a

		inner join UMETRICS.PersonAttribute b on
		b.PersonId = _older_person_id and
		b.AttributeId = a.AttributeId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonAttribute',
		a.PersonAttributeId,
		'REASSIGNED',
		concat_ws('', '<PersonAttribute><PersonAttributeId>', a.PersonAttributeId, '</PersonAttributeId><PersonId>', a.PersonId, '</PersonId><AttributeId>', a.AttributeId, '</AttributeId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonAttribute>')

	from
		UMETRICS.PersonAttribute a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonAttribute

	set
		PersonId = _older_person_id

	where
		PersonId = _newer_person_id;


	###### PersonGrantAward


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonGrantAward',
		a.PersonGrantAwardId,
		'DELETED',
		concat_ws('', '<PersonGrantAward><PersonGrantAwardId>', a.PersonGrantAwardId, '</PersonGrantAwardId><PersonId>', a.PersonId, '</PersonId><GrantAwardId>', a.GrantAwardId, '</GrantAwardId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonGrantAward>')

	from
		UMETRICS.PersonGrantAward a

		inner join UMETRICS.PersonGrantAward b on
		b.PersonId = _older_person_id and
		b.GrantAwardId = a.GrantAwardId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	delete
		a

	from
		UMETRICS.PersonGrantAward a

		inner join UMETRICS.PersonGrantAward b on
		b.PersonId = _older_person_id and
		b.GrantAwardId = a.GrantAwardId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonGrantAward',
		a.PersonGrantAwardId,
		'REASSIGNED',
		concat_ws('', '<PersonGrantAward><PersonGrantAwardId>', a.PersonGrantAwardId, '</PersonGrantAwardId><PersonId>', a.PersonId, '</PersonId><GrantAwardId>', a.GrantAwardId, '</GrantAwardId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonGrantAward>')

	from
		UMETRICS.PersonGrantAward a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonGrantAward

	set
		PersonId = _older_person_id

	where
		PersonId = _newer_person_id;


	###### PersonName - PersonNames are never deleted, only reassigned as they enjoy a
	#                   special kind of relationship with a Person.


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	# To save on space, we are not going to record the entire name, just the bits that help
	# us trace collapses.  The actual name information is never really lost due to
	# collapsing, so the risk is much lower.
	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonName',
		a.PersonNameId,
		'REASSIGNED',
		concat_ws('', '<PersonName><PersonNameId>', a.PersonNameId, '</PersonNameId><PersonId>', a.PersonId, '</PersonId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonName>')

	from
		UMETRICS.PersonName a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonName

	set
		PersonId = _older_person_id,
		RelationshipCode = if(RelationshipCode = 'PRIMARY', 'ALIAS', RelationshipCode) # Multiple PRIMARY names can be problematic

	where
		PersonId = _newer_person_id;


	###### PersonPublication


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonPublication',
		a.PersonPublicationId,
		'DELETED',
		concat_ws('', '<PersonPublication><PersonPublicationId>', a.PersonPublicationId, '</PersonPublicationId><PersonId>', a.PersonId, '</PersonId><PublicationId>', a.PublicationId, '</PublicationId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonPublication>')

	from
		UMETRICS.PersonPublication a

		inner join UMETRICS.PersonPublication b on
		b.PersonId = _older_person_id and
		b.PublicationId = a.PublicationId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	delete
		a

	from
		UMETRICS.PersonPublication a

		inner join UMETRICS.PersonPublication b on
		b.PersonId = _older_person_id and
		b.PublicationId = a.PublicationId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonPublication',
		a.PersonPublicationId,
		'REASSIGNED',
		concat_ws('', '<PersonPublication><PersonPublicationId>', a.PersonPublicationId, '</PersonPublicationId><PersonId>', a.PersonId, '</PersonId><PublicationId>', a.PublicationId, '</PublicationId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode></PersonPublication>')

	from
		UMETRICS.PersonPublication a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonPublication

	set
		PersonId = _older_person_id

	where
		PersonId = _newer_person_id;


	###### PersonTerm


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonTerm',
		a.PersonTermId,
		'DELETED',
		concat_ws('', '<PersonTerm><PersonTermId>', a.PersonTermId, '</PersonTermId><PersonId>', a.PersonId, '</PersonId><TermId>', a.TermId, '</TermId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode><Weight>', a.Weight, '</Weight></PersonTerm>')

	from
		UMETRICS.PersonTerm a

		inner join UMETRICS.PersonTerm b on
		b.PersonId = _older_person_id and
		b.TermId = a.TermId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	delete
		a

	from
		UMETRICS.PersonTerm a

		inner join UMETRICS.PersonTerm b on
		b.PersonId = _older_person_id and
		b.TermId = a.TermId and
		b.RelationshipCode = a.RelationshipCode

	where
		a.PersonId = _newer_person_id;


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'PersonTerm',
		a.PersonTermId,
		'REASSIGNED',
		concat_ws('', '<PersonTerm><PersonTermId>', a.PersonTermId, '</PersonTermId><PersonId>', a.PersonId, '</PersonId><TermId>', a.TermId, '</TermId><RelationshipCode>', a.RelationshipCode, '</RelationshipCode><Weight>', a.Weight, '</Weight></PersonTerm>')

	from
		UMETRICS.PersonTerm a

	where
		a.PersonId = _newer_person_id;


	update
		UMETRICS.PersonTerm

	set
		PersonId = _older_person_id

	where
		PersonId = _newer_person_id;


	### Finally, blow away the newer person.


	insert into UMETRICSSupport.CollapsePersonsDetail
	(
		CollapsePersonsLogId,
		OrderNumber,
		TableName,
		TableId,
		Event,
		Snapshot
	)

	select
		_person_collapse_log_id,
		@counter := @counter + 1,
		'Person',
		_newer_person_id,
		'DELETED',
		concat_ws('', '<Person><PersonId>', _newer_person_id, '</PersonId></Person>');


	delete from UMETRICS.Person where PersonId = _newer_person_id;


end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertDatabaseStatisticsRun` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mysqladmin`@`%` PROCEDURE `InsertDatabaseStatisticsRun`(IN `_database_name` VARCHAR(100), IN `_description` VARCHAR(250), OUT `_DatabaseStatisticsRunId` INT)
BEGIN

	################################################################################
	# Copyright (c) 2014, AMERICAN INSTITUTES FOR RESEARCH
	# All rights reserved.
	# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
	# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
	# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	################################################################################

	insert into DatabaseStatisticsRun (AsOf, DatabaseName, Description) values (now(), _database_name, _description);
	set _DatabaseStatisticsRunId = last_insert_id();
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
