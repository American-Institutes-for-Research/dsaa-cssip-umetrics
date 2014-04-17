################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################


	/****************************************************************************************

	NOTES

		General observations, documented assumptions, and other notes of interest.  Much of
		this will need to be double checked when the new data is released.

		In order for this script to function properly, you will need a copy of select tables
		from the Flemming USPTO database on the database instance where you intend to run this
		script.  And, unless you want to globally replace the database name in this script,
		you will want to name that database "uspto" (NOTE TO SELF: Let's change this in the
		future to "flemming_uspto" or some such nonsense since uspto is ambiguous in the
		UMetrics domain).

		You will need to create the destination database before you run this script and it
		shall be called "PatentsView" unless, again, you wish to globally replace that name
		with something else.

		PLEASE NOTE:  These observations were of the original uspto dataset and have not
		been updated with subsequent data updates.



	ASSIGNEE

		According to USPTO Red Book documentation, assignee type is a numeric value between 1
		and 9.  The data actually contained in this column varies wildly and contains pipe
		characters (|) and what appears to be country codes.  I have stripped pipes and removed
		values that are purely alphabetic characters.  I have not done anything about numbers
		outside of the 1 to 9 range.

			select type, count(*) from assignee group by type order by type;

		The nationality column is not populated.  The residence column contains 3 rows with data,
		none of which appears to be a location.  I have not included either of these columns in
		the PatentsView database.



	FOREIGNCITATION

		Many foreign citations do not include a patent id.  Without being able to link them back
		to a patent, those citations are unusable and were not included in the PatentsView
		database.

			select count(*) from foreigncitation; -- 43,690,188
			select count(*) from foreigncitation where patent_id = ''; -- 35,053,568 (80%)

		This is probably related to the missing patent ids, but there are citations where the
		sequence count is missing sections.  For example, with patent '7354988', when I count
		the number of foreign citations (77), domestic citations (121), and other citations
		(32), I come up with 230 citations total, yet the sequence number for these columns
		runs up to 291.  Where are the other 61 citations?  Are they part of the citations
		without patent ids?  The other citations sequence overlaps with foreign and us
		citations.  When I exclude them, I end up with 198 citations total with the max
		sequence still at 291.  Where are the other 93 citations? For example, the range of
		sequence numbers between 121 and 214 are missing for '7354988'.

			select count(*) from otherreference where patent_id = '7354988'; -- 32
			select count(*) from foreigncitation where patent_id = '7354988'; -- 77
			select count(*) from uspatentcitation where patent_id = '7354988'; -- 121

			select 'or', sequence from otherreference where patent_id = '7354988'
				union all
			select 'fc', sequence from foreigncitation where patent_id = '7354988'
				union all
			select 'upc', sequence from uspatentcitation where patent_id = '7354988' order by sequence;

		Since they are nearly the same data, I have combined foreigncitation and
		uspatentcitation.



	INVENTOR

		The data in this table appears to be mixed up.  There are country codes in the first
		name column for many, many rows.



	INVENTORRANK

		This table is currently empty.  I have made no attempt to copy it to the PatentsView
		database.



	LOCATION

		There seems to be quite a bit of what appears to be improperly encoded data in this
		table (i.e. data that may have been in a character set other than latin1 that were
		forced into latin1 - usually denoted by a bunch of question marks '?????').  Not much
		we can do with this, so I have nulled these values out.

			select * from location where city regexp '^[ ?]+$' limit 10;
			select count(*) from location where city regexp '^[ ?]+$'; -- 1,820



	LOCATION_ASSIGNEE

		There are many, many duplicates in this table.  I have trimmed them out.  This should
		help tremendously with the size of the table.

			select count(*) from location_assignee; -- 1,698,360
			select count(distinct location_id, assignee_id) from location_assignee; -- 255,183 (15%)



	LOCATION_INVENTOR

		There are a handful of duplicates in this table.  I have trimmed them out.

			select count(*) from location_inventor; -- 2,629,291
			select count(distinct location_id, inventor_id) from location_inventor; -- 2,602,878 (99%)



	MAINCLASS

		This table is essentially empty in that it only contains a primary key.  The title and
		text are not meaningfully populated.  From the documentation: "These will contain
		descriptions of what the main classes are. Currently unpopulated, but the USPC above can
		be cross referenced with the USPTO websites, so these are not a priority."

			select count(*) from mainclass; -- 885
			select count(*) from mainclass where title is not null or text is not null; -- 3

		I have not copied this to the PatentsView database.



	PATENT

		Many patents are missing crucial data (or any data, really).

			select count(*) from USPTO.patent; -- 5,001,277
			select count(*) from USPTO.patent where type = '' and title = '' and abstract = '' and kind = '' and country = ''; -- 2,353,430 (47%)

		There are almost 6,000 patents where the number column does not match the id column.  In
		all of those cases, the patent number starts with a letter and has an extra 0 between
		the letter and the rest of the number.  I used number as the patent number in the
		PatentsView database.

			select id, number from patent where id != number; -- example: H001705 / H0001705

		The country code, where it exists, is always US.  I did not include country in the
		PatentsView database.

			select country, count(*) from patent group by country;

		I split the title out from the rest of the patent since it is a TEXT field.  This should
		speed queries against the patent table but will require an extra join when querying the
		title column.

		I did not include the abstract column since it didn't look like it was being used in
		PatentsView.



	PATENT_ASSIGNEE




	PATENT_INVENTOR

		There are some duplicates in this table.  Is it possible for an inventor to be listed
		more than once or are these maybe inventors that were, perhaps improperly, collapsed
		down during disambiguation?

			select count(*) from patent_inventor; -- 5,209,374
			select count(distinct patent_id, inventor_id) from patent_inventor; -- 5,209,150



	SUBCLASS

		This table is essentially empty in that it only contains a primary key.  The title and
		text are not meaningfully populated.  From the documentation: "These will contain
		descriptions of what the main classes are. Currently unpopulated, but the USPC above can
		be cross referenced with the USPTO websites, so these are not a priority."

			select count(*) from subclass; -- 157,203
			select count(*) from subclass where nullif(title, '') is not null or nullif(text, '') is not null; -- 0

		I have not copied this to the PatentsView database.



	USPATENTCITATION

		See comments under FOREIGNCITATION.



	USPC

		Many, many rows do not contain a patent_id and, as such, cannot be linked back to a
		patent.  These rows were not included in the PatentsView database.

			select count(*) from uspc; -- 32,021,123
			select count(*) from uspc where patent_id = ''; -- 19,878,852 (62%)

		It seems class/subclass information is duplicated for many of these in that, sometimes,
		the subclass contains just the subclass and sometimes it contains both the mainclass and
		the subclass.  For example, for patent '7609258', '345/419' is listed as both
		'345','419' and '345','345/419', if that makes sense.

			select * from uspc where patent_id = '7609258'

		Also, the sequence seems to be off for many patents.  Again, using patent '7609258' as
		an example, there are 7 mainclass/subclass combinations.  The first one is sequence 1
		and all the others are sequence 2.

			select * from uspc where patent_id = '7609258'



	****************************************************************************************/



	create database if not exists `PatentsView` /*!40100 DEFAULT CHARACTER SET latin1 */;



	## ID REMAPPINGS ########################################################################



	-- So we are going to use basic, unsigned integers for all of our ids.  This means we will
	-- need to remap all of the larger uuid and other textual ids.  We're going to do this
	-- through a collection of temporary tables that we will create in this section.
	--
	-- I opted not to use ACTUAL temporary tables for several reasons, the foremost being that
	-- I didn't want to recreate them every time I wanted to re-run certain sections of this
	-- script.  Also, they tend to be tempermental; lose your connection for whatever reason
	-- and they vanish.  Finally, and perhaps most annoyingly, they cannot be joined to more
	-- than once in a single query.
	--
	-- We will perform all of the data filtering here in order to speed joins later.  Plus,
	-- reducing data insertions SHOULD speed this up, even if we have to perform full table
	-- scans.



	-- ASSIGNEE (290,061 rows @ 9.500 sec) --------------------------------------------------
	-- ASSIGNEE (466,614 rows @ 4.516 sec) --------------------------------------------------
	-- ASSIGNEE RDS (466,614 rows @ 7.395 sec) --------------------------------------------------



	drop table if exists `PatentsView`.`temp_id_mapping_assignee`;



	create table `PatentsView`.`temp_id_mapping_assignee`
	(
		`new_assignee_id` int unsigned not null auto_increment,
		`old_assignee_id` varchar(36) not null,
		primary key (`new_assignee_id`),
		unique index `ak_temp_id_mapping_assignee` (`old_assignee_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into
		`PatentsView`.`temp_id_mapping_assignee` (`old_assignee_id`)
	select
		`id`
	from
		`uspto`.`assignee`
	where
		nullif(`name_first`, '') is not null or
		nullif(`name_last`, '') is not null or
		nullif(`organization`, '') is not null;



	-- CITATION (43,750,321 rows @ 00:16:59) ------------------------------------------------
	-- CITATION (70,466,235 rows @ 00:10:14) ------------------------------------------------
	-- CITATION RDS (70,466,235 rows @ 00:19:53) ------------------------------------------------



	-- 35,113,701 00:12:56
	drop table if exists `PatentsView`.`temp_id_mapping_uspatentcitation`;



	create table `PatentsView`.`temp_id_mapping_uspatentcitation`
	(
		`new_citation_id` int unsigned not null auto_increment,
		`old_citation_id` varchar(36) not null,
		primary key (`new_citation_id`),
		unique index `ak_temp_id_mapping_uspatentcitation` (`old_citation_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into
		`PatentsView`.`temp_id_mapping_uspatentcitation` (`old_citation_id`)

	select
		`uuid`

	from
		`uspto`.`uspatentcitation`

	where
		nullif(`patent_id`, '') is not null and
		(
			nullif(`date`, date('0000-00-00')) is not null or
			nullif(`number`, '') is not null or
			nullif(`country`, '') is not null
		);



	-- 8,636,620 00:04:03
	drop table if exists `PatentsView`.`temp_id_mapping_foreigncitation`;



	create table `PatentsView`.`temp_id_mapping_foreigncitation`
	(
		`new_citation_id` int unsigned not null auto_increment,
		`old_citation_id` varchar(36) not null,
		primary key (`new_citation_id`),
		unique index `ak_temp_id_mapping_foreigncitation` (`old_citation_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	-- We want the number for this to start where the previous one left off so we can merge
	-- them later.
	insert into
		`PatentsView`.`temp_id_mapping_foreigncitation` (`new_citation_id`, `old_citation_id`)
	select
		max(new_citation_id),
		'XXXXX QQQ BOGUS QQQ XXXXX'
	from
		`PatentsView`.`temp_id_mapping_uspatentcitation`;



	insert into
		`PatentsView`.`temp_id_mapping_foreigncitation` (`old_citation_id`)

	select
		`uuid`

	from
		`uspto`.`foreigncitation`

	where
		nullif(`patent_id`, '') is not null and
		(
			nullif(`date`, date('0000-00-00')) is not null or
			nullif(`number`, '') is not null or
			nullif(`country`, '') is not null
		);



	-- INVENTOR (4,919,420 rows @ 00:01:23) -------------------------------------------------
	-- INVENTOR (3,441,192 rows @ 27.000 sec) -------------------------------------------------
	-- INVENTOR RDS (3,441,192 rows @ 38.360 sec) -------------------------------------------------



	drop table if exists `PatentsView`.`temp_id_mapping_inventor`;



	create table `PatentsView`.`temp_id_mapping_inventor`
	(
		`new_inventor_id` int unsigned not null auto_increment,
		`old_inventor_id` varchar(36) not null,
		primary key (`new_inventor_id`),
		unique index `ak_temp_id_mapping_inventor` (`old_inventor_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into
		`PatentsView`.`temp_id_mapping_inventor` (`old_inventor_id`)
	select
		`id`
	from
		`uspto`.`inventor`
	where
		nullif(`name_first`, '') is not null or
		nullif(`name_last`, '') is not null;



	-- LOCATION (84,356 rows @ 3.728 sec) ---------------------------------------------------
	-- LOCATION (66,058 rows @ 1.249 sec) ---------------------------------------------------
	-- LOCATION RDS (66,058 rows @ 1.466 sec) ---------------------------------------------------



	drop table if exists `PatentsView`.`temp_id_mapping_location`;



	create table `PatentsView`.`temp_id_mapping_location`
	(
		`new_location_id` int unsigned not null auto_increment,
		`old_location_id` varchar(256) not null,
		primary key (`new_location_id`),
		unique index `ak_temp_id_mapping_location` (`old_location_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into
		`PatentsView`.`temp_id_mapping_location` (`old_location_id`)
	select
		`id`
	from
		`uspto`.`location`
	where
		(nullif(`city`, '') is not null and `city` not regexp '^[ ?-]+$') or
		(nullif(`state`, '') is not null and `state` not regexp '^[ ?-]+$') or
		(nullif(`country`, '') is not null and `country` not regexp '^[ ?-]+$') or
		latitude is not null or
		longitude is not null;



	-- PATENT (5,001,277 rows @ 00:01:26) ---------------------------------------------------
	-- PATENT (5,037,938 rows @ 45.860 sec) ---------------------------------------------------
	-- PATENT RDS (5,037,938 rows @ 00:01:31) ---------------------------------------------------



	drop table if exists `PatentsView`.`temp_id_mapping_patent`;



	create table `PatentsView`.`temp_id_mapping_patent`
	(
		`new_patent_id` int unsigned not null auto_increment,
		`old_patent_id` varchar(20) not null,
		primary key (`new_patent_id`),
		unique index `ak_temp_id_mapping_patent` (`old_patent_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into
		`PatentsView`.`temp_id_mapping_patent` (`old_patent_id`)
	select
		`id`
	from
		`uspto`.`patent`
	where
		`num_claims` is not null or
		nullif(`number`, '') is not null or
		nullif(`date`, date('0000-00-00')) is not null or
		nullif(`title`, '') is not null;



	## BASE TABLES ##########################################################################



	-- ASSIGNEE (290,061 rows @ 12.714 sec) -------------------------------------------------
	-- ASSIGNEE (466,614 rows @ 9.875 sec) -------------------------------------------------
	-- ASSIGNEE RDS (466,614 rows @ 13.089 sec) -------------------------------------------------



	drop table if exists `PatentsView`.`assignee`;



	-- Create the new assignee table.
	create table `PatentsView`.`assignee`
	(
		`assignee_id` int unsigned not null,
		`first_last_org` varchar(256) not null,
		`name_source` enum('INDIVIDUAL','ORGANIZATION') not null,
		primary key (`assignee_id`),
		index `ix_assignee_first_last_org` (`first_last_org`),
		index `ix_assignee_name_source` (`name_source`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	-- Add the old assignee data + new assignee ids to the new assignee table.
	insert into `PatentsView`.`assignee`
	(
		`assignee_id`,
		`first_last_org`,
		`name_source`
	)

	select
		t.`new_assignee_id`,
		ifnull(nullif(a.`organization`, ''), concat_ws(' ', nullif(a.`name_first`, ''), nullif(a.`name_last`, ''))),
		case when nullif(a.`organization`, '') is not null then 'ORGANIZATION' else 'INDIVIDUAL' end

	from
		`PatentsView`.`temp_id_mapping_assignee` t

		inner join `uspto`.`assignee` a on
		a.`id` = t.`old_assignee_id`;



	-- CITATION (43,750,320 @ 00:56:20) -----------------------------------------------------
	-- CITATION RDS (146,690,078 @ 01:57:14) ------------------------------------------------


	-- RDS 61,674,890 @ 00:44:19
	drop table if exists `PatentsView`.`temp_uspatentcitation`;



	create table `PatentsView`.`temp_uspatentcitation`
	(
		`citation_id` int unsigned not null,
		`patent_id` int unsigned not null,
		`cited_patent_id` int unsigned null,
		`foreign` bit not null,
		`date` date null,
		`number` varchar(64) null,
		`country` varchar(10) null
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into `PatentsView`.`temp_uspatentcitation`
	(
		`citation_id`,
		`patent_id`,
		`cited_patent_id`,
		`foreign`,
		`date`,
		`number`,
		`country`
	)

	-- Now do the same thing for us patent citations.
	select
		tpc.`new_citation_id`,
		tp1.`new_patent_id`,
		tp2.`new_patent_id`,
		0,
		nullif(pc.`date`, date('0000-00-00')),
		nullif(pc.`number`, ''),
		nullif(pc.`country`, '')

	from
		`PatentsView`.`temp_id_mapping_uspatentcitation` tpc

		inner join `uspto`.`uspatentcitation` pc on
		pc.`uuid` = tpc.`old_citation_id`

		inner join `PatentsView`.`temp_id_mapping_patent` tp1 on
		tp1.old_patent_id = pc.patent_id

		left outer join `PatentsView`.`temp_id_mapping_patent` tp2 on
		tp2.old_patent_id = pc.citation_id;



	-- RDS 8,791,343 @ 00:03:32
	drop table if exists `PatentsView`.`temp_foreigncitation`;



	create table `PatentsView`.`temp_foreigncitation`
	(
		`citation_id` int unsigned not null,
		`patent_id` int unsigned not null,
		`cited_patent_id` int unsigned null,
		`foreign` bit not null,
		`date` date null,
		`number` varchar(64) null,
		`country` varchar(10) null
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into `PatentsView`.`temp_foreigncitation`
	(
		`citation_id`,
		`patent_id`,
		`cited_patent_id`,
		`foreign`,
		`date`,
		`number`,
		`country`
	)

	-- Get foreign citations.
	select
		tfc.`new_citation_id`,
		tp.`new_patent_id`,
		null,
		1,
		nullif(fc.`date`, date('0000-00-00')),
		nullif(fc.`number`, ''),
		nullif(fc.`country`, '')

	from
		`PatentsView`.`temp_id_mapping_foreigncitation` tfc

		inner join `uspto`.`foreigncitation` fc on
		fc.`uuid` = tfc.`old_citation_id`

		inner join `PatentsView`.`temp_id_mapping_patent` tp on
		tp.old_patent_id = fc.patent_id;



	-- 70,466,233  @ 00:42:40 
	drop table if exists `PatentsView`.`citation`;



	create table `PatentsView`.`citation`
	(
		`citation_id` int unsigned not null,
		`patent_id` int unsigned not null,
		`cited_patent_id` int unsigned null,
		`foreign` bit not null,
		`date` date null,
		`number` varchar(64) null,
		`country` varchar(10) null,
		primary key (`citation_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



  insert into
    `PatentsView`.`citation`
  select * from `PatentsView`.`temp_uspatentcitation`;



  insert into
    `PatentsView`.`citation`
  select * from `PatentsView`.`temp_foreigncitation`;



	-- RDS 24:45
	alter table `PatentsView`.`citation` add index `ix_citation_patent_id` (`patent_id`);
	alter table `PatentsView`.`citation` add index `ix_citation_cited_patent_id_patent_id` (`cited_patent_id`, `patent_id`);
	alter table `PatentsView`.`citation` add index `ix_citation_date` (`date`);
	alter table `PatentsView`.`citation` add index `ix_citation_country` (`country`);



	-- RDS 3,866,390 @ 59.421
	drop table if exists `PatentsView`.`temp_citation_count`;



	create table `PatentsView`.`temp_citation_count`
	(
		`patent_id` int unsigned not null auto_increment,
		`count` int unsigned not null,
		primary key (`patent_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into
		`PatentsView`.`temp_citation_count` (`patent_id`, `count`)

	select
		cited_patent_id,
		count(*)

	from
		`PatentsView`.`citation`

	where
		`cited_patent_id` is not null

	group by
		`cited_patent_id`;



	-- INVENTOR (4,919,420 rows @ 00:02:16) -------------------------------------------------
	-- INVENTOR RDS (3,441,192 rows @ 00:01:38) -------------------------------------------------



	drop table if exists `PatentsView`.`inventor`;



	-- Create the new inventor table.
	create table `PatentsView`.`inventor`
	(
		`inventor_id` int unsigned not null,
		`name_first` varchar(64) null,
		`name_last` varchar(64) null,
		`usda_funded` bit not null,
		primary key (`inventor_id`),
		index `ix_inventor_name_last_name_first` (`name_last`, `name_first`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	-- Add the old inventor data + new inventor ids to the new inventor table.
	insert into `PatentsView`.`inventor`
	(
		`inventor_id`,
		`name_first`,
		`name_last`,
		`usda_funded`
	)

	select
		t.`new_inventor_id`,
		nullif(i.`name_first`, ''),
		nullif(i.`name_last`, ''),
		case when t.`new_inventor_id` like '%1' then 1 else 0 end # hack to simulate having usda_funded data - this will need to be fixed once we actually have usda data

	from
		`PatentsView`.`temp_id_mapping_inventor` t

		inner join `uspto`.`inventor` i on
		i.`id` = t.`old_inventor_id`;



	-- LOCATION (84,356 rows @ 5.241 sec) ---------------------------------------------------
	-- LOCATION RDS (66,058 rows @ 2.433 sec) ---------------------------------------------------



	drop table if exists `PatentsView`.`location`;



	-- Create the new location table.
	create table `PatentsView`.`location`
	(
		`location_id` int unsigned not null,
		`city` varchar(128) null,
		`state` varchar(10) null,
		`country` varchar(10) null,
		`latitude` float null,
		`longitude` float null,
		primary key (`location_id`),
		index `ix_location_country_state_city` (`country`, `state`, `city`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	-- Add the old location data + new location ids to the new location table.
	insert into `PatentsView`.`location`
	(
		`location_id`,
		`city`,
		`state`,
		`country`,
		`latitude`,
		`longitude`
	)

	select
		t.`new_location_id`,
		case when l.`city` regexp '^[ ?-]+$' then null else nullif(l.`city`, '') end,
		case when l.`state` regexp '^[ ?-]+$' then null else nullif(l.`state`, '') end,
		case when l.`country` regexp '^[ ?-]+$' then null else nullif(l.`country`, '') end,
		l.`latitude`,
		l.`longitude`

	from
		`PatentsView`.`temp_id_mapping_location` t

		inner join `uspto`.`location` l on
		l.`id` = t.`old_location_id`;



	-- PATENT (6,913,416 rows @ 00:03:08) ---------------------------------------------------
	-- PATENT RDS (7,722,446 rows @ 00:03:12) ---------------------------------------------------
	-- PATENT RDS (10,068,621 rows @ 00:03:12) ---------------------------------------------------



	drop table if exists `PatentsView`.`patent`;



	-- Create the new patent table.
	create table `PatentsView`.`patent`
	(
		`patent_id` int unsigned not null,
		`number` varchar(20) not null,
		`date` date not null,
		`num_claims` smallint unsigned not null,
		`num_times_cited` int unsigned not null,
		primary key (`patent_id`),
		unique index `ak_patent` (`number`),
		index `ix_patent_date` (`date`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	-- Add the old patent data + new patent ids to the new patent table.
	insert into `PatentsView`.`patent`
	(
		`patent_id`,
		`number`,
		`date`,
		`num_claims`,
		`num_times_cited`
	)

	select
		t.`new_patent_id`,
		p.`number`,
		p.`date`,
		p.`num_claims`,
		ifnull(tcc.`count`, 0)

	from
		`PatentsView`.`temp_id_mapping_patent` t

		inner join `uspto`.`patent` p on
		p.`id` = t.`old_patent_id`

		left outer join `PatentsView`.`temp_citation_count` tcc on
		tcc.`patent_id` = t.`new_patent_id`;



	drop table if exists `PatentsView`.`patent_text`;



	-- Create our new patent_text table.  This will be used to offload the bulkier columns
	-- so that, hopefully, aggregate functions will perform more quickly on the primary
	-- patent table.
	create table `PatentsView`.`patent_text`
	(
		`patent_id` int unsigned not null,
		`title` text not null,
		primary key (`patent_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	-- Add the bulky columns to this new table.
	insert into `PatentsView`.`patent_text`
	(
		`patent_id`,
		`title`
	)

	select
		t.`new_patent_id`,
		p.`title`

	from
		`PatentsView`.`temp_id_mapping_patent` t

		inner join `uspto`.`patent` p on
		p.`id` = t.`old_patent_id` and
		nullif(p.title, '') is not null;



	-- PATENT_CLASS_SUBCLASS (12,142,271 rows @ 00:08:40) -----------------------------------
	-- PATENT_CLASS_SUBCLASS RDS (13,794,375 rows @ 00:08:04) -----------------------------------
	-- PATENT_CLASS_SUBCLASS RDS (19,924,071 rows @ 00:10:41) -----------------------------------



	drop table if exists `PatentsView`.`patent_class_subclass`;



	create table `PatentsView`.`patent_class_subclass`
	(
		`patent_class_subclass_id` int unsigned not null auto_increment,
		`patent_id` int unsigned not null,
		`class` varchar(10) not null,
		`subclass` varchar(10) not null,
		primary key (`patent_class_subclass_id`),
		index `ix_patent_class_subclass_patent_id` (`patent_id`),
		index `ix_patent_class_subclass_class_patent_id` (`class`, `patent_id`),
		index `ix_patent_class_subclass_patent_id_class` (`patent_id`, `class`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into `PatentsView`.`patent_class_subclass`
	(
		`patent_id`,
		`class`,
		`subclass`
	)

	select
		t.new_patent_id,
		pc.mainclass_id,
		pc.subclass_id

	from
		`PatentsView`.`temp_id_mapping_patent` t

		inner join `uspto`.`uspc` pc on
		pc.`patent_id` = t.`old_patent_id`;



	## LINK/CROSS REFERENCE TABLES ##########################################################



	-- LOCATION_ASSIGNEE (255,183 rows @ 00:01:48) ------------------------------------------
	-- LOCATION_ASSIGNEE RDS (695,884 rows @ 00:01:00) ------------------------------------------
	-- LOCATION_ASSIGNEE RDS (1,122,129 rows @ 00:04:35) ------------------------------------------



	drop table if exists `PatentsView`.`location_assignee`;



	create table `PatentsView`.`location_assignee`
	(
		`location_id` int unsigned not null,
		`assignee_id` int unsigned not null,
		primary key (`location_id`, `assignee_id`),
		unique index ak_patent_inventor (`assignee_id`, `location_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into `PatentsView`.`location_assignee`
	(
		`location_id`,
		`assignee_id`
	)

	select distinct
		tl.`new_location_id`,
		ta.`new_assignee_id`

	from
		`PatentsView`.`temp_id_mapping_location` tl

		inner join `uspto`.`location_assignee` la on
		la.`location_id` = tl.`old_location_id`

		inner join `PatentsView`.`temp_id_mapping_assignee` ta on
		ta.`old_assignee_id` = la.`assignee_id`;



	-- LOCATION_INVENTOR (2,602,878 rows @ 00:04:48) ----------------------------------------
	-- LOCATION_INVENTOR RDS (5,573,349 rows @ 00:04:23) ----------------------------------------
	-- LOCATION_INVENTOR RDS (7,353,313 rows @ 00:11:08) ----------------------------------------



	drop table if exists `PatentsView`.`location_inventor`;



	create table `PatentsView`.`location_inventor`
	(
		`location_id` int unsigned not null,
		`inventor_id` int unsigned not null,
		primary key (`location_id`, `inventor_id`),
		unique index ak_patent_inventor (`inventor_id`, `location_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into `PatentsView`.`location_inventor`
	(
		`location_id`,
		`inventor_id`
	)

	select distinct
		tl.`new_location_id`,
		ti.`new_inventor_id`

	from
		`PatentsView`.`temp_id_mapping_location` tl

		inner join `uspto`.`location_inventor` li on
		li.`location_id` = tl.`old_location_id`

		inner join `PatentsView`.`temp_id_mapping_inventor` ti on
		ti.`old_inventor_id` = li.`inventor_id`;



	-- PATENT_ASSIGNEE (2,369,135 rows @ 00:03:38) ------------------------------------------
	-- PATENT_ASSIGNEE RDS (4,844,336 rows @ 00:12:27) ------------------------------------------



	drop table if exists `PatentsView`.`patent_assignee`;



	create table `PatentsView`.`patent_assignee`
	(
		`patent_id` int unsigned not null,
		`assignee_id` int unsigned not null,
		primary key (`patent_id`, `assignee_id`),
		unique index ak_patent_assignee (`assignee_id`, `patent_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into `PatentsView`.`patent_assignee`
	(
		`patent_id`,
		`assignee_id`
	)

	select distinct
		tp.`new_patent_id`,
		ta.`new_assignee_id`

	from
		`PatentsView`.`temp_id_mapping_patent` tp

		inner join `uspto`.`patent_assignee` pa on
		pa.`patent_id` = tp.`old_patent_id`

		inner join `PatentsView`.`temp_id_mapping_assignee` ta on
		ta.`old_assignee_id` = pa.`assignee_id`;



	-- PATENT_INVENTOR (5,209,150 rows @ 00:09:27) ------------------------------------------
	-- PATENT_INVENTOR RDS (11,062,721 rows @ 00:08:16) ------------------------------------------



	drop table if exists `PatentsView`.`patent_inventor`;



	create table `PatentsView`.`patent_inventor`
	(
		`patent_id` int unsigned not null,
		`inventor_id` int unsigned not null,
		primary key (`patent_id`, `inventor_id`),
		unique index ak_patent_inventor (`inventor_id`, `patent_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	insert into `PatentsView`.`patent_inventor`
	(
		`patent_id`,
		`inventor_id`
	)

	select distinct
		tp.`new_patent_id`,
		ti.`new_inventor_id`

	from
		`PatentsView`.`temp_id_mapping_patent` tp

		inner join `uspto`.`patent_inventor` pi on
		pi.`patent_id` = tp.`old_patent_id`

		inner join `PatentsView`.`temp_id_mapping_inventor` ti on
		ti.`old_inventor_id` = pi.`inventor_id`;



	-- RAWASSIGNEE (3,715,173 rows @ 00:03:34) ------------------------------------------



	drop table if exists `PatentsView`.`rawassignee`;



	-- Create the new rawassignee table.
	create table `PatentsView`.`rawassignee`
	(
		`assignee_id` int unsigned not null,
		`patent_id` int unsigned not null,
		`location_id` int unsigned null,
		unique index `ak0_rawassignee` (`assignee_id`, `patent_id`, `location_id`),
		unique index `ak1_rawassignee` (`patent_id`, `assignee_id`, `location_id`),
		unique index `ak2_rawassignee` (`location_id`, `assignee_id`, `patent_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	-- Convert all the old ids into new ids.
	insert into `PatentsView`.`rawassignee`
	(
		`assignee_id`,
		`patent_id`,
		`location_id`
	)

	select distinct
		ta.`new_assignee_id`,
		tp.`new_patent_id`,
		tl.`new_location_id`

	from
		`uspto`.`rawassignee` ra

		inner join `PatentsView`.`temp_id_mapping_assignee` ta on
		ta.`old_assignee_id` = ra.`assignee_id`

		inner join `PatentsView`.`temp_id_mapping_patent` tp on
		tp.`old_patent_id` = ra.`patent_id`

		left outer join `uspto`.`rawlocation` rl on
		rl.`id` = ra.`rawlocation_id`

		left outer join `PatentsView`.`temp_id_mapping_location` tl on
		tl.`old_location_id` = rl.`location_id`;



	-- RAWINVENTOR (10,957,836 rows @ 00:09:50) ------------------------------------------



	drop table if exists `PatentsView`.`rawinventor`;



	-- Create the new rawinventor table.
	create table `PatentsView`.`rawinventor`
	(
		`inventor_id` int unsigned not null,
		`patent_id` int unsigned not null,
		`location_id` int unsigned null,
		unique index `ak0_rawinventor` (`inventor_id`, `patent_id`, `location_id`),
		unique index `ak1_rawinventor` (`patent_id`, `inventor_id`, `location_id`),
		unique index `ak2_rawinventor` (`location_id`, `inventor_id`, `patent_id`)
	)
	engine=InnoDB
	character set=latin1; -- to be consistent with the source data



	-- Convert all the old ids into new ids.
	insert into `PatentsView`.`rawinventor`
	(
		`inventor_id`,
		`patent_id`,
		`location_id`
	)

	select distinct
		ti.`new_inventor_id`,
		tp.`new_patent_id`,
		tl.`new_location_id`

	from
		`uspto`.`rawinventor` ri

		inner join `PatentsView`.`temp_id_mapping_inventor` ti on
		ti.`old_inventor_id` = ri.`inventor_id`

		inner join `PatentsView`.`temp_id_mapping_patent` tp on
		tp.`old_patent_id` = ri.`patent_id`

		left outer join `uspto`.`rawlocation` rl on
		rl.`id` = ri.`rawlocation_id`

		left outer join `PatentsView`.`temp_id_mapping_location` tl on
		tl.`old_location_id` = rl.`location_id`;

