CREATE TABLE `middleinitialvariant10recent` (
	`MiddleInitialVariant10RecentId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (MiddleInitialVariant10RecentId),
	UNIQUE INDEX `MiddleInitialVariant10RecentId` (`MiddleInitialVariant10RecentId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
