################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

# Clear out our program table.
#truncate table program;

# Load Program. You'll need to run this for each file.
load data local infile
	'XXXfullfilenameXXX' ignore
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
	UMSourceFile = 'XXXfilenameXXX'