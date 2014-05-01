################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import os
import datetime
import constants
import xml.parsers.expat


class FileManager:
    """
    Having a class here is a bit of overkill as this is really just a couple of related functions.  The idea here is
    that we just need a couple of functions to tell us the most recent download date and create new file names for us.
    Eventually, we might also want to remove files back to a certain period in time just in case Research.gov updates
    older files and we need to re-download them.  Anyhow, we'll leave it as a class in case we decide to add anything
    in the future and to guarantee that everyone is using the same set of values.
    """


    def __init__(self, destination_path=constants.DOWNLOAD_DESTINATION_PATH):

        self.destination_path = destination_path


    def create_download_directory(self):

        if not os.path.isdir(self.destination_path):
            os.mkdir(self.destination_path)


    @staticmethod
    def remove_file(file_name):

        if os.path.exists(file_name):
            os.remove(file_name)


    def generate_full_file_path(self, start_date, end_date):

        if start_date is None:
            raise ValueError("start_date is required")

        if end_date is None:
            raise ValueError("end_date is required")

        if type(start_date) is not datetime.date:
            raise TypeError("start_date must be a datetime.date")

        if type(end_date) is not datetime.date:
            raise TypeError("end_date must be a datetime.date")

        if end_date < start_date:
            raise ValueError("end_date must fall on or after start_date")

        return os.path.join\
        (
            self.destination_path,
            constants.DOWNLOAD_FILE_FORMAT %
            {
                "start_date" : start_date.strftime(constants.DOWNLOAD_FILE_DATE_FORMAT),
                "end_date" : end_date.strftime(constants.DOWNLOAD_FILE_DATE_FORMAT)
            }
        )


    # This actually pulls from the file name, not any timestamp associated with the file.
    def get_most_recent_download_date(self):

        most_recent_download_date = None
        if os.path.isdir(self.destination_path):
            file_names = os.listdir(self.destination_path)
            if file_names:
                for file_name in file_names:
                    if file_name.startswith(constants.DOWNLOAD_FILE_PREFIX):
                        findall = constants.DOWNLOAD_FILE_NAME_DATE_EXTRACT_REGEX.findall(file_name)
                        if len(findall) == 2:
                            end_date = datetime.datetime.strptime(findall[1], "%Y-%m-%d").date()
                            if most_recent_download_date is None or end_date > most_recent_download_date:
                                most_recent_download_date = end_date

        return most_recent_download_date


    # Just performs simple xml validation for well formedness.  Does not validate against a schema.
    @staticmethod
    def is_xml_file_well_formed(file_path):

        try:
            parser = xml.parsers.expat.ParserCreate()
            parser.ParseFile(open(file_path, "r"))

        except Exception:
            return False

        return True
