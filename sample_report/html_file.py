################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import os, mysql.connector, datetime, html, locale


def make_file_path_from_project_path(file_name):
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), file_name)


def read_file_contents(_file_path):
    """Read in the contents of a file.  Intended to be used for HTML template files, but could be used for any text
    file, theoretically."""

    _input_file = open(_file_path, 'r')
    _input_file_contents = _input_file.read()
    _input_file.close()
    return _input_file_contents


def write_file_contents(_file_path, _file_contents):
    """Write out the provided contents to a text file."""

    _output_file = open(_file_path, 'w')
    _output_file.write(_file_contents)
    _output_file.close()


def xstr(s):
    return '' if s is None else s


class HTMLFile:
    """Represents an HTML file in the sample_report project."""

    def __init__(self, nih_pi_id, database):
        locale.setlocale(locale.LC_ALL, '')

        _file_name = 'Sample Report - NIH_PI_ID_%s.html' % nih_pi_id
        _file_path = make_file_path_from_project_path(_file_name)

        if os.path.exists(_file_path):
            os.remove(_file_path)

        self.nih_pi_id = nih_pi_id
        self.file_name = _file_name
        self.file_path = _file_path
        self.database = database


    def dump_html_file(self):
        _person_ids = self._get_person_ids()

        if _person_ids:
            _person_name = self._get_person_name(_person_ids)

            _html_rows = []

            _aliases = self._get_aliases(_person_ids)
            _html_rows = self.format_html('e', "Aliases:", _aliases, _html_rows)

            _affiliations = self._get_affiliations(_person_ids)
            _html_rows = self.format_html('o', "Affiliations:", _affiliations, _html_rows)

            _attributes = self._get_attributes(_person_ids)
            _html_rows = self.format_html('e', "Attributes:", _attributes, _html_rows)

            _terms = self._get_mesh_terms(_person_ids)
            _html_rows = self.format_html('o', "MeSH Terms:", _terms, _html_rows)

            _grant_awards = self._get_grant_awards(_person_ids)
            _html_rows = self.format_grant_award_html('e', "Grant Awards:", _grant_awards, _html_rows)

            _publication = self._get_publications(_person_ids)
            _html_rows = self.format_publication_html('o', "Publications:", _publication, _html_rows)

            _html_template_file_path = make_file_path_from_project_path("template.html")
            _html_template_file_contents = read_file_contents(_html_template_file_path)
            _html_template_file_contents = _html_template_file_contents % {
                "PrimaryPersonName": _person_name,
                "CurrentDate": datetime.datetime.today(),
                "TableRows": '\n'.join(_html_rows)
            }

            write_file_contents(self.file_path, _html_template_file_contents)


    def _get_person_ids(self):
        _sql = """
            select
                FamilyName,
                left(GivenName, 1) GivenInitial,
                left(OtherName, 1) OtherInitial
            from
                PersonName pn
                inner join PersonAttribute pa on
                    pa.PersonId = pn.PersonId
                inner join Attribute a on
                    a.AttributeId = pa.AttributeId
            where
                pa.RelationshipCode = 'NIH_PI_ID' and
                a.Attribute = '%s'
            limit 1;
        """ % self.nih_pi_id
        _person_name = self.database.get_all_rows(_sql)

        if _person_name:
            _sql = """
                select distinct
                    PersonId
                from
                    PersonName
                where
                    FamilyName = '%s' and
                    (left(GivenName, 1) = '%s' or GivenName is null) and
                    (left(OtherName, 1) = '%s' or OtherName is null)
                order by
                    PersonId;
            """ % (_person_name[0][0], _person_name[0][1] or '', _person_name[0][2] or '')
            _rows = self.database.get_all_rows(_sql)

            if _rows:
                _person_ids = []
                for _row in _rows:
                    _person_ids.append(_row[0])
                return ", ".join(str(_person_id) for _person_id in _person_ids)

        return None


    def _get_person_name(self, _person_ids):
        _sql = """
            select
                (select FamilyName from PersonName where PersonId in (%s) order by char_length(FamilyName) desc limit 1),
                (select GivenName from PersonName where PersonId in (%s) order by char_length(GivenName) desc limit 1),
                (select OtherName from PersonName where PersonId in (%s) order by char_length(OtherName) desc limit 1)
        """ % (_person_ids, _person_ids, _person_ids)
        _person_names = self.database.get_all_rows(_sql)
        _person_name = _person_names[0]
        _flattened_person_name = " ".join(filter(None, (_person_name[1], _person_name[2])))
        if _flattened_person_name:
            return ", ".join((_person_name[0], _flattened_person_name)).upper()
        else:
            return _person_name[0].upper()


    def format_html(self, _class, _title, _rows, _html_rows):
        if not _rows:
            return ("<tr class='%s'><td>%s</td><td colspan='3'>%s</td></tr>" % (_class, _title, ""))
        title = _title
        for _row in _rows:
            _html_rows.append("<tr class='%s'><td>%s</td><td colspan='3'>%s</td></tr>" % (_class, title, html.escape(_row)))
            if title:
                title = ""
        return _html_rows


    def format_grant_award_html(self, _class, _title, _rows, _html_rows):
        if not _rows:
            return ("<tr class='%s'><td>%s</td><td colspan='3'>%s</td></tr>" % (_class, _title, ""))
        title = _title
        cclass = _class
        for _row in _rows:
            full_project_num = None
            subproject_id = None
            project_date = None
            project_cost = None
            if _row[1]:
                subproject_id = "[SUB %s]" % _row[1]
            if _row[0]:
                full_project_num = " ".join(filter(None, (_row[0], subproject_id)))
            if _row[2]:
                project_date = _row[2].strftime("%Y-%m-%d")
            if _row[3]:
                project_cost = locale.currency(_row[3], True, True)
            _html_rows.append("<tr class='%s'><td>%s</td><td>%s</td><td>%s</td><td align='right'>%s</td></tr>" % (cclass, title, xstr(project_date), xstr(full_project_num), xstr(project_cost)))
            if title:
                title = ""
            if _row[4]:
                _html_rows.append("<tr class='%s'><td>%s</td><td class='c' colspan='3'>%s</td></tr>" % (cclass, title, html.escape(_row[4])))
            else:
                _html_rows.append("<tr class='%s'><td>%s</td><td class='c' colspan='3'>title unknown</td></tr>" % (cclass, title))
            if cclass[-1:] == '2':
                cclass = _class
            else:
                cclass = _class + '2'
        return _html_rows


    def format_publication_html(self, _class, _title, _rows, _html_rows):
        if not _rows:
            return ("<tr class='%s'><td>%s</td><td colspan='3'>%s</td></tr>" % (_class, _title, ""))
        title = _title
        cclass = _class
        for _row in _rows:
            _html_rows.append("<tr class='%s'><td>%s</td><td>%s</td><td>PMID %s</td><td align='right'>%s</td></tr>" % (cclass, title, xstr(_row[1]), xstr(_row[0]), ""))
            if title:
                title = ""
            if _row[2]:
                _html_rows.append("<tr class='%s'><td>%s</td><td class='c' colspan='3'>%s</td></tr>" % (cclass, title, html.escape(xstr(_row[2]))))
            else:
                _html_rows.append("<tr class='%s'><td>%s</td><td class='c' colspan='3'>title unknown</td></tr>" % (cclass, title))
            if cclass[-1:] == '2':
                cclass = _class
            else:
                cclass = _class + '2'
        return _html_rows


    def _get_aliases(self, _person_ids):
        _sql = """
            select distinct
                FamilyName, Prefix, GivenName, OtherName, Suffix, Nickname
            from
                PersonName
            where
                PersonId in (%s) and
                GivenName is not null and
                GivenName != ''
            order by
                GivenName, Prefix, OtherName, FamilyName, Suffix, Nickname;
        """ % _person_ids
        _aliases = self.database.get_all_rows(_sql)

        _results = []
        for _alias in _aliases:
            if _alias[5]:
                _nickname = "".join(('(', _alias[5], ')'))
            else:
                _nickname = None
            _flattened_name = " ".join(filter(None, (_alias[1], _alias[2], _alias[3], _alias[4], _nickname)))
            if _flattened_name:
                _flattened_name = ", ".join((_alias[0], _flattened_name))
            else:
                _flattened_name = _alias[0]
            _results.append(_flattened_name.upper())

        return _results


    def _get_affiliations(self, _person_ids):
        _sql = """
            select distinct
                onn.Name
            from
                OrganizationName onn
                inner join OrganizationGrantAward oga on
                    oga.OrganizationId = onn.OrganizationId
                inner join PersonGrantAward pga on
                    pga.GrantAwardId = oga.GrantAwardId
            where
                oga.RelationshipCode = 'AWARDEE' and
                pga.PersonId in (%s)
            order by
                onn.Name;
        """ % _person_ids
        _rows = self.database.get_all_rows(_sql)

        _results = []
        for _row in _rows:
            _results.append(_row[0].upper())

        return _results


    def _get_attributes(self, _person_ids):
        _sql = """
            select distinct
                pa.RelationshipCode,
                a.Attribute
            from
                PersonAttribute pa
                inner join Attribute a on
                    a.AttributeId = pa.AttributeId
            where
                pa.PersonId in (%s)
            order by
                pa.RelationshipCode,
                a.Attribute;
        """ % _person_ids
        _rows = self.database.get_all_rows(_sql)

        _results = []
        for _row in _rows:
            if _row[1]:
                _results.append(": ".join((_row[0], _row[1])))

        return _results


    def _get_mesh_terms(self, _person_ids):
        _sql = """
            select distinct
                t.Term
            from
                PersonTerm pt
                inner join Term t on
                    t.TermId = pt.TermId
            where
                pt.PersonId in (%s) and
                pt.RelationshipCode = 'MESH'
            order by
                t.Term;
        """ % _person_ids
        _rows = self.database.get_all_rows(_sql)

        _results = []
        for _row in _rows:
            _results.append(_row[0])

        return _results


    def _get_grant_awards(self, _person_ids):
        _sql = """
        select
            (select a.Attribute from Attribute a inner join GrantAwardAttribute gaa on gaa.AttributeId = a.AttributeId and gaa.RelationshipCode = 'NIH_FULL_PROJECT_NUM' where gaa.GrantAwardId = ga.GrantAwardId limit 1) NIH_FULL_PROJECT_NUM,
            (select a.Attribute from Attribute a inner join GrantAwardAttribute gaa on gaa.AttributeId = a.AttributeId and gaa.RelationshipCode = 'NIH_SUBPROJECT_ID' where gaa.GrantAwardId = ga.GrantAwardId limit 1) NIH_SUBPROJECT_ID,
            ga.StartDate,
            ga.Amount,
            ga.Title
        from
            GrantAward ga
            inner join PersonGrantAward pga on
                pga.GrantAwardId = ga.GrantAwardId
        where
            pga.PersonId in (%s) and
            pga.RelationshipCode = 'PI'
        order by
            ga.StartDate desc,
            NIH_FULL_PROJECT_NUM asc,
            NIH_SUBPROJECT_ID asc;
        """ % _person_ids
        return self.database.get_all_rows(_sql)


    def _get_publications(self, _person_ids):
        _sql = """
            select
                PMID,
                max(Year) Year,
                max(Title) Title
            from
            (
                select
                    p.Year,
                    (select Attribute from Attribute a inner join PublicationAttribute pa on pa.AttributeId = a.AttributeId and pa.RelationshipCode = 'TITLE_PRIMARY' where pa.PublicationId = pp.PublicationId limit 1) Title,
                    (select Attribute from Attribute a inner join PublicationAttribute pa on pa.AttributeId = a.AttributeId and pa.RelationshipCode = 'PMID' where pa.PublicationId = pp.PublicationId limit 1) PMID
                from
                    PersonPublication pp
                    inner join Publication p on
                        p.PublicationId = pp.PublicationId
                where
                    pp.PersonId in (%s)
            ) t
            group by
                PMID
            order by
                Year desc, PMID asc;
        """ % _person_ids
        return self.database.get_all_rows(_sql)




