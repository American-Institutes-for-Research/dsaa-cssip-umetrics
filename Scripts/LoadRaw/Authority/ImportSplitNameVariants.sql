# Load Program.
load data local infile
	'D:\\Raw Data\\Authority\\SplitFiles\\namevariants.txt' ignore
into table
	namevariant
character set latin1
fields terminated by '\t'
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
(
	@RawID,
	@Position,
	@LastName,
	@FirstName,
	@MiddleName,
	@Suffix,
	@Count
)
set
	RawID = cast(nullif(@RawID, '') as unsigned int),
	Position = cast(nullif(@Position, '') as unsigned int),
	LastName = nullif(@LastName, ''),
	FirstName = nullif(@FirstName, ''),
	MiddleName = nullif(@MiddleName, ''),
	Suffix = nullif(@Suffix, ''),
	Count = cast(nullif(@Count, '') as unsigned int)