################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import time
import urllib
import cookielib
import constants
import mechanize
from BeautifulSoup import BeautifulSoup


class Scraper:

    def __init__(self):

        # Set up a browser.  We're going to use the RobustFactory to better handle malformed HTML.
        browser = mechanize.Browser(factory=mechanize.RobustFactory())

        # Open up a cookie jar for holding... wait for it... COOKIES!
        cookie_jar = cookielib.LWPCookieJar()
        browser.set_cookiejar(cookie_jar)

        # Set browser options.
        browser.set_handle_equiv(True)  # Handle HTTP-EQUIV headers (HTTP headers embedded in HTML).
        browser.set_handle_gzip(False)  # Disallow compressed content.  Enabling this caused problems on research.gov.
        browser.set_handle_redirect(True)  # Handle redirects automatically.
        browser.set_handle_referer(True)  # Add referrer header.
        browser.set_handle_robots(False)  # Ignore robots.txt... yeah... I know... BAD netizen... BAD!

        # Only allow one refresh.  Not sure we need this, but I've read that mechanize can hang if it receives a
        # refresh request, so we'll keep it just to be safe.
        browser.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=1)

        # Supply a user-agent. We fabricated this one. If it doesn't work with the web site, may need to experiment
        # until we find one that does. Not really rocket surgery.
        browser.addheaders = [("User-agent", constants.USER_AGENT)]

        self.browser = browser


    def __enter__(self):

        return self


    def close(self):

        if self.browser:
            self.browser.close()
            self.browser = None


    def __exit__(self, exc_type, exc_val, exc_tb):

        self.close()


    def _open_page(self, url):

        response = self.browser.open(url)
        if not response:
            raise RuntimeError("No response received")
        if not response.code == 200:
            raise RuntimeError("Received response %s.  Was expecting 200." % response.code)


    def _submit_query(self, start_date, end_date):

        data = urllib.urlencode({"awardFromDate" : start_date.strftime("%m/%d/%Y"), "awardToDate" : end_date.strftime("%m/%d/%Y")})
        data = data.encode("utf-8")
        response = self.browser.open(constants.SUBMIT_QUERY_URL, data)
        if not response:
            raise RuntimeError("No response received")
        if not response.code == 200:
            raise RuntimeError("Received response %s.  Was expecting 200." % response.code)

        # <div class="resultsFound"><b>No results found: "12/30/1974, 12/30/1974, All"</b></div>
        # <div class="resultsFound"><b>32 awards found : "12/30/1994, 12/30/1994, All"</b></div>

        soup = BeautifulSoup(response)
        div = soup.find("div", {"class" : "resultsFound"})
        if div:
            b = div.b
            if b:
                if b.text.startswith("No"):
                    return 0
                return int(b.text.partition(' ')[0])

        raise RuntimeError("Unable to find query result count")


    def _download_xml_file(self, file_manager, file_path):

        soup = BeautifulSoup(self.browser.response())
        links = soup.findAll("a")
        download_links = []
        for link in links:
            if link.text == "Download":
                download_links.append(link)

        if len(download_links) != 1:
            raise RuntimeError("Expected 1 download link, found %s" % len(links))

        url = constants.BASE_URL + download_links[0].get("href")

        file_manager.remove_file(file_path)
        for loop in range(1, constants.XML_FILE_MAX_DOWNLOAD_ATTEMPTS):

            # Sleep for a bit.
            time.sleep(constants.XML_GENERATION_PAUSE_SECONDS)

            response = self.browser.open(url)
            if not response:
                raise RuntimeError("No response received")
            if not response.code == 200:
                raise RuntimeError("Received response %s.  Was expecting 200." % response.code)

            # Testing has shown these files to be less than 1MB, so this should be safe for our purposes.  If a time
            # arrives where downloads become quite large, a chunking method will need to be implemented.
            xml = response.read()
            if len(xml) > 0:
                with open(file_path, 'wb') as handle:
                    handle.write(xml)
                if file_manager.is_xml_file_well_formed(file_path):
                    return
                else:
                    print "Downloaded XML file %s is not well formed. Trying again." % file_path
                    file_manager.remove_file(file_path)

        raise RuntimeError("XML file never became downloadable after several attempts")


    def get_query_results(self, file_manager, download_period):

        file_path = file_manager.generate_full_file_path(download_period.current_start_date,
                                                         download_period.current_end_date)

        status = "Attempting to download period %s through %s... " %\
            (
                download_period.current_start_date.strftime(constants.DOWNLOAD_FILE_DATE_FORMAT),
                download_period.current_end_date.strftime(constants.DOWNLOAD_FILE_DATE_FORMAT)
            )

        # For reasons I don't fully understand, we must first visit the simple search page before we can visit the
        # advanced search page.  Maybe it's required in order to set up session information?
        self._open_page(constants.SIMPLE_SEARCH_URL)

        # Submit our query to the advanced search page.
        count = self._submit_query(download_period.current_start_date, download_period.current_end_date)
        if count >= constants.MAX_RESEARCH_GOV_ROWS:
            status += "failed... search generated too many results"
            print status
            return False

        status += "succeeded... search generated %s results" % "{:,}".format(count)
        if count < 1:
            print status
            return True

        # Submit this query for XML generation.
        self._open_page(constants.INITIATE_XML_GENERATION_URL)

        # Go to query results page.
        self._open_page(constants.DOWNLOAD_PAGE_URL)

        # Download XML file.
        self._download_xml_file(file_manager, file_path)

        print status
        print "Downloaded to file %s" % file_path
        return True
