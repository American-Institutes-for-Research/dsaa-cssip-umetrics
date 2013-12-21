################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

#### WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING ####
#### WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING ####
####                                                                         ####
####     DO NOT RUN THIS SCRIPT AGAINST A POPULATED UMETRICS DATABASE!!!     ####
####                                                                         ####
#### This script was written to function in a vacuum.  Since its creation,   ####
#### other data sources have been added to the UMETRICS database.  Running   ####
#### this script against a populated database will cause irreparable harm!   ####
####                                                                         ####
#### As time permits, a new version of this script will be crafted to        ####
#### address this issue.                                                     ####
####                                                                         ####
#### Thank you for your cooperation.                                         ####
####                                                                         ####
#### WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING ####
#### WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING ####



set AUTOCOMMIT = 0;
set FOREIGN_KEY_CHECKS = 0;
set UNIQUE_CHECKS = 0;



truncate table UMETRICS.Address;
truncate table UMETRICS.Attribute;
truncate table UMETRICS.GrantAward;
truncate table UMETRICS.GrantAwardAttribute;
truncate table UMETRICS.Organization;
truncate table UMETRICS.OrganizationAddress;
truncate table UMETRICS.OrganizationAttribute;
truncate table UMETRICS.OrganizationGrantAward;
truncate table UMETRICS.OrganizationName;
truncate table UMETRICS.OrganizationOrganization;
truncate table UMETRICS.Person;
truncate table UMETRICS.PersonAddress;
truncate table UMETRICS.PersonAttribute;
truncate table UMETRICS.PersonGrantAward;
truncate table UMETRICS.PersonName;



drop table if exists UMETRICS.temp;
create temporary table UMETRICS.temp
(
	`GrantAwardId` int(11) not null auto_increment,
	`APPLICATION_ID` int(11) not null,
	primary key (`GrantAwardId`, `APPLICATION_ID`),
	unique index `AK_temp` (`APPLICATION_ID`, `GrantAwardId`)
)
collate='utf8_general_ci'
engine=InnoDB;



-- Get APPLICATION_ID for every Project that is not a multi (so everything,
-- including sub-projects, that is not a parent of a set of sub-projects).
insert into UMETRICS.temp
(
	APPLICATION_ID
)
select
	APPLICATION_ID

from
	ExPORTER.Project

where
	APPLICATION_ID not in
	(
		select
			APPLICATION_ID
		from
			ExPORTER.Project
		where
			SUBPROJECT_ID is null and
			FULL_PROJECT_NUM in
			(
				select
					FULL_PROJECT_NUM
				from
					ExPORTER.Project
				where
					SUBPROJECT_ID is not null
			)
	);



-- Now add the records we just selected to the GrantAward table.
insert into UMETRICS.GrantAward
(
	GrantAwardId,
	EffectiveDate,
	StartDate,
	ExpirationDate,
	Amount,
	EstimatedAmount,
	ARRAAmount,
	Title
)

select
	T.GrantAwardId,
	P.AWARD_NOTICE_DATE,
	P.BUDGET_START,
	P.BUDGET_END,
	coalesce(P.TOTAL_COST_SUB_PROJECT, P.TOTAL_COST),
	null,
	if(P.ARRA_FUNDED = 1, coalesce(P.TOTAL_COST_SUB_PROJECT, P.TOTAL_COST), 0),
	P.PROJECT_TITLE

from
	ExPORTER.Project P

	inner join UMETRICS.temp T on
	T.APPLICATION_ID = P.APPLICATION_ID;



-- Add APPLICATION_IDs to the Attribute table.
insert into UMETRICS.Attribute
(
	Attribute
)

select
	APPLICATION_ID

from
	UMETRICS.temp;



-- Link APPLICATION_IDs back to the GrantAward.
insert into UMETRICS.GrantAwardAttribute
(
	GrantAwardId,
	AttributeId,
	RelationshipCode
)

select
	ga.GrantAwardId,
	a.AttributeId,
	'NIH_APPLICATION_ID'

from
	UMETRICS.GrantAward ga

	inner join UMETRICS.temp t on
	t.GrantAwardId = ga.GrantAwardId

	inner join UMETRICS.Attribute a on
	a.Attribute = t.APPLICATION_ID;



-- Add CORE_PROJECT_NUMs to the Attribute table.
insert into UMETRICS.Attribute
(
	Attribute
)

select distinct
	trim(p.CORE_PROJECT_NUM)

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

where
	p.CORE_PROJECT_NUM is not null and
	p.CORE_PROJECT_NUM != '';



-- Link CORE_PROJECT_NUMs back to the GrantAward.
insert into UMETRICS.GrantAwardAttribute
(
	GrantAwardId,
	AttributeId,
	RelationshipCode
)

select
	t.GrantAwardId,
	a.AttributeId,
	'NIH_CORE_PROJECT_NUM'

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

	inner join UMETRICS.Attribute a on
	a.Attribute = p.CORE_PROJECT_NUM;



-- Add FULL_PROJECT_NUMs to the Attribute table.
insert into UMETRICS.Attribute
(
	Attribute
)

select distinct
	trim(p.FULL_PROJECT_NUM)

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

where
	p.FULL_PROJECT_NUM is not null and
	p.FULL_PROJECT_NUM != '' and
	trim(p.FULL_PROJECT_NUM) not in
	(
		select Attribute from UMETRICS.Attribute
	);



-- Link FULL_PROJECT_NUMs back to the GrantAward.
insert into UMETRICS.GrantAwardAttribute
(
	GrantAwardId,
	AttributeId,
	RelationshipCode
)

select
	t.GrantAwardId,
	a.AttributeId,
	'NIH_FULL_PROJECT_NUM'

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

	inner join UMETRICS.Attribute a on
	a.Attribute = p.FULL_PROJECT_NUM;



-- Add NIH_SUBPROJECT_IDs to the Attribute table.
insert into UMETRICS.Attribute
(
	Attribute
)

select distinct
	p.SUBPROJECT_ID

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

where
	p.SUBPROJECT_ID is not null and
	cast(p.SUBPROJECT_ID as char(100)) not in
	(
		select Attribute from UMETRICS.Attribute
	);



-- Link NIH_SUBPROJECT_IDs back to the GrantAward.
insert into UMETRICS.GrantAwardAttribute
(
	GrantAwardId,
	AttributeId,
	RelationshipCode
)

select
	t.GrantAwardId,
	a.AttributeId,
	'NIH_SUBPROJECT_ID'

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

	inner join UMETRICS.Attribute a on
	a.Attribute = cast(p.SUBPROJECT_ID as char(100));



-- Add CFDA_CODEs to the Attribute table.
insert into UMETRICS.Attribute
(
	Attribute
)

select distinct
	trim(p.CFDA_CODE)

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

where
	p.CFDA_CODE is not null and
	p.CFDA_CODE != '' and
	trim(p.CFDA_CODE) not in
	(
		select Attribute from UMETRICS.Attribute
	);



-- Link CFDA_CODEs back to the GrantAward.
insert into UMETRICS.GrantAwardAttribute
(
	GrantAwardId,
	AttributeId,
	RelationshipCode
)

select
	t.GrantAwardId,
	a.AttributeId,
	'CFDA_CODE'

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

	inner join UMETRICS.Attribute a on
	a.Attribute = p.CFDA_CODE;



-- Add FOA_NUMBERs to the Attribute table.
insert into UMETRICS.Attribute
(
	Attribute
)

select distinct
	trim(p.FOA_NUMBER)

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

where
	p.FOA_NUMBER is not null and
	p.FOA_NUMBER != '' and
	trim(p.FOA_NUMBER) not in
	(
		select Attribute from UMETRICS.Attribute
	);



-- Link FOA_NUMBERs back to the GrantAward.
insert into UMETRICS.GrantAwardAttribute
(
	GrantAwardId,
	AttributeId,
	RelationshipCode
)

select
	t.GrantAwardId,
	a.AttributeId,
	'FOA_CODE'

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

	inner join UMETRICS.Attribute a on
	a.Attribute = p.FOA_NUMBER;



drop table if exists UMETRICS.temp_org;
create temporary table UMETRICS.temp_org
(
	`OrganizationId` int(11) not null auto_increment,
	`OrganizationName` varchar(100) not null,
	primary key (`OrganizationId`),
	unique index `AK_temp_org` (`OrganizationName`)
)
collate='utf8_general_ci'
engine=InnoDB;



-- Get IC_NAME for every Project that is not a multi (so everything,
-- including sub-projects, that is not a parent of a set of sub-projects).
insert into
	UMETRICS.temp_org
	(
		OrganizationName
	)

select distinct
	IC_NAME

from
	UMETRICS.temp t
	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

where
	p.IC_NAME is not null and
	p.IC_NAME != '';



-- For whatever reason, in MySQL, you cannot join to a temp table more than once
-- so we're going to just duplicate the temp_org table for expediency.
drop table if exists UMETRICS.temp_org2;
create temporary table UMETRICS.temp_org2 like UMETRICS.temp_org;
insert into UMETRICS.temp_org2 select * from UMETRICS.temp_org;



-- Get ORG_NAME for every Project that is not a multi (so everything,
-- including sub-projects, that is not a parent of a set of sub-projects).
insert into
	UMETRICS.temp_org
	(
		OrganizationName
	)

select distinct
	concat(org_name, ifnull(concat(' ', nullif(org_dept, 'none')), ''))

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

where
	p.ORG_NAME is not null and
	p.ORG_NAME != '' and
	p.ORG_NAME not in
	(
		select OrganizationName from UMETRICS.temp_org2
	);



-- Right now, all we have is an Organization name, so our temp OrganizationIds will
-- become our Organization.OrganizationIds.  Don't panic!  I'm an expert.
-- Create Organizations from our temp table.
insert into UMETRICS.Organization
(
	OrganizationId
)

select
	OrganizationId

from
	UMETRICS.temp_org;



-- Now add our OrganizationNames.
insert into UMETRICS.OrganizationName
(
	OrganizationId,
	RelationshipCode,
	Name
)

select
	OrganizationId,
	'PRIMARY_FULL',
	OrganizationName

from
	UMETRICS.temp_org;



-- Link our GrantAwards to our IC_NAME Organizations.
insert into UMETRICS.OrganizationGrantAward
(
	OrganizationId,
	GrantAwardId,
	RelationshipCode
)

select distinct
	tt.OrganizationId,
	t.GrantAwardId,
	'GRANTOR'

from
	UMETRICS.temp_org tt

	inner join ExPORTER.Project p on
	p.IC_NAME = tt.OrganizationName

	inner join UMETRICS.temp t on
	t.APPLICATION_ID = p.APPLICATION_ID;



-- Link our GrantAwards to our ORG_NAME Organizations.
insert into UMETRICS.OrganizationGrantAward
(
	OrganizationId,
	GrantAwardId,
	RelationshipCode
)

select distinct
	tt.OrganizationId,
	t.GrantAwardId,
	'AWARDEE'

from
	UMETRICS.temp_org tt

	inner join ExPORTER.Project p on
	concat(org_name, ifnull(concat(' ', nullif(org_dept, 'none')), '')) = tt.OrganizationName

	inner join UMETRICS.temp t on
	t.APPLICATION_ID = p.APPLICATION_ID;



-- Since NIH is the only funder currently in ExPORTER, let's manually
-- add NIH to the Organization table so we can link it to the ICs.
insert into	UMETRICS.Organization (OrganizationId) values (null);
set @nihOrganizationId = last_insert_id();



-- Add some names for NIH.
insert into UMETRICS.OrganizationName
(
	OrganizationId,
	RelationshipCode,
	Name
)
values
(
	@nihOrganizationId,
	'PRIMARY_FULL',
	'National Institutes of Health'
),
(
	@nihOrganizationId,
	'PRIMARY_ACRONYM',
	'NIH'
),
(
	@nihOrganizationId,
	'ALIAS',
	'Natl. Inst. of Health'
),
(
	@nihOrganizationId,
	'ALIAS',
	'The National Institutes of Health'
);



-- Let's add an address for NIH.
insert into UMETRICS.Address
(
	Street1,
	Street2,
	City,
	CountyEquivalent,
	StateEquivalent,
	PostalCode,
	CountryName
)
values
(
	'9000 Rockville Pike',
	null,
	'Bethesda',
	'Montgomery',
	'MD',
	'20892',
	'United States of America'
);
set @nihAddressId = last_insert_id();



insert into UMETRICS.OrganizationAddress
(
	OrganizationId,
	AddressId,
	RelationshipCode
)
values
(
	@nihOrganizationId,
	@nihAddressId,
	'PRIMARY'
);



-- Now make NIH the parent of all the GRANTOR institutions.
insert into UMETRICS.OrganizationOrganization
(
	OrganizationAId,
	OrganizationBId,
	RelationshipCode
)

select distinct
	@nihOrganizationId,
	OrganizationId,
	'PARENT'
	
from
	UMETRICS.OrganizationGrantAward

where
	RelationshipCode = 'GRANTOR';



-- Add ORG addresses.
insert into UMETRICS.Address
(
	City,
	StateEquivalent,
	PostalCode,
	CountryName
)

select distinct
	nullif(p.ORG_CITY, ''),
	nullif(p.ORG_STATE, ''),
	nullif(p.ORG_ZIPCODE, ''),
	nullif(p.ORG_COUNTRY, '')

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

where
	(p.ORG_CITY is not null and
	p.ORG_CITY != '') or
	(p.ORG_STATE is not null and
	p.ORG_STATE != '') or
	(p.ORG_ZIPCODE is not null and
	p.ORG_ZIPCODE != '') or
	(p.ORG_COUNTRY is not null and
	p.ORG_COUNTRY != '');



drop table if exists UMETRICS.temp_umetrics_address;
create temporary table UMETRICS.temp_umetrics_address
(
	`AddressId` int(11) not null,
	`City` varchar(100) not null default '',
	`StateEquivalent` varchar(100) not null default '',
	`PostalCode` varchar(100) not null default '',
	`CountryName` varchar(100) not null default '',
	primary key (`AddressId`),
	index `IX_temp_umetrics_address` (`City`, `StateEquivalent`, `PostalCode`, `CountryName`)
)
collate='utf8_general_ci'
engine=InnoDB;



insert into UMETRICS.temp_umetrics_address
(
	AddressId,
	City,
	StateEquivalent,
	PostalCode,
	CountryName
)

select
	a.AddressId,
	ifnull(a.City, ''),
	ifnull(a.StateEquivalent, ''),
	ifnull(a.PostalCode, ''),
	ifnull(a.CountryName, '')

from
	UMETRICS.Address a;



drop table if exists UMETRICS.temp_exporter_address;
create temporary table UMETRICS.temp_exporter_address
(
	`APPLICATION_ID` int(11) not null,
	`City` varchar(100) not null default '',
	`StateEquivalent` varchar(100) not null default '',
	`PostalCode` varchar(100) not null default '',
	`CountryName` varchar(100) not null default '',
	primary key (`APPLICATION_ID`),
	index `IX_temp_exporter_address` (`City`, `StateEquivalent`, `PostalCode`, `CountryName`)
)
collate='utf8_general_ci'
engine=InnoDB;



insert into UMETRICS.temp_exporter_address
(
	APPLICATION_ID,
	City,
	StateEquivalent,
	PostalCode,
	CountryName
)

select
	p.APPLICATION_ID,
	ifnull(p.ORG_CITY, ''),
	ifnull(p.ORG_STATE, ''),
	ifnull(p.ORG_ZIPCODE, ''),
	ifnull(p.ORG_COUNTRY, '')

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

where
	(p.ORG_CITY is not null and
	p.ORG_CITY != '') or
	(p.ORG_STATE is not null and
	p.ORG_STATE != '') or
	(p.ORG_ZIPCODE is not null and
	p.ORG_ZIPCODE != '') or
	(p.ORG_COUNTRY is not null and
	p.ORG_COUNTRY != '');



-- Link these addresses back to the Organizations.
insert into UMETRICS.OrganizationAddress
(
	OrganizationId,
	AddressId,
	RelationshipCode
)

select distinct
	oga.OrganizationId,
	tua.AddressId,
	'PRIMARY'

from
	UMETRICS.temp_umetrics_address tua

	inner join UMETRICS.temp_exporter_address tea on
	tea.City = tua.City and
	tea.StateEquivalent = tua.StateEquivalent and
	tea.PostalCode = tua.PostalCode and
	tea.CountryName = tua.CountryName

	inner join UMETRICS.temp t on
	t.APPLICATION_ID = tea.APPLICATION_ID

	inner join UMETRICS.OrganizationGrantAward oga on
	oga.GrantAwardId = t.GrantAwardId and
	oga.RelationshipCode = 'AWARDEE';



drop table if exists UMETRICS.temp_duns;
create temporary table UMETRICS.temp_duns
(
	`OrganizationId` int(11) not null auto_increment,
	`OrganizationName` varchar(100) not null,
	primary key (`OrganizationId`),
	unique index `AK_temp_duns` (`OrganizationName`)
)
collate='utf8_general_ci'
engine=InnoDB;



-- Add ORG_DUNS to the Attribute table.
insert into UMETRICS.Attribute
(
	Attribute
)

select distinct
	trim(p.ORG_DUNS)

from
	UMETRICS.temp t

	inner join ExPORTER.Project p on
	p.APPLICATION_ID = t.APPLICATION_ID

where
	p.ORG_DUNS is not null and
	p.ORG_DUNS != '';



-- Link ORG_DUNS back to the Organization.
insert into UMETRICS.OrganizationAttribute
(
	OrganizationId,
	AttributeId,
	RelationshipCode
)

select distinct
	tt.OrganizationId,
	a.AttributeId,
	'DUNS'

from
	UMETRICS.temp_org tt

	inner join ExPORTER.Project p on
	concat(org_name, ifnull(concat(' ', nullif(org_dept, 'none')), '')) = tt.OrganizationName

	inner join UMETRICS.Attribute a on
	a.Attribute = p.ORG_DUNS;



-- Ok, this seems weird, but creating this temporary table allows us to split out PI_NAMEs and
-- PI_IDs.  Look a couple queries down to see this table in use.
--
-- P.S.  THIS ONLY WORKS FOR 40 NAMES!  If there are more than 40 names or IDs in the PI_NAMEs or
-- PI_IDs column, those beyond 40 will be ignored.
drop table if exists UMETRICS.counter;
CREATE temporary TABLE UMETRICS.counter (id int);
INSERT INTO UMETRICS.counter VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), (13), (14), (15), (16), (17), (18), (19), (20), (21), (22), (23), (24), (25), (26), (27), (28), (29), (30), (31), (32), (33), (34), (35), (36), (37), (38), (39), (40);



drop table if exists UMETRICS.temp_pis;
create temporary table UMETRICS.temp_pis
(
	`APPLICATION_ID` int(11) not null,
	`PIName` varchar(100) not null,
	`OrdinalPosition` int(11) not null,
	`Nickname` varchar(100) null,
	unique index `AK1_temp_pis` (`APPLICATION_ID`, `PIName`, `OrdinalPosition`),
	unique index `AK2_temp_pis` (`PIName`, `APPLICATION_ID`, `OrdinalPosition`),
	unique index `AK3_temp_pis` (`APPLICATION_ID`, `OrdinalPosition`, `PIName`)
)
collate='utf8_general_ci'
engine=InnoDB;



-- Split out names from the PI_NAMEs field.  While we're at it, remove meaningless junk such as "(contact)"
-- and "(interim)".  Also, standardize spaces a bit.  There are also some data corrections (that we know of):
--   'GEMG;ER-NOWAK, KARLA' should be 'GENGLER-NOWAK, KARLA'
--   one of the names contains '11/22/2006'
--
-- Very little work is done to confirm that PI_IDs and PI_NAMEs match up!!!!!  This is a quick and dirty
-- solution for the intial load.  Data was checked by hand.  If you run this code again in the future
-- against different source data, you will need to manually verify that the name and Ids match up!!!!!!
insert into UMETRICS.temp_pis
(
	APPLICATION_ID,
	PIName,
	OrdinalPosition
)

select
	p.APPLICATION_ID,
	trim(replace(replace(replace(replace(substring_index(substring_index(p.PI_NAMEs, ';', c.id), ';', -1), '   ', ' '), '  ', ' '), '  ', ' '), ' ,', ',')) as PIName,
	c.id OrdinalPosition

from
	(
		select
			APPLICATION_ID,
			trim(replace(replace(replace(replace(replace(replace(replace(replace(PI_NAMEs, 'GEMG;ER-NOWAK, KARLA', 'GENGLER-NOWAK, KARLA'), '11/22/2006', ' '), '(contact)', ' '), '(CONTACT)', ' '), '(deceased)', ' '), '(DECEASED)', ' '), '(interim)', ' '), '(INTERIM)', ' ')) as PI_NAMEs

		from
			ExPORTER.Project

		where
		  PI_NAMEs is not null and
		  PI_NAMEs != '' and
			PI_NAMEs != ';' and
		  PI_NAMEs != ', ;'
	) p

	inner join UMETRICS.counter c on
	substring_index(substring_index(p.PI_NAMEs, ';', c.id), ';', -1)
    <> substring_index(substring_index(p.PI_NAMEs, ';', c.id - 1), ';', -1) and
  substring_index(substring_index(p.PI_NAMEs, ';', c.id), ';', -1) != '';



-- Find nicknames.
update
	UMETRICS.temp_pis

set
	Nickname = substring_index(substring_index(PIName, ')', 1), '(', -1)

where
	PIName like '%(%' and
	PIName like '%)%';



-- Remove nicknames from the name.
update
	UMETRICS.temp_pis

set
	PIName = trim(replace(replace(replace(replace(PIName, concat('(', Nickname, ')'), ' '), '  ', ' '), '  ', ' '), ' ,', ','))

where
	Nickname is not null;



drop table if exists UMETRICS.temp_pi_ids;
create temporary table UMETRICS.temp_pi_ids
(
	`APPLICATION_ID` int(11) not null,
	`PIId` int(11) not null,
	`OrdinalPosition` int(11) not null,
	unique index `AK1_temp_pis` (`APPLICATION_ID`, `PIId`, `OrdinalPosition`),
	unique index `AK2_temp_pis` (`PIId`, `APPLICATION_ID`, `OrdinalPosition`),
	unique index `AK3_temp_pis` (`APPLICATION_ID`, `OrdinalPosition`, `PIId`)
)
collate='utf8_general_ci'
engine=InnoDB;



-- Split out Ids from the PI_IDs field.  While we're at it, remove meaningless junk such as "(contact)"
-- and "(interim)".  Also, standardize spaces a bit.
insert into UMETRICS.temp_pi_ids
(
	APPLICATION_ID,
	PIId,
	OrdinalPosition
)

select
	p.APPLICATION_ID,
	trim(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(substring_index(substring_index(p.PI_IDs, ';', c.id), ';', -1), '(contact)', ' '), '(CONTACT)', ' '), '(deceased)', ' '), '(DECEASED)', ' '), '(interim)', ' '), '(INTERIM)', ' '), '   ', ' '), '  ', ' '), '  ', ' '), ' ,', ',')) as PIId,
	c.id OrdinalPosition

from
	ExPORTER.Project p

	inner join UMETRICS.counter c on
  p.PI_IDs is not null and
  p.PI_IDs != '' and
  p.PI_IDs != ';' and
  p.PI_IDs != ', ;' and
	substring_index(substring_index(p.PI_IDs, ';', c.id), ';', -1)
    <> substring_index(substring_index(p.PI_IDs, ';', c.id - 1), ';', -1) and
  substring_index(substring_index(p.PI_IDs, ';', c.id), ';', -1) != '';



drop table if exists UMETRICS.temp_pi_names_and_ids;
create temporary table UMETRICS.temp_pi_names_and_ids
(
	`APPLICATION_ID` int(11) not null,
	`PIName` varchar(100) not null,
	`PIId` int(11) not null,
	`OrdinalPosition` int not null,
	`Nickname` varchar(100) null,
	unique index `AK1_temp_pi_names_and_ids` (`APPLICATION_ID`, `PIName`, `PIId`, `OrdinalPosition`),
	unique index `AK2_temp_pi_names_and_ids` (`APPLICATION_ID`, `PIId`, `PIName`, `OrdinalPosition`),
	unique index `AK3_temp_pi_names_and_ids` (`PIName`, `PIId`, `APPLICATION_ID`, `OrdinalPosition`),
	unique index `AK4_temp_pi_names_and_ids` (`PIId`, `PIName`, `APPLICATION_ID`, `OrdinalPosition`)
)
collate='utf8_general_ci'
engine=InnoDB;



insert into UMETRICS.temp_pi_names_and_ids
(
	APPLICATION_ID,
	trim(PIName),
	PIId,
	OrdinalPosition,
	trim(Nickname)
)

select
	a.APPLICATION_ID,
	a.PIName,
	b.PIId,
	a.OrdinalPosition,
	a.Nickname

from
	UMETRICS.temp_pis a

	inner join UMETRICS.temp_pi_ids b on
	b.APPLICATION_ID = a.APPLICATION_ID and
	b.OrdinalPosition = a.OrdinalPosition

where
	a.PIName is not null and
	a.PIName != '' and
	a.PIName != ',';



drop table if exists UMETRICS.temp_person;
create temporary table UMETRICS.temp_person
(
	`PersonId` int(11) not null AUTO_INCREMENT,
	`PIName` varchar(100) not null,
	`PIId` int(11) not null,
	`Nickname` varchar(100) null,
	primary key (PersonId),
	unique index `AK1_temp_person` (`PIName`, `PIId`, `Nickname`),
	unique index `AK2_temp_person` (`PIId`, `PIName`, `Nickname`)
)
collate='utf8_general_ci'
engine=InnoDB;



-- I hate to do this, but for this version of the bulk load, we're going to treat
-- every variation of PIName/PIId as a new "person".  This will hopefully be cleaned
-- up by the as-yet-to-be-written "person engine/crawler".
insert into UMETRICS.temp_person
(
	PIName,
	PIId,
	Nickname
)

select distinct
	PIName,
	PIId,
	Nickname

from
	UMETRICS.temp_pi_names_and_ids;



-- Add our temporary persons to the Person table.
insert into UMETRICS.Person
(
	PersonId
)

select
	PersonId

from
	UMETRICS.temp_person;



-- Add our temporary person names to the PersonName table.
insert into UMETRICS.PersonName
(
	PersonNameId,
	PersonId,
	RelationshipCode,
	FullName,
	Prefix,
	GivenName,
	OtherName,
	FamilyName,
	Suffix,
	Nickname
)

select
	PersonId,
	PersonId,
	'PRIMARY',
	PIName,
	null,
	null,
	null,
	null,
	null,
	Nickname

from
	UMETRICS.temp_person;



-- Add PI Ids to the Attribute table.
insert into UMETRICS.Attribute
(
	Attribute
)

select distinct
	PIId

from
	UMETRICS.temp_person

where
	cast(PIId as char(100)) not in
	(
		select Attribute from UMETRICS.Attribute
	);



-- Link PI Ids from the Attribute table to the Person table.
insert into UMETRICS.PersonAttribute
(
	PersonId,
	AttributeId,
	RelationshipCode
)

select
	tp.PersonId,
	a.AttributeId,
	'NIH_PI_ID'

from
	UMETRICS.temp_person tp

	inner join UMETRICS.Attribute a on
	a.Attribute = cast(tp.PIId as char(11));



-- Link Persons back to the appropriate GrantAward.
insert into UMETRICS.PersonGrantAward
(
	`PersonId`,
	`GrantAwardId`,
	`RelationshipCode`
)

select distinct
	tp.PersonId,
	gaa.GrantAwardId,
	'PI'

from
	UMETRICS.temp_person tp

	inner join UMETRICS.temp_pi_names_and_ids tpnai on
	tpnai.PIId = tp.PIId

	inner join UMETRICS.Attribute a1 on
	a1.Attribute = cast(tpnai.PIId as char(100))

	inner join UMETRICS.PersonAttribute pa on
	pa.AttributeId = a1.AttributeId and
	pa.RelationshipCode = 'NIH_PI_ID'

	inner join UMETRICS.Attribute a2 on
	a2.Attribute = cast(tpnai.APPLICATION_ID as char(100))

	inner join UMETRICS.GrantAwardAttribute gaa on
	gaa.AttributeId = a2.AttributeId and
	gaa.RelationshipCode = 'NIH_APPLICATION_ID';



drop table if exists UMETRICS.temp_missing_org_names;
create table UMETRICS.temp_missing_org_names
(
	OrganizationId int unsigned not null auto_increment,
	Name varchar(200) not null,
	primary key (OrganizationId),
	unique index `ak_temp_missing_org_names` (Name)
)
engine InnoDB;



-- So we can continue where Organization.OrganizationId leaves off.
insert into UMETRICS.temp_missing_org_names
(
	OrganizationId,
	Name
)

select
	max(OrganizationId),
	'XXX QQQ BOGUS DELETE ME QQQ XXX'

from
	UMETRICS.Organization;



-- Add names we don't already know about.
insert into UMETRICS.temp_missing_org_names
(
	Name
)

select distinct
	p.ORG_NAME

from
	ExPORTER.Project p

	left outer join UMETRICS.OrganizationName onn on
	onn.Name = p.ORG_NAME

where
	onn.Name is null and
	p.ORG_NAME is not null and
	p.ORG_NAME != '';



-- Delete the bogus name so it doesn't cause problems later.
delete from
	UMETRICS.temp_missing_org_names

where
	Name = 'XXX QQQ BOGUS DELETE ME QQQ XXX';



-- We need to add the Organization first.
insert into UMETRICS.Organization
(
	OrganizationId
)

select
	OrganizationId

from
	UMETRICS.temp_missing_org_names;



-- Now add the OrganizationName.
insert into UMETRICS.OrganizationName
(
	OrganizationId,
	RelationshipCode,
	Name
)

select
	t.OrganizationId,
	'PRIMARY_FULL',
	t.Name

from
	UMETRICS.temp_missing_org_names t;



-- Get rid of the temp table.
drop table if exists UMETRICS.temp_missing_org_names;



-- We're going to do this as a two step process so we can check the results before committing.
drop table if exists UMETRICS.temp_hierarchy;
create table UMETRICS.temp_hierarchy
(
	ParentOrganizationId int unsigned not null,
	ParentOrganizationName varchar(200) not null,
	ChildOrganizationId int unsigned not null,
	ChildOrganizationName varchar(200) not null,
	primary key (ParentOrganizationId, ChildOrganizationId)
)
engine InnoDB;



-- Now we need to link ORG_DEPT to ORG_NAME so as to create an hierarchy.  NOTE:  How
-- ORG_NAME and ORG_DEPT are joined MUST MATCH how they were created in the first place
-- above.
insert into
	UMETRICS.temp_hierarchy

select distinct
	onn1.OrganizationId ParentOrganizationId,
	onn1.Name ParentOrganizationName,
	onn2.OrganizationId ChildOrganizationId,
	onn2.Name ChildOrganizationName

from
	ExPORTER.Project p

	inner join UMETRICS.OrganizationName onn1 on
	onn1.Name = p.ORG_NAME

	inner join UMETRICS.OrganizationName onn2 on
	onn2.Name = concat(p.ORG_NAME, ifnull(concat(' ', nullif(p.ORG_DEPT, 'none')), ''))

where
	p.ORG_NAME != concat(p.ORG_NAME, ifnull(concat(' ', nullif(p.ORG_DEPT, 'none')), ''));



insert into UMETRICS.OrganizationOrganization
(
	OrganizationAId,
	OrganizationBId,
	RelationshipCode
)

select
	ParentOrganizationId,
	ChildOrganizationId,
	'PARENT'

from
	UMETRICS.temp_hierarchy;



drop table UMETRICS.temp_hierarchy;



optimize table UMETRICS.Address;
optimize table UMETRICS.Attribute;
optimize table UMETRICS.GrantAward;
optimize table UMETRICS.GrantAwardAttribute;
optimize table UMETRICS.Organization;
optimize table UMETRICS.OrganizationAddress;
optimize table UMETRICS.OrganizationAttribute;
optimize table UMETRICS.OrganizationGrantAward;
optimize table UMETRICS.OrganizationName;
optimize table UMETRICS.OrganizationOrganization;
optimize table UMETRICS.Person;
optimize table UMETRICS.PersonAddress;
optimize table UMETRICS.PersonAttribute;
optimize table UMETRICS.PersonGrantAward;
optimize table UMETRICS.PersonName;



set AUTOCOMMIT = 1;
set FOREIGN_KEY_CHECKS = 1;
set UNIQUE_CHECKS = 1;
