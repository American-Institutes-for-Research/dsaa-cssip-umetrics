CREATE TABLE `email10recent` (
	`Email10RecentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(100) NOT NULL,
	PRIMARY KEY (Email10RecentID),
	UNIQUE INDEX `Email10RecentID` (`Email10RecentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
