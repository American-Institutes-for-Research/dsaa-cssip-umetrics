CREATE TABLE `coauthorid` (
	`CoauthorIdId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(100) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`CoauthorIdId`),
	UNIQUE INDEX `CoauthorIdId` (`CoauthorIdId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
