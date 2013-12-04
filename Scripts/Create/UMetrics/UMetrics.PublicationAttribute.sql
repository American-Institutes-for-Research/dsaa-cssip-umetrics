CREATE TABLE `PublicationAttribute` (
	`PublicationAttributeId` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`PublicationId` INT(10) UNSIGNED NOT NULL,
	`AttributeId` INT(11) NOT NULL,
	`RelationshipCode` ENUM('PMID') NOT NULL,
	PRIMARY KEY (`PublicationAttributeId`),
	UNIQUE INDEX `AK_PublicationAttribute` (`RelationshipCode`, `PublicationId`, `AttributeId`),
	INDEX `FK_PublicationAttribute_Attribute` (`AttributeId`),
	INDEX `PK_PublicationAttribute_Publication` (`PublicationId`),
	CONSTRAINT `FK_PublicationAttribute_Attribute` FOREIGN KEY (`AttributeId`) REFERENCES `Attribute` (`AttributeId`),
	CONSTRAINT `PK_PublicationAttribute_Publication` FOREIGN KEY (`PublicationId`) REFERENCES `Publication` (`PublicationId`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;
