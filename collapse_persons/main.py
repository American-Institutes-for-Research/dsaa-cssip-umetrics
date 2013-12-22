################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
"""
Here's how version 0 of this is going to work:

  The overall goal is to identify candidates for collapse and collapse those that meet a predetermined threshold.
  Currently, candidates are identified using NAME ONLY.  This is fairly crude but is the lowest hanging fruit.  If
  names are even remotely similar, they will run through the following steps to confirm their candidacy for collapse.

  Step 1: Compare names.  Names are the first and most stringent test.  If the names aren't even close, we're not
          going to continue.  TODO: Add more blocking/clustering/chunking techniques and more sophisticated matching
          techniques.  This version is intended to get the ball rolling/discussion started.

  Step 2: If we get past name comparison, we will start comparing other factors.  First will be the address.  If
          a name matches and an address matches, there's a very strong chance they're the same person, but there's
          always the chance of someone with a similar name at the same address, so we'll need to be careful.

  Step 3: Compare attributes.  Attributes can be anything; email addresses, phone numbers, NIH PI Ids, etc.  We've
          previously calculated some statistics on our various attributes to help us determine how strong an
          attribute/attribute type is at identifying a person.  If we find strong attributes that match, there's a
          good possibility that we're looking at the same person.

  Step 4: GrantAwards.  If these persons are on the same grant, that's a pretty good indicator.  Of course, we've
          seen two people with the same name on a grant before, so even this isn't 100%.

  Step 5: GrantPublication.  Same as Step 4 except with publications.

We are not using PersonTerms yet.  TODO: Possibly take terms into account for persons.

All collapses will occur in a downward fashion based on PersonId.  That is to say, since PersonId is assigned
serially, newer persons will be collapsed into older ones.

And this is a very important point... In the past, we've seen two different people with the same name listed on the
same article.  A little research on the Internet confirmed that these were two different people, working in the same
lab, for the same PI, and published together on the same paper.  I do not know how we are possibly going to prevent
collapses in such situations.  I guess it's possible to identify such situations by looking specifically for cases
where a name is listed more than once on a paper.

FOR VERSION 0, WE WILL NOT GET INTO THAT LEVEL OF DETAIL.  VERSION 0 IS BASICALLY A PROOF OF CONCEPT IN THAT WE WANT
TO DEMONSTRATE WHAT'S POSSIBLE WITHOUT BOGGING OURSELVES DOWN WITH FRINGE CASES.  The next release will need to be
more sophisticated.
"""
import os, sys
import person
import person_name
import person_address
import person_attribute
import person_grant_award
import person_publication
sys.path.append(os.path.abspath('../Shared'))
import __database__ as db

if len(sys.argv) != 1 and len(sys.argv) != 3:
    raise "Incorrect number of parameters. Should be none or two; [<start_id> <end_id>]"

start_id = None
end_id = None
if len(sys.argv) == 3:
    if not sys.argv[1].isnumeric() or not sys.argv[2].isnumeric():
        raise "Parameters must be numeric; [<start_id> <end_id>]"
    start_id = sys.argv[1]
    end_id = sys.argv[2]

database = db.Database("localhost", 3306, "", "", "UMETRICS")

# Start looping through persons.  If we receive back a None, there's nothing to be processed.
person_id = person.get_person_id(database, start_id, end_id)
while person_id is not None:

    move_on = True

    # Get the current person's names.
    person_names = person_name.get_person_names(database, person_id)

    # No sense continuing if we don't have names.  They're our primary matching point.
    if person_names:

        # Get stuff for matching this person.
        person_addresses = person_address.get_person_addresses(database, person_id)
        person_attributes = person_attribute.get_person_attributes(database, person_id)
        person_grant_awards = person_grant_award.get_person_grant_awards(database, person_id)
        person_publications = person_publication.get_person_publications(database, person_id)

        # Get person ids for people whose names might match the current person's names.
        candidate_person_ids = person.get_person_candidates(database, person_id)

        # Start looping through candidates.
        for candidate_person_id in candidate_person_ids:
            if person_name.any_names_match(database, person_names, candidate_person_id):
                notes = ["Name match found"]
                votes = 0
                if person_addresses and \
                        person_address.any_addresses_match(database, person_addresses, candidate_person_id):
                    notes.append("Address match found")
                    votes += 1
                if person_attributes and \
                        person_attribute.any_attributes_match(database, person_attributes, candidate_person_id):
                    notes.append("Attribute match found")
                    votes += 1
                if person_grant_awards and \
                        person_grant_award.any_grant_awards_match(database, person_grant_awards, candidate_person_id):
                    notes.append("GrantAward match found")
                    votes += 1
                if person_publications and \
                        person_publications.any_publications_match(database, person_publications, candidate_person_id):
                    notes.append("Publication match found")
                    votes += 1

                if votes > 1:
                    full_notes = "; ".join(notes)
                    database.execute("call UMETRICSSupport.CollapsePersons(%d, %d, '%s')" %
                                     (person_id, candidate_person_id, full_notes), commit=True)
                    move_on = False
                    break

    # If we've performed a collapse, we're going to reprocess this person to see if there are more collapses.  We'll
    # keep doing this until there are no more collapses for this person.
    if move_on:

        # Mark person as "crawled".
        person.mark_crawled(database, person_id)

        # Get the next person_id
        person_id = person.get_person_id(database, start_id, end_id)

database.close()
