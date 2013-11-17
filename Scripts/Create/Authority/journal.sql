CREATE TABLE `journal` (
	`JournalID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(100) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`JournalID`),
	UNIQUE INDEX `JournalID` (`JournalID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
