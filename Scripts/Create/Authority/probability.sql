CREATE TABLE `probability` (
	`ProbabilityID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`Probability` float unsigned NOT NULL,
	PRIMARY KEY (`ProbabilityID`),
	UNIQUE INDEX `ProbabilityID` (`ProbabilityID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
