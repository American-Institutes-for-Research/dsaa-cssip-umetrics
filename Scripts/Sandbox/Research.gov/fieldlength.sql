################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

#select count(*) from ResearchGovRaw -- 87,531
select max(char_length(Awardee)) from ResearchGovRaw; -- 255
select max(char_length(DoingBusinessAsName)) from ResearchGovRaw; -- 255
select max(char_length(PDPIName)) from ResearchGovRaw; -- 40
select max(char_length(PDPIPhone)) from ResearchGovRaw; -- 14
select max(char_length(PDPIEmail)) from ResearchGovRaw; -- 42
select max(char_length(CoPDsCoPIs)) from ResearchGovRaw; -- 124
select max(char_length(AwardDate)) from ResearchGovRaw; -- 13
select max(char_length(EstimatedTotalAwardAmount)) from ResearchGovRaw; -- 15
select max(char_length(FundsObligatedToDate)) from ResearchGovRaw; -- 15
select max(char_length(AwardStartDate)) from ResearchGovRaw; -- 13
select max(char_length(AwardExpirationDate)) from ResearchGovRaw; -- 13
select max(char_length(TransactionType)) from ResearchGovRaw; -- 22
select max(char_length(Agency)) from ResearchGovRaw; -- 4
select max(char_length(AwardingAgencyCode)) from ResearchGovRaw; -- 7
select max(char_length(FundingAgencyCode)) from ResearchGovRaw; -- 7
select max(char_length(CFDANumber)) from ResearchGovRaw; -- 9
select max(char_length(PrimaryProgramSource)) from ResearchGovRaw; -- 37
select max(char_length(AwardTitleOrDescription)) from ResearchGovRaw; -- 255
select max(char_length(FederalAwardIDNumber)) from ResearchGovRaw; -- 17
select max(char_length(DUNSID)) from ResearchGovRaw; -- 16
select max(char_length(ParentDUNSID)) from ResearchGovRaw; -- 12
select max(char_length(Program)) from ResearchGovRaw; -- 30
select max(char_length(ProgramOfficerName)) from ResearchGovRaw; -- 31
select max(char_length(ProgramOfficerPhone)) from ResearchGovRaw; -- 14
select max(char_length(ProgramOfficerEmail)) from ResearchGovRaw; -- 16
select max(char_length(AwardeeStreet)) from ResearchGovRaw; -- 32
select max(char_length(AwardeeCity)) from ResearchGovRaw; -- 26
select max(char_length(AwardeeState)) from ResearchGovRaw; -- 2
select max(char_length(AwardeeZIP)) from ResearchGovRaw; -- 10
select max(char_length(AwardeeCounty)) from ResearchGovRaw; -- 22
select max(char_length(AwardeeCountry)) from ResearchGovRaw; -- 4
select max(char_length(AwardeeCongressionalDistrict)) from ResearchGovRaw; -- 5
select max(char_length(PrimaryOrganizationName)) from ResearchGovRaw; -- 64
select max(char_length(PrimaryStreet)) from ResearchGovRaw; -- 73
select max(char_length(PrimaryCity)) from ResearchGovRaw; -- 26
select max(char_length(PrimaryState)) from ResearchGovRaw; -- 2
select max(char_length(PrimaryZIP)) from ResearchGovRaw; -- 10
select max(char_length(PrimaryCounty)) from ResearchGovRaw; -- 22
select max(char_length(PrimaryCountry)) from ResearchGovRaw; -- 4
select max(char_length(PrimaryCongressionalDistrict)) from ResearchGovRaw; -- 5
select max(char_length(AbstractAtTimeOfAward)) from ResearchGovRaw; -- 7999
select max(char_length(PublicationsProducedAsAResultsOfThisResearch)) from ResearchGovRaw; -- 32557
select max(char_length(PublicationsProducedAsConferenceProceedings)) from ResearchGovRaw; -- 32557
select max(char_length(ProjectOutcomesReport)) from ResearchGovRaw; -- 20079
