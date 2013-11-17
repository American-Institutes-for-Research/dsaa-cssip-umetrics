CREATE TABLE `affiliation10recent` (
	`Affiliation10RecentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(50) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`Affiliation10RecentID`),
	UNIQUE INDEX `Affiliation10RecentID` (`Affiliation10RecentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
