CREATE TABLE IF NOT EXISTS raw (
	`RawID` INT(11) NOT NULL AUTO_INCREMENT,
	`SourceFile` varchar(50) null default null,
	`Blocks` TEXT NULL,
	`Probabilities` TEXT NULL,
	`Cluster` VARCHAR(50) NULL DEFAULT NULL,
	`AuthorID` VARCHAR(100) NULL DEFAULT NULL,
	`ClusterSize` INT(10) UNSIGNED NULL DEFAULT NULL,
	`NameVariants` TEXT NULL,
	`LastNameVariants` TEXT NULL,
	`FirstNameVariants` TEXT NULL,
	`MiddleInitialVariants` TEXT NULL,
	`SuffixVariants` TEXT NULL,
	`Emails` TEXT NULL,
	`YearRange` VARCHAR(50) NULL DEFAULT NULL,
	`Affiliations` TEXT NULL,
	`MeSHTerms` TEXT NULL,
	`Journals` TEXT NULL,
	`TitleWords` TEXT NULL,
	`CoauthorNames` TEXT NULL,
	`CoauthorIDs` MEDIUMTEXT NULL,
	`AuthorNameInstances` TEXT NULL,
	`GrantIDs` TEXT NULL,
	`TotalTimesCited` INT(10) UNSIGNED NULL DEFAULT NULL,
	`HIndex` FLOAT UNSIGNED NULL DEFAULT NULL,
	`CitationCounts` TEXT NULL,
	`Cited` TEXT NULL,
	`CitedBy` TEXT NULL,
	`AuthorID_10Recent` VARCHAR(50) NULL DEFAULT NULL,
	`ClusterSize_10Recent` INT(10) UNSIGNED NULL DEFAULT NULL,
	`NameVariants_10Recent` TEXT NULL,
	`LastNameVariants_10Recent` TEXT NULL,
	`FirstNameVariants_10Recent` TEXT NULL,
	`MiddleInitialVariants_10Recent` TEXT NULL,
	`SuffixVariants_10Recent` TEXT NULL,
	`Emails_10Recent` TEXT NULL,
	`RecentRange_10Recent` VARCHAR(50) NULL DEFAULT NULL,
	`Affiliations_10Recent` TEXT NULL,
	`MeSHTerms_10Recent` TEXT NULL,
	`Journals_10Recent` TEXT NULL,
	`TitleWords_10Recent` TEXT NULL,
	`CoauthorNames_10Recent` TEXT NULL,
	`CoauthorIDs_10Recent` TEXT NULL,
	`AuthorNameInstances_10Recent` TEXT NULL,
	`GrantIDs_10Recent` TEXT NULL,
	`TotalTimesCited_10Recent` INT(10) UNSIGNED NULL DEFAULT NULL,
	`HIndex_10Recent` FLOAT UNSIGNED NULL DEFAULT NULL,
	`CitationCounts_10Recent` TEXT NULL,
	`Cited_10Recent` TEXT NULL,
	`CitedBy_10Recent` TEXT NULL,
	PRIMARY KEY (`RawID`),
	UNIQUE INDEX `RawID` (`RawID`),
	INDEX 'AuthorID' ('AuthorID')
	) ENGINE=MYISAM DEFAULT CHARSET=utf8 COMMENT='Raw data from Authority files from Torvik';
	