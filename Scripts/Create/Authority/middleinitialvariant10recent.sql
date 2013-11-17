CREATE TABLE `middleinitialvariant10recent` (
	`MiddleInitialVariant10RecentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (MiddleInitialVariant10RecentID),
	UNIQUE INDEX `MiddleInitialVariant10RecentID` (`MiddleInitialVariant10RecentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
