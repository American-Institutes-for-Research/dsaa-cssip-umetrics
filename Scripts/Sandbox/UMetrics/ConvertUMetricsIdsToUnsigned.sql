/*

	Some quick and dirty code to convert Ids in UMetrics from SIGNED INTs to UNSIGNED.

	This code is, obviously, not terribly sophisticated.  It does not dynamically check
	data types or foreign keys.  Re-run at your own risk.

*/

alter table GrantAwardAttribute drop foreign key `FK_GrantAwardAttribute_Attribute`;
alter table GrantAwardAttribute drop foreign key `FK_GrantAwardAttribute_GrantAward`;

alter table OrganizationAddress drop foreign key `FK_OrganizationAddress_Address`;
alter table OrganizationAddress drop foreign key `FK_OrganizationAddress_Organization`;

alter table OrganizationAttribute drop foreign key `FK_OrganizationAttribute_Attribute`;
alter table OrganizationAttribute drop foreign key `FK_OrganizationAttribute_Organization`;

alter table OrganizationGrantAward drop foreign key `FK_OrganizationGrantAward_GrantAward`;
alter table OrganizationGrantAward drop foreign key `FK_OrganizationGrantAward_Organization`;

alter table OrganizationName drop foreign key `FK_OrganizationName_Organization`;

alter table OrganizationOrganization drop foreign key `FK_OrganizationOrganization_Organization`;
alter table OrganizationOrganization drop foreign key `FK_OrganizationOrganization_Organization_2`;

alter table PersonAddress drop foreign key `FK_PersonAddress_Address`;
alter table PersonAddress drop foreign key `FK_PersonAddress_Person`;

alter table PersonAttribute drop foreign key `FK_PersonAttribute_Attribute`;
alter table PersonAttribute drop foreign key `FK_PersonAttribute_Person`;

alter table PersonGrantAward drop foreign key `FK_PersonGrantAward_GrantAward`;
alter table PersonGrantAward drop foreign key `FK_PersonGrantAward_Person`;

alter table PersonName drop foreign key `FK_PersonName_Person`;



ALTER TABLE `Address`
	CHANGE COLUMN `AddressId` `AddressId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an Address.' FIRST;

ALTER TABLE `Attribute`
	CHANGE COLUMN `AttributeId` `AttributeId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an Attribute.' FIRST;

ALTER TABLE `GrantAward`
	CHANGE COLUMN `GrantAwardId` `GrantAwardId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for a GrantAward.' FIRST;

ALTER TABLE `GrantAwardAttribute`
	ALTER `GrantAwardId` DROP DEFAULT,
	ALTER `AttributeId` DROP DEFAULT;
ALTER TABLE `GrantAwardAttribute`
	CHANGE COLUMN `GrantAwardAttributeId` `GrantAwardAttributeId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an GrantAwardAttribute.' FIRST,
	CHANGE COLUMN `GrantAwardId` `GrantAwardId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the GrantAward.' AFTER `GrantAwardAttributeId`,
	CHANGE COLUMN `AttributeId` `AttributeId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the Attribute.' AFTER `GrantAwardId`;

ALTER TABLE `Organization`
	CHANGE COLUMN `OrganizationId` `OrganizationId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an Organization.' FIRST;

ALTER TABLE `OrganizationAddress`
	ALTER `OrganizationId` DROP DEFAULT,
	ALTER `AddressId` DROP DEFAULT;
ALTER TABLE `OrganizationAddress`
	CHANGE COLUMN `OrganizationAddressId` `OrganizationAddressId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an OrganizationAddress.' FIRST,
	CHANGE COLUMN `OrganizationId` `OrganizationId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the Organization table.' AFTER `OrganizationAddressId`,
	CHANGE COLUMN `AddressId` `AddressId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the Address table.' AFTER `OrganizationId`;

ALTER TABLE `OrganizationAttribute`
	ALTER `OrganizationId` DROP DEFAULT,
	ALTER `AttributeId` DROP DEFAULT;
ALTER TABLE `OrganizationAttribute`
	CHANGE COLUMN `OrganizationAttributeId` `OrganizationAttributeId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an OrganizationAttribute.' FIRST,
	CHANGE COLUMN `OrganizationId` `OrganizationId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the Organization.' AFTER `OrganizationAttributeId`,
	CHANGE COLUMN `AttributeId` `AttributeId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the Attribute.' AFTER `OrganizationId`;

ALTER TABLE `OrganizationGrantAward`
	ALTER `OrganizationId` DROP DEFAULT,
	ALTER `GrantAwardId` DROP DEFAULT;
ALTER TABLE `OrganizationGrantAward`
	CHANGE COLUMN `OrganizationGrantAwardId` `OrganizationGrantAwardId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an OrganizationGrantAward.' FIRST,
	CHANGE COLUMN `OrganizationId` `OrganizationId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to Organization table.' AFTER `OrganizationGrantAwardId`,
	CHANGE COLUMN `GrantAwardId` `GrantAwardId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to GrantAward table.' AFTER `OrganizationId`;

ALTER TABLE `OrganizationName`
	ALTER `OrganizationId` DROP DEFAULT;
ALTER TABLE `OrganizationName`
	CHANGE COLUMN `OrganizationNameId` `OrganizationNameId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an OrganizationName.' FIRST,
	CHANGE COLUMN `OrganizationId` `OrganizationId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the Organization table.  Each organization can have more than one name, but must have at least one.' AFTER `OrganizationNameId`;

ALTER TABLE `OrganizationOrganization`
	ALTER `OrganizationAId` DROP DEFAULT,
	ALTER `OrganizationBId` DROP DEFAULT;
ALTER TABLE `OrganizationOrganization`
	CHANGE COLUMN `OrganizationOrganizationId` `OrganizationOrganizationId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an OrganizationOrganization.' FIRST,
	CHANGE COLUMN `OrganizationAId` `OrganizationAId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the first organization in the relationship.' AFTER `OrganizationOrganizationId`,
	CHANGE COLUMN `OrganizationBId` `OrganizationBId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the second organization in the relationship.' AFTER `OrganizationAId`;

ALTER TABLE `Person`
	CHANGE COLUMN `PersonId` `PersonId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for a Person.' FIRST;

ALTER TABLE `PersonAddress`
	ALTER `PersonId` DROP DEFAULT,
	ALTER `AddressId` DROP DEFAULT;
ALTER TABLE `PersonAddress`
	CHANGE COLUMN `PersonAddressId` `PersonAddressId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for a PersonAddress.' FIRST,
	CHANGE COLUMN `PersonId` `PersonId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the Person table.' AFTER `PersonAddressId`,
	CHANGE COLUMN `AddressId` `AddressId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the Address table.' AFTER `PersonId`;

ALTER TABLE `PersonAttribute`
	ALTER `PersonId` DROP DEFAULT,
	ALTER `AttributeId` DROP DEFAULT;
ALTER TABLE `PersonAttribute`
	CHANGE COLUMN `PersonAttributeId` `PersonAttributeId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an PersonAttribute.' FIRST,
	CHANGE COLUMN `PersonId` `PersonId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the Person.' AFTER `PersonAttributeId`,
	CHANGE COLUMN `AttributeId` `AttributeId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to the Attribute.' AFTER `PersonId`;

ALTER TABLE `PersonGrantAward`
	ALTER `PersonId` DROP DEFAULT,
	ALTER `GrantAwardId` DROP DEFAULT;
ALTER TABLE `PersonGrantAward`
	CHANGE COLUMN `PersonGrantAwardId` `PersonGrantAwardId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an PersonGrantAward.' FIRST,
	CHANGE COLUMN `PersonId` `PersonId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to Person table.' AFTER `PersonGrantAwardId`,
	CHANGE COLUMN `GrantAwardId` `GrantAwardId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key to GrantAward table.' AFTER `PersonId`;

ALTER TABLE `PersonName`
	ALTER `PersonId` DROP DEFAULT;
ALTER TABLE `PersonName`
	CHANGE COLUMN `PersonNameId` `PersonNameId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for a PersonName.' FIRST,
	CHANGE COLUMN `PersonId` `PersonId` INT(11) UNSIGNED NOT NULL COMMENT 'Foreign key of the person to whom this name belongs.' AFTER `PersonNameId`;






alter table GrantAwardAttribute add CONSTRAINT `FK_GrantAwardAttribute_Attribute` FOREIGN KEY (`AttributeId`) REFERENCES `Attribute` (`AttributeId`);
alter table GrantAwardAttribute add CONSTRAINT `FK_GrantAwardAttribute_GrantAward` FOREIGN KEY (`GrantAwardId`) REFERENCES `GrantAward` (`GrantAwardId`);

alter table OrganizationAddress add CONSTRAINT `FK_OrganizationAddress_Address` FOREIGN KEY (`AddressId`) REFERENCES `Address` (`AddressId`);
alter table OrganizationAddress add CONSTRAINT `FK_OrganizationAddress_Organization` FOREIGN KEY (`OrganizationId`) REFERENCES `Organization` (`OrganizationId`);

alter table OrganizationAttribute add CONSTRAINT `FK_OrganizationAttribute_Attribute` FOREIGN KEY (`AttributeId`) REFERENCES `Attribute` (`AttributeId`);
alter table OrganizationAttribute add CONSTRAINT `FK_OrganizationAttribute_Organization` FOREIGN KEY (`OrganizationId`) REFERENCES `Organization` (`OrganizationId`);

alter table OrganizationGrantAward add CONSTRAINT `FK_OrganizationGrantAward_GrantAward` FOREIGN KEY (`GrantAwardId`) REFERENCES `GrantAward` (`GrantAwardId`);
alter table OrganizationGrantAward add CONSTRAINT `FK_OrganizationGrantAward_Organization` FOREIGN KEY (`OrganizationId`) REFERENCES `Organization` (`OrganizationId`);

alter table OrganizationName add CONSTRAINT `FK_OrganizationName_Organization` FOREIGN KEY (`OrganizationId`) REFERENCES `Organization` (`OrganizationId`);

alter table OrganizationOrganization add CONSTRAINT `FK_OrganizationOrganization_Organization` FOREIGN KEY (`OrganizationAId`) REFERENCES `Organization` (`OrganizationId`);
alter table OrganizationOrganization add CONSTRAINT `FK_OrganizationOrganization_Organization_2` FOREIGN KEY (`OrganizationBId`) REFERENCES `Organization` (`OrganizationId`);

alter table PersonAddress add CONSTRAINT `FK_PersonAddress_Address` FOREIGN KEY (`AddressId`) REFERENCES `Address` (`AddressId`);
alter table PersonAddress add CONSTRAINT `FK_PersonAddress_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`);

alter table PersonAttribute add CONSTRAINT `FK_PersonAttribute_Attribute` FOREIGN KEY (`AttributeId`) REFERENCES `Attribute` (`AttributeId`);
alter table PersonAttribute add CONSTRAINT `FK_PersonAttribute_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`);

alter table PersonGrantAward add CONSTRAINT `FK_PersonGrantAward_GrantAward` FOREIGN KEY (`GrantAwardId`) REFERENCES `GrantAward` (`GrantAwardId`);
alter table PersonGrantAward add CONSTRAINT `FK_PersonGrantAward_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`);

alter table PersonName add CONSTRAINT `FK_PersonName_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`);
