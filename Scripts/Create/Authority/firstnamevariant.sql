CREATE TABLE `firstnamevariant` (
	`FirstNameVariantId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (FirstNameVariantId),
	UNIQUE INDEX `FirstNameVariantId` (`FirstNameVariantId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
