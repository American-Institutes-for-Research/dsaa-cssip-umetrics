CREATE TABLE `authornameinstance10recent` (
	`AuthorNameInstance10RecentID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawID` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`PMID` INT(11) unsigned NOT NULL,
	`AuthorPosition` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (AuthorNameInstance10RecentID),
	UNIQUE INDEX `AuthorNameInstance10RecentID` (`AuthorNameInstance10RecentID`),
	INDEX `RawID` (`RawID`)
)
ENGINE=InnoDB;
