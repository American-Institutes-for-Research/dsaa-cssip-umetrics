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
import pymysql as mySQL
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
arg_parser = argparse.ArgumentParser(description="Imports XML files downloaded from the Research.gov site using the "
                                                 "Research.gov scraper. "
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

# Get all XML files in the specified directory
files = glob.glob(os.path.join(args.rootPath, "*.xml"))

fileCount = len(files)

# Read in all of our SQL INSERT statements.
awardSQL = get_sql("InsertAward.sql")

# Connect to the database.
connection = mySQL.connect(host=args.host, port=args.port, user=args.user, passwd=password, db=args.database)
cursor = connection.cursor()

# Set up utf8 encoding
# connection.set_character_set('utf8')
# cursor.execute('SET NAMES utf8;')
# cursor.execute('SET CHARACTER SET utf8;')
# cursor.execute('SET character_set_connection=utf8;')

# Clear out all of our destination tables.
# This line is Good for Testing - Removeing For Right Now 
# cursor.execute("truncate table RG_Award")

# Suck in each XML file and dump it into the database.
counter = 0
for file in files:

    tree = elementTree.parse(file)

    for awardElement in tree.iterfind("award"):

        awardeeElement = awardElement.find("Awardee")
        doingBusinessAsNameElement = awardElement.find("DoingBusinessAsName")
        pdPINameElement = awardElement.find("PD-PIName")
        pdPIPhoneElement = awardElement.find("PD-PIPhone")
        pdPIEmailElement = awardElement.find("PD-PIEmail")
        coPDsCoPIsElement = awardElement.find("Co-PDs-co-PIs")
        awardDateElement = awardElement.find("AwardDate")
        estimatedTotalAwardAmountElement = awardElement.find("EstimatedTotalAwardAmount")
        fundsObligatedToDateElement = awardElement.find("FundsObligatedtoDate")
        awardStartDateElement = awardElement.find("StartDate")
        awardExpirationDateElement = awardElement.find("EndDate")
        transactionTypeElement = awardElement.find("TransactionType")
        agencyElement = awardElement.find("Agency")
        awardingAgencyCodeElement = awardElement.find("AwardingAgencyCode")
        fundingAgencyCodeElement = awardElement.find("FundingAgencyCode")
        cfdaNumberElement = awardElement.find("CFDANumber")
        primaryProgramSourceElement = awardElement.find("PrimaryProgramSource")
        awardTitleOrDescriptionElement = awardElement.find("AwardTitleorDescription")
        federalAwardIDNumberElement = awardElement.find("FederalAwardIDNumber")
        dunsIDElement = awardElement.find("DUNSID")
        parentDUNSIDElement = awardElement.find("ParentDUNSID")
        programElement = awardElement.find("Program")
        programOfficerNameElement = awardElement.find("ProgramOfficerName")
        programOfficerPhoneElement = awardElement.find("ProgramOfficerPhone")
        programOfficerEmailElement = awardElement.find("ProgramOfficerEmail")
        awardeeStreetElement = awardElement.find("AwardeeStreet")
        awardeeCityElement = awardElement.find("AwardeeCity")
        awardeeStateElement = awardElement.find("AwardeeState")
        awardeeZIPElement = awardElement.find("AwardeeZIP")
        awardeeCountyElement = awardElement.find("AwardeeCounty")
        awardeeCountryElement = awardElement.find("AwardeeCountry")
        awardeeCongDistrictElement = awardElement.find("AwardeeCong.District")
        primaryOrganizationNameElement = awardElement.find("PrimaryOrganizationName")
        primaryStreetElement = awardElement.find("PrimaryStreet")
        primaryCityElement = awardElement.find("PrimaryCity")
        primaryStateElement = awardElement.find("PrimaryState")
        primaryZIPElement = awardElement.find("PrimaryZIP")
        primaryCountyElement = awardElement.find("PrimaryCounty")
        primaryCountryElement = awardElement.find("PrimaryCountry")
        primaryCongDistrictElement = awardElement.find("PrimaryCong.District")
        abstractAtTimeOfAwardElement = awardElement.find("AbstractatTimeofAward")
        publicationsProducedAsAResultOfThisResearchElement = awardElement.find("PublicationsProducedasaResultofthisResearch")
        publicationsProducedAsConferenceProceedingsElement = awardElement.find("PublicationsProducedasConferenceProceedings")
        projectOutcomesReportElement = awardElement.find("ProjectOutcomesReport")

        data = {
            "Awardee" : awardeeElement.text if awardeeElement is not None else None,
            "DoingBusinessAsName" : doingBusinessAsNameElement.text if doingBusinessAsNameElement is not None else None,
            "PDPIName" : pdPINameElement.text if pdPINameElement is not None else None,
            "PDPIPhone" : pdPIPhoneElement.text if pdPIPhoneElement is not None else None,
            "PDPIEmail" : pdPIEmailElement.text if pdPIEmailElement is not None else None,
            "CoPDsCoPIs" : coPDsCoPIsElement.text if coPDsCoPIsElement is not None else None,
            "AwardDate" : awardDateElement.text if awardDateElement is not None else None,
            "EstimatedTotalAwardAmount" : estimatedTotalAwardAmountElement.text if estimatedTotalAwardAmountElement is not None else None,
            "FundsObligatedToDate" : fundsObligatedToDateElement.text if fundsObligatedToDateElement is not None else None,
            "AwardStartDate" : awardStartDateElement.text if awardStartDateElement is not None else None,
            "AwardExpirationDate" : awardExpirationDateElement.text if awardExpirationDateElement is not None else None,
            "TransactionType" : transactionTypeElement.text if transactionTypeElement is not None else None,
            "Agency" : agencyElement.text if agencyElement is not None else None,
            "AwardingAgencyCode" : awardingAgencyCodeElement.text if awardingAgencyCodeElement is not None else None,
            "FundingAgencyCode" : fundingAgencyCodeElement.text if fundingAgencyCodeElement is not None else None,
            "CFDANumber" : cfdaNumberElement.text if cfdaNumberElement is not None else None,
            "PrimaryProgramSource" : primaryProgramSourceElement.text if primaryProgramSourceElement is not None else None,
            "AwardTitleOrDescription" : awardTitleOrDescriptionElement.text if awardTitleOrDescriptionElement is not None else None,
            "FederalAwardIDNumber" : federalAwardIDNumberElement.text if federalAwardIDNumberElement is not None else None,
            "DUNSID" : dunsIDElement.text if dunsIDElement is not None else None,
            "ParentDUNSID" : parentDUNSIDElement.text if parentDUNSIDElement is not None else None,
            "Program" : programElement.text if programElement is not None else None,
            "ProgramOfficerName" : programOfficerNameElement.text if programOfficerNameElement is not None else None,
            "ProgramOfficerPhone" : programOfficerPhoneElement.text if programOfficerPhoneElement is not None else None,
            "ProgramOfficerEmail" : programOfficerEmailElement.text if programOfficerEmailElement is not None else None,
            "AwardeeStreet" : awardeeStreetElement.text if awardeeStreetElement is not None else None,
            "AwardeeCity" : awardeeCityElement.text if awardeeCityElement is not None else None,
            "AwardeeState" : awardeeStateElement.text if awardeeStateElement is not None else None,
            "AwardeeZIP" : awardeeZIPElement.text if awardeeZIPElement is not None else None,
            "AwardeeCounty" : awardeeCountyElement.text if awardeeCountyElement is not None else None,
            "AwardeeCountry" : awardeeCountryElement.text if awardeeCountryElement is not None else None,
            "AwardeeCongDistrict" : awardeeCongDistrictElement.text if awardeeCongDistrictElement is not None else None,
            "PrimaryOrganizationName" : primaryOrganizationNameElement.text if primaryOrganizationNameElement is not None else None,
            "PrimaryStreet" : primaryStreetElement.text if primaryStreetElement is not None else None,
            "PrimaryCity" : primaryCityElement.text if primaryCityElement is not None else None,
            "PrimaryState" : primaryStateElement.text if primaryStateElement is not None else None,
            "PrimaryZIP" : primaryZIPElement.text if primaryZIPElement is not None else None,
            "PrimaryCounty" : primaryCountyElement.text if primaryCountyElement is not None else None,
            "PrimaryCountry" : primaryCountryElement.text if primaryCountryElement is not None else None,
            "PrimaryCongDistrict" : primaryCongDistrictElement.text if primaryCongDistrictElement is not None else None,
            "AbstractAtTimeOfAward" : abstractAtTimeOfAwardElement.text if abstractAtTimeOfAwardElement is not None else None,
            "PublicationsProducedAsAResultOfThisResearch" : publicationsProducedAsAResultOfThisResearchElement.text if publicationsProducedAsAResultOfThisResearchElement is not None else None,
            "PublicationsProducedAsConferenceProceedings" : publicationsProducedAsConferenceProceedingsElement.text if publicationsProducedAsConferenceProceedingsElement is not None else None,
            "ProjectOutcomesReport" : projectOutcomesReportElement.text if projectOutcomesReportElement is not None else None
        }

        cursor.execute(awardSQL, data)

    # Dump something out to the screen to give us some indication of our progress.
    counter += 1
    if counter % 10 == 0:
        connection.commit()
        print('Completed: {0:.2f}%'.format((counter / fileCount) * 100))


# Close up shop.
connection.commit()
cursor.close()
connection.close()

print "COMPLETE"
