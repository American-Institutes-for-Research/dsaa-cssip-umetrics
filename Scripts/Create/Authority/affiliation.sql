CREATE TABLE `affiliation` (
	`AffiliationId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Name` VARCHAR(50) NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (AffiliationId),
	UNIQUE INDEX `AffiliationId` (`AffiliationId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
