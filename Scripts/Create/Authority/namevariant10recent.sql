CREATE TABLE `namevariant10recent` (
	`NameVariant10RecentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`LastName` VARCHAR(100) NOT NULL,
	`FirstName` VARCHAR(50) NOT NULL,
	`MiddleName` VARCHAR(50) NULL default null,
	`Suffix` VARCHAR(50) NULL default null,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (NameVariant10RecentID),
	UNIQUE INDEX `NameVariant10RecentID` (`NameVariant10RecentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
