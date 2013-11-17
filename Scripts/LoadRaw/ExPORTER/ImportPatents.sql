# Clear out our Patent table.
truncate table Patent;

# Load Patents.
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\\RePORTER_PATENTS_C_ALLFYS.csv' ignore
into table
	Patent
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@PATENT_ID, @PATENT_TITLE, @PROJECT_ID, @bogus1, @bogus2
)
set
	PATENT_ID = nullif(@PATENT_ID, ''),
	PATENT_TITLE = nullif(@PATENT_TITLE, ''),
	PROJECT_ID = nullif(@PROJECT_ID, '')
