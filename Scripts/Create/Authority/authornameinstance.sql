CREATE TABLE `authornameinstance` (
	`AuthorNameInstanceId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`PMID` INT(11) unsigned NOT NULL,
	`AuthorPosition` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (AuthorNameInstanceId),
	UNIQUE INDEX `AuthorNameInstanceId` (`AuthorNameInstanceId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
