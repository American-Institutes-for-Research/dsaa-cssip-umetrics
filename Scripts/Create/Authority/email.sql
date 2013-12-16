CREATE TABLE `email` (
	`EmailId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(100) NOT NULL,
	PRIMARY KEY (EmailId),
	UNIQUE INDEX `EmailId` (`EmailId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
