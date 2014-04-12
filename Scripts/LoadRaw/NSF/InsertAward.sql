################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

insert into Award
(
    AwardTitle,
    AwardEffectiveDate,
    AwardExpirationDate,
    AwardAmount,
    AwardInstrument,
    AwardInstrumentCode,
    OrganizationCode,
    Directorate,
    DirectorateAbbreviation,
    DirectorateCode,
    Division,
    DivisionAbbreviation,
    DivisionCode,
    ProgramOfficer,
    AbstractNarration,
    MinAmdLetterDate,
    MaxAmdLetterDate,
    ARRAAmount,
    AwardID,
    IsHistoricalAward
) values (
    %(AwardTitle)s,
    str_to_date(%(AwardEffectiveDate)s, '%m/%d/%Y'),
    str_to_date(%(AwardExpirationDate)s, '%m/%d/%Y'),
    %(AwardAmount)s,
    %(AwardInstrument)s,
    %(AwardInstrumentCode)s,
    %(OrganizationCode)s,
    %(Directorate)s,
    %(DirectorateAbbreviation)s,
    %(DirectorateCode)s,
    %(Division)s,
    %(DivisionAbbreviation)s,
    %(DivisionCode)s,
    %(ProgramOfficer)s,
    %(AbstractNarration)s,
    str_to_date(%(MinAmdLetterDate)s, '%m/%d/%Y'),
    str_to_date(%(MaxAmdLetterDate)s, '%m/%d/%Y'),
    %(ARRAAmount)s,
    %(AwardID)s,
    %(IsHistoricalAward)s
)
