CREATE TABLE `suffixvariant` (
	`SuffixVariantID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (SuffixVariantID),
	UNIQUE INDEX `SuffixVariantID` (`SuffixVariantID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
