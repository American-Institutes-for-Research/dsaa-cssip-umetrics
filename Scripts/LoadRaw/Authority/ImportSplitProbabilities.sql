# Load Program.
load data local infile
	'D:\\Raw Data\\Authority\\SplitFiles\\probabilities.txt' ignore
into table
	probability
character set latin1
fields terminated by '\t'
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
(
	@RawID,
	@Position,
	@Probability
)
set
	RawID = cast(nullif(@RawID, '') as unsigned int),
	Position = cast(nullif(@Position, '') as unsigned int),
	Probability = cast(nullif(@Probability, '') as decimal(8,6))