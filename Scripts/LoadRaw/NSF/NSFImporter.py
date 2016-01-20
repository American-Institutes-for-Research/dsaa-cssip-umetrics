################################################################################
# Copyright (c) 2014, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

import os
import glob
import xml.etree.ElementTree as elementTree
#import mysql.connector as mySQL
import MySQLdb as mySQL
import argparse
import getpass

# Function to read in SQL script files.
def get_sql(filename):
    fd = open(filename, 'rt')
    sql_file = fd.read()
    fd.close()
    return sql_file

# Build the argument list for this. Sure, some of these could be put into a config file, but when it comes to
# credentials I prefer to not have them in a config file but rather as commandline arguments - sometimes
# config files get checked in with the credentials still in them.
arg_parser = argparse.ArgumentParser(description="Imports XML files downloaded from the NSF Awards Database site. "
                                                 "See the documentation for more information on usage.")
arg_parser.add_argument(dest="host", action="store", help="MySQL host string. E.g. www.example.com or 123.123.123.123")
arg_parser.add_argument(dest="database", action="store", help="The name of the database that you want to collect "
                                                              "statistics for.")
arg_parser.add_argument(dest="user", action="store", help="MySQL user name.")
arg_parser.add_argument(dest="rootPath", action="store", help="Path to the root of the NSF XML files.")
arg_parser.add_argument("-p", "--password", dest="password", metavar="password", action="store",
                        help="The password for the MySQL user. If not provided, then you will be prompted for it.")
arg_parser.add_argument("-po", "--port", dest="port", action="store", metavar="port", default=3306,
                        help="Numeric port number for the MySQL instance. Default is 3306.")
args = arg_parser.parse_args()

# If the password wasn't provided as a parameter, then prompt for it.
if args.password is None:
    password = getpass.getpass()
else:
    password = args.password

# Get all XML files in directories names YYYY
files = glob.glob(os.path.join(args.rootPath, "[0-9][0-9][0-9][0-9]\*.xml"))
# Get all XML files in the Historical directory. This directory has awards prior to 1976.
files.extend(glob.glob(os.path.join(args.rootPath, "historical\*.xml")))

fileCount = len(files)

# Read in all of our SQL INSERT statements.
awardSQL = get_sql("InsertAward.sql")
investigatorSQL = get_sql("InsertInvestigator.sql")
institutionSQL = get_sql("InsertInstitution.sql")
foaInformationSQL = get_sql("InsertFoaInformation.sql")
programElementSQL = get_sql("InsertProgramElement.sql")
programReferenceSQL = get_sql("InsertProgramReference.sql")

# Connect to the database.
connection = mySQL.connect(host=args.host, port=args.port, user=args.user, passwd=password, db=args.database)
cursor = connection.cursor()

# Clear out all of our destination tables.
cursor.execute("truncate table NSF_Award")
cursor.execute("truncate table NSF_FOAInformation")
cursor.execute("truncate table NSF_Institution")
cursor.execute("truncate table NSF_Investigator")
cursor.execute("truncate table NSF_ProgramElement")
cursor.execute("truncate table NSF_ProgramReference")


# Suck in each XML file and dump it into the database.
counter = 0
for file in files:

    tree = elementTree.parse(file)

    rootTagElement = tree.getroot()
    awardElement = rootTagElement.find("Award")

    awardTitleElement = awardElement.find("AwardTitle")
    awardEffectiveDateElement = awardElement.find("AwardEffectiveDate")
    awardExpirationDateElement = awardElement.find("AwardExpirationDate")
    awardAmountElement = awardElement.find("AwardAmount")

    awardInstrumentElement = awardElement.find("AwardInstrument")
    awardInstrumentValueElement = awardInstrumentElement.find("Value")
    awardInstrumentCodeElement = awardInstrumentElement.find("Code")

    organizationElement = awardElement.find("Organization")
    organizationCodeElement = organizationElement.find("Code")

    directorateElement = organizationElement.find("Directorate")
    directorateLongNameElement = directorateElement.find("LongName")
    directorateAbbreviationElement = directorateElement.find("Abbreviation")
    directorateCodeElement = directorateElement.find("Code")

    divisionElement = organizationElement.find("Division")
    divisionLongNameElement = divisionElement.find("LongName")
    divisionAbbreviationElement = divisionElement.find("Abbreviation")
    divisionCodeElement = divisionElement.find("Code")

    programOfficerElement = awardElement.find("ProgramOfficer")
    programOfficerSignBlockNameElement = programOfficerElement.find("SignBlockName")

    abstractNarrationElement = awardElement.find("AbstractNarration")
    minAmdLetterDateElement = awardElement.find("MinAmdLetterDate")
    maxAmdLetterDateElement = awardElement.find("MaxAmdLetterDate")
    arraAmountElement = awardElement.find("ARRAAmount")
    awardIDElement = awardElement.find("AwardID")
    isHistoricalAwardElement = awardElement.find("IsHistoricalAward")

    data = {
        "AwardTitle": awardTitleElement.text if awardTitleElement is not None else None,
        "AwardEffectiveDate": awardEffectiveDateElement.text if awardEffectiveDateElement is not None else None,
        "AwardExpirationDate": awardExpirationDateElement.text if awardExpirationDateElement is not None else None,
        "AwardAmount": awardAmountElement.text if awardAmountElement is not None else None,
        "AwardInstrument": awardInstrumentValueElement.text if awardInstrumentElement is not None else None,
        "AwardInstrumentCode": awardInstrumentCodeElement.text if awardInstrumentCodeElement is not None else None,
        "OrganizationCode": organizationCodeElement.text if organizationCodeElement is not None else None,
        "Directorate": directorateLongNameElement.text if directorateElement is not None else None,
        "DirectorateAbbreviation": directorateAbbreviationElement.text if directorateAbbreviationElement is not None else None,
        "DirectorateCode": directorateCodeElement.text if directorateCodeElement is not None else None,
        "Division": divisionLongNameElement.text if divisionElement is not None else None,
        "DivisionAbbreviation": divisionAbbreviationElement.text if divisionAbbreviationElement is not None else None,
        "DivisionCode": divisionCodeElement.text if divisionCodeElement is not None else None,
        "ProgramOfficer": programOfficerSignBlockNameElement.text if programOfficerElement is not None else None,
        "AbstractNarration": abstractNarrationElement.text if abstractNarrationElement is not None else None,
        "MinAmdLetterDate": minAmdLetterDateElement.text if minAmdLetterDateElement is not None else None,
        "MaxAmdLetterDate": maxAmdLetterDateElement.text if maxAmdLetterDateElement is not None else None,
        "ARRAAmount": arraAmountElement.text if arraAmountElement is not None else None,
        "AwardID": awardIDElement.text,
        "IsHistoricalAward": isHistoricalAwardElement.text if isHistoricalAwardElement is not None else None
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
            "FirstName": firstNameElement.text if firstNameElement is not None else None,
            "LastName": lastNameElement.text if lastNameElement is not None else None,
            "EmailAddress": emailAddressElement.text if emailAddressElement is not None else None,
            "StartDate": startDateElement.text if startDateElement is not None else None,
            "EndDate": endDateElement.text if endDateElement is not None else None,
            "RoleCode": roleCodeElement.text if roleCodeElement is not None else None
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
        emailAddressElement = institutionElement.find("EmailAddress")
        countryFlagElement = institutionElement.find("CountryFlag")

        data = {
            "AwardID": awardIDElement.text,
            "Name": nameElement.text if nameElement is not None else None,
            "CityName": cityNameElement.text if cityNameElement is not None else None,
            "ZipCode": zipCodeElement.text if zipCodeElement is not None else None,
            "PhoneNumber": phoneNumberElement.text if phoneNumberElement is not None else None,
            "StreetAddress": streetAddressElement.text if streetAddressElement is not None else None,
            "CountryName": countryNameElement.text if countryNameElement is not None else None,
            "StateName": stateNameElement.text if stateNameElement is not None else None,
            "StateCode": stateCodeElement.text if stateCodeElement is not None else None,
            "EmailAddress": emailAddressElement.text if emailAddressElement is not None else None,
            "CountryFlag": countryFlagElement.text if countryFlagElement is not None else None
        }

        cursor.execute(institutionSQL, data)

    for foaInformationElement in awardElement.findall("FoaInformation"):
        codeElement = foaInformationElement.find("Code")
        nameElement = foaInformationElement.find("Name")

        data = {
            "AwardID": awardIDElement.text,
            "Code": codeElement.text if codeElement is not None else None,
            "Name": nameElement.text if nameElement is not None else None
        }

        cursor.execute(foaInformationSQL, data)

    for programElementElement in awardElement.findall("ProgramElement"):
        codeElement = programElementElement.find("Code")
        textElement = programElementElement.find("Text")

        data = {
            "AwardID": awardIDElement.text,
            "Code": codeElement.text if codeElement is not None else None,
            "Text": textElement.text if textElement is not None else None
        }

        cursor.execute(programElementSQL, data)

    for programReferenceElement in awardElement.findall("ProgramReference"):
        codeElement = programReferenceElement.find("Code")
        textElement = programReferenceElement.find("Text")

        data = {
            "AwardID": awardIDElement.text,
            "Code": codeElement.text if codeElement is not None else None,
            "Text": textElement.text if textElement is not None else None
        }

        cursor.execute(programReferenceSQL, data)

    # Dump something out to the screen to give us some indication of our progress.
    counter += 1
    if counter % 1000 == 0:
        connection.commit()
        print('Completed: {0:.2f}%'.format((counter / fileCount) * 100))


# Close up shop.
connection.commit()
cursor.close()
connection.close()
