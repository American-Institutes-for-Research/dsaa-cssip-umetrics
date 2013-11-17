insert into Investigator
(
    AwardID,
    FirstName,
    LastName,
    EmailAddress,
    StartDate,
    EndDate,
    RoleCode
) values (
    %(AwardID)s,
    %(FirstName)s,
    %(LastName)s,
    %(EmailAddress)s,
    str_to_date(%(StartDate)s, '%m/%d/%Y'),
    str_to_date(%(EndDate)s, '%m/%d/%Y'),
    %(RoleCode)s
)
