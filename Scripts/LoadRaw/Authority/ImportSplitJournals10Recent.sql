# Load Program.
load data local infile
	'D:\\Raw Data\\Authority\\SplitFiles\\journals10recent.txt' ignore
into table
	journal10recent
character set latin1
fields terminated by '\t'
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
(
	@RawID,
	@Position,
	@Name,
	@Count
)
set
	RawID = cast(nullif(@RawID, '') as unsigned int),
	Position = cast(nullif(@Position, '') as unsigned int),
	Name = nullif(@Name, ''),
	Count = cast(nullif(@Count, '') as unsigned int)