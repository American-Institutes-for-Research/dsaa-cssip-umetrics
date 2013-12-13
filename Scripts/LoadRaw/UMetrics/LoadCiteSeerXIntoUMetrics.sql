-- use UMetrics_GJY;

set FOREIGN_KEY_CHECKS = 0;
set UNIQUE_CHECKS = 0;

-- truncate Person;
-- truncate PersonAttribute;
-- truncate Attribute;
-- truncate PersonName;
-- truncate Address;
-- truncate PersonAddress;
-- truncate Publication;
-- truncate PublicationAttribute;
-- truncate PersonPublication;
-- truncate Term;
-- truncate PersonTerm;
-- truncate GrantAward;
-- truncate GrantAwardAttribute;
-- truncate PersonGrantAward;




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
insert into Person () select null from (select distinct cluster from CiteSeerX.authors where cluster not in (0, 1, 2)) x;

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
	) z;

COMMIT;

-- Add cluster ID to PersonAttribute
insert ignore into Attribute (Attribute)
	select cluster
		from CSXAuthorTemp;

insert into PersonAttribute (PersonID, AttributeID, RelationshipCode)
	select t.PersonID, a.AttributeId, 'CITESEERX_CLUSTER'
		from CSXAuthorTemp t
			inner join Attribute a on a.Attribute=t.cluster;


-- Add email to PersonAttribute
insert ignore into Attribute (Attribute)
	select email
		from CiteSeerX.authors
		where email is not null
			and cluster not in (0, 1, 2);

insert into PersonAttribute (PersonID, AttributeID, RelationshipCode)
	select distinct t.PersonID, a.AttributeId, 'EMAIL'
		from CSXAuthorTemp t
			inner join CiteSeerX.authors ca on ca.cluster=t.cluster
			inner join Attribute a on a.Attribute=ca.email;


-- Add Names to the PersonName table. authors.name is an alias, the primary name is in cannames
insert into PersonName (PersonID, FullName, GivenName, OtherName, FamilyName, RelationshipCode)
	select distinct t.PersonId, cc.canname, cc.fname, cc.mname, cc.lname, 'PRIMARY'
		from CSXAuthorTemp t
			inner join CiteSeerX.cannames cc on cc.id=t.cluster;

insert into PersonName (PersonID, RelationshipCode, FullName )
	select distinct t.PersonID, 'ALIAS', ca.name
		from CSXAuthorTemp t
			inner join CiteSeerX.authors ca on ca.cluster=t.cluster;


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
			where address is not null and cluster not in (0,1,2);


insert into Address (FullAddress)
	select distinct address
		from CSXAddressTemp cta;

SET SQL_SAFE_UPDATES=0;	
update CSXAddressTemp cat inner join Address a on cat.address=a.FullAddress set cat.AddressId=a.AddressId;
SET SQL_SAFE_UPDATES=1;


insert into PersonAddress (PersonId, AddressId, RelationshipCode)
	select distinct tauthor.PersonId, a.AddressId, 'ALTERNATE'
		from CSXAuthorTemp tauthor
			inner join CSXAddressTemp taddress on tauthor.cluster=taddress.cluster
			inner join Address a on a.FullAddress=taddress.address;

			
-- ---------------------------------------------------------------------------------------------------
-- Papers
-- ---------------------------------------------------------------------------------------------------
drop table if exists CSXPublicationTemp;
CREATE temporary TABLE `CSXPublicationTemp` (
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
	year int(11) null default null,
	index cluster (cluster),
	index id (id),
	primary key (cluster)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

-- Get all the unqiue papers by getting one for each paper cluster id in the CiteSeerX.papers table. When more than one, use
-- the one with the latest crawldate.
-- After doing a left outer join against itself with the crawldate comparison, the right side will contain nulls when the left side's
-- crawldate is the latest one.
-- Need to use "ignore" so we only get one  - there may be multiple ids per cluster, and we don't want that - and doesn't matter much which one
insert ignore into CSXUniquePapersTemp (cluster, id, year)
	select p1.cluster, p1.id, p1.year
		from CiteSeerX.papers p1
			left join CiteSeerX.papers p2 ON (p1.cluster = p2.cluster AND p1.crawlDate < p2.crawlDate)
		WHERE p2.crawlDate IS NULL and p1.cluster <> 0;


-- Need to insert rows into the UMetrics.Publication table, get those inserted ids back, and link them to
-- the cluster ids from the CiteSeerX.papers table.
start transaction;
-- This will insert one row into the Publication table for each row in the CiteSeerX.papers table.
insert into Publication (Year) select year from CSXUniquePapersTemp;

-- Although this says "last", it is actually the first id of the last insert statement, which was a multiple row insert.
SET @key = LAST_INSERT_ID();  
-- This will insert into CSXPublicationTemp one row for each row in the CiteSeerX.papers table combining it with the PublicationId from the Publication table.
-- It uses the last insert id and increments it by one for each row.
INSERT INTO CSXPublicationTemp (PublicationId, cluster)  
SELECT PublicationId, cluster
	FROM
	(
		SELECT @key + @rn as PublicationId, cluster, @rn := @rn + 1
		FROM (select @rn:=0) x, CSXUniquePapersTemp
	) z;

COMMIT;

-- Add cluster ID to PublicationAttribute
insert ignore into Attribute (Attribute)
	select cluster
		from CSXPublicationTemp;

insert into PublicationAttribute (PublicationId, AttributeId, RelationshipCode)
	select t.PublicationId, a.AttributeId, 'CITESEERX_CLUSTER'
		from CSXPublicationTemp t
			inner join Attribute a on a.Attribute=cast(t.cluster as char(100));
			
-- Add Title to PublicationAttribute
insert ignore into Attribute (Attribute)
	select title
		from CiteSeerX.papers
		where title is not null
			and cluster <> 0;

-- Add them all as 'other', then we'll go back and set some to 'primary'
insert ignore into PublicationAttribute (PublicationId, AttributeId, RelationshipCode)
	select t.PublicationId, a.AttributeId, 'TITLE_OTHER'
		from CSXPublicationTemp t
			inner join CiteSeerX.papers cp on cp.cluster=t.cluster
			inner join Attribute a on a.Attribute=left(cp.title,100);

-- Set one of the titles as primary. This will be the one that had the latest crawl date in a cluster. So it is the one
-- There is a double nesting of selects to avoid a MySQL restriction. See this for an explanation: http://verysimple.com/2011/03/30/mysql-cant-specify-target-table-for-update-in-from-clause/
-- 
SET SQL_SAFE_UPDATES=0;
update PublicationAttribute
	set RelationshipCode='TITLE_PRIMARY'
	where PublicationAttributeId in
		(select PublicationAttributeId from	
			(select PublicationAttributeId
				from CSXUniquePapersTemp up
					inner join CiteSeerX.papers cp on cp.id=up.id
					inner join CSXPublicationTemp t on t.cluster=cp.cluster
					inner join PublicationAttribute pa on pa.PublicationId=t.PublicationId and pa.RelationshipCode='TITLE_OTHER'
					inner join Attribute a on a.AttributeId=pa.AttributeId
				where a.Attribute=left(cp.title,100)
			) X
		);
SET SQL_SAFE_UPDATES=1;
--
-- Add PersonPublication relationships to represent what is in CiteSeerX.papers
--
insert into PersonPublication (PersonId, PublicationId, RelationshipCode)
	select cat.PersonId, cpt.PublicationId, 'AUTHOR'
		from CiteSeerX.authors ca
			inner join CiteSeerX.papers cp on cp.id=ca.paperid
			inner join CSXAuthorTemp cat on cat.cluster=ca.cluster
			inner join CSXPublicationTemp cpt on cpt.cluster=cp.cluster;

			
set FOREIGN_KEY_CHECKS = 1;
set UNIQUE_CHECKS = 1;
