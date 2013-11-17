import os
import re
import xml.etree.ElementTree as ET
import mysql.connector as MY


# Function to read in SQL script files.
def GetSQL(filename):
    fd = open(filename, 'r')
    sqlFile = fd.read()
    fd.close()
    return sqlFile


# The path where we expect to find NSF grant award directories in the form of YYYY for the Award year in question.
# Each of those directories, in turn, contains XML files; one for each grant award.
rootPath = "D:\\Raw Data\\NSF"

# Dig through the directory structure of rootPath looking for files that meet our criteria.  This will only dig down
# one directory level.
files = []
for directoryCandidate in os.listdir(rootPath):

    directoryPath = os.path.join(rootPath, directoryCandidate)

    # Is this a directory and is the name in YYYY format?
    if os.path.isdir(directoryPath) and re.match("^[0-9]{4}$", directoryCandidate, 0):

        for fileCandidate in os.listdir(directoryPath):

            # Is this an XML file?
            if fileCandidate.endswith(".xml"):
                files.append(os.path.join(directoryPath, fileCandidate))


# This will cause files to be sorted chronologically since the year directory name comes before the file name in
# the path.
files.sort()
fileCount = len(files)


# Read in all of our SQL INSERT statements.
awardSQL = GetSQL("InsertAward.sql")
investigatorSQL = GetSQL("InsertInvestigator.sql")
institutionSQL = GetSQL("InsertInstitution.sql")
foaInformationSQL = GetSQL("InsertFoaInformation.sql")
programElementSQL = GetSQL("InsertProgramElement.sql")
programReferenceSQL = GetSQL("InsertProgramReference.sql")

# Connect to the database.
connection = MY.connect(host="mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com", port=3306, user="", password="", database="NSF")
cursor = connection.cursor()

# Clear out all of our destination tables.
cursor.execute("truncate table Award")
cursor.execute("truncate table FOAInformation")
cursor.execute("truncate table Institution")
cursor.execute("truncate table Investigator")
cursor.execute("truncate table ProgramElement")
cursor.execute("truncate table ProgramReference")


# Suck in each XML file and dump it into the database.
counter = 0
for file in files:

    tree = ET.parse(file)

    rootTagElement = tree.getroot()
    awardElement = rootTagElement.find("Award")

    awardTitleElement = awardElement.find("AwardTitle")
    awardEffectiveDateElement = awardElement.find("AwardEffectiveDate")
    awardExpirationDateElement = awardElement.find("AwardExpirationDate")
    awardAmountElement = awardElement.find("AwardAmount")

    awardInstrumentElement = awardElement.find("AwardInstrument")
    awardInstrumentValueElement = awardInstrumentElement.find("Value")

    organizationElement = awardElement.find("Organization")
    organizationCodeElement = organizationElement.find("Code")

    directorateElement = organizationElement.find("Directorate")
    directorateLongNameElement = directorateElement.find("LongName")

    divisionElement = organizationElement.find("Division")
    divisionLongNameElement = divisionElement.find("LongName")

    programOfficerElement = awardElement.find("ProgramOfficer")
    programOfficerSignBlockNameElement = programOfficerElement.find("SignBlockName")

    abstractNarrationElement = awardElement.find("AbstractNarration")
    minAmdLetterDateElement = awardElement.find("MinAmdLetterDate")
    maxAmdLetterDateElement = awardElement.find("MaxAmdLetterDate")
    arraAmountElement = awardElement.find("ARRAAmount")
    awardIDElement = awardElement.find("AwardID")

    data = {
        "AwardTitle": awardTitleElement.text,
        "AwardEffectiveDate": awardEffectiveDateElement.text,
        "AwardExpirationDate": awardExpirationDateElement.text,
        "AwardAmount": awardAmountElement.text,
        "AwardInstrument": awardInstrumentValueElement.text,
        "OrganizationCode": organizationCodeElement.text,
        "Directorate": directorateLongNameElement.text,
        "Division": divisionLongNameElement.text,
        "ProgramOfficer": programOfficerSignBlockNameElement.text,
        "AbstractNarration": abstractNarrationElement.text,
        "MinAmdLetterDate": minAmdLetterDateElement.text,
        "MaxAmdLetterDate": maxAmdLetterDateElement.text,
        "ARRAAmount": arraAmountElement.text,
        "AwardID": awardIDElement.text
    }

    cursor.execute(awardSQL, data)


    for investigatorElement in awardElement.findall("Investigator"):
        firstNameElement = investigatorElement.find("FirstName")
        lastNameElement = investigatorElement.find("LastName")
        emailAddressElement = investigatorElement.find("EmailAddress")
        startDateElement = investigatorElement.find("StartDate")
        endDateElement = investigatorElement.find("EndDate")
        roleCodeElement = investigatorElement.find("RoleCode")

        data = {
            "AwardID": awardIDElement.text,
            "FirstName": firstNameElement.text,
            "LastName": lastNameElement.text,
            "EmailAddress": emailAddressElement.text,
            "StartDate": startDateElement.text,
            "EndDate": endDateElement.text,
            "RoleCode": roleCodeElement.text
        }

        cursor.execute(investigatorSQL, data)


    for institutionElement in awardElement.findall("Institution"):
        nameElement = institutionElement.find("Name")
        cityNameElement = institutionElement.find("CityName")
        zipCodeElement = institutionElement.find("ZipCode")
        phoneNumberElement = institutionElement.find("PhoneNumber")
        streetAddressElement = institutionElement.find("StreetAddress")
        countryNameElement = institutionElement.find("CountryName")
        stateNameElement = institutionElement.find("StateName")
        stateCodeElement = institutionElement.find("StateCode")

        data = {
            "AwardID": awardIDElement.text,
            "Name": nameElement.text,
            "CityName": cityNameElement.text,
            "ZipCode": zipCodeElement.text,
            "PhoneNumber": phoneNumberElement.text,
            "StreetAddress": streetAddressElement.text,
            "CountryName": countryNameElement.text,
            "StateName": stateNameElement.text,
            "StateCode": stateCodeElement.text
        }

        cursor.execute(institutionSQL, data)


    for foaInformationElement in awardElement.findall("FoaInformation"):
        codeElement = foaInformationElement.find("Code")
        nameElement = foaInformationElement.find("Name")

        data = {
            "AwardID": awardIDElement.text,
            "Code": codeElement.text,
            "Name": nameElement.text
        }

        cursor.execute(foaInformationSQL, data)


    for programElementElement in awardElement.findall("ProgramElement"):
        codeElement = programElementElement.find("Code")
        textElement = programElementElement.find("Text")

        data = {
            "AwardID": awardIDElement.text,
            "Code": codeElement.text,
            "Text": textElement.text
        }

        cursor.execute(programElementSQL, data)


    for programReferenceElement in awardElement.findall("ProgramReference"):
        codeElement = programReferenceElement.find("Code")
        textElement = programReferenceElement.find("Text")

        data = {
            "AwardID": awardIDElement.text,
            "Code": codeElement.text,
            "Text": textElement.text
        }

        cursor.execute(programReferenceSQL, data)


    # Dump something out to the screen to give us some indication of our progress.
    counter += 1
    if counter % 1000 == 0:
        print('Completed: {0:.2f}%'.format((counter / fileCount) * 100))


# Close up shop.
connection.commit()
cursor.close()
connection.close()
