# Clear out our Project table.
truncate table Project;


# And before you ask, NO the file path cannot be a variable.  Because the file path is interpreted by
# the MySQL client and variables are server side, you cannot use variables in the file name to clean
# up the code a bit.  Be cool if there was such a thing as a client side variable......  Anyhow, just
# use a global search and replace to fix the path for all SQL statements below.


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2000.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,
	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),
	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2001.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,
	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),
	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2002.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,
	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),
	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2003.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,
	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),
	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2004.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,
	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),
	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2005.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,
	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),
	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2006.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,
	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),
	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2007.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,
	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),
	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2008.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,
	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),
	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2009.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,

	@FUNDING_MECHANISM, # this doesn't exist prior to 2009

	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),

	FUNDING_MECHANISM = nullif(@FUNDING_MECHANISM, ''), # this doesn't exist prior to 2009

	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2010.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,

	@FUNDING_MECHANISM, # this doesn't exist prior to 2009

	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),

	FUNDING_MECHANISM = nullif(@FUNDING_MECHANISM, ''), # this doesn't exist prior to 2009

	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2011.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,

	@FUNDING_MECHANISM, # this doesn't exist prior to 2009

	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),

	FUNDING_MECHANISM = nullif(@FUNDING_MECHANISM, ''), # this doesn't exist prior to 2009

	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));


# NOTE: For 2009-2012, there's a new column called FUNDING_MECHANISM that comes BEFORE FY!!!
load data local infile
	'D:\\Raw Data\\ExPORTER\\extracted\RePORTER_PRJ_C_FY2012.csv' ignore
into table
	Project
character set latin1
fields terminated by ','
optionally enclosed by '"'
escaped by ''
lines terminated by '\r\n'
ignore 1 lines
(
	@APPLICATION_ID, @ACTIVITY, @ADMINISTERING_IC, @APPLICATION_TYPE, @ARRA_FUNDED, @AWARD_NOTICE_DATE, @BUDGET_START,
	@BUDGET_END, @CFDA_CODE, @CORE_PROJECT_NUM, @ED_INST_TYPE, @FOA_NUMBER, @FULL_PROJECT_NUM, @FUNDING_ICs,

	@FUNDING_MECHANISM, # this doesn't exist prior to 2009

	@FY, @IC_NAME, @NIH_SPENDING_CATS, @ORG_CITY, @ORG_COUNTRY, @ORG_DEPT, @ORG_DISTRICT, @ORG_DUNS, @ORG_FIPS, @ORG_NAME,
	@ORG_STATE, @ORG_ZIPCODE, @PHR, @PI_IDS, @PI_NAMEs, @PROGRAM_OFFICER_NAME, @PROJECT_START, @PROJECT_END,
	@PROJECT_TERMS, @PROJECT_TITLE, @SERIAL_NUMBER, @STUDY_SECTION, @STUDY_SECTION_NAME, @SUBPROJECT_ID, @SUFFIX,
	@SUPPORT_YEAR, @TOTAL_COST, @TOTAL_COST_SUB_PROJECT, @bogus
)
set
	APPLICATION_ID = cast(nullif(@APPLICATION_ID, '') as unsigned),
	ACTIVITY = nullif(@ACTIVITY, ''),
	ADMINISTERING_IC = nullif(@ADMINISTERING_IC, ''),
	APPLICATION_TYPE = nullif(@APPLICATION_TYPE, ''),
	ARRA_FUNDED = if(@ARRA_FUNDED = 'Y', 1, 0),
	AWARD_NOTICE_DATE = if(@AWARD_NOTICE_DATE like '%t%', str_to_date(left(@AWARD_NOTICE_DATE, 10), '%Y-%m-%d'), str_to_date(nullif(@AWARD_NOTICE_DATE, ''), '%m/%d/%Y')),
	BUDGET_START = str_to_date(nullif(@BUDGET_START, ''), '%m/%d/%Y'),
	BUDGET_END = str_to_date(nullif(@BUDGET_END, ''), '%m/%d/%Y'),
	CFDA_CODE = nullif(@CFDA_CODE, ''),
	CORE_PROJECT_NUM = nullif(@CORE_PROJECT_NUM, ''),
	ED_INST_TYPE = nullif(@ED_INST_TYPE, ''),
	FOA_NUMBER = nullif(@FOA_NUMBER, ''),
	FULL_PROJECT_NUM = nullif(@FULL_PROJECT_NUM, ''),
	FUNDING_ICs = nullif(@FUNDING_ICs, ''),

	FUNDING_MECHANISM = nullif(@FUNDING_MECHANISM, ''), # this doesn't exist prior to 2009

	FY = cast(nullif(@FY, '') as unsigned),
	IC_NAME = nullif(@IC_NAME, ''),
	NIH_SPENDING_CATS = nullif(@NIH_SPENDING_CATS, ''),
	ORG_CITY = nullif(@ORG_CITY, ''),
	ORG_COUNTRY = nullif(@ORG_COUNTRY, ''),
	ORG_DEPT = nullif(@ORG_DEPT, ''),
	ORG_DISTRICT = nullif(@ORG_DISTRICT, ''),
	ORG_DUNS = nullif(@ORG_DUNS, ''),
	ORG_FIPS = nullif(@ORG_FIPS, ''),
	ORG_NAME = nullif(@ORG_NAME, ''),
	ORG_STATE = nullif(@ORG_STATE, ''),
	ORG_ZIPCODE = nullif(@ORG_ZIPCODE, ''),
	PHR = nullif(@PHR, ''),
	PI_IDS = nullif(@PI_IDS, ''),
	PI_NAMEs = nullif(@PI_NAMEs, ''),
	PROGRAM_OFFICER_NAME = nullif(@PROGRAM_OFFICER_NAME, ''),
	PROJECT_START = str_to_date(nullif(@PROJECT_START, ''), '%m/%d/%Y'),
	PROJECT_END = str_to_date(nullif(@PROJECT_END, ''), '%m/%d/%Y'),
	PROJECT_TERMS = nullif(@PROJECT_TERMS, ''),
	PROJECT_TITLE = nullif(@PROJECT_TITLE, ''),
	SERIAL_NUMBER = cast(nullif(@SERIAL_NUMBER, '') as unsigned),
	STUDY_SECTION = nullif(@STUDY_SECTION, ''),
	STUDY_SECTION_NAME = nullif(@STUDY_SECTION_NAME, ''),
	SUBPROJECT_ID = cast(nullif(@SUBPROJECT_ID, '') as unsigned),
	SUFFIX = nullif(@SUFFIX, ''),
	SUPPORT_YEAR = cast(nullif(@SUPPORT_YEAR, '') as unsigned),
	TOTAL_COST = cast(nullif(@TOTAL_COST, '') as decimal(13, 2)),
	TOTAL_COST_SUB_PROJECT = cast(nullif(@TOTAL_COST_SUB_PROJECT, '') as decimal(13, 2));
