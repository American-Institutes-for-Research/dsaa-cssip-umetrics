# Load Program.
load data local infile
	'D:\\Raw Data\\Authority\\SplitFiles\\authornameinstances.txt' ignore
into table
	authornameinstance
character set latin1
fields terminated by '\t'
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
(
	@RawID,
	@Position,
	@PMID,
	@AuthorPosition
)
set
	RawID = cast(nullif(@RawID, '') as unsigned int),
	Position = cast(nullif(@Position, '') as unsigned int),
	PMID = cast(nullif(@PMID, '') as unsigned int),
	AuthorPosition = cast(nullif(@AuthorPosition, '') as unsigned int)