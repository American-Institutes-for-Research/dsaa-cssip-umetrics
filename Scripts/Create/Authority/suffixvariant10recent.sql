CREATE TABLE `suffixvariant10recent` (
	`SuffixVariant10RecentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (SuffixVariant10RecentID),
	UNIQUE INDEX `SuffixVariant10RecentID` (`SuffixVariant10RecentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
