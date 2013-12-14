CREATE TABLE `email10recent` (
	`Email10RecentId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(100) NOT NULL,
	PRIMARY KEY (Email10RecentId),
	UNIQUE INDEX `Email10RecentId` (`Email10RecentId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
