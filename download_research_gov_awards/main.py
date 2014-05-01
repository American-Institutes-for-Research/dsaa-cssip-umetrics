################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
"""
    Tool for downloading Research.gov grant awards from the Research.gov web site.  This is a screen scraper and, as
    such, comes with all the caveats typical of a screen scraper, the most important of which is that it is fragile and
    may break with the slightest change on the Research.gov web site.

    Because this tool uses the mechanize module and mechanize does not yet support Python 3+, Python 2.7 is required.

    This tool was developed and tested under:

        Windows 8.1
        Python 2.7.6
        BeautifulSoup 3.2.1 (installed using "easy_install BeautifulSoup")
        mechanize 0.2.5 (installed using "easy_install mechanize")

    Other configurations may work, but you're on your own.

    For the most part, this tool is completely self contained; you just fire it off and it does the rest.  The default
    location for downloaded files is a directory called "downloads" under the directory that contains main.py for
    the project.  It will pick up where it left off on the next run by examining already downloaded files.  If the
    downloads directory is empty, it will start downloading from 1980.  Check the constants.py file for a list of
    other default values.

    The easiest way to run this is to simply kick off main.py:

        python main.py

    Of course, exactly how you do this is dependent upon your configuration.

    IMPROVEMENTS

    Due to time and budgetary constraints, this is a bare bones version of the tool.  Some obvious improvements include:

        1)  Provide command line parameter support.  The download directory and start and end dates should be
            configurable from the command line.

        2)  Better logging.  Right now, the tool just dumps output in print statements.  While this isn't horrible and
            can be redirected to a file, logging directly to a file might be a better solution.

        3)  Better error handling.  Right now, the tool just crashes when it runs into a problem.  It would be nice if
            it were a little more graceful when things go awry.

        4)  More resiliency should be built in.  Related to #3, if there's a web problem, the app will just crash.  It
            would be better in the long run if it reattempted before crashing.  The web can be a flaky place sometimes.

        5)  Currently, the app is designed to pick up where it left off so, for example, if the last file downloaded
            was dated 2014-04-01 through 2014-04-30, on the next run, the app will attempt to download May of 2014.
            This is exactly how it is designed to behave, however, this leaves us some gray areas...

            --  The app doesn't know if files it has downloaded are complete.  It knows what dates it asked for, but it
                doesn't know if the data that were provided are the whole picture for that date range.  In fact, this
                would be very difficult for any app to know.  If I request data from 2014-04-01 through 2014-04-30 but
                only receive data from 2014-04-01 through 2014-04-15, is it because the data after 04-15 isn't available
                yet or is it because there actually are no grant awards after 04-15?  There's really no way to know
                without going back and requerying that date range again some time in the future.

            --  Similarly, how does Research.gov handle updates?  Does it update historical grant awards if something
                changes?  How do we pick up those changes?

            The simplest solution to both of these issues is to simply re-download grant award date ranges on occasion.
            At present, the app is not set up to do this.  It can be done manually be simply deleting some of the more
            recent download files, but the app should have a built-in lookback period of, say, 6 months or something so
            that every time it's run, it will redownload the previous 6 months and then, annually, it should probably be
            rebaselined.

            So, the short term solution?  Just delete 6 months worth of the most recent files in the downloads
            directory and then, annually, delete all the files in the downloads directory.  Long term solution?  Build
            that logic into the app.

            If you do this, though, it is important then for the loader app to be very resilient.  It will need to know
            that it will be receiving duplicated data and will need to be smart enough to handle it.
"""
import datetime
import constants
from scraper import Scraper
from file_manager import FileManager
from download_period import DownloadPeriod


def main():

    file_manager = FileManager()
    file_manager.create_download_directory()
    last_run_date = file_manager.get_most_recent_download_date()
    if last_run_date is None:
        start_date = constants.EARLIEST_GRANT_AWARD_DATE
    else:
        start_date = last_run_date + datetime.timedelta(days=1)

    if start_date <= constants.MOST_RECENT_GRANT_AWARD_DATE:

        download_period = DownloadPeriod(start_date)
        while download_period:

            # This is really inefficient, but we're going to create a new browser session for each request.  This is
            # because of how report results are presented.  It would be difficult to determine which results go with which
            # date ranges otherwise.
            with Scraper() as scraper:
                if scraper.get_query_results(file_manager, download_period):
                    download_period = download_period.increment_period()
                else:
                    download_period.downgrade_period()

    else:

        print "Downloads directory is up to date.  Quitting."


if __name__ == '__main__':
    main()
