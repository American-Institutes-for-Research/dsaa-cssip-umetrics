CREATE TABLE `coauthorname10recent` (
	`CoauthorName10RecentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(200) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`CoauthorName10RecentID`),
	UNIQUE INDEX `CoauthorName10RecentID` (`CoauthorName10RecentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
