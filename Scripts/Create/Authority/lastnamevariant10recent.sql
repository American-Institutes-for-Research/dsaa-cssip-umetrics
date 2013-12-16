CREATE TABLE `lastnamevariant10recent` (
	`LastNameVariant10RecentId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(100) NOT NULL,
	PRIMARY KEY (LastNameVariant10RecentId),
	UNIQUE INDEX `LastNameVariant10RecentId` (`LastNameVariant10RecentId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
