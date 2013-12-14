CREATE TABLE `firstnamevariant10recent` (
	`FirstNameVariant10RecentId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (FirstNameVariant10RecentId),
	UNIQUE INDEX `FirstNameVariant10RecentId` (`FirstNameVariant10RecentId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
