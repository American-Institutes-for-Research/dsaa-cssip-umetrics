insert into Institution
(
    AwardID,
    Name,
    CityName,
    ZipCode,
    PhoneNumber,
    StreetAddress,
    CountryName,
    StateName,
    StateCode
) values (
    %(AwardID)s,
    %(Name)s,
    %(CityName)s,
    %(ZipCode)s,
    %(PhoneNumber)s,
    %(StreetAddress)s,
    %(CountryName)s,
    %(StateName)s,
    %(StateCode)s
)
