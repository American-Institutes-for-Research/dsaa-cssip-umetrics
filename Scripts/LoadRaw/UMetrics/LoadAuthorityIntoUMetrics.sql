#use UMetrics_GJY;

set FOREIGN_KEY_CHECKS = 0;
set UNIQUE_CHECKS = 0;

-- truncate Person;
-- truncate PersonAttribute;
-- truncate Attribute;
-- truncate PersonName;
-- truncate Publication;
-- truncate PublicationAttribute;
-- truncate PersonPublication;
-- truncate Term;
-- truncate PersonTerm;
-- truncate GrantAward;
-- truncate GrantAwardAttribute;
-- truncate PersonGrantAward;



-- You'll see below that we don't do anything with the Authority.coauthorid table. That is because we can infer those relationships via
-- the PersonPublication relationships: if two persons are authors on the same pub, then they are coauthors. In the PersonPublication table,
-- all PersonId's for the same PublicationId are coauthors on that paper.

-- You'll also see that the affiliation and title word tables are currently not used. They will generate a lot of rows and it is 
-- uncertain as of now whether they will add value for matching or downstream use.

-- ---------------------------------------------------------------------------------------------------
-- Add Authors
-- ---------------------------------------------------------------------------------------------------

drop table if exists AuthorityAuthorTemp;
CREATE temporary TABLE `AuthorityAuthorTemp` (
	`PersonId` int(11) UNSIGNED NOT NULL,
	`AuthorityRawId` int(11) UNSIGNED NULL DEFAULT NULL,
	`AuthorID` varchar(100) NULL DEFAULT NULL,
	`HIndex` varchar(100) NULL DEFAULT NULL,
	PRIMARY KEY (`PersonId`),
	INDEX `AuthorityRawId` (`AuthorityRawId`),
	INDEX `AuthorID` (`AuthorID`),
	INDEX `HIndex` (`HIndex`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- Need to insert rows into the UMetrics.Person table, get those inserted ids back, and link them to
-- the raw ids from the Authority.Author table.
start transaction;
-- This will insert one row into the Person table for each row in the Authority.author table.
insert into Person () select null from Authority.author;

-- Although this says "last", it is actually the first id of the last insert statement, which was a multiple row insert.
SET @key = LAST_INSERT_ID();  
-- This will insert into AuthorityAuthorTemp one row for each row in the Authority.author table combining it with the PersonId from the Person table.
-- It uses the last insert id and increments it by one for each row.
INSERT INTO AuthorityAuthorTemp (PersonID, AuthorityRawID, AuthorID, HIndex)
SELECT PersonID, RawID, AuthorID, HIndex
	FROM
	(
		SELECT @key + @rn as PersonID, RawID, AuthorID, cast(HIndex as char(100)) HIndex, @rn := @rn + 1
		FROM (select @rn:=0) x, Authority.author
	) y;

COMMIT;


-- Add Author_ID to the Attribute table
insert ignore into Attribute (Attribute)
	select AuthorID
		from AuthorityAuthorTemp;
insert into PersonAttribute (PersonID, AttributeID, RelationshipCode)
	select t.PersonID, a.AttributeId, 'AUTHORITY_AUTHOR_ID'
		from AuthorityAuthorTemp t
			inner join Attribute a on a.Attribute=t.AuthorID;
	
-- Add HIndex to the Attribute table
insert ignore into Attribute (Attribute)
	select HIndex
		from AuthorityAuthorTemp;
insert into PersonAttribute (PersonID, AttributeID, RelationshipCode)
	select t.PersonID, a.AttributeId, 'HINDEX'
		from AuthorityAuthorTemp t
			inner join Attribute a on a.Attribute=t.HIndex;
			
-- Add EMail to the Attribute table
insert ignore into Attribute (Attribute)
	select Name
		from Authority.email;

insert into PersonAttribute (PersonID, AttributeID, RelationshipCode)
	select t.PersonID, a.AttributeId, 'EMAIL'
		from AuthorityAuthorTemp t
			inner join Authority.email am on am.RawID=t.AuthorityRawId
			inner join Attribute a on a.Attribute=am.Name;


-- Add Names to the PersonName table - primary first
insert into PersonName
(
	PersonID,
	RelationshipCode,
	FullName,
	Prefix,
	GivenName,
	OtherName,
	Familyname,
	Suffix,
	Nickname
)
	select t.PersonID, 'PRIMARY', null, null, n.FirstName, n.MiddleName, n.LastName, n.Suffix, null
		from AuthorityAuthorTemp t
			inner join Authority.namevariant n on n.RawID=t.AuthorityRawId and n.Position=0 #Position=0 means that it was listed first and thus was the most frequently appearing
			;

	
-- Add Names to the PersonName table - alias's now
insert into PersonName
(
	PersonID,
	RelationshipCode,
	FullName,
	Prefix,
	GivenName,
	OtherName,
	Familyname,
	Suffix,
	Nickname
)
	select t.PersonID, 'ALIAS', null, null, n.FirstName, n.MiddleName, n.LastName, n.Suffix, null
		from AuthorityAuthorTemp t
			inner join Authority.namevariant n on n.RawID=t.AuthorityRawId and n.Position<>0;


-- ---------------------------------------------------------------------------------------------------
-- Add Publications
-- ---------------------------------------------------------------------------------------------------
drop table if exists AuthorityPublicationTemp;
CREATE temporary TABLE `AuthorityPublicationTemp` (
	`PublicationId` int(11) UNSIGNED NOT NULL,
	`PMID` int(11) UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (`PublicationId`),
	INDEX `PMID` (`PMID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- Need to insert rows into the UMetrics.Publication table, get those inserted ids back, and link them to
-- the PMIDs from the Authority.authornameinstance table.
start transaction;
-- This will insert one row into the Publication table for each unique PMID in the Authority.authornameinstance table.
insert into Publication (Year) select null from (select distinct PMID from Authority.authornameinstance) X;

-- Although this says "last", it is actually the first id of the last insert statement, which was a multiple row insert.
SET @key = LAST_INSERT_ID();  
-- This will insert into AuthorityPublicationTemp one row for each row in the Authority.authornameinstance table combining it with the PublicationId from the Publication table.
-- It uses the last insert id and increments it by one for each row.
INSERT INTO AuthorityPublicationTemp (PublicationId, PMID)
SELECT PublicationId, PMID
	FROM
	(
		SELECT @key + @rn as PublicationId, PMID, @rn := @rn + 1
		FROM (select @rn:=0) x, (select distinct PMID from Authority.authornameinstance) y
	) z;
COMMIT;

-- Add PMID to Attribute
insert ignore into Attribute (Attribute)
	select PMID from AuthorityPublicationTemp
		where PMID is not null;
insert into PublicationAttribute (PublicationId, AttributeId, RelationshipCode)
	select t.PublicationId, a.AttributeId, 'PMID'
		from AuthorityPublicationTemp t
			inner join Attribute a on a.Attribute=cast(t.PMID as char(100));

			--
-- Add PersonPublication relationships to represent what is in authornameinstance
--
insert into PersonPublication (PersonId, PublicationId, RelationshipCode)
	select  aat.PersonId, pa.PublicationId, 'AUTHOR'
		from AuthorityAuthorTemp aat
			inner join Authority.authornameinstance ani on ani.RawID=aat.AuthorityRawId
			inner join Attribute a on a.Attribute=cast(ani.PMID as char(100))
			inner join PublicationAttribute pa on pa.AttributeId=a.AttributeId and pa.RelationshipCode='PMID';

-- ---------------------------------------------------------------------------------------------------
-- Add Terms (journal, affiliation, MeSH, and title words)
-- ---------------------------------------------------------------------------------------------------
-- Need to insert rows into the UMetrics.Term table, get those inserted ids back, and link them to
-- the terms from the Authority.meshterm, affiliation, and titleword tables.
-- This will insert one row into the Term table for each term in the Authority database.
insert into Term (Term) select distinct Name from Authority.meshterm ;
--  insert ignore into Term (Term) select Name from 
--	(
--		select Name from Authority.meshterm 
--		union 
--		select Name from Authority.affiliation 
--		union
--		select Name from Authority.titleword 
--	) x;

-- This query takes a very long time and I can't figure out why.
insert ignore into PersonTerm (PersonId, TermId, RelationshipCode, Weight)
	select aat.PersonId, t.TermId, 'MESH', m.Count
		from AuthorityAuthorTemp aat
			inner join Authority.meshterm m on m.RawID=aat.AuthorityRawId
			inner join Term t on t.Term=m.Name;

-- insert ignore into PersonTerm (PersonId, TermId, RelationshipCode, Weight)
--	select aat.PersonId, t.TermId, 'AFFILIATION', a.Count from AuthorityAuthorTemp aat
--		inner join Authority.affiliation a on a.RawID=aat.AuthorityRawId
--		inner join Term t on t.Term=a.Name;
-- insert ignore into PersonTerm (PersonId, TermId, RelationshipCode, Weight)
--	select aat.PersonId, t.TermId, 'TITLEWORD', tw.Count from AuthorityAuthorTemp aat
--		inner join Authority.titleword tw on tw.RawID=aat.AuthorityRawId
--		inner join Term t on t.Term=tw.Name;


-- ---------------------------------------------------------------------------------------------------
-- Add PersonGrantAward relationships based on the Authority.grantid table.
-- ---------------------------------------------------------------------------------------------------

drop table if exists AuthorityGrantTemp;
CREATE temporary TABLE `AuthorityGrantTemp` (
	`GrantAwardId` int(11) UNSIGNED NOT NULL,
	`GrantNumber` varchar(50) not NULL,
	PRIMARY KEY (`GrantAwardId`),
	INDEX `PMID` (`GrantNumber`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- Need to insert rows into the UMetrics.GrantAward table, get those inserted ids back, and link them to
-- the grant numbers from the Authority.grantid table.
start transaction;
-- This will insert one row into the GrantAward table for each grant number in the Authority database.
insert into GrantAward (Title) select null from 
	(select distinct Name from Authority.grantid where Name is not null ) x;

-- Although this says "last", it is actually the first id of the last insert statement, which was a multiple row insert.
SET @key = LAST_INSERT_ID();  
-- This will insert into AuthorityGrantTemp one row for each row in the Authority.grantid table combining it with the GrantAwardId from the GrantAward table.
-- It uses the last insert id and increments it by one for each row.
INSERT INTO AuthorityGrantTemp (GrantAwardId, GrantNumber)  
SELECT GrantAwardId, Name
	FROM
	(
		SELECT @key + @rn as GrantAwardId, Name, @rn := @rn + 1
		FROM (select @rn:=0) x, 
			(select distinct Name from Authority.grantid where Name is not null ) y
	) z;

COMMIT;

-- Insert any grant numbers/Ids that do not currently exist in Attribute
insert ignore into Attribute (Attribute)
	select Name
		from Authority.grantid g;

insert into GrantAwardAttribute (GrantAwardId, AttributeId, RelationshipCode)
	select t.GrantAwardId, a.AttributeId, 'GRANTIDENTIFIER'
		from AuthorityGrantTemp t
			inner join Attribute a on a.Attribute=t.GrantNumber;


--
-- Add PersonGrantAward relationships to represent what is in Authority.grantid
--

insert ignore into PersonGrantAward (PersonId, GrantAwardId, RelationshipCode)
	select pa.PersonId, gaa.GrantAwardId, 'CITED'
		from Authority.grantid ag
			inner join Authority.author aa on aa.RawID=ag.RawID
			inner join Attribute a1 on a1.Attribute=aa.AuthorID
			inner join PersonAttribute pa on pa.AttributeId=a1.AttributeId and pa.RelationshipCode='AUTHORITY_AUTHOR_ID'
			inner join Attribute a2 on a2.Attribute=ag.Name
			inner join GrantAwardAttribute gaa on gaa.AttributeId=a2.AttributeId and gaa.RelationshipCode='GRANTIDENTIFIER';


set FOREIGN_KEY_CHECKS = 1;
set UNIQUE_CHECKS = 1;
