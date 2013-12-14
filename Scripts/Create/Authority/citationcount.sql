CREATE TABLE `citationcount` (
	`CitationCountId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`PMID` INT(11) UNSIGNED NOT NULL,
	`Count` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`CitationCountId`),
	UNIQUE INDEX `CitationCountId` (`CitationCountId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
