################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import os
import re
import sys
import datetime
import mechanize

# The earliest grant award date we have found in Research.gov is in 1982.  To provide a little leeway, we will allow
# downloads back to 1/1/1980.  Adjust this if these findings change.
EARLIEST_GRANT_AWARD_DATE = datetime.date(1980, 1, 1)

# It appears that future grant awards do not exist in Research.gov, so we will simply limit downloads to today.
MOST_RECENT_GRANT_AWARD_DATE = datetime.date.today()

# The maximum number of grant award downloads in a single query (as restricted by the web site) is 2,000.  Research.gov
# returns a row count of 2,000 for any row count >= 2,000, so we will need to re-run queries that report 2,000 rows
# to get that row count down below the 2,000 number.
MAX_RESEARCH_GOV_ROWS = 2000

# The default location for download files.  This should be a subdirectory underneath the directory that contains
# the main Python file for the project.
DOWNLOAD_DESTINATION_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), "downloads")

# Prefix for download file names.
DOWNLOAD_FILE_PREFIX = "research_gov"

# Patterns for formatting a download file name (research_gov_2001-01-01_2005-01-01.xml).
DOWNLOAD_FILE_DATE_FORMAT = "%Y-%m-%d"
DOWNLOAD_FILE_FORMAT = DOWNLOAD_FILE_PREFIX + "_%(start_date)s_%(end_date)s.xml"

# Pattern for extracting the "to date" from a download file name.  Obviously, this needs to match the pattern in
# DOWNLOAD_FILE_DATE_FORMAT, just in RegEx form.
DOWNLOAD_FILE_NAME_DATE_EXTRACT_REGEX = re.compile("\d{4}-\d{2}-\d{2}")

# Base URL for Research.gov
BASE_URL = "http://www.research.gov"

# URL for simple search page.
SIMPLE_SEARCH_URL = BASE_URL +\
    "/research-portal/appmanager/base/desktop?_nfpb=true&_eventName=viewQuickSearchFormEvent_so_rsr"

# URL for submitting search queries.
SUBMIT_QUERY_URL = BASE_URL +\
    "/research-portal/appmanager/base/desktop?_nfpb=true&_windowLabel=T31400570011264188753337&wsrp-urlType=blockingAction&wsrp-url=&wsrp-requiresRewrite=&wsrp-navigationalState=eJyLL07OL0i1Tc-JT0rMUYNQtgBZ6Af8&wsrp-interactionState=wlpT31400570011264188753337_action%3DviewRsrAdvanceSearchForm&wsrp-mode=&wsrp-windowState="

# URL for initiating XML generation.
INITIATE_XML_GENERATION_URL = BASE_URL +\
    "/research-portal/resource?_windowLabel=T31400570011264188753337&wsrp-urlType=resource&wsrp-url=http%3A%2F%2Fwww.research.gov%3A80%2Frsr-portal%2FRsrExportServlet%3FrptType%3DXML&wsrp-requiresRewrite=true"

# URL for download files.
DOWNLOAD_PAGE_URL = BASE_URL +\
    "/research-portal/appmanager/base/desktop?_nfpb=true&_windowLabel=T31400570011264188753337&wsrp-urlType=render&wsrp-url=&wsrp-requiresRewrite=&wsrp-navigationalState=eJyLL07OL0i1Tc-JT0rMUYNQtuU5BSHGhiYGBqbmBgaGhkZmJoYWFuamxsbG5vGJySWZ*Xmqxi5FxUWuFQX5RSXBJYklpcUAcrsYGA&wsrp-interactionState=&wsrp-mode=&wsrp-windowState="

# User agent string.
PYTHON_VERSION = "%d.%d.%d" % (sys.version_info.major, sys.version_info.minor, sys.version_info.micro)
MECHANIZE_VERSION = "%d.%d.%d" % (mechanize.__version__[0], mechanize.__version__[1], mechanize.__version__[2])
USER_AGENT = "Mechanize/%s Python/%s (http://pypi.python.org/pypi/mechanize/)" % (MECHANIZE_VERSION, PYTHON_VERSION)

# Maximum number of times we will attempt to download a file before we give up.
XML_FILE_MAX_DOWNLOAD_ATTEMPTS = 5

# It takes a little time for XML files to be generated sometimes.  This is just a cheeseball method for giving the
# web site time to catch up.
XML_GENERATION_PAUSE_SECONDS = 6
