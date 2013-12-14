CREATE TABLE `coauthorid10recent` (
	`CoauthorId10RecentId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(100) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`CoauthorId10RecentId`),
	UNIQUE INDEX `CoauthorId10RecentId` (`CoauthorId10RecentId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
