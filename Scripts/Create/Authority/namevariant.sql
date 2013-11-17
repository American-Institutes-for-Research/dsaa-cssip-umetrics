CREATE TABLE `namevariant` (
	`NameVariantID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`LastName` VARCHAR(100) NOT NULL,
	`FirstName` VARCHAR(50) NOT NULL,
	`MiddleName` VARCHAR(50) NULL default null,
	`Suffix` VARCHAR(50) NULL default null,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (NameVariantID),
	UNIQUE INDEX `NameVariantID` (`NameVariantID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
