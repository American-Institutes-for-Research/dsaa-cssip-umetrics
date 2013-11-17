CREATE TABLE `firstnamevariant10recent` (
	`FirstNameVariant10RecentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (FirstNameVariant10RecentID),
	UNIQUE INDEX `FirstNameVariant10RecentID` (`FirstNameVariant10RecentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
