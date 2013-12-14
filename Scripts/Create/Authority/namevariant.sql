CREATE TABLE `namevariant` (
	`NameVariantId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`LastName` VARCHAR(100) NOT NULL,
	`FirstName` VARCHAR(50) NOT NULL,
	`MiddleName` VARCHAR(50) NULL default null,
	`Suffix` VARCHAR(50) NULL default null,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (NameVariantId),
	UNIQUE INDEX `NameVariantId` (`NameVariantId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
