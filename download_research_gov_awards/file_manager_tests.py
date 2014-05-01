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
import unittest
from datetime import date
from file_manager import FileManager


class FileManagerTests(unittest.TestCase):

    def test_file_name_generation(self):

        file_manager = FileManager()
        self.assertRaises(ValueError, file_manager.generate_full_file_path, None, None)
        self.assertRaises(ValueError, file_manager.generate_full_file_path, date(2001, 1, 1), None)
        self.assertRaises(ValueError, file_manager.generate_full_file_path, None, date(2001, 1, 1))
        self.assertRaises(TypeError, file_manager.generate_full_file_path, "2001-01-01", date(2001, 1, 1))
        self.assertRaises(TypeError, file_manager.generate_full_file_path, date(2001, 1, 1), "2001-01-01")
        self.assertRaises(ValueError, file_manager.generate_full_file_path, date(2005, 1, 1), date(1999, 7, 15))

        s = file_manager.generate_full_file_path(date(1999, 7, 15), date(2005, 1, 1))
        split = os.path.split(s)
        self.assertEqual(split[0], os.path.dirname(os.path.realpath(__file__)) + "\\downloads")
        self.assertEqual(split[1], "research_gov_1999-07-15_2005-01-01.xml")

    def test_most_recent_download_date(self):

        test_directory = os.path.dirname(os.path.realpath(__file__)) + "\\test_" +\
            datetime.datetime.today().strftime("%Y%m%d%H%M%S%f")

        file_manager = FileManager(test_directory)

        self.assertEqual(os.path.isdir(test_directory), False)  # Make sure directory doesn't already exist
        self.assertEqual(file_manager.get_most_recent_download_date(), None)  # Directory doesn't exist.  Should return None.

        os.mkdir(test_directory)
        self.assertEqual(file_manager.get_most_recent_download_date(), None)  # Directory is empty.  Should return None.

        test_filename = test_directory + "\\this_is_a_test.xml"
        open(test_filename, "a").close()
        self.assertEqual(file_manager.get_most_recent_download_date(), None)  # Directory with no properly formatted file names.  Should return None.

        test_filename = test_directory + "\\research_gov_2001-07-02_2005-01-30.xml"
        open(test_filename, "a").close()
        self.assertEqual(file_manager.get_most_recent_download_date(), date(2005, 1, 30))  # Only one valid file name.  Make sure the date is what we expected.

        test_filename = test_directory + "\\research_gov_2001-07-02_2006-02-28.xml"
        open(test_filename, "a").close()
        test_filename = test_directory + "\\research_gov_2001-07-02_2002-03-14.xml"
        open(test_filename, "a").close()
        test_filename = test_directory + "\\research_gov_2001-07-02_2006-02-27.xml"
        open(test_filename, "a").close()
        self.assertEqual(file_manager.get_most_recent_download_date(), date(2006, 2, 28))  # Several valid file names. Make sure the correct date is returned.

        # Clean up.  Can also use shutil.rmtree, but that's a little scary.  NOTE that if any test fails, clean up will
        # not occur...
        os.remove(test_directory + "\\this_is_a_test.xml")
        os.remove(test_directory + "\\research_gov_2001-07-02_2005-01-30.xml")
        os.remove(test_directory + "\\research_gov_2001-07-02_2006-02-28.xml")
        os.remove(test_directory + "\\research_gov_2001-07-02_2002-03-14.xml")
        os.remove(test_directory + "\\research_gov_2001-07-02_2006-02-27.xml")
        os.rmdir(test_directory)


if __name__ == '__main__':
    unittest.main()
