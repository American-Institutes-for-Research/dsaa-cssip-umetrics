# Clear out our PublicationProject table.
truncate table PublicationProject;


# And before you ask, NO the file path cannot be a variable.  Because the file path is interpreted by
# the MySQL client and variables are server side, you cannot use variables in the file name to clean
# up the code a bit.  Be cool if there was such a thing as a client side variable......  Anyhow, just
# use a global search and replace to fix the path for all SQL statements below.


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2000.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2001.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2002.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2003.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2004.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2005.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2006.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2007.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2008.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2009.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2010.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2011.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');


# Load PublicationProject.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PUBLNK_C_2012.csv' ignore
into table
	PublicationProject
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PMID, @CORE_PROJECT_NUM
)
set
	PMID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, '');
