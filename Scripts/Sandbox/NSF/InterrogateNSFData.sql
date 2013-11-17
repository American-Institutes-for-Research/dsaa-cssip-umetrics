select max(char_length(awardtitle)), min(char_length(awardtitle)) from award -- 180, 5

select max(char_length(AwardEffectiveDate)), min(char_length(AwardEffectiveDate)) from award -- 10, 10
select AwardEffectiveDate from award limit 10 -- 04/01/2007

select max(char_length(AwardExpirationDate)), min(char_length(AwardExpirationDate)) from award -- 10, 10
select AwardExpirationDate from award limit 10 -- 04/01/2007

select max(char_length(AwardAmount)), min(char_length(AwardAmount)) from award -- 9, 1
select AwardAmount from award limit 10 -- 128678

select max(char_length(AwardInstrument)), min(char_length(AwardInstrument)) from award -- 30, 8
select AwardInstrument from award limit 10 -- Standard Grant

select max(char_length(OrganizationCode)), min(char_length(OrganizationCode)) from award -- 8, 8
select OrganizationCode from award limit 10 -- 07030004
select OrganizationCode from award where OrganizationCode not regexp '^[0-9]*$' limit 10 -- all valid numbers

select max(char_length(Directorate)), min(char_length(Directorate)) from award -- 60, 22
select Directorate from award limit 10 -- Directorate for Mathematical & Physical Sciences

select max(char_length(Division)), min(char_length(Division)) from award -- 74, 6
select Division from award limit 10 -- Division of Civil, Mechanical, and Manufacturing Innovation

select max(char_length(ProgramOfficer)), min(char_length(ProgramOfficer)) from award -- 31, 6
select ProgramOfficer from award limit 10 -- George A. Hazelrigg

select max(char_length(AbstractNarration)), min(char_length(AbstractNarration)) from award -- 7997, 3

select max(char_length(MinAmdLetterDate)), min(char_length(MinAmdLetterDate)) from award -- 10, 10
select MinAmdLetterDate from award limit 10 -- 03/07/2007

select max(char_length(MaxAmdLetterDate)), min(char_length(MaxAmdLetterDate)) from award -- 10, 10
select MaxAmdLetterDate from award limit 10 -- 03/07/2007

select max(char_length(ARRAAmount)), min(char_length(ARRAAmount)) from award -- 9, 4
select ARRAAmount from award where ARRAAmount is not null limit 10 -- 4346611
select ARRAAmount from award where ARRAAmount not regexp '^[0-9]*$' limit 10 -- all valid numbers

select max(char_length(AwardID)), min(char_length(AwardID)) from award -- 7, 7
select AwardID from award limit 10 -- 0700021







select max(char_length(Code)), min(char_length(Code)) from foainformation -- 7, 7
select Code from foainformation limit 10 -- 0700021
select Code from foainformation where Code not regexp '^[0-9]*$' limit 10 -- all valid numbers

select max(char_length(Name)), min(char_length(Name)) from foainformation -- 34, 4
select Name from foainformation limit 10 -- Industrial Technology






select max(char_length(Name)), min(char_length(Name)) from institution -- 64, 4
select Name from institution limit 10 -- Duke University

select max(char_length(CityName)), min(char_length(CityName)) from institution -- 25, 2
select CityName from institution limit 10 -- Durham

select max(char_length(ZipCode)), min(char_length(ZipCode)) from institution -- 9, 4
select ZipCode from institution limit 10 -- 277054010

select max(char_length(PhoneNumber)), min(char_length(PhoneNumber)) from institution -- 10, 8
select PhoneNumber from institution limit 10 -- 9196843030

select max(char_length(StreetAddress)), min(char_length(StreetAddress)) from institution -- 34, 4
select StreetAddress from institution limit 10 -- 2200 W. Main St, Suite 710

select max(char_length(CountryName)), min(char_length(CountryName)) from institution -- 15, 5
select CountryName from institution limit 10 -- United States

select max(char_length(StateName)), min(char_length(StateName)) from institution -- 20, 4
select StateName from institution limit 10 -- North Carolina

select max(char_length(StateCode)), min(char_length(StateCode)) from institution -- 2, 2
select StateCode from institution limit 10 -- NC





select max(char_length(FirstName)), min(char_length(FirstName)) from investigator -- 15, 1
select FirstName from investigator limit 10 -- Richard

select max(char_length(LastName)), min(char_length(LastName)) from investigator -- 24, 1
select LastName from investigator limit 10 -- Schulz

select max(char_length(EmailAddress)), min(char_length(EmailAddress)) from investigator -- 50, 9
select EmailAddress from investigator limit 10 -- rfair@ee.duke.edu

select max(char_length(StartDate)), min(char_length(StartDate)) from investigator -- 10, 10
select StartDate from investigator limit 10 -- 03/07/2007

select max(char_length(EndDate)), min(char_length(EndDate)) from investigator -- 10, 10
select EndDate from investigator limit 10 -- 03/07/2007

select max(char_length(RoleCode)), min(char_length(RoleCode)) from investigator -- 1, 1
select RoleCode from investigator limit 10 -- 1






select max(char_length(Code)), min(char_length(Code)) from programelement -- 4, 4
select Code from programelement limit 10 -- 1468
select Code from programelement where Code not regexp '^[0-9]*$' limit 10 -- NOT all valid numbers

select max(char_length(Text)), min(char_length(Text)) from programelement -- 30, 3
select Text from programelement limit 10 -- Manufacturing Machines & Equip






select max(char_length(Code)), min(char_length(Code)) from programreference -- 4, 4
select Code from programreference limit 10 -- 1468
select Code from programreference where Code not regexp '^[0-9]*$' limit 10 -- NOT all valid numbers

select max(char_length(Text)), min(char_length(Text)) from programreference -- 40, 3
select Text from programreference limit 10 -- MATERIAL TRANSFORMATION PROC






select count(*) from award






truncate table award;
truncate table foainformation;
truncate table institution;
truncate table investigator;
truncate table programelement;
truncate table programreference;
