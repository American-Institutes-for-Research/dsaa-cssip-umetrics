# Clear out our Abstract table.
truncate table Abstract;


# And before you ask, NO the file path cannot be a variable.  Because the file path is interpreted by
# the MySQL client and variables are server side, you cannot use variables in the file name to clean
# up the code a bit.  Be cool if there was such a thing as a client side variable......  Anyhow, just
# use a global search and replace to fix the path for all SQL statements below.


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2000.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2001.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2002.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2003.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2004.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2005.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2006.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2007.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2008.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2009.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2010.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2011.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');


# Load Abstracts.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJABS_C_FY2012.csv' ignore
into table
	Abstract
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ABSTRACT_TEXT
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ABSTRACT_TEXT = nullif(@ABSTRACT_TEXT, '');
