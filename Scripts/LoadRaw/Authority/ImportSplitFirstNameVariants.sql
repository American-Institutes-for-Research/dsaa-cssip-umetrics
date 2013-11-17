# Load Program.
load data local infile
	'D:\\Raw Data\\Authority\\SplitFiles\\firstnamevariants.txt' ignore
into table
	firstnamevariant
character set latin1
fields terminated by '\t'
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
(
	@RawID,
	@Position,
	@Name
)
set
	RawID = cast(nullif(@RawID, '') as unsigned int),
	Position = cast(nullif(@Position, '') as unsigned int),
	Name = nullif(@Name, '')