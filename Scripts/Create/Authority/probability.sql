CREATE TABLE `probability` (
	`ProbabilityId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Probability` float unsigned NOT NULL,
	PRIMARY KEY (`ProbabilityId`),
	UNIQUE INDEX `ProbabilityId` (`ProbabilityId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
