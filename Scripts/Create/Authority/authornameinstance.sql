CREATE TABLE `authornameinstance` (
	`AuthorNameInstanceID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`PMID` INT(11) unsigned NOT NULL,
	`AuthorPosition` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (AuthorNameInstanceID),
	UNIQUE INDEX `AuthorNameInstanceID` (`AuthorNameInstanceID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
