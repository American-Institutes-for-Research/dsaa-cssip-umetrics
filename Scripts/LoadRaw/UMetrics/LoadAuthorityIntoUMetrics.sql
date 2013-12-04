use UMetrics_GJY;

set AUTOCOMMIT = 0;
set FOREIGN_KEY_CHECKS = 0;
set UNIQUE_CHECKS = 0;

truncate Person;
truncate PersonAttribute;
truncate Attribute;
truncate PersonName;
truncate Publication;
truncate PublicationAttribute;
truncate PersonPublication;
truncate Term;
truncate PersonTerm;
truncate GrantAward;
truncate GrantAwardAttribute;
truncate PersonGrantAward;

-- You'll see below that we don't do anything with the Authority.coauthorid table. That is because we can infer those relationships via
-- the PersonPublication relationships: if two persons are authors on the same pub, then they are coauthors. In the PersonPublication table,
-- all PersonId's for the same PublicationId are coauthors on that paper.

-- You'll also see that the affiliation and title word tables are currently not used. They will generate a lot of rows and it is 
-- uncertain as of now whether they will add value for matching or downstream use.

drop table if exists AuthorityAuthorTemp;
CREATE  TABLE `AuthorityAuthorTemp` (
	`PersonId` INT(10) UNSIGNED NOT NULL,
	`AuthorityRawId` INT(10) UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (`PersonId`),
	INDEX `AuthorityRawId` (`AuthorityRawId`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- Need to insert rows into the UMetrics.Person table, get those inserted ids back, and link them to
-- the raw ids from the Authority.Author table.
start transaction;
-- This will insert one row into the Person table for each row in the Authority.author table.
insert into Person () select null from Authority.author /* order by RawID */ /* limit 200000 */;
-- Although this says "last", it is actually the first id of the last insert statement, which was a multiple row insert.
SET @key = LAST_INSERT_ID();  
-- This will insert into AuthorityAuthorTemp one row for each row in the Authority.author table combining it with the PersonId from the Person table.
-- It uses the last insert id and increments it by one for each row.
INSERT INTO AuthorityAuthorTemp (PersonID, AuthorityRawID)  
SELECT PersonID, RawID
	FROM
	(
		SELECT @key + @rn as PersonID, RawID, @rn := @rn + 1
		FROM (select @rn:=0) x, Authority.author
		/* order by RawID */ /* limit 200000 */
	) y;
COMMIT;


-- Add Author_ID to the Attribute table
insert into Attribute (Attribute)
	select distinct AuthorID
		from Authority.author
		where AuthorID not in (select Attribute from Attribute)
		/* order by RawID */
		/* limit 200000 */;
insert into PersonAttribute (PersonID, AttributeID, RelationshipCode)
	select t.PersonID, a.AttributeId, 'AUTHORITY_AUTHOR_ID'
		from AuthorityAuthorTemp t
			inner join Authority.author aa on aa.RawID=t.AuthorityRawId
			inner join Attribute a on a.Attribute=aa.AuthorID;
	
-- Add HIndex to the Attribute table
insert into Attribute (Attribute)
	select distinct HIndex
		from Authority.author
		where cast(HIndex as char(100)) not in (select Attribute from Attribute)
		/* order by RawID */
		/* limit 200000 */;
insert into PersonAttribute (PersonID, AttributeID, RelationshipCode)
	select t.PersonID, a.AttributeId, 'HINDEX'
		from AuthorityAuthorTemp t
			inner join Authority.author aa on aa.RawID=t.AuthorityRawId
			inner join Attribute a on a.Attribute=cast(aa.HIndex as char(100));
			
			
-- Add EMail to the Attribute table
insert into Attribute (Attribute)
	select distinct Name
		from Authority.email
		where Name not in (select Attribute from Attribute)
		/* order by RawID */
		/* limit 200000 */;
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
			/* order by n.RawID */
			/* limit 200000 */;
	
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
			inner join Authority.namevariant n on n.RawID=t.AuthorityRawId and n.Position<>0
			/* limit 200000 */;




-- Add Publications
drop table if exists AuthorityPublicationTemp;
CREATE  TABLE `AuthorityPublicationTemp` (
	`PublicationId` INT(10) UNSIGNED NOT NULL,
	`PMID` INT(10) UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (`PublicationId`),
	INDEX `PMID` (`PMID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- Need to insert rows into the UMetrics.Publication table, get those inserted ids back, and link them to
-- the PMIDs from the Authority.citationcount, cited, citedby, and authornameinstance tables.
start transaction;
-- This will insert one row into the Publication table for each PMID in the Authority database.
insert into Publication () select null from 
	(
--		select distinct PMID from Authority.citationcount /* limit 200000 */
--		union 
--		select distinct PMID from Authority.cited /* limit 200000 */
--		union
--		select distinct PMID from Authority.citedby /* limit 200000 */
--		union
		select distinct PMID from Authority.authornameinstance /* limit 200000 */
	) x;
-- Although this says "last", it is actually the first id of the last insert statement, which was a multiple row insert.
SET @key = LAST_INSERT_ID();  
-- This will insert into AuthorityPublicationTemp one row for each row in the Authority.author table combining it with the Publication from the Publication table.
-- It uses the last insert id and increments it by one for each row.
INSERT INTO AuthorityPublicationTemp (PublicationId, PMID)  
SELECT PublicationId, PMID
	FROM
	(
		SELECT @key + @rn as PublicationId, PMID, @rn := @rn + 1
		FROM (select @rn:=0) x, 
			(
--				select distinct PMID from Authority.citationcount /* limit 200000 */
--				union 
--				select distinct PMID from Authority.cited /* limit 200000 */
--				union
--				select distinct PMID from Authority.citedby /* limit 200000 */
--				union
				select distinct PMID from Authority.authornameinstance /* limit 200000 */
			) y
		/* order by PMID */
	) z;
COMMIT;

-- Add PMID to the Attribute table
insert into Attribute (Attribute)
	select distinct PMID
		from AuthorityPublicationTemp
		where cast(PMID as char(100)) not in (select Attribute from Attribute)
		/* order by PMID */
		/* limit 200000 */;
insert into PublicationAttribute (PublicationId, AttributeId, RelationshipCode)
	select t.PublicationId, a.AttributeId, 'PMID'
		from AuthorityPublicationTemp t
			inner join Attribute a on a.Attribute=cast(t.PMID as char(100));


--
-- Add PersonPublication relationships to represent what is in authornameinstance
--

insert into PersonPublication (PersonId, PublicationId, RelationshipCode)
	select pa.PersonId, puba.PublicationId, 'AUTHOR'
		from Authority.authornameinstance aani
			inner join Authority.author aa on aa.RawID=aani.RawID
			inner join Attribute a1 on a1.Attribute=aa.AuthorID
			inner join PersonAttribute pa on pa.AttributeId=a1.AttributeId and pa.RelationshipCode='AUTHORITY_AUTHOR_ID'
			inner join Attribute a2 on a2.Attribute=aani.PMID
			inner join PublicationAttribute puba on puba.AttributeId=a2.AttributeId and puba.RelationshipCode='PMID'
			/* order by aani.RawID */
			/* limit 200000 */;


--
-- Add Terms (journal, affiliation, MeSH, and title words)
--
-- Need to insert rows into the UMetrics.Term table, get those inserted ids back, and link them to
-- the terms from the Authority.meshterm, affiliation, and titleword tables.
-- This will insert one row into the Term table for each term in the Authority database.
insert into Term (Term) select Name from 
	(
		select distinct Name from Authority.meshterm /* limit 200000 */
--		union 
--		select distinct Name from Authority.affiliation /* limit 200000 */
--		union
--		select distinct Name from Authority.titleword /* limit 200000 */
	) x where x.Name not in (select Term from Term);
insert into PersonTerm (PersonId, TermId, RelationshipCode, Weight)
	select aat.PersonId, t.TermId, 'MESH', m.Count from AuthorityAuthorTemp aat
		inner join Authority.meshterm m on m.RawID=aat.AuthorityRawId
		inner join Term t on t.Term=m.Name;
-- insert into PersonTerm (PersonId, TermId, RelationshipCode, Weight)
--	select aat.PersonId, t.TermId, 'AFFILIATION', a.Count from AuthorityAuthorTemp aat
--		inner join Authority.affiliation a on a.RawID=aat.AuthorityRawId
--		inner join Term t on t.Term=a.Name;
-- insert into PersonTerm (PersonId, TermId, RelationshipCode, Weight)
--	select aat.PersonId, t.TermId, 'TITLEWORD', tw.Count from AuthorityAuthorTemp aat
--		inner join Authority.titleword tw on tw.RawID=aat.AuthorityRawId
--		inner join Term t on t.Term=tw.Name;


--
-- Add PersonGrantAward relationships based on the Authority.grantid table.
--

drop table if exists AuthorityGrantTemp;
CREATE  TABLE `AuthorityGrantTemp` (
	`GrantAwardId` INT(10) UNSIGNED NOT NULL,
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
	(select distinct Name from Authority.grantid /* limit 200000 */) x;
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
			(select distinct Name from Authority.grantid /* limit 200000 */) y
		/* order by Name */
	) z;
COMMIT;

-- Insert any grant numbers/Ids that do not currently exist in Attribute
insert into Attribute (Attribute)
	select distinct Name
		from Authority.grantid g
		where g.Name not in (select Attribute from Attribute)
		/* limit 200000 */;
insert into GrantAwardAttribute (GrantAwardId, AttributeId, RelationshipCode)
	select t.GrantAwardId, a.AttributeId, 'GRANTIDENTIFIER'
		from AuthorityGrantTemp t
			inner join Attribute a on a.Attribute=t.GrantNumber;

--
-- Add PersonGrantAward relationships to represent what is in Authority.grantid
--

insert into PersonGrantAward (PersonId, GrantAwardId, RelationshipCode)
	select pa.PersonId, gaa.GrantAwardId, 'CITED'
		from Authority.grantid ag
			inner join Authority.author aa on aa.RawID=ag.RawID
			inner join Attribute a1 on a1.Attribute=aa.AuthorID
			inner join PersonAttribute pa on pa.AttributeId=a1.AttributeId and pa.RelationshipCode='AUTHORITY_AUTHOR_ID'
			inner join Attribute a2 on a2.Attribute=ag.Name
			inner join GrantAwardAttribute gaa on gaa.AttributeId=a2.AttributeId and gaa.RelationshipCode='GRANTIDENTIFIER'
			/* order by ag.RawID */
			/* limit 200000 */;


set AUTOCOMMIT = 1;
set FOREIGN_KEY_CHECKS = 1;
set UNIQUE_CHECKS = 1;
