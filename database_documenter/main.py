################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
"""
Quick and dirty tool to automate data dictionary documentation for MySQL databases.
"""
import os, mysql.connector, datetime

_database_names = ("UMETRICS", "UMETRICSSupport")

for _database_name in _database_names:

    _output_file_name = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                     'Data Dictionary - %s.html' % _database_name)

    if os.path.exists(_output_file_name):
        os.remove(_output_file_name)

    _output_file = open(_output_file_name, 'w')

    _output_file.write("""<html>
<head>
<style type='text/css'>
body, p, td {font-family: Arial; font-size: 10pt;}
h1 {font-family: Arial; font-size: 13pt; font-weight: bold;}
h2 {font-family: Arial; font-size: 12pt; font-weight: bold;}
td {padding: 3px 15px 3px 3px; vertical-align: top;}
tr.h {background-color: #053061; color: #FFFFFF; font-weight: bold;}
tr.o {background-color: #f7f7f7; color: #000000;}
tr.e {background-color: #d1e5f0; color: #000000;}
td.c {padding-left: 35px; color: #666666; font-style: italic;}
</style>
</head>
<body>
<h1>Data Dictionary for %s</h1>
<p>Generated %s</p>
<br clear='all' style='page-break-before:always' />
""" % (_database_name, datetime.datetime.today()))

    _connection = mysql.connector.connect(host="localhost",
                                          port=3306,
                                          user="",
                                          password="",
                                          database=_database_name)
    _cursor = _connection.cursor()

    _query = """
        select
            table_name
        from
            information_schema.tables
        where
            table_type in ('base table', 'view') and
            table_schema = '%s'
        order by
            table_name;
        """ % _database_name

    _cursor.execute(_query)
    _table_names = _cursor.fetchall()

    for _table_name in _table_names:

        _output_file.write("<h2>%s</h2>\n" % _table_name)

        _query = """
            select
                table_comment
            from
                information_schema.tables
            where
                table_schema = '%s' and
                table_name = '%s';
            """ % (_database_name, _table_name[0])
        _cursor.execute(_query)
        _columns = _cursor.fetchall()

        if _columns and _columns[0]:
            _output_file.write("<p>%s</p>\n" % _columns[0])

        _output_file.write("<table border='0'><tr class='h'><td>Column</td><td>Datatype</td><td>Nullable</td></tr>\n")

        _query = """
            select
                c.column_name,
                c.column_type,
                c.is_nullable,
                c.column_comment,
                c.ordinal_position
            from
                information_schema.tables as t
                inner join information_schema.columns as c on
                t.table_name = c.table_name and
                t.table_schema = c.table_schema
            where
                t.table_type in('base table', 'view') and
                t.table_schema like '%s' and
                t.table_name like '%s'
            order by
                c.ordinal_position
            """ % (_database_name, _table_name[0])
        _cursor.execute(_query)
        _columns = _cursor.fetchall()

        for _column in _columns:
            _column_name = _column[0]
            _column_type = _column[1]
            _is_nullable = _column[2]
            _column_comment = _column[3]
            _ordinal_position = _column[4]
            _is_even = (_ordinal_position % 2) == 0

            if _column_type[:4] == "enum":
                _column_type =_column_type.replace(",", ", ")

            if _is_even:
                _tr_class = "e"
            else:
                _tr_class = "o"

            _output_file.write("<tr class='%s'><td>%s</td><td>%s</td><td>%s</td></tr>\n" %
                                    (_tr_class, _column_name, _column_type, _is_nullable.lower()))

            if _column_comment:
                _output_file.write("<tr class='%s'><td class='c' colspan='3'>%s</td></tr>\n" %
                                        (_tr_class, _column_comment))

        _output_file.write("</table>\n")
        if _table_name[0] != _table_names[-1][0]:
            _output_file.write("<br clear='all' style='page-break-before:always' />\n")

    _output_file.write("""</body>
</html>
""")

    _output_file.close()
    _cursor.close()
    _connection.close()
