################################################################################
# Copyright (c) 2014, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

import sys
import mysql.connector as mySQL
import argparse
import getpass
import datetime
sys.path.append("..\..\..\correct_email")
import email_corrector

# Build the argument list for this. Sure, some of these could be put into a config file, but when it comes to
# credentials I prefer to not have them in a config file but rather as commandline arguments - sometimes
# config files get checked in with the credentials still in them.
arg_parser = argparse.ArgumentParser(description="Correct email addresses in the NSF database by ensuring they meet"
                                                 " rather broad pattern constraints.")
arg_parser.add_argument(dest="host", action="store", help="MySQL host string. E.g. www.example.com or 123.123.123.123")
arg_parser.add_argument(dest="database", action="store", help="The name of the database that you want to collect "
                                                              "statistics for.")
arg_parser.add_argument(dest="user", action="store", help="MySQL user name.")
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

# Connect to the database.
read_cnx = mySQL.connect(user=args.user, password=password, database=args.database, host=args.host,
                         port=args.port)
read_cursor = read_cnx.cursor()
write_cnx = mySQL.connect(user=args.user, password=password, database=args.database, host=args.host,
                          port=args.port)
write_cursor = write_cnx.cursor()

query_string = "select InvestigatorId, EmailAddress from Investigator"\
    " where EmailAddress is not null;"
read_cursor.execute(query_string)

num_rows_read = 0
print(datetime.datetime.now(), num_rows_read)

for (InvestigatorId, EmailAddress) in read_cursor:
    corrected_email_address = email_corrector.email_corrector(EmailAddress)
    if corrected_email_address is not None:
        query_string = "UPDATE Investigator SET UM_Corrected_EmailAddress=%s WHERE InvestigatorId=%s;"
        write_cursor.execute(query_string, (corrected_email_address, InvestigatorId))
    num_rows_read += 1

    if divmod(num_rows_read, 10000)[1] == 0:
        print(datetime.datetime.now(), num_rows_read)
        write_cnx.commit()

write_cnx.commit()

write_cursor.close()
write_cnx.close()
read_cursor.close()
read_cnx.close()

