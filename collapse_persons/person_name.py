################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import common, os, sys
sys.path.append(os.path.abspath('../Shared'))
sys.path.append(os.path.abspath('../ThirdParty'))
import __string__ as s
from jellyfish import jellyfish


def get_person_names(database, person_id):
    """A person can have more than one name.  Get all the names for the person indicated."""

    query = """
        select
            pn.PersonNameId,
            pn.GivenName,
            pn.OtherName,
            pn.FamilyName,
            pn.FullName
        from
            PersonName pn
        where
            pn.PersonId = %d;
    """ % person_id
    person_names = []
    rows = database.get_all_rows(query)
    for row in rows:
        person_name = PersonName(row[0], row[1], row[2], row[3], row[4])
        if person_name.is_populated:
            person_names.append(person_name)
    return person_names


def any_names_match(database, person_names, candidate_person_id):
    """Check to see if any of the candidate person's names match the current person's"""

    candidate_person_names = get_person_names(database, candidate_person_id)
    for person_name in person_names:
        for candidate_person_name in candidate_person_names:
            if person_name.is_similar(candidate_person_name):
                return True
    return False


class PersonName:
    """
        Simplistic class to hold a PersonName.  For this version, we will only work with split out names, not full
        names.  It is the responsibility of the PersonName crawler to figure out how to split up full names.
    """

    def __init__(self, id, given, other, family, full_name):
        self.id = id
        self.given = common.standardize_text(given)
        self.other = common.standardize_text(other)
        self.family = common.standardize_text(family)
        self.concat = s.nullify_blanks(s.make_string([self.given, self.other, self.family]))
        self.is_populated = self.concat is not None

    def is_similar(self, other_person_name):
        if self.family is None or other_person_name.family is None:
            return False
        if self.id == other_person_name.id:
            return True

        # This seems redundant-ish, but Levenshtein is fairly inefficient.  If we can reduce runs through the
        # here, it should help speed things up a bit.
        if self.family != other_person_name.family and \
                        jellyfish.damerau_levenshtein_distance(self.family, other_person_name.family) > 1:
            return False

        if (self.given is None and self.other is None) or \
                (other_person_name.given is None and other_person_name.other is None):
            return True

        if ((self.given is not None or other_person_name.other is not None) and
                (self.other is not None or other_person_name.given is not None) and
                not common.names_conflict(self.given, other_person_name.given) and
                     not common.names_conflict(self.other, other_person_name.other)):
            return True

        if ((self.given is not None or other_person_name.given is not None) and
                (self.other is not None or other_person_name.other is not None) and
                not common.names_conflict(self.given, other_person_name.other) and
                     not common.names_conflict(self.other, other_person_name.given)):
            return True

        return False
