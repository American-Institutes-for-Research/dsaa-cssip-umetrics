# Clear out our ResearchGovRaw table.
#truncate table ResearchGovRaw; # For a full refresh, run this first, then load each Research.gov file individually.

# Load the testing file.  Found the character set using SHOW CHARACTER SET sql.
load data local infile
	'D:\\Raw Data\\Research.gov\\exportAwards-2012.csv' ignore
into table
	ResearchGovRaw
character set utf8 # 2007-2010 use latin1 whereas 2011 and 2012 use utf16le... go figure.  NOTE: MySQL cannot import utf16 files... I had to convert them to utf8 first...
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\n'
ignore 1 lines
(
	@Awardee, @DoingBusinessAsName, @PDPIName, @PDPIPhone, @PDPIEmail, @CoPDsCoPIs, @AwardDate, @EstimatedTotalAwardAmount, @FundsObligatedToDate,
	@AwardStartDate, @AwardExpirationDate, @TransactionType, @Agency, @AwardingAgencyCode, @FundingAgencyCode, @CFDANumber, @PrimaryProgramSource,
	@AwardTitleOrDescription, @FederalAwardIDNumber, @DUNSID, @ParentDUNSID, @Program, @ProgramOfficerName, @ProgramOfficerPhone, @ProgramOfficerEmail,
	@AwardeeStreet, @AwardeeCity, @AwardeeState, @AwardeeZIP, @AwardeeCounty, @AwardeeCountry, @AwardeeCongressionalDistrict, @PrimaryOrganizationName,
	@PrimaryStreet, @PrimaryCity, @PrimaryState, @PrimaryZIP, @PrimaryCounty, @PrimaryCountry, @PrimaryCongressionalDistrict, @AbstractAtTimeOfAward,
	@PublicationsProducedAsAResultsOfThisResearch, @PublicationsProducedAsConferenceProceedings, @ProjectOutcomesReport, @bogus
)
set
	Awardee = nullif(@Awardee, ''),
	DoingBusinessAsName = nullif(@DoingBusinessAsName, ''),
	PDPIName = nullif(@PDPIName, ''),
	PDPIPhone = nullif(@PDPIPhone, ''),
	PDPIEmail = nullif(@PDPIEmail, ''),
	CoPDsCoPIs = nullif(@CoPDsCoPIs, ''),
	AwardDate = str_to_date(replace(replace(nullif(@AwardDate, ''), '=', ''), '"', ''), '%m/%d/%Y'),
	EstimatedTotalAwardAmount = cast(replace(replace(replace(replace(nullif(@EstimatedTotalAwardAmount, ''), '=', ''), '"', ''), '$', ''), ',', '') as decimal(13, 2)),
	FundsObligatedToDate = cast(replace(replace(replace(replace(nullif(@FundsObligatedToDate, ''), '=', ''), '"', ''), '$', ''), ',', '') as decimal(13, 2)),
	AwardStartDate = str_to_date(replace(replace(nullif(@AwardStartDate, ''), '=', ''), '"', ''), '%m/%d/%Y'),
	AwardExpirationDate = str_to_date(replace(replace(nullif(@AwardExpirationDate, ''), '=', ''), '"', ''), '%m/%d/%Y'),
	TransactionType = nullif(@TransactionType, ''),
	Agency = nullif(@Agency, ''),
	AwardingAgencyCode = replace(replace(nullif(@AwardingAgencyCode, ''), '=', ''), '"', ''),
	FundingAgencyCode = replace(replace(nullif(@FundingAgencyCode, ''), '=', ''), '"', ''),
	CFDANumber = replace(replace(nullif(@CFDANumber, ''), '=', ''), '"', ''),
	PrimaryProgramSource = nullif(@PrimaryProgramSource, ''),
	AwardTitleOrDescription = nullif(@AwardTitleOrDescription, ''),
	FederalAwardIDNumber = replace(replace(nullif(@FederalAwardIDNumber, ''), '=', ''), '"', ''),
	DUNSID = replace(replace(nullif(@DUNSID, ''), '=', ''), '"', ''),
	ParentDUNSID = replace(replace(nullif(@ParentDUNSID, ''), '=', ''), '"', ''),
	Program = nullif(@Program, ''),
	ProgramOfficerName = nullif(@ProgramOfficerName, ''),
	ProgramOfficerPhone = nullif(@ProgramOfficerPhone, ''),
	ProgramOfficerEmail = nullif(@ProgramOfficerEmail, ''),
	AwardeeStreet = nullif(@AwardeeStreet, ''),
	AwardeeCity = nullif(@AwardeeCity, ''),
	AwardeeState = nullif(@AwardeeState, ''),
	AwardeeZIP = nullif(@AwardeeZIP, ''),
	AwardeeCounty = nullif(@AwardeeCounty, ''),
	AwardeeCountry = nullif(@AwardeeCountry, ''),
	AwardeeCongressionalDistrict = replace(replace(nullif(@AwardeeCongressionalDistrict, ''), '=', ''), '"', ''),
	PrimaryOrganizationName = nullif(@PrimaryOrganizationName, ''),
	PrimaryStreet = nullif(@PrimaryStreet, ''),
	PrimaryCity = nullif(@PrimaryCity, ''),
	PrimaryState = nullif(@PrimaryState, ''),
	PrimaryZIP = nullif(@PrimaryZIP, ''),
	PrimaryCounty = nullif(@PrimaryCounty, ''),
	PrimaryCountry = nullif(@PrimaryCountry, ''),
	PrimaryCongressionalDistrict = replace(replace(nullif(@PrimaryCongressionalDistrict, ''), '=', ''), '"', ''),
	AbstractAtTimeOfAward = nullif(@AbstractAtTimeOfAward, ''),
	PublicationsProducedAsAResultsOfThisResearch = nullif(@PublicationsProducedAsAResultsOfThisResearch, ''),
	PublicationsProducedAsConferenceProceedings = nullif(@PublicationsProducedAsConferenceProceedings, ''),
	ProjectOutcomesReport = nullif(@ProjectOutcomesReport, '')
