CREATE TABLE `lastnamevariant` (
	`LastNameVariantId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(100) NOT NULL,
	PRIMARY KEY (LastNameVariantId),
	UNIQUE INDEX `LastNameVariantId` (`LastNameVariantId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
