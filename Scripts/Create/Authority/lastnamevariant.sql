CREATE TABLE `lastnamevariant` (
	`LastNameVariantID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(100) NOT NULL,
	PRIMARY KEY (LastNameVariantID),
	UNIQUE INDEX `LastNameVariantID` (`LastNameVariantID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
