/*

	Some quick and dirty code to fix the naming inconsistency in the RelationshipCode
	column in the OrganizationName table.

	This code is, obviously, not terribly sophisticated.  It does not verify that the
	naming inconsistency even exists before doing its thing.  Re-run at your own risk.

*/


ALTER TABLE `OrganizationName`
	ALTER `RelationshipCode` DROP DEFAULT;

ALTER TABLE `OrganizationName`
	CHANGE COLUMN `RelationshipCode` `RelationshipCode` ENUM('ALIAS','PRIMARY ACRONYM','PRIMARY FULL','PRIMARY_ACRONYM','PRIMARY_FULL') NOT NULL COMMENT 'Describes the name\'s relationship to the organization.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!' AFTER `OrganizationId`;

update OrganizationName set RelationshipCode = 'PRIMARY_FULL' where RelationshipCode = 'PRIMARY FULL';

update OrganizationName set RelationshipCode = 'PRIMARY_ACRONYM' where RelationshipCode = 'PRIMARY ACRONYM';

ALTER TABLE `OrganizationName`
	ALTER `RelationshipCode` DROP DEFAULT;

ALTER TABLE `OrganizationName`
	CHANGE COLUMN `RelationshipCode` `RelationshipCode` ENUM('ALIAS','PRIMARY_ACRONYM','PRIMARY_FULL') NOT NULL COMMENT 'Describes the name\'s relationship to the organization.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!' AFTER `OrganizationId`;

