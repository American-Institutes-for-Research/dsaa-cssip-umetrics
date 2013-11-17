CREATE TABLE `affiliation` (
	`AffiliationID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(50) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (AffiliationID),
	UNIQUE INDEX `AffiliationID` (`AffiliationID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
