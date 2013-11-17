# Clear out our Publication table.
truncate table Publication;


# And before you ask, NO the file path cannot be a variable.  Because the file path is interpreted by
# the MySQL client and variables are server side, you cannot use variables in the file name to clean
# up the code a bit.  Be cool if there was such a thing as a client side variable......  Anyhow, just
# use a global search and replace to fix the path for all SQL statements below.


# Load Publications for 2000-2004.  File format is different for 2005 and newer.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2000.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2000-2004.  File format is different for 2005 and newer.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2001.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2000-2004.  File format is different for 2005 and newer.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2002.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2000-2004.  File format is different for 2005 and newer.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2003.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2000-2004.  File format is different for 2005 and newer.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2004.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2005-2012.  File format is different prior to 2005.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2005.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PMID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2005-2012.  File format is different prior to 2005.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2006.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PMID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2005-2012.  File format is different prior to 2005.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2007.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PMID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2005-2012.  File format is different prior to 2005.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2008.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PMID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2005-2012.  File format is different prior to 2005.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2009.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PMID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2005-2012.  File format is different prior to 2005.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2010.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PMID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2005-2012.  File format is different prior to 2005.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2011.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PMID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);


# Load Publications for 2005-2012.  File format is different prior to 2005.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUB_C_2012.csv' ignore
into table
	Publication
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@AFFILIATION, @AUTHOR_LIST, @COUNTRY, @ISSN, @JOURNAL_ISSUE, @JOURNAL_TITLE, @JOURNAL_TITLE_ABBR,
	@JOURNAL_VOLUME, @LANG, @PAGE_NUMBER, @PMC_ID, @PMID, @PUB_DATE, @PUB_TITLE, @PUB_YEAR
)
set
	AFFILIATION = nullif(@AFFILIATION, ''),
	AUTHOR_LIST = nullif(@AUTHOR_LIST, ''),
	COUNTRY = nullif(@COUNTRY, ''),
	ISSN = nullif(@ISSN, ''),
	JOURNAL_ISSUE = nullif(@JOURNAL_ISSUE, ''),
	JOURNAL_TITLE = nullif(@JOURNAL_TITLE, ''),
	JOURNAL_TITLE_ABBR = nullif(@JOURNAL_TITLE_ABBR, ''),
	JOURNAL_VOLUME = nullif(@JOURNAL_VOLUME, ''),
	LANG = nullif(@LANG, ''),
	PAGE_NUMBER = nullif(@PAGE_NUMBER, ''),
	PMC_ID = cast(nullif(@PMC_ID, '') as unsigned),
	PMID = cast(nullif(@PMID, '') as unsigned),
	PUB_DATE = nullif(@PUB_DATE, ''),
	PUB_TITLE = nullif(@PUB_TITLE, ''),
	PUB_YEAR = cast(nullif(@PUB_YEAR, '') as unsigned);
