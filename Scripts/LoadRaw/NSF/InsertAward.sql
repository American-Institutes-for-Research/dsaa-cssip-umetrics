insert into Award
(
    AwardTitle,
    AwardEffectiveDate,
    AwardExpirationDate,
    AwardAmount,
    AwardInstrument,
    OrganizationCode,
    Directorate,
    Division,
    ProgramOfficer,
    AbstractNarration,
    MinAmdLetterDate,
    MaxAmdLetterDate,
    ARRAAmount,
    AwardID
) values (
    %(AwardTitle)s,
    str_to_date(%(AwardEffectiveDate)s, '%m/%d/%Y'),
    str_to_date(%(AwardExpirationDate)s, '%m/%d/%Y'),
    %(AwardAmount)s,
    %(AwardInstrument)s,
    %(OrganizationCode)s,
    %(Directorate)s,
    %(Division)s,
    %(ProgramOfficer)s,
    %(AbstractNarration)s,
    str_to_date(%(MinAmdLetterDate)s, '%m/%d/%Y'),
    str_to_date(%(MaxAmdLetterDate)s, '%m/%d/%Y'),
    %(ARRAAmount)s,
    %(AwardID)s
)
