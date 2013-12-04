CREATE TABLE `PersonPublication` (
	`PersonPublicationId` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`PersonId` INT(11) NOT NULL,
	`PublicationId` INT(10) UNSIGNED NOT NULL,
	`RelationshipCode` ENUM('AUTHOR') NOT NULL,
	PRIMARY KEY (`PersonPublicationId`),
	INDEX `RelationshipCode` (`RelationshipCode`),
	INDEX `FK_PersonPublication_Person` (`PersonId`),
	INDEX `FK_PersonPublication_Publication` (`PublicationId`),
	CONSTRAINT `FK_PersonPublication_Person` FOREIGN KEY (`PersonId`) REFERENCES `Person` (`PersonId`),
	CONSTRAINT `FK_PersonPublication_Publication` FOREIGN KEY (`PublicationId`) REFERENCES `Publication` (`PublicationId`)
)
ENGINE=InnoDB;
