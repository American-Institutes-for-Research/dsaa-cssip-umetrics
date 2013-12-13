################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

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
