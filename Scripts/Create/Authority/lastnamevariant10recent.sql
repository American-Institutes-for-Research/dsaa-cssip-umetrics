CREATE TABLE `lastnamevariant10recent` (
	`LastNameVariant10recentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(100) NOT NULL,
	PRIMARY KEY (LastNameVariant10recentID),
	UNIQUE INDEX `LastNameVariant10recentID` (`LastNameVariant10recentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
