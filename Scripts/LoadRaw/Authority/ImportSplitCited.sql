# Load Program.
load data local infile
	'D:\\Raw Data\\Authority\\SplitFiles\\cited.txt' ignore
into table
	cited
character set latin1
fields terminated by '\t'
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
(
	@RawID,
	@Position,
	@PMID,
	@Count
)
set
	RawID = cast(nullif(@RawID, '') as unsigned int),
	Position = cast(nullif(@Position, '') as unsigned int),
	PMID = cast(nullif(@PMID, '') as unsigned int),
	Count = cast(nullif(@Count, '') as unsigned int)