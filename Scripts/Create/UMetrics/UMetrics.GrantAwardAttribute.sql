CREATE TABLE `GrantAwardAttribute` (
	`GrantAwardAttributeId` INT(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for an GrantAwardAttribute.',
	`GrantAwardId` INT(11) NOT NULL COMMENT 'Foreign key to the GrantAward.',
	`AttributeId` INT(11) NOT NULL COMMENT 'Foreign key to the Attribute.',
	`RelationshipCode` ENUM('CFDA_CODE','FOA_CODE','GRANTIDENTIFIER','NIH_APPLICATION_ID','NIH_CORE_PROJECT_NUM','NIH_FULL_PROJECT_NUM','NIH_SUBPROJECT_ID') NOT NULL COMMENT 'Describes the attribute\'s relationship to the organization.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!',
	PRIMARY KEY (`GrantAwardAttributeId`),
	UNIQUE INDEX `AK_GrantAwadAttribute` (`RelationshipCode`, `GrantAwardId`, `AttributeId`),
	INDEX `FK_GrantAwardAttribute_GrantAward` (`GrantAwardId`),
	INDEX `FK_GrantAwardAttribute_Attribute` (`AttributeId`),
	CONSTRAINT `FK_GrantAwardAttribute_Attribute` FOREIGN KEY (`AttributeId`) REFERENCES `Attribute` (`AttributeId`),
	CONSTRAINT `FK_GrantAwardAttribute_GrantAward` FOREIGN KEY (`GrantAwardId`) REFERENCES `GrantAward` (`GrantAwardId`)
)
COMMENT='Attributes for GrantAwards.'
COLLATE='utf8_general_ci'
ENGINE=InnoDB;
