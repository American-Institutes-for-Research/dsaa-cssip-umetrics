CREATE TABLE `EXPPublicationAuthorListTemp` (
	`AuthorName` VARCHAR(100) NOT NULL,
	`PMID` INT(11) NOT NULL,
	INDEX `AuthorName_PMID` (`AuthorName`, `PMID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB;
