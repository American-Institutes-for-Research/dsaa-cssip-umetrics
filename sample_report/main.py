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
import os, sys, html_file
sys.path.append(os.path.abspath('../Shared'))
import __database__ as db


# Yes, these were cherry picked for their unique names.  In the future, once UMETRICS has been more curated (a.k.a.
# reduced via various crawlers), we won't have to do this, but because there was very little overlap in Person
# attributes and due to time constraints, collapses were few and far between thus requiring cherry picked Persons.
_nih_pi_ids = ("1985470", "1867148", "1876415")


database = db.Database(
    host="mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com",
    port=3306,
    user="",
    password="",
    database="UMETRICS")


for _nih_pi_id in _nih_pi_ids:
    _html_file = html_file.HTMLFile(_nih_pi_id, database)
    _html_file.dump_html_file()


database.close()
