################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

################################################################################
# Prior to running this script, you will need to first create the EXPPublicationAuthorListTemp
# table that this uses. Then you will need to run a Python programm called
# SplitExPORTERPublicationAuthorNames to populate that table. You can then
# run this script. Drop the EXPPublicationAuthorListTemp table when done.
################################################################################

-- ---------------------------------------------------------------------------------------------------
-- Publications
-- ---------------------------------------------------------------------------------------------------
drop table if exists EXPPublicationTemp;
CREATE temporary TABLE EXPPublicationTemp (
	PublicationId int(11) UNSIGNED NOT NULL,
	PMID int(11) UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (PublicationId),
	INDEX PMID (PMID)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- Need to insert rows into the UMETRICS.Publication table, get those inserted ids back, and link them to
-- the PMIDs from the ExPORTER.Publication table.
start transaction;
-- This will insert one row into the Publication table for each PMID in the ExPORTER.Publication table.
insert into Publication (Year) select PUB_YEAR from (select distinct PMID, PUB_YEAR from ExPORTER.Publication) x;

-- Although this says "last", it is actually the first id of the last insert statement, which was a multiple row insert.
SET @key = LAST_INSERT_ID();  
-- This will insert into EXPPublicationTemp one row for each PMID in the EXPPublicationTemp table combining it with the PublicationId from the Pulication table.
-- It uses the last insert id and increments it by one for each row.
INSERT INTO EXPPublicationTemp (PublicationID, PMID)  
SELECT PublicationId, PMID
	FROM
	(
		SELECT @key + @rn as PublicationID, PMID, @rn := @rn + 1
		FROM (select @rn:=0) x, (select distinct PMID from ExPORTER.Publication) y
	) z;

COMMIT;

-- Add PMID ID to PublicationAttribute
insert ignore into Attribute (Attribute)
	select PMID
		from EXPPublicationTemp;

insert ignore into PublicationAttribute (PublicationId, AttributeId, RelationshipCode)
	select t.PublicationId, a.AttributeId, 'PMID'
		from EXPPublicationTemp t
			inner join Attribute a on a.Attribute=cast(t.PMID as char(100));
			
-- Add Title to PublicationAttribute
insert ignore into Attribute (Attribute)
	select left(trim(PUB_TITLE),100)
		from ExPORTER.Publication
		where PUB_TITLE is not null;

insert ignore into PublicationAttribute (PublicationId, AttributeId, RelationshipCode)
	select t.PublicationId, a.AttributeId, 'TITLE_PRIMARY'
		from EXPPublicationTemp t
			inner join ExPORTER.Publication p on p.PMID=t.PMID
			inner join Attribute a on a.Attribute=left(p.PUB_TITLE,100);


			
-- ---------------------------------------------------------------------------------------------------
-- Authors
-- ---------------------------------------------------------------------------------------------------

drop table if exists EXPAuthorTemp;
CREATE temporary TABLE EXPAuthorTemp (
	PersonId int(11) UNSIGNED NOT NULL,
	AuthorName varchar(100) NOT NULL,
	PRIMARY KEY (PersonId),
	INDEX AuthorName (AuthorName)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- Need to insert rows into the UMETRICS.Person table, get those inserted ids back.
start transaction;
-- This will insert one row into the Person table for each row in the EXPPublicationAuthorListTemp table.
insert into Person () select null from (select distinct AuthorName from EXPPublicationAuthorListTemp where AuthorName is not null) x;

-- Although this says "last", it is actually the first id of the last insert statement, which was a multiple row insert.
SET @key = LAST_INSERT_ID();  
-- This will insert into EXPAuthorTemp one row for each unique name in the EXPPublicationAuthorListTemp table combining it with the PersonId from the Person table.
-- It uses the last insert id and increments it by one for each row.
INSERT INTO EXPAuthorTemp (PersonID, AuthorName)  
SELECT PersonID, trim(AuthorName)
	FROM
	(
		SELECT @key + @rn as PersonID, AuthorName, @rn := @rn + 1
		FROM (select @rn:=0) x, (select distinct AuthorName from EXPPublicationAuthorListTemp where AuthorName is not null) y
	) z;

COMMIT;

-- Add Names to the PersonName table. 
insert into PersonName (PersonID, FullName, RelationshipCode)
	select distinct t.PersonId, t.AuthorName, 'PRIMARY'
		from EXPAuthorTemp t
			where AuthorName is not null;
			

-- ---------------------------------------------------------------------------------------------------
-- PersonPublication
-- ---------------------------------------------------------------------------------------------------
		
insert ignore into PersonPublication (PersonId, PublicationId, RelationshipCode)
	select at.PersonId, pt.PublicationId, 'AUTHOR'
		from EXPPublicationAuthorListTemp pat
			inner join EXPAuthorTemp at on at.AuthorName=pat.AuthorName
			inner join EXPPublicationTemp pt on pt.PMID=pat.PMID;