################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
def get_person_grant_awards(database, person_id):
    """A person can have more than one grant award.  Get all the grant awards for the person indicated."""

    query = """
        select
            GrantAwardId
        from
            PersonGrantAward
        where
            PersonId = %d
    """ % person_id
    person_grant_awards = []
    rows = database.get_all_rows(query)
    for row in rows:
        person_grant_award = PersonGrantAward(row[0])
        if person_grant_award.is_populated:
            person_grant_awards.append(person_grant_award)
    return person_grant_awards


def any_grant_awards_match(database, person_grant_awards, candidate_person_id):
    """Check to see if any of the candidate person's grant awards match the current person's"""

    candidate_person_grant_awards = get_person_grant_awards(database, candidate_person_id)
    for person_grant_award in person_grant_awards:
        for candidate_person_grant_award in candidate_person_grant_awards:
            if person_grant_award.is_similar(candidate_person_grant_award):
                return True
    return False


class PersonGrantAward:
    """Simplistic class to hold a PersonGrantAward"""

    def __init__(self, id):
        self.id = id
        self.concat = "%d" % self.id
        self.is_populated = self.concat is not None

    # This is SUPER trivial for GrantAwards.  The assumption here is that GrantAwards have been collapsed down so that
    # there is only one record per award.  If the two people are on the same award, that might be an indication that
    # they are the same person.  Then again, it may be an indication that there are two people on the award with the
    # same name which would actually be a very strong vote AGAINST collapsing.  We're going to leave it this way for
    # now.  The next phase of this project may see us doing this a different way.
    def is_similar(self, other_person_grant_award):
        if not self.is_populated or not other_person_grant_award.is_populated:
            return False
        return self.id == other_person_grant_award.id

    # TODO: See if this type of matching should be a vote for or a vote against collapsing.  Or maybe it's just
    # muddying the situation and we should ignore it as evidence altogether.
