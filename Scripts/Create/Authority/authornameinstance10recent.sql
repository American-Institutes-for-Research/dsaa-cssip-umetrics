CREATE TABLE `authornameinstance10recent` (
	`AuthorNameInstance10RecentId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) UNSIGNED NOT NULL,
	`PMID` INT(11) unsigned NOT NULL,
	`AuthorPosition` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (AuthorNameInstance10RecentId),
	UNIQUE INDEX `AuthorNameInstance10RecentId` (`AuthorNameInstance10RecentId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
