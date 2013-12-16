CREATE TABLE `affiliation10recent` (
	`Affiliation10RecentId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(50) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`Affiliation10RecentId`),
	UNIQUE INDEX `Affiliation10RecentId` (`Affiliation10RecentId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
