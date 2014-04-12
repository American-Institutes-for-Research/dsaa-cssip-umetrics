################################################################################
# Copyright (c) 2014, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import mysql.connector as mySQL
import argparse
import getpass
import configparser


# Build the argument list for this. Sure, some of these could be put into a config file, but when it comes to
# credentials I prefer to not have them in a config file but rather as commandline arguments - sometimes
# config files get checked in with the credentials still in them.
arg_parser = argparse.ArgumentParser(description="Calculate basic statistics for a database and store in a support "
                                                 "database.")
arg_parser.add_argument(dest="host", action="store", help="MySQL host string. E.g. www.example.com or 123.123.123.123")
arg_parser.add_argument(dest="database", action="store", help="The name of the database that you want to collect "
                                                              "statistics for.")
arg_parser.add_argument(dest="user", action="store", help="MySQL user name.")
arg_parser.add_argument(dest="support_database", help="The name of the database into which you want to store the "
                                                      "statistics; this database must also have the stored procedures "
                                                      "that will be used.")
arg_parser.add_argument(dest="description", help="Description of the database that is being processed. You may want "
                                                 "to identify the version of the database, or perhaps what the most "
                                                 "recent change was.")
arg_parser.add_argument("-p", "--password", dest="password", metavar="password", action="store",
                        help="The password for the MySQL user. If not provided, then you will be prompted for it.")
arg_parser.add_argument("-po", "--port", dest="port", action="store", metavar="port", default=3306,
                        help="Numeric port number for the MySQL instance. Default is 3306.")
arg_parser.add_argument("-k", "--keyed_columns_only", dest="keyed_columns_only", action="store_true",
                        default=False, help="Only include columns that are part of a key or index. Using this option"
                                            "could speed up the processing for large tables (many rows or "
                                            "many columns).")
arg_parser.add_argument("-c", "--config", dest="config_file", action="store", metavar="config_file",
                        help="The configuration file that contains optional additional calculations to do.")
args = arg_parser.parse_args()

# If the password wasn't provided as a parameter, then prompt for it.
if args.password is None:
    password = getpass.getpass()
else:
    password = args.password

# Connect to the support database.
connection = mySQL.connect(host=args.host, port=int(args.port), user=args.user, password=password,
                           database=args.support_database)
cursor = connection.cursor()

# Get a run identifier and store the description with it.
print("Calling InsertDatabaseStatisticsRun")
results = cursor.callproc("InsertDatabaseStatisticsRun", (args.database, args.description, 0))
database_statistics_run_id = results[2]

# Call the stored proc that calculates the basic statistics.
print("Calling CalculateBasicColumnStatistics")
cursor.callproc("CalculateBasicColumnStatistics", (database_statistics_run_id, args.database, args.keyed_columns_only))

connection.commit()

# If there was a config file specified, we have some more processing to do.
if args.config_file is not None:
    config = configparser.ConfigParser()
    config.optionxform = str    # For some reason this causes the config parser to keep the case of the text,
                                # otherwise it is all done in lowercase. Case sensitivity is important for MySQL
                                # table names.
    config.read(args.config_file)

    # Get all entries in the enumerated columns section. Then we'll iterate through those. Each entry in this sections
    # will have a key value which will be the table name, and the value will be a comma-delimited list of column
    # names.
    enumerated_tables = config["CALCULATESTATS_ENUMERATEDCOLUMNS"]
    for table in enumerated_tables:
        for column in config["CALCULATESTATS_ENUMERATEDCOLUMNS"][table].split(","):
            print("Calling CalculateEnumeratedStatistics for " + table + "." + column.strip())
            cursor.callproc("CalculateEnumeratedStatistics", (database_statistics_run_id, args.database,
                                                              table, column.strip()))
    connection.commit()

    # Ditto now for the groupby section.
    groupby_tables = config["CALCULATESTATS_GROUPBY"]
    for table in groupby_tables:
        for column in config["CALCULATESTATS_GROUPBY"][table].split(","):
            print("Calling CalculateGroupByStatistics for " + table + "." + column.strip())
            cursor.callproc("CalculateGroupByStatistics", (database_statistics_run_id, args.database,
                                                           table, column.strip()))
    connection.commit()

# Clean up and go away.
cursor.close()
connection.close()
