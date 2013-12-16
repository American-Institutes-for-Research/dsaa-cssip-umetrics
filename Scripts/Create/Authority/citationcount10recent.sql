CREATE TABLE `citationcount10recent` (
	`CitationCount10RecentId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`PMID` INT(11) UNSIGNED NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`CitationCount10RecentId`),
	UNIQUE INDEX `CitationCount10RecentId` (`CitationCount10RecentId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
