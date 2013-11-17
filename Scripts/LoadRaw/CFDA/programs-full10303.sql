# Clear out our program table.
#truncate table program;

# Load Program. You'll need to run this for each file.
load data local infile
	'z:\\Raw Data\\CFDA\\programs-full10303.csv' ignore
into table
	program
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\n'
ignore 1 lines
(
	@ProgramTitle,
	@ProgramNumber,
	@PopularName,
	@FederalAgency,
	@Authorization,
	@Objectives,
	@TypesOfAssistance,
	@UsesAndUseRestrictions,
	@ApplicantEligibility,
	@BeneficiaryEligibility,
	@CredentialsDocumentation,
	@PreapplicationCoordination,
	@ApplicationProcedures,
	@AwardProcedure,
	@Deadlines,
	@RangeOfApprovalDisapprovalTime,
	@Appeals,
	@Renewals,
	@FormulaAndMatchingRequirements,
	@LengthAndTimePhasingOfAssistance,
	@Reports,
	@Audits,
	@Records,
	@AccountIdentification,
	@Obligations,
	@RangeAndAverageOfFinancialAssistance,
	@ProgramAccomplishments,
	@RegulationsGuidelinesAndLiterature,
	@RegionalOrLocalOffice,
	@HeadquartersOffice,
	@WebsiteAddress,
	@RelatedPrograms,
	@ExamplesOfFundedProjects,
	@CriteriaForSelectingProposals,
	@PublishedDate,
	@ParentShortname,
	@URL,
	@Recovery
)
set
	ProgramTitle = nullif(@ProgramTitle, ''),
	ProgramNumber = nullif(@ProgramNumber, ''),
	PopularName = nullif(@PopularName, ''),
	FederalAgency = nullif(@FederalAgency, ''),
	Authorization = nullif(@Authorization, ''),
	Objectives = nullif(@Objectives, ''),
	TypesOfAssistance = nullif(@TypesOfAssistance, ''),
	UsesAndUseRestrictions = nullif(@UsesAndUseRestrictions, ''),
	ApplicantEligibility = nullif(@ApplicantEligibility, ''),
	BeneficiaryEligibility = nullif(@BeneficiaryEligibility, ''),
	CredentialsDocumentation = nullif(@CredentialsDocumentation, ''),
	PreapplicationCoordination = nullif(@PreapplicationCoordination, ''),
	ApplicationProcedures = nullif(@ApplicationProcedures, ''),
	AwardProcedure = nullif(@AwardProcedure, ''),
	Deadlines = nullif(@Deadlines, ''),
	RangeOfApprovalDisapprovalTime = nullif(@RangeOfApprovalDisapprovalTime, ''),
	Appeals = nullif(@Appeals, ''),
	Renewals = nullif(@Renewals, ''),
	FormulaAndMatchingRequirements = nullif(@FormulaAndMatchingRequirements, ''),
	LengthAndTimePhasingOfAssistance = nullif(@LengthAndTimePhasingOfAssistance, ''),
	Reports = nullif(@Reports, ''),
	Audits = nullif(@Audits, ''),
	Records = nullif(@Records, ''),
	AccountIdentification = nullif(@AccountIdentification, ''),
	Obligations = nullif(@Obligations, ''),
	RangeAndAverageOfFinancialAssistance = nullif(@RangeAndAverageOfFinancialAssistance, ''),
	ProgramAccomplishments = nullif(@ProgramAccomplishments, ''),
	RegulationsGuidelinesAndLiterature = nullif(@RegulationsGuidelinesAndLiterature, ''),
	RegionalOrLocalOffice = nullif(@RegionalOrLocalOffice, ''),
	HeadquartersOffice = nullif(@HeadquartersOffice, ''),
	WebsiteAddress = nullif(@WebsiteAddress, ''),
	RelatedPrograms = nullif(@RelatedPrograms, ''),
	ExamplesOfFundedProjects = nullif(@ExamplesOfFundedProjects, ''),
	CriteriaForSelectingProposals = nullif(@CriteriaForSelectingProposals, ''),
	PublishedDate = str_to_date(nullif(@PublishedDate, ''), '%M, %d %Y'),
	ParentShortname = nullif(@ParentShortname, ''),
	URL = nullif(@URL, ''),
	Recovery = nullif(@Recovery, ''),
	UMSourceFile = 'programs-full10303'
