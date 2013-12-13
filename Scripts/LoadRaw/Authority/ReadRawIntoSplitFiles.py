################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

import mysql.connector
import re

# Open all the files that we are going to use.
def OpenFiles():
	global blocksFile, probabilitiesFile, nameVariantsFile, lastNameVariantsFile, firstNameVariantsFile, middleInitialVariantsFile
	global suffixVariantsFile, emailsFile, affiliationsFile, meshTermsFile, journalsFile, titleWordsFile, coauthorNamesFile, coauthorIDsFile
	global authorNameInstancesFile, grantIDsFile, citationCountsFile, citedFile, citedByFile
	global nameVariantsFile10Recent, lastNameVariantsFile10Recent, firstNameVariantsFile10Recent, middleInitialVariantsFile10Recent
	global suffixVariantsFile10Recent, emailsFile10Recent, affiliationsFile10Recent, meshTermsFile10Recent, journalsFile10Recent, titleWordsFile10Recent, coauthorNamesFile10Recent, coauthorIDsFile10Recent
	global authorNameInstancesFile10Recent, grantIDsFile10Recent, citationCountsFile10Recent, citedFile10Recent, citedByFile10Recent
	splitFileDirectory = "d:\\Raw Data\\Authority\\SplitFiles\\"
	blocksFile = open(splitFileDirectory+"blocks.txt", "w")
	probabilitiesFile = open(splitFileDirectory+"probabilities.txt", "w")
	nameVariantsFile = open(splitFileDirectory+"namevariants.txt", "w")
	lastNameVariantsFile = open(splitFileDirectory+"lastnamevariants.txt", "w")
	firstNameVariantsFile = open(splitFileDirectory+"firstnamevariants.txt", "w")
	middleInitialVariantsFile = open(splitFileDirectory+"middleinitialvariants.txt", "w")
	suffixVariantsFile = open(splitFileDirectory+"suffixvariants.txt", "w")
	emailsFile = open(splitFileDirectory+"emails.txt", "w")
	affiliationsFile = open(splitFileDirectory+"affiliations.txt", "w")
	meshTermsFile = open(splitFileDirectory+"meshterms.txt", "w")
	journalsFile = open(splitFileDirectory+"journals.txt", "w")
	titleWordsFile = open(splitFileDirectory+"titlewords.txt", "w")
	coauthorNamesFile = open(splitFileDirectory+"coauthornames.txt", "w")
	coauthorIDsFile = open(splitFileDirectory+"coauthorids.txt", "w")
	authorNameInstancesFile = open(splitFileDirectory+"authornameinstances.txt", "w")
	grantIDsFile = open(splitFileDirectory+"grantids.txt", "w")
	citationCountsFile = open(splitFileDirectory+"citationcounts.txt", "w")
	citedFile = open(splitFileDirectory+"cited.txt", "w")
	citedByFile = open(splitFileDirectory+"citedby.txt", "w")
	nameVariantsFile10Recent = open(splitFileDirectory+"namevariants10Recent.txt", "w")
	lastNameVariantsFile10Recent = open(splitFileDirectory+"lastnamevariants10Recent.txt", "w")
	firstNameVariantsFile10Recent = open(splitFileDirectory+"firstnamevariants10Recent.txt", "w")
	middleInitialVariantsFile10Recent = open(splitFileDirectory+"middleinitialvariants10Recent.txt", "w")
	suffixVariantsFile10Recent = open(splitFileDirectory+"suffixvariants10Recent.txt", "w")
	emailsFile10Recent = open(splitFileDirectory+"emails10Recent.txt", "w")
	affiliationsFile10Recent = open(splitFileDirectory+"affiliations10Recent.txt", "w")
	meshTermsFile10Recent = open(splitFileDirectory+"meshterms10Recent.txt", "w")
	journalsFile10Recent = open(splitFileDirectory+"journals10Recent.txt", "w")
	titleWordsFile10Recent = open(splitFileDirectory+"titlewords10Recent.txt", "w")
	coauthorNamesFile10Recent = open(splitFileDirectory+"coauthornames10Recent.txt", "w")
	coauthorIDsFile10Recent = open(splitFileDirectory+"coauthorids10Recent.txt", "w")
	authorNameInstancesFile10Recent = open(splitFileDirectory+"authornameinstances10Recent.txt", "w")
	grantIDsFile10Recent = open(splitFileDirectory+"grantids10Recent.txt", "w")
	citationCountsFile10Recent = open(splitFileDirectory+"citationcounts10Recent.txt", "w")
	citedFile10Recent = open(splitFileDirectory+"cited10Recent.txt", "w")
	citedByFile10Recent = open(splitFileDirectory+"citedby10Recent.txt", "w")

# Close all the files
def CloseFiles():
	blocksFile.close()
	probabilitiesFile.close()
	nameVariantsFile.close()
	lastNameVariantsFile.close()
	firstNameVariantsFile.close()
	middleInitialVariantsFile.close()
	suffixVariantsFile.close()
	emailsFile.close()
	affiliationsFile.close()
	meshTermsFile.close()
	journalsFile.close()
	titleWordsFile.close()
	coauthorNamesFile.close()
	coauthorIDsFile.close()
	authorNameInstancesFile.close()
	grantIDsFile.close()
	citationCountsFile.close()
	citedFile.close()
	citedByFile.close()
	nameVariantsFile10Recent.close()
	lastNameVariantsFile10Recent.close()
	firstNameVariantsFile10Recent.close()
	middleInitialVariantsFile10Recent.close()
	suffixVariantsFile10Recent.close()
	emailsFile10Recent.close()
	affiliationsFile10Recent.close()
	meshTermsFile10Recent.close()
	journalsFile10Recent.close()
	titleWordsFile10Recent.close()
	coauthorNamesFile10Recent.close()
	coauthorIDsFile10Recent.close()
	authorNameInstancesFile10Recent.close()
	grantIDsFile10Recent.close()
	citationCountsFile10Recent.close()
	citedFile10Recent.close()
	citedByFile10Recent.close()

# Blocks need their own processing since the format it: value|value||value|value
# Blocks are separated by "||" and the values within a block are separated by "|"
def ProcessBlocks(outputFile, rawid, fieldString):
	position = 0
	for (valueString) in fieldString.split("||"):
		positionInBlock = 0
		for (subValueString) in valueString.split("|"):
			outputFile.write("{}\t{}\t{}\t{}\n".format(rawid, position, subValueString, positionInBlock))
			positionInBlock += 1
		position += 1

# A simple field is one that has "|" delimited values. Those values could be a "-" and when so they are not output since the "-" indicates no value
# Example: value|value|-|value
def ProcessSimpleField(outputFile, rawid, fieldString):
	if fieldString != None:
		position = 0
		for (valueString) in fieldString.split("|"):
			if (valueString != "") and (valueString != "-"):
				outputFile.write("{}\t{}\t{}\n".format(rawid, position, valueString))
				position += 1

# A simple field with counts is one that has "|" delimited values and each value is followed by a count inside parens.
# Those values could be a "-" and when so they are not output since the "-" indicates no value
# Example: value(33)|value (subvalue)(22)|value(11)
def ProcessSimpleFieldWithCount(outputFile, rawid, fieldString):
	if fieldString != None:
		position = 0
		for (valueString) in fieldString.split("|"):
			if (valueString != "") and (valueString != "-"):
				spl = valueString.rsplit("(", 1) #rsplit with 1 is important since there could be this: Something (and more)(3)|Something else(4)
				simpleString = spl[0] # everything before the left paren
				countString = 0
				# In case there wasn't a count within parens...
				if (len(spl) > 1) and (spl[1].find(")") != -1):
					countString = spl[1].split(")")[0] # take everything between the parens
				outputFile.write("{}\t{}\t{}\t{}\n".format(rawid, position, simpleString, countString))
				position += 1

# Author names are of the format, e.g.: 465668_6|1651658_1
# The first part of the value is a PMID and the second part is the author position on the paper's author list
def ProcessAuthorNameInstances(outputFile, rawid, fieldString):
	if fieldString != None:
		position = 0
		for (valueString) in fieldString.split("|"):
			if (valueString != "") and (valueString != "-"):
				spl = valueString.split("_")
				simpleString = spl[0] # everything before the underscore
				authorNum = spl[1] # everything after the underscore
				outputFile.write("{}\t{}\t{}\t{}\n".format(rawid, position, simpleString, authorNum))
				position += 1

# There are four patterns to these:
# lastname_firstname(count)
# lastname_firstname middlename(count)
# lastname_firstname, suffix(count)
# lastname_firstname middlename, suffix(count)
# Note that the middlename could also have spaces
def ProcessNameVariants(outputFile, rawid, namevariants):
	if namevariants != None:
		position = 0
		for (valueString) in namevariants.split("|"):
			# There will always be at least a lastname and firstname, separated by an underscore
			spl = valueString.split("_", 1)
			lastName = spl[0] # everything before the underscore
			splitAfterUnderscore = spl[1]
			# The first name could be followed by a blank, a comma, or a left paren, so we need to find which ones exist
			# and make a decision based on that
			blankIndex = splitAfterUnderscore.find(" ")
			commaIndex = splitAfterUnderscore.find(", ")
			leftParenIndex = splitAfterUnderscore.find("(")
			# If there isn't a blank or comma, then the firstname goes all the way to the left paren, and there's no middlename or suffix
			# This is option 1 above
			if (blankIndex == -1) and (commaIndex == -1):
				splBeforeParen = splitAfterUnderscore.split("(")
				firstName = splBeforeParen[0]
				middleName = ""
				suffix = ""
				splitAfterParen = splBeforeParen[1]
			# Else if there is a blank but not a comma, then the first name goes to the blank and there is a middlename but no suffix
			# This is option 2 above
			elif commaIndex == -1:
				spl = splitAfterUnderscore.split(" ", 1) # If there are two spaces in the first and middle name, the middle name gets the multiple parts
				firstName = spl[0] # everything before the first blank (subsequent blanks are part of the middlename)
				spl = spl[1].split("(") 
				middleName = spl[0] # everything after the blank and before the left paren
				suffix = ""
				splitAfterParen = spl[1]
			# Else if there is a comma but no blank, then the first name goes to the comma, there is no middlename but there is a suffix
			# Note that we also have to make sure that the blank is before the comma, if not then it is actually the blank after the comma and counts as not blank at all
			# This is option 3 above
			elif (blankIndex == -1) or (commaIndex < blankIndex):
				spl = splitAfterUnderscore.split(", ")
				firstName = spl[0] # everything after the underscore and before the ", "
				middleName = ""
				spl = spl[1].split("(")
				suffix = spl[0] # everything after the ", " and before the left paren
				splitAfterParen = spl[1]
			# Else it has all the parts
			else:
				spl = splitAfterUnderscore.split(" ", 1)
				firstName = spl[0] # everything between the underscore and the first blank
				spl = spl[1].split(", ")
				middleName = spl[0] # everything between the first blank and the ", "
				spl = spl[1].split("(")
				suffix = spl[0] # everything after the ", " and before the left paren
				splitAfterParen = spl[1]

			# Now get the count.
			spl = splitAfterParen.split(")")
			nameCount = spl[0]
			
			outputFile.write("{}\t{}\t{}\t{}\t{}\t{}\t{}\n".format(rawid, position, lastName, firstName, middleName, suffix, nameCount))
			position += 1


################### MAIN ########################


# Connect to MySQL. This stuff should be in a config file somewhere.
cnx = mysql.connector.connect(user='mysqladmin', password='shorplun', database='Authority', host='mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com')
cursor = cnx.cursor()

OpenFiles()

query = ("select rawid, blocks, probabilities, namevariants, lastnamevariants, firstnamevariants, middleinitialvariants, suffixvariants, emails, affiliations, meshterms, journals, titlewords, coauthornames, coauthorids, authornameinstances, grantids, citationcounts, cited, citedby, namevariants_10Recent, lastnamevariants_10Recent, firstnamevariants_10Recent, middleinitialvariants_10Recent, suffixvariants_10Recent, emails_10Recent, affiliations_10Recent, meshterms_10Recent, journals_10Recent, titlewords_10Recent, coauthornames_10Recent, coauthorids_10Recent, authornameinstances_10Recent, grantids_10Recent, citationcounts_10Recent, cited_10Recent, citedby_10Recent from raw")

cursor.execute(query)

#ProcessNameVariants(nameVariantsFile, 111, "xxx", "LastName_FirstName(111)")
#ProcessNameVariants(nameVariantsFile, 222, "xxx", "LastName_FirstName MiddleName(222)")
#ProcessNameVariants(nameVariantsFile, 333, "xxx", "LastName_FirstName, Suffix(333)")
#ProcessNameVariants(nameVariantsFile, 444, "xxx", "LastName_FirstName MiddleName, Suffix(444)")

numRowsProcessed = 0

for (rawid, blocks, probabilities,
	namevariants, lastnamevariants, firstnamevariants, middleinitialvariants, suffixvariants,
	emails, affiliations, meshterms, journals, titlewords, coauthornames, coauthorids,
	authornameinstances, grantids, citationcounts, cited, citedby,
	namevariants10Recent, lastnamevariants10Recent, firstnamevariants10Recent, middleinitialvariants10Recent, suffixvariants10Recent,
	emails10Recent, affiliations10Recent, meshterms10Recent, journals10Recent, titlewords10Recent, coauthornames10Recent, coauthorids10Recent,
	authornameinstances10Recent, grantids10Recent, citationcounts10Recent, cited10Recent, citedby10Recent) in cursor:
	ProcessBlocks(blocksFile, rawid, blocks)
	ProcessSimpleField(probabilitiesFile, rawid, probabilities)
	ProcessNameVariants(nameVariantsFile, rawid, namevariants)
	ProcessSimpleField(lastNameVariantsFile, rawid, lastnamevariants)
	ProcessSimpleField(firstNameVariantsFile, rawid, firstnamevariants)
	ProcessSimpleField(middleInitialVariantsFile, rawid, middleinitialvariants)
	ProcessSimpleField(suffixVariantsFile, rawid, suffixvariants)
	ProcessSimpleField(emailsFile, rawid, emails)
	ProcessSimpleFieldWithCount(affiliationsFile, rawid, affiliations)
	ProcessSimpleFieldWithCount(meshTermsFile, rawid, meshterms)
	ProcessSimpleFieldWithCount(titleWordsFile, rawid, titlewords)
	ProcessSimpleFieldWithCount(journalsFile, rawid, journals)
	ProcessSimpleFieldWithCount(coauthorNamesFile, rawid, coauthornames)
	ProcessSimpleFieldWithCount(coauthorIDsFile, rawid, coauthorids)
	ProcessAuthorNameInstances(authorNameInstancesFile, rawid, authornameinstances)
	ProcessSimpleFieldWithCount(grantIDsFile, rawid, grantids)
	ProcessSimpleFieldWithCount(citationCountsFile, rawid, citationcounts)
	ProcessSimpleFieldWithCount(citedFile, rawid, cited)
	ProcessSimpleFieldWithCount(citedByFile, rawid, citedby)
	ProcessNameVariants(nameVariantsFile10Recent, rawid, namevariants10Recent)
	ProcessSimpleField(lastNameVariantsFile10Recent, rawid, lastnamevariants10Recent)
	ProcessSimpleField(firstNameVariantsFile10Recent, rawid, firstnamevariants10Recent)
	ProcessSimpleField(middleInitialVariantsFile10Recent, rawid, middleinitialvariants10Recent)
	ProcessSimpleField(suffixVariantsFile10Recent, rawid, suffixvariants10Recent)
	ProcessSimpleField(emailsFile10Recent, rawid, emails10Recent)
	ProcessSimpleFieldWithCount(affiliationsFile10Recent, rawid, affiliations10Recent)
	ProcessSimpleFieldWithCount(meshTermsFile10Recent, rawid, meshterms10Recent)
	ProcessSimpleFieldWithCount(titleWordsFile10Recent, rawid, titlewords10Recent)
	ProcessSimpleFieldWithCount(journalsFile10Recent, rawid, journals10Recent)
	ProcessSimpleFieldWithCount(coauthorNamesFile10Recent, rawid, coauthornames10Recent)
	ProcessSimpleFieldWithCount(coauthorIDsFile10Recent, rawid, coauthorids10Recent)
	ProcessAuthorNameInstances(authorNameInstancesFile10Recent, rawid, authornameinstances10Recent)
	ProcessSimpleFieldWithCount(grantIDsFile10Recent, rawid, grantids10Recent)
	ProcessSimpleFieldWithCount(citationCountsFile10Recent, rawid, citationcounts10Recent)
	ProcessSimpleFieldWithCount(citedFile10Recent, rawid, cited10Recent)
	ProcessSimpleFieldWithCount(citedByFile10Recent, rawid, citedby10Recent)
	numRowsProcessed += 1
	if numRowsProcessed % 1000 == 0:
		print (numRowsProcessed)

CloseFiles()

cursor.close()
cnx.close()

