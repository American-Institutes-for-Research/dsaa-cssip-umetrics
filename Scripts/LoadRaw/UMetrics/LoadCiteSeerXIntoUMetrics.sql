use UMetrics_GJY;

set AUTOCOMMIT = 0;
set FOREIGN_KEY_CHECKS = 0;
set UNIQUE_CHECKS = 0;

truncate Person;
truncate PersonAttribute;
truncate Attribute;
truncate PersonName;
truncate Address;
truncate PersonAddress;
truncate Publication;
truncate PublicationAttribute;
truncate PersonPublication;
truncate Term;
truncate PersonTerm;
truncate GrantAward;
truncate GrantAwardAttribute;
truncate PersonGrantAward;




-- ---------------------------------------------------------------------------------------------------
-- Authors
-- ---------------------------------------------------------------------------------------------------

drop table if exists CSXAuthorTemp;
CREATE temporary TABLE `CSXAuthorTemp` (
	`PersonId` int(11) UNSIGNED NOT NULL,
	`cluster` int(11) UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (`PersonId`),
	INDEX `cluster` (`cluster`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- Need to insert rows into the UMetrics.Person table, get those inserted ids back, and link them to
-- the raw ids from the CiteSeerX.authors table.
start transaction;
-- This will insert one row into the Person table for each row in the CiteSeerX.authors table.
insert into Person () select null from (select distinct cluster from CiteSeerX.authors where cluster not in (0, 1, 2) /* order by cluster */ /* limit 2000 */) x;

-- Although this says "last", it is actually the first id of the last insert statement, which was a multiple row insert.
SET @key = LAST_INSERT_ID();  
-- This will insert into CSXAuthorTemp one row for each row in the CiteSeerX.authors table combining it with the PersonId from the Person table.
-- It uses the last insert id and increments it by one for each row.
INSERT INTO CSXAuthorTemp (PersonID, cluster)  
SELECT PersonID, cluster
	FROM
	(
		SELECT @key + @rn as PersonID, cluster, @rn := @rn + 1
		FROM (select @rn:=0) x, (select distinct cluster from CiteSeerX.authors where cluster not in (0, 1, 2)) y
		/* order by cluster */ /* limit 2000 */
	) z;

COMMIT;

-- Add cluster ID to PersonAttribute
insert into Attribute (Attribute)
	select distinct cluster
		from CSXAuthorTemp
		where cluster not in (select Attribute from Attribute)
		/* order by cluster */
		/* limit 2000 */;

insert into PersonAttribute (PersonID, AttributeID, RelationshipCode)
	select t.PersonID, a.AttributeId, 'CITESEERX_CLUSTER'
		from CSXAuthorTemp t
			inner join Attribute a on a.Attribute=t.cluster;


-- Add email to PersonAttribute
insert into Attribute (Attribute)
	select distinct email
		from CiteSeerX.authors
		where email not in (select Attribute from Attribute)
		/* order by cluster */
		/* limit 2000 */;

insert into PersonAttribute (PersonID, AttributeID, RelationshipCode)
	select distinct t.PersonID, a.AttributeId, 'EMAIL'
		from CSXAuthorTemp t
			inner join CiteSeerX.authors ca on ca.cluster=t.cluster
			inner join Attribute a on a.Attribute=ca.email;


-- Add Names to the PersonName table. authors.name is an alias, the primary name is in cannames
insert into PersonName (PersonID, FullName, GivenName, OtherName, FamilyName, RelationshipCode)
	select distinct t.PersonId, cc.canname, cc.fname, cc.mname, cc.lname, 'PRIMARY'
		from CSXAuthorTemp t
			inner join CiteSeerX.cannames cc on cc.id=t.cluster
			/* order by cc.id */
			/* limit 2000 */;

insert into PersonName (PersonID, RelationshipCode, FullName )
	select distinct t.PersonID, 'ALIAS', ca.name
		from CSXAuthorTemp t
			inner join CiteSeerX.authors ca on ca.cluster=t.cluster
			/* order by ca.cluster */
			/* limit 2000 */;


-- Add Addresses to Address and PersonAddress
drop table if exists CSXAddressTemp;
create temporary table CSXAddressTemp
(
	cluster int(11) unsigned,
	address varchar(255),
	AddressId int(11) unsigned null default null,
	index cluster (cluster),
	index address (address)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

insert into CSXAddressTemp (cluster, address)
	select cluster, address
			from CiteSeerX.authors
			where address is not null and cluster not in (0,1,2) /* limit 2000 */;


insert into Address (FullAddress)
	select distinct address
		from CSXAddressTemp cta
		where address not in (select FullAddress from Address where FullAddress is not null)
		/* order by cluster */ /* limit 2000 */;

	
update CSXAddressTemp cat inner join Address a on cat.address=a.FullAddress set cat.AddressId=a.AddressId;


insert into PersonAddress (PersonId, AddressId, RelationshipCode)
	select distinct tauthor.PersonId, a.AddressId, 'ALTERNATE'
		from CSXAuthorTemp tauthor
			inner join CSXAddressTemp taddress on tauthor.cluster=taddress.cluster
			inner join Address a on a.FullAddress=taddress.address
			/* limit 2000 */;

			
-- ---------------------------------------------------------------------------------------------------
-- Papers
-- ---------------------------------------------------------------------------------------------------
drop table if exists CSXPaperTemp;
CREATE temporary TABLE `CSXPaperTemp` (
	`PublicationId` int(11) UNSIGNED NOT NULL,
	`cluster` int(11) UNSIGNED NULL DEFAULT NULL,
	PRIMARY KEY (`PublicationId`),
	INDEX `cluster` (`cluster`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

drop table if exists CSXUniquePapersTemp;
create temporary table CSXUniquePapersTemp
(
	cluster int(11) unsigned null default null,
	id varchar(100) null default null,
	title varchar(255) null default null,
	year int(11) null default null,
	index cluster (cluster),
	index id (id)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- Get all the unqiue papers by getting one for each paper cluster id in the CiteSeerX.papers table. When more than one, use
-- the one with the latest crawldate.
-- After doing a left outer join against itself with the crawldate comparison, the right side will contain nulls when the left side's
-- crawldate is the latest one.
insert into CSXUniquePapersTemp (cluster, id, title, year)
	select p1.cluster, p1.id, p1.title, p1.year
		from CiteSeerX.papers p1
			left join CiteSeerX.papers p2 ON (p1.cluster = p2.cluster AND p1.crawlDate < p2.crawlDate)
		WHERE p2.crawlDate IS NULL and p1.cluster not in (0,1,2)
		/* limit 2000 */;



-- Need to insert rows into the UMetrics.Publication table, get those inserted ids back, and link them to
-- the cluster ids from the CiteSeerX.papers table.
start transaction;
-- This will insert one row into the Publication table for each row in the CiteSeerX.papers table.
insert into Publication (Title, Year) select title, year from CSXUniquePapersTemp /* order by cluster */ /* limit 2000 */;

-- Although this says "last", it is actually the first id of the last insert statement, which was a multiple row insert.
SET @key = LAST_INSERT_ID();  
-- This will insert into CSXPaperTemp one row for each row in the CiteSeerX.papers table combining it with the PublicationId from the Publication table.
-- It uses the last insert id and increments it by one for each row.
INSERT INTO CSXPaperTemp (PublicationId, cluster)  
SELECT PublicationId, cluster
	FROM
	(
		SELECT @key + @rn as PublicationId, cluster, @rn := @rn + 1
		FROM (select @rn:=0) x, CSXUniquePapersTemp
		/* order by cluster */ /* limit 2000 */
	) z;

COMMIT;

-- Add cluster ID to PublicationAttribute
insert into Attribute (Attribute)
	select distinct cluster
		from CSXPaperTemp
		where cast(cluster as char(100)) not in (select Attribute from Attribute)
		/* order by cluster */
		/* limit 2000 */;

insert into PublicationAttribute (PublicationID, AttributeID, RelationshipCode)
	select t.PublicationID, a.AttributeId, 'CITESEERX_CLUSTER'
		from CSXPaperTemp t
			inner join Attribute a on a.Attribute=cast(t.cluster as char(100));


--
-- Add PersonPublication relationships to represent what is in CiteSeerX.papers
--
insert into PersonPublication (PersonId, PublicationId, RelationshipCode)
	select cat.PersonId, cpt.PublicationId, 'AUTHOR'
		from CiteSeerX.authors ca
			inner join CiteSeerX.papers cp on cp.id=ca.paperid
			inner join CSXAuthorTemp cat on cat.cluster=ca.cluster
			inner join CSXPaperTemp cpt on cpt.cluster=cp.cluster
		/* limit 2000 */;			



			
set AUTOCOMMIT = 1;
set FOREIGN_KEY_CHECKS = 1;
set UNIQUE_CHECKS = 1;
