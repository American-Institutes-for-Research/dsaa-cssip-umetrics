###############################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

import datetime
import mysql.connector
import name_parser


def from_exporter(username, password, host, database, table):
    """
    Reads person names from the given table that are in the same format as names from ExPORTER,
    parses them, and writes the parts back out to the tables.

    """

    # Connect to the database.
    read_cnx = mysql.connector.connect(user=username, password=password, database=database,
                                  host=host)
    read_cursor = read_cnx.cursor()
    write_cnx = mysql.connector.connect(user=username, password=password, database=database,
                                  host=host)
    write_cursor = write_cnx.cursor()

    query_string = "select PersonNameId, FullName from {0} pn inner join PersonAttribute pa "\
        " on pa.PersonId=pn.PersonId and pa.RelationshipCode='NIH_PI_ID'"\
        " where GivenName is null and FamilyName is null".format(table)
    read_cursor.execute(query_string)

    num_rows_read = 0
    print(datetime.datetime.now(), num_rows_read)

    for (PersonNameId, FullName) in read_cursor:
        name_components = name_parser.parse_name(name_parser.NameFormat.EXPORTER, FullName)
        if (name_components.Prefix is not None) or (name_components.GivenName is not None)\
            or (name_components.OtherName is not None) or (name_components.FamilyName is not None)\
            or (name_components.Suffix is not None) or (name_components.NickName is not None):
            query_string = "UPDATE {0} SET Prefix=%s, GivenName=%s, OtherName=%s, FamilyName=%s, Suffix=%s"\
                " WHERE PersonNameId=%s".format(table)
            write_cursor.execute(query_string, (name_components.Prefix, name_components.GivenName,
                                                name_components.OtherName, name_components.FamilyName,
                                                name_components.Suffix, PersonNameId))
        num_rows_read += 1
        if divmod(num_rows_read,10000)[1] == 0:
            print(datetime.datetime.now(), num_rows_read)
            write_cnx.commit()

    write_cnx.commit()

    write_cursor.close()
    write_cnx.close()
    read_cursor.close()
    read_cnx.close()
    return


def from_citeseerx(username, password, host, database, table):
    """
    Reads person names from the given table that are in the same format as names from ExPORTER,
    parses them, and writes the parts back out to the tables.

    """

    # Connect to the database.
    read_cnx = mysql.connector.connect(user=username, password=password, database=database,
                                  host=host)
    read_cursor = read_cnx.cursor()
    write_cnx = mysql.connector.connect(user=username, password=password, database=database,
                                  host=host)
    write_cursor = write_cnx.cursor()

    query_string = "select PersonNameId, FullName from {0} pn inner join PersonAttribute pa"\
        " on pa.PersonId=pn.PersonId and pa.RelationshipCode='CITESEERX_CLUSTER'"\
        " where GivenName is null and FamilyName is null;".format(table)
    read_cursor.execute(query_string)

    num_rows_read = 0
    print(datetime.datetime.now(), num_rows_read)

    for (PersonNameId, FullName) in read_cursor:
        name_components = name_parser.parse_name(name_parser.NameFormat.CITESEERX, FullName)
        if (name_components.Prefix is not None) or (name_components.GivenName is not None)\
                or (name_components.OtherName is not None) or (name_components.FamilyName is not None)\
                or (name_components.Suffix is not None) or (name_components.NickName is not None):
            query_string = "UPDATE {0} SET Prefix=%s, GivenName=%s, OtherName=%s, FamilyName=%s, Suffix=%s"\
                " WHERE PersonNameId=%s".format(table)
            write_cursor.execute(query_string, (name_components.Prefix, name_components.GivenName,
                                                name_components.OtherName, name_components.FamilyName,
                                                name_components.Suffix, PersonNameId))
        num_rows_read += 1
        if divmod(num_rows_read,10000)[1] == 0:
            print(datetime.datetime.now(), num_rows_read)
            write_cnx.commit()

    write_cnx.commit()

    write_cursor.close()
    write_cnx.close()
    read_cursor.close()
    read_cnx.close()
    return

def other_with_comma(username, password, host, database, table):
    """
    Reads person names from the given table that are from an unknown source and that has one comma in it,
    as these may be of the same format as ones from ExPORTER; that is, they are of the format
    [familyname], [givenname] [othername]

    """

    # Connect to the database.
    read_cnx = mysql.connector.connect(user=username, password=password, database=database, host=host)
    read_cursor = read_cnx.cursor()
    write_cnx = mysql.connector.connect(user=username, password=password, database=database, host=host)
    write_cursor = write_cnx.cursor()

    query_string = "select PersonNameId, FullName from {0} where GivenName is null and FamilyName is null" \
                   " and locate(',',FullName)>0".format(table)
    read_cursor.execute(query_string)

    num_rows_read = 0
    print(datetime.datetime.now(), num_rows_read)

    for (PersonNameId, FullName) in read_cursor:
        name_components = name_parser.parse_name(name_parser.NameFormat.EXPORTER, FullName)
        if (name_components.Prefix is not None) or (name_components.GivenName is not None)\
            or (name_components.OtherName is not None) or (name_components.FamilyName is not None)\
            or (name_components.Suffix is not None) or (name_components.NickName is not None):
            query_string = "UPDATE {0} SET Prefix=%s, GivenName=%s, OtherName=%s, FamilyName=%s, Suffix=%s"\
                " WHERE PersonNameId=%s".format(table)
            write_cursor.execute(query_string, (name_components.Prefix, name_components.GivenName,
                                                name_components.OtherName, name_components.FamilyName,
                                                name_components.Suffix, PersonNameId))
        num_rows_read += 1
        if divmod(num_rows_read,10000)[1] == 0:
            print(datetime.datetime.now(), num_rows_read)
            write_cnx.commit()

    write_cnx.commit()

    write_cursor.close()
    write_cnx.close()
    read_cursor.close()
    read_cnx.close()
    return





if __name__ == "__main__":
#    from_exporter("[username]", "[password]", "[host]", "UMETRICS", "PersonName")

#    from_citeseerx("[username]", "[password]", "[host]", "UMETRICS", "PersonName")

#    other_with_comma("[username]", "[password]", "[host]", "UMETRICS", "PersonName")
