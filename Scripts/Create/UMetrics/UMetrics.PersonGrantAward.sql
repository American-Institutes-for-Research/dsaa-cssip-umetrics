CREATE TABLE `PersonGrantAward` (
	`PersonGrantAwardId` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an PersonGrantAward.',
	`PersonId` INT(11) NOT NULL COMMENT 'Foreign key to Person table.',
	`GrantAwardId` INT(11) NOT NULL COMMENT 'Foreign key to GrantAward table.',
	`RelationshipCode` ENUM('CITED','PI','PO') NOT NULL COMMENT 'Describes the person\'s relationship to the grant award.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
	PRIMARY KEY (`PersonGrantAwardId`),
	UNIQUE INDEX `AK_PersonGrantAward` (`PersonId`, `GrantAwardId`, `RelationshipCode`),
	INDEX `FK_PersonGrantAward_GrantAward` (`GrantAwardId`),
	INDEX `FK_PersonGrantAward_Person` (`PersonId`),
	CONSTRAINT `FK_PersonGrantAward_GrantAward` FOREIGN KEY (`GrantAwardId`) REFERENCES `GrantAward` (`GrantAwardId`),
	CONSTRAINT `FK_PersonGrantAward_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`)
)
COMMENT='Relationships between an Person and a GrantAward.'
COLLATE='utf8_general_ci'
ENGINE=InnoDB;
