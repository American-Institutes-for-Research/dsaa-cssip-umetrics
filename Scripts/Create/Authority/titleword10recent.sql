CREATE TABLE `titleword10recent` (
	`TitleWord10RecentId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(100) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`TitleWord10RecentId`),
	UNIQUE INDEX `TitleWord10RecentId` (`TitleWord10RecentId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
