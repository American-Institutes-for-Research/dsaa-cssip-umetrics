CREATE TABLE `coauthorname` (
	`CoauthorNameId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(200) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`CoauthorNameId`),
	UNIQUE INDEX `CoauthorNameId` (`CoauthorNameId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
