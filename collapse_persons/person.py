################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
def _get_fresh_person_id(database, start_id, end_id):
    """Get us someone who hasn't been crawled yet."""

    addendum = ""
    if start_id is not None and end_id is not None:
        addendum = "and p.PersonId between %s and %s" % (start_id, end_id)

	# hack to grab just CIC PIs
    query = """
		select distinct
			pga.PersonId
		from
			Institute.CICOrganizations cico
			inner join UMETRICS.OrganizationGrantAward oga on
				oga.OrganizationId = cico.OrganizationId and
				oga.RelationshipCode = 'AWARDEE'
			inner join UMETRICS.PersonGrantAward pga on
				pga.GrantAwardId = oga.GrantAwardId and
				pga.RelationshipCode = 'PI'
			left outer join UMETRICSSupport.CollapsePersonsCrawler cpc on
				cpc.PersonId = pga.personId
		where
			cpc.PersonId is null
		limit 1;
	"""

    #query = """
    #    select
    #        p.PersonId
    #    from
    #        Person p
    #        left outer join UMETRICSSupport.CollapsePersonsCrawler cpc on
    #        cpc.PersonId = p.PersonId
    #    where
    #        cpc.PersonId is null %s
    #    limit
    #        1;
    #""" % addendum
    return database.get_scalar(query)


def _get_stale_person_id(database, start_id, end_id):
    """
    Get us someone who hasn't been crawled recently.  For now, we'll use a 30 day window.  If everyone's been crawled in
    the past 30 days, then there's nothing to do.  TODO: Obviously, the number of days should go in a config file.
    """

    addendum = ""
    if start_id is not None and end_id is not None:
        addendum = "and p.PersonId between %s and %s" % (start_id, end_id)

    query = """
        select
            p.PersonId
        from
            Person p
            inner join UMETRICSSupport.CollapsePersonsCrawler cpc on
            cpc.PersonId = p.PersonId
        where
            cpc.CrawledDateTime < now() - interval 30 day %s
        order by
            cpc.CrawledDateTime
        limit
            1;
    """ % addendum
    return database.get_scalar(query)


def mark_crawled(database, person_id):
    """Mark this person as "crawled"."""

    query = """
        insert into UMETRICSSupport.CollapsePersonsCrawler
            (PersonId, CrawledDateTime)
        values
            (%d, now())
        on duplicate key update
            CrawledDateTime = now();
    """ % person_id
    database.execute(query, commit=True)


def get_person_id(database, start_id, end_id):
    """Get a person id.  First try to get a fresh id.  If there are none, get a stale one."""

    person_id = _get_fresh_person_id(database, start_id, end_id)
    if person_id is None:
        person_id = _get_stale_person_id(database, start_id, end_id)
    return person_id


def get_person_candidates(database, person_id):
    """Get us everyone whose name has something in common with the current person's name(s)."""

    query = """
        select distinct
            pn2.PersonId
        from
            PersonName pn1
            inner join UMETRICSSupport.PersonNameTokens pnt1 on
            pnt1.PersonNameId = pn1.PersonNameId
            inner join UMETRICSSupport.PersonNameTokens pnt2 on
            pnt2.Token = pnt1.Token
            inner join PersonName pn2 on
            pn2.PersonNameId = pnt2.PersonNameId
        where
            pn1.PersonId = %d and
            pn2.PersonId != %d;
    """ % (person_id, person_id)
    candidate_person_ids = []
    rows = database.get_all_rows(query)
    for row in rows:
        candidate_person_ids.append(row[0])
    return candidate_person_ids
