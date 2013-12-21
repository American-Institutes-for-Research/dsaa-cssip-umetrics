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
import EmailCorrector


def correct_email(username, password, host, database):
    """
    Iterates through all the emails in the UMETRICS database, when possible, changes them to be vald email addresses.
    """

    # Connect to the database.
    print(datetime.datetime.now())
    read_cnx = mysql.connector.connect(user=username, password=password, database=database,
                                  host=host)
    read_cursor = read_cnx.cursor()
    write_cnx = mysql.connector.connect(user=username, password=password, database=database,
                                  host=host)
    write_cursor = write_cnx.cursor()

    query_string = "select distinct a.AttributeId, a.Attribute from Attribute a " \
                   "inner join PersonAttribute pa on pa.AttributeId=a.AttributeId and RelationshipCode='EMAIL' " \
                   "order by a.AttributeId;"
    read_cursor.execute(query_string)

    num_rows_read = 0
    num_attributes_changed = 0
    print(datetime.datetime.now(), num_rows_read, num_attributes_changed)

    for (AttributeId, Attribute) in read_cursor:
        corrected_email = EmailCorrector.email_corrector(Attribute)
        if (corrected_email is not None) and (corrected_email != Attribute):
            write_cursor.callproc("ChangeAttributeValue", (AttributeId, corrected_email, None))
            num_attributes_changed += 1

        num_rows_read += 1
        if divmod(num_rows_read, 10000)[1] == 0:
            print(datetime.datetime.now(), num_rows_read, num_attributes_changed)

    write_cursor.close()
    write_cnx.close()
    read_cursor.close()
    read_cnx.close()
    return


if __name__ == "__main__":
    correct_email("[username]", "[password]", "[host]", "UMETRICS")