################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
"""
This module will create tokens for chunking/grouping/clustering/etc names for comparison purposes.
"""
import re, os, sys, subprocess, mysql.connector
sys.path.append(os.path.abspath('../ThirdParty'))
from unidecode import unidecode


_pattern = re.compile("[^\W_]")

# TODO: For performance reasons, we have scaled way back on tokens.  We're only going to take the first 5 characters
# into account (used to be 4).  Fix this some day.
_token_length = 5


def tokenize_name(name_component):
    """
    Simple function to clean up and "standardize" name components for clustering.  Our clustering is extremely crude
    right now.  It goes a little something like this:

      Step 1: Remove diacritics
      Step 2: Remove punctuation
      Step 3: Take the first _token_length characters in each name component (fewer if the name is less than
              _token_length characters)
      Step 4: Capitalize
      Step 5: Return what's left over
    """

    if name_component is None:
        return ''
    return unidecode("".join(_pattern.findall(name_component))[:_token_length+2])[:_token_length].upper()


def tokenize_names(name_components):
    """Accepts multiple strings and converts them to clusterable strings."""

    standardized_names = []
    for name_component in name_components:
        standardized_name = tokenize_name(name_component)
        if(len(standardized_name)) > 1:
            standardized_names.append(standardized_name.ljust(_token_length))
    return list(set(standardized_names))


# Some working values.
output_file_name = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tokenize_person_names_import_file.txt')
sorted_output_file_name = output_file_name + '.sorted'

# Connect to the database.
connection = mysql.connector.connect(host="localhost",
                                     port=3306,
                                     user="",
                                     password="",
                                     database="UMETRICSSupport")
cursor = connection.cursor()

connection.raise_on_warnings = True

# Clear out the PersonNameTokens table.
query = 'truncate table PersonNameTokens;'
cursor.execute(query)
connection.commit()

# Clean up any boogers from the previous run.
if os.path.exists(output_file_name):
    os.remove(output_file_name)

if os.path.exists(sorted_output_file_name):
    os.remove(sorted_output_file_name)

# Open us up an output file.
output_file = open(output_file_name, 'w')

# Grab ALL PersonNames.
query = 'select PersonNameId, GivenName, OtherName, FamilyName from UMETRICS.PersonName;'
cursor.execute(query)

# Create tokens for this name.
for row in cursor:
    id = row[0]

    # TODO: For performance reasons, we have scaled way back on tokens.  We're only going to take family names into
    # account for now.  Fix this some day.
    # tokens = tokenize_names([row[1], row[2], row[3]])

    tokens = tokenize_names([row[3]])
    for token in tokens:
        output_file.write('%010d\t%s\n' % (id, token))

output_file.close()

# Sort the output file.
subprocess.call('sort "%s" /o "%s"' % (output_file_name, sorted_output_file_name), shell=True)

query = """
load data infile '%s'
into table PersonNameTokens
fields terminated by '\\t'
lines terminated by '\\n'
(
  PersonNameId,
  Token
);
""" % (sorted_output_file_name.replace('\\', '/'))

cursor.execute(query)
connection.commit()

cursor.close()
connection.close()
