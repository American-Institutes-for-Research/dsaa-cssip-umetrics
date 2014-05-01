################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import datetime
import calendar
import constants

class DownloadPeriod:
    """
    Class to handle the iteration of Research.gov download periods.  Due to download limitations of the web site, we
    are going to implement a variable periodization system to allow us to shrink and grow download periods on the fly
    to try and maximize the number of downloads in a single batch.  See constants.MAX_RESEARCH_GOV_ROWS for the maximum
    number of grant awards that can be downloaded at once.

    First, we will try to download XML files along year boundaries.  If there are too many for a single year, we will
    drop back to month boundaries for that year.  If a month contains too many, we will drop back to week boundaries
    (Monday - Sunday) for that month.  If we encounter weeks that contain too many, we will drop back to days.  We want
    to strictly fall along year and month boundaries as much as possible, so block sizes will be re-upgraded after
    a month or year completes.  So, for example, if we end up downloading the last week of December at the day
    granularity, we will re-try year boundaries for January 1st of the following year.
    """


    # "Enumeration" of our period sizes.
    period_day, period_week, period_month, period_year = range(4)


    def __init__(self,
                absolute_start_date=constants.EARLIEST_GRANT_AWARD_DATE,
                absolute_end_date=constants.MOST_RECENT_GRANT_AWARD_DATE):

        if absolute_start_date is None:
            raise ValueError("absolute_start_date is required")

        if absolute_end_date is None:
            raise ValueError("absolute_end_date is required")

        if type(absolute_start_date) is not datetime.date:
            raise TypeError("absolute_start_date must be a datetime.date")

        if type(absolute_end_date) is not datetime.date:
            raise TypeError("absolute_end_date must be a datetime.date")

        if absolute_end_date < absolute_start_date:
            raise ValueError("absolute_end_date must fall on or after absolute_start_date")

        self.absolute_start_date = absolute_start_date
        self.absolute_end_date = absolute_end_date
        self.period = self.period_year
        self.current_start_date = absolute_start_date
        self.current_end_date =\
            self._get_end_of_current_period(self.current_start_date, self.period, self.absolute_end_date)


    def increment_period(self):

        if self.current_end_date >= self.absolute_end_date:
            return None

        self.current_start_date = self._get_start_of_next_period(self.current_end_date)
        self.period = self._get_recommended_period(self.current_start_date)
        self.current_end_date =\
            self._get_end_of_current_period(self.current_start_date, self.period, self.absolute_end_date)

        return self


    def downgrade_period(self):

        if self.period <= self.period_day:
            raise ValueError("period cannot be reduced below period_day")

        self.period -= 1
        self.current_end_date =\
            self._get_end_of_current_period(self.current_start_date, self.period, self.absolute_end_date)

        return self



    def _get_start_of_next_period(self, end_date):

        if end_date is None:
            raise ValueError("end_date is required")

        if type(end_date) is not datetime.date:
            raise TypeError("end_date must be a datetime.date")

        return end_date + datetime.timedelta(days=1)


    def _get_recommended_period(self, start_date):

        if start_date is None:
            raise ValueError("start_date is required")

        if type(start_date) is not datetime.date:
            raise TypeError("start_date must be a datetime.date")

        # If beginning of a new year, let's try annual periods.
        if start_date.month == 1 and start_date.day == 1:
            return self.period_year

        # If beginning of a new month, let's try monthly periods.
        if start_date.day == 1:
            return self.period_month

        # If beginning of a new week, let's try weekly periods.
        if start_date.weekday() == 0:
            return self.period_week

        return self.period_day


    def _get_end_of_current_period(self, start_date, period, absolute_end_date):

        if start_date is None:
            raise ValueError("start_date is required")

        if type(start_date) is not datetime.date:
            raise TypeError("start_date must be a datetime.date")

        if type(period) is not int:
            raise TypeError("period must be an int")

        if period == self.period_day:
            return start_date

        # Smaller of Sunday or end of month.  Remember, we're trying really hard to fall along month boundaries.
        if period == self.period_week:
            candidate = min(
                start_date + datetime.timedelta(days=(6 - start_date.weekday())),
                datetime.date(
                    start_date.year,
                    start_date.month,
                    calendar.monthrange(start_date.year, start_date.month)[1]
                )
            )

        elif period == self.period_month:
            candidate = datetime.date(
                start_date.year,
                start_date.month,
                calendar.monthrange(start_date.year, start_date.month)[1]
            )

        elif period == self.period_year:
            candidate = min(
                datetime.date(start_date.year, 12, 31),
                self.absolute_end_date
            )

        else:
            raise ValueError("Unrecognized period %s" % period)

        return min(candidate, absolute_end_date)
