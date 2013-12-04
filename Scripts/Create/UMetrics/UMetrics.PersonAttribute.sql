CREATE TABLE `PersonAttribute` (
	`PersonAttributeId` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an PersonAttribute.',
	`PersonId` INT(11) NOT NULL COMMENT 'Foreign key to the Person.',
	`AttributeId` INT(11) NOT NULL COMMENT 'Foreign key to the Attribute.',
	`RelationshipCode` ENUM('AUTHORITY_AUTHOR_ID','EMAIL','HINDEX','TELEPHONE','NIH_PI_ID') NOT NULL COMMENT 'Describes the attribute\'s relationship to the person.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
	PRIMARY KEY (`PersonAttributeId`),
	UNIQUE INDEX `AK_PersonAttribute` (`RelationshipCode`, `PersonId`, `AttributeId`),
	INDEX `FK_PersonAttribute_Person` (`PersonId`),
	INDEX `FK_PersonAttribute_Attribute` (`AttributeId`),
	CONSTRAINT `FK_PersonAttribute_Attribute` FOREIGN KEY (`AttributeId`) REFERENCES `Attribute` (`AttributeId`),
	CONSTRAINT `FK_PersonAttribute_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`)
)
COMMENT='Attributes for Persons.'
COLLATE='utf8_general_ci'
ENGINE=InnoDB;
