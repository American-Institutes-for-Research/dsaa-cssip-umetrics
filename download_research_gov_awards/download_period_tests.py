################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import unittest
from datetime import date
from download_period import DownloadPeriod


# The reason I didn't use constants for start and end dates is because, for some tests, I needed more flexibility, so
# I just universally decided to hardcode dates everywhere.  Bad decision?  Only time will tell...
class DownloadPeriodTests(unittest.TestCase):

    def test_bad_construction(self):
        self.assertRaises(TypeError, DownloadPeriod, absolute_start_date="2001-01-01")
        self.assertRaises(TypeError, DownloadPeriod, absolute_end_date="2001-01-01")
        self.assertRaises(ValueError, DownloadPeriod, date(2005, 1, 1), date(1999, 7, 15))

    def test_good_construction(self):
        d = DownloadPeriod(date(1999, 7, 15), date(2005, 1, 1))
        self.assertEqual(d.absolute_start_date, date(1999, 7, 15))
        self.assertEqual(d.absolute_end_date, date(2005, 1, 1))
        self.assertEqual(d.current_start_date, date(1999, 7, 15))
        self.assertEqual(d.period, DownloadPeriod.period_year)
        self.assertEqual(d.current_end_date, date(1999, 12, 31))

    def test_period_downgrade(self):
        d = DownloadPeriod(date(1999, 7, 15), date(2005, 1, 1))
        self.assertEqual(d.current_end_date, date(1999, 12, 31))
        d.downgrade_period()  # downgrade to month
        self.assertEqual(d.current_end_date, date(1999, 7, 31))
        d.downgrade_period()  # downgrade to week
        self.assertEqual(d.current_end_date, date(1999, 7, 18))
        d.downgrade_period()  # downgrade to day
        self.assertEqual(d.current_end_date, date(1999, 7, 15))
        self.assertRaises(ValueError, d.downgrade_period)  # cannot downgrade below period_day

    def test_iteration(self):
        d = DownloadPeriod(date(1999, 7, 15), date(2001, 12, 5))
        self.assertEqual(d.current_start_date, date(1999, 7, 15))
        self.assertEqual(d.current_end_date, date(1999, 12, 31))

        d.increment_period()
        self.assertEqual(d.current_start_date, date(2000, 1, 1))
        self.assertEqual(d.current_end_date, date(2000, 12, 31))

        d.downgrade_period()
        self.assertEqual(d.current_start_date, date(2000, 1, 1))
        self.assertEqual(d.current_end_date, date(2000, 1, 31))

        d.increment_period()
        self.assertEqual(d.current_start_date, date(2000, 2, 1))
        self.assertEqual(d.current_end_date, date(2000, 2, 29))

        d.increment_period()
        self.assertEqual(d.current_start_date, date(2000, 3, 1))
        self.assertEqual(d.current_end_date, date(2000, 3, 31))

        d.downgrade_period()
        self.assertEqual(d.current_start_date, date(2000, 3, 1))
        self.assertEqual(d.current_end_date, date(2000, 3, 5))

        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        self.assertEqual(d.current_start_date, date(2000, 3, 27))
        self.assertEqual(d.current_end_date, date(2000, 3, 31))

        d.increment_period()
        self.assertEqual(d.current_start_date, date(2000, 4, 1))
        self.assertEqual(d.current_end_date, date(2000, 4, 30))

        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        self.assertEqual(d.current_start_date, date(2001, 1, 1))
        self.assertEqual(d.current_end_date, date(2001, 12, 5))

        d.downgrade_period()
        d.downgrade_period()
        d.downgrade_period()
        self.assertEqual(d.current_start_date, date(2001, 1, 1))
        self.assertEqual(d.current_end_date, date(2001, 1, 1))

        d.increment_period()
        self.assertEqual(d.current_start_date, date(2001, 1, 2))
        self.assertEqual(d.current_end_date, date(2001, 1, 2))

        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        self.assertEqual(d.current_start_date, date(2001, 1, 8))
        self.assertEqual(d.current_end_date, date(2001, 1, 14))

        d.increment_period()
        d.increment_period()
        d.increment_period()
        self.assertEqual(d.current_start_date, date(2001, 1, 29))
        self.assertEqual(d.current_end_date, date(2001, 1, 31))

        d.increment_period()
        self.assertEqual(d.current_start_date, date(2001, 2, 1))
        self.assertEqual(d.current_end_date, date(2001, 2, 28))

        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        d.increment_period()
        self.assertEqual(d.current_start_date, date(2001, 12, 1))
        self.assertEqual(d.current_end_date, date(2001, 12, 5))

        end_year = 2001
        start_year = end_year - 3
        d = DownloadPeriod(date(start_year, 7, 15), date(end_year, 12, 31))
        while d:
            self.assertEqual(d.current_end_date, date(start_year, 12, 31))
            start_year += 1
            d = d.increment_period()


if __name__ == '__main__':
    unittest.main()
