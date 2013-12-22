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
import __string__ as s


def get_person_attributes(database, person_id):
    """A person can have more than one attribute.  Get all the attributes for the person indicated."""

    query = """
        select
            a.AttributeId,
            pa.RelationshipCode,
            a.Attribute,
            coalesce(pas.RelationshipCodeWeight, 0.0) RelationshipCodeWeight
        from
            Attribute a
            inner join PersonAttribute pa on
            pa.AttributeId = a.AttributeId and
            pa.PersonId = %d
            left outer join UMETRICSSupport.PersonAttributeStatistics pas on
            pas.RelationshipCode = pa.RelationshipCode;
    """ % person_id
    person_attributes = []
    rows = database.get_all_rows(query)
    for row in rows:
        person_attribute = PersonAttribute(row[0], row[1], row[2], row[3])
        if person_attribute.is_populated:
            person_attributes.append(person_attribute)
    return person_attributes


def any_attributes_match(database, person_attributes, candidate_person_id):
    """Check to see if any of the candidate person's attributes match the current person's"""

    candidate_person_attributes = get_person_attributes(database, candidate_person_id)
    for person_attribute in person_attributes:
        for candidate_person_attribute in candidate_person_attributes:
            if person_attribute.is_similar(candidate_person_attribute):
                return True
    return False


class PersonAttribute:
    """Simplistic class to hold a PersonAttribute"""

    def __init__(self, id, relationship, attribute, weight):
        self.id = id
        self.relationship = common.standardize_text(relationship)
        self.attribute = common.standardize_text(attribute)
        self.weight = weight
        self.concat = s.nullify_blanks(s.make_string([self.relationship, self.attribute]))
        self.is_populated = self.concat is not None

    def is_similar(self, other_person_attribute):
        if not self.is_populated or not other_person_attribute.is_populated:
            return False
        if self.relationship != other_person_attribute.relationship:
            return False
        if self.id == other_person_attribute.id:
            return True
        return (self.weight > 0.9 and self.attribute == other_person_attribute.attribute)

    # TODO: Add more sophisticated matching
