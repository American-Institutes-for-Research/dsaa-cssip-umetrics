################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

select max(char_length(GrantNumber)) from Project
select concat('select max(char_length(', COLUMN_NAME, ')) from Project;') from information_schema.columns where TABLE_NAME = 'Project' order by ORDINAL_POSITION


select max(char_length(APPLICATION_ID)) from Project; -- 7 (int)
select max(char_length(ACTIVITY)) from Project; -- 3
select max(char_length(ADMINISTERING_IC)) from Project; -- 2
select max(char_length(APPLICATION_TYPE)) from Project; -- 1
select max(char_length(ARRA_FUNDED)) from Project; -- 1
select max(char_length(AWARD_NOTICE_DATE)) from Project; -- 19 (12/15/2008 or 2009-12-03T00:00:00)
select max(char_length(BUDGET_START)) from Project; -- 10 (09/01/2007)
select max(char_length(BUDGET_END)) from Project; -- 10 (09/01/2007)
select max(char_length(CFDA_CODE)) from Project; -- 3
select max(char_length(CORE_PROJECT_NUM)) from Project; -- 27
select max(char_length(ED_INST_TYPE)) from Project; -- 30
select max(char_length(FOA_NUMBER)) from Project; -- 14
select max(char_length(FULL_PROJECT_NUM)) from Project; -- 27
select max(char_length(FUNDING_ICs)) from Project; -- 290
select max(char_length(FUNDING_MECHANISM)) from Project; -- 23
select max(char_length(FY)) from Project; -- 4 (2007)
select max(char_length(IC_NAME)) from Project; -- 77
select max(char_length(NIH_SPENDING_CATS)) from Project; -- 827
select max(char_length(ORG_CITY)) from Project; -- 23
select max(char_length(ORG_COUNTRY)) from Project; -- 14
select max(char_length(ORG_DEPT)) from Project; -- 29
select max(char_length(ORG_DISTRICT)) from Project; -- 2
select max(char_length(ORG_DUNS)) from Project; -- 9
select max(char_length(ORG_FIPS)) from Project; -- 2
select max(char_length(ORG_NAME)) from Project; -- 76
select max(char_length(ORG_STATE)) from Project; -- 2
select max(char_length(ORG_ZIPCODE)) from Project; -- 9
select max(char_length(PHR)) from Project; -- 30160
select max(char_length(PI_IDS)) from Project; -- 234
select max(char_length(PI_NAMEs)) from Project; -- 497
select max(char_length(PROGRAM_OFFICER_NAME)) from Project; -- 39
select max(char_length(PROJECT_START)) from Project; -- 10 (09/01/2007)
select max(char_length(PROJECT_END)) from Project; -- 10 (09/01/2007)
select max(char_length(PROJECT_TERMS)) from Project; -- 32767
select max(char_length(PROJECT_TITLE)) from Project; -- 103
select max(char_length(SERIAL_NUMBER)) from Project; -- 6 (int)
select max(char_length(STUDY_SECTION)) from Project; -- 4
select max(char_length(STUDY_SECTION_NAME)) from Project; -- 89
select max(char_length(SUBPROJECT_ID)) from Project; -- 4 (int)
select max(char_length(SUFFIX)) from Project; -- 4
select max(char_length(SUPPORT_YEAR)) from Project; -- 2 (int)
select max(char_length(TOTAL_COST)) from Project; -- 9 (currency)
select max(char_length(TOTAL_COST_SUB_PROJECT)) from Project; -- 8 (currency)

select max(char_length(AFFILIATION)) from Publication; -- 2314
select max(char_length(AUTHOR_LIST)) from Publication; -- 3772
select max(char_length(COUNTRY)) from Publication; -- 25
select max(char_length(ISSN)) from Publication; -- 9
select max(char_length(JOURNAL_ISSUE)) from Publication; -- 26
select max(char_length(JOURNAL_TITLE)) from Publication; -- 282
select max(char_length(JOURNAL_TITLE_ABBR)) from Publication; -- 99
select max(char_length(JOURNAL_VOLUME)) from Publication; -- 24
select max(char_length(LANG)) from Publication; -- 3
select max(char_length(PAGE_NUMBER)) from Publication; -- 137
select max(char_length(PUB_DATE)) from Publication; -- 25
select max(char_length(PUB_TITLE)) from Publication; -- 838

select distinct PUB_DATE from Publication limit 100
