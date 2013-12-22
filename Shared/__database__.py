################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import mysql.connector


class Database:
    """An extremely crude database encapsulation class."""

    def __init__(self, host, port, user, password, database):
        self._connection = mysql.connector.connect(host=host, port=port, user=user, password=password, database=database)
        self._cursor = self._connection.cursor()

    # Get the first value returned from the provided query.
    def get_scalar(self, query, parameters=None):
        scalar = None
        self._cursor.execute(query, parameters)
        row = self._cursor.fetchone()
        if row:
            scalar = row[0]
        return scalar

    # Get all rows from a query.  Small result sets only, please...
    def get_all_rows(self, query, parameters=None):
        self._cursor.execute(query, parameters)
        rows = self._cursor.fetchall()
        return rows

    # Execute a query for which we do not care about any return values.
    def execute(self, query, parameters=None, commit=False):
        self._cursor.execute(query, parameters)
        if commit:
            self.commit_transaction()

    # Start transaction.
    def start_transaction(self):
        self._connection.start_transaction()

    # Commit a transaction.
    def commit_transaction(self):
        self._connection.commit()

    # Rollback a transaction.
    def rollback_transaction(self):
        self._connection.rollback()

    # Closes out our database object references.
    def close(self):
        if self._cursor is not None:
            self._cursor.close()
            self._cursor = None
        if self._connection is not None:
            self._connection.close()
            self._connection = None

    # Just in case we forget to manually close the object.
    def __del__(self):
        self.close()
