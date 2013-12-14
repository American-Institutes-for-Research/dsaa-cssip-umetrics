CREATE TABLE `suffixvariant` (
	`SuffixVariantId` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`RawId` INT(11) UNSIGNED NOT NULL,
	`Position` INT(11) unsigned not null,
	`Name` VARCHAR(50) NOT NULL,
	PRIMARY KEY (SuffixVariantId),
	UNIQUE INDEX `SuffixVariantId` (`SuffixVariantId`),
	INDEX `RawId` (`RawId`)
)
ENGINE=InnoDB;
