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


def get_person_addresses(database, person_id):
    """A person can have more than one address.  Get all the addresses for the person indicated."""

    query = """
        select
            a.AddressId,
            a.Street1,
            a.Street2,
            a.City,
            a.CountyEquivalent,
            a.StateEquivalent,
            a.PostalCode,
            a.CountryName,
            a.FullAddress
        from
            Address a
            inner join PersonAddress pa on
            pa.AddressId = a.AddressId and
            pa.PersonId = %d;
    """ % person_id
    person_addresses = []
    rows = database.get_all_rows(query)
    for row in rows:
        person_address = PersonAddress(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8])
        if person_address.is_populated:
            person_addresses.append(person_address)
    return person_addresses


def any_addresses_match(database, person_addresses, candidate_person_id):
    """Check to see if any of the candidate person's addresses match the current person's"""

    candidate_person_addresses = get_person_addresses(database, candidate_person_id)
    for person_address in person_addresses:
        for candidate_person_address in candidate_person_addresses:
            if person_address.is_similar(candidate_person_address):
                return True
    return False


class PersonAddress:
    """Simplistic class to hold a PersonAddress"""

    def __init__(self, id, street1, street2, city, county_equivalent, state_equivalent, postal_code, country_name,
                 full_address):
        self.id = id
        self.street1 = common.standardize_text(street1)
        self.street2 = common.standardize_text(street2)
        self.city = common.standardize_text(city)
        self.county_equivalent = common.standardize_text(county_equivalent)
        self.state_equivalent = common.standardize_text(state_equivalent)
        self.postal_code = common.standardize_text(postal_code)
        self.country_name = common.standardize_text(country_name)
        self.full_address = common.standardize_text(full_address)
        self.concat = s.nullify_blanks(string.make_string([self.street1, self.street2, self.city,
                                                           self.county_equivalent, self.state_equivalent,
                                                           self.postal_code, self.country_name]))
        if self.concat is None:
            self.concat = self.full_address
        self.is_populated = self.concat is not None

    def is_similar(self, other_person_address):
        if not self.is_populated or not other_person_address.is_populated:
            return False
        if self.id == other_person_address.id:
            return True
        return (jellyfish.damerau_levenshtein_distance(self.concat, other_person_address.concat) < 3 and
            len(self.concat) > 20)

    # TODO: Add more sophisticated matching
