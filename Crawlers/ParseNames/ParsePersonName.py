import datetime
import mysql.connector
import NameParser


def from_exporter(username, password, host, database, table):
    """
    Reads person names from the given table that are in the same format as names from ExPORTER,
    parses them, and writes the parts back out to the tables.

    """

    # Connect to the database.
    cnx = mysql.connector.connect(user=username, password=password, database=database,
                                  host=host)
    read_cursor = cnx.cursor(buffered=True)
    write_cursor = cnx.cursor()

    start_row = 0
    num_rows_to_get = 10000
    get_another_chunk = True

    while get_another_chunk:
        query_string = "select PersonNameId, FullName from {0} pn inner join PersonAttribute pa "\
            " on pa.PersonId=pn.PersonId and pa.RelationshipCode='NIH_PI_ID'"\
            " where GivenName is null and FamilyName is null limit %s,%s;".format(table)
        read_cursor.execute(query_string, (start_row, num_rows_to_get))
        num_rows_read = 0
        for (PersonNameId, FullName) in read_cursor:
            name_components = NameParser.parse_name(NameParser.NameFormat.EXPORTER, FullName)
            if (name_components.Prefix is not None) or (name_components.GivenName is not None)\
                or (name_components.OtherName is not None) or (name_components.FamilyName is not None)\
                or (name_components.Suffix is not None) or (name_components.NickName is not None):
                query_string = "UPDATE {0} SET Prefix=%s, GivenName=%s, OtherName=%s, FamilyName=%s, Suffix=%s"\
                    " WHERE PersonNameId=%s".format(table)
                write_cursor.execute(query_string, (name_components.Prefix, name_components.GivenName,
                                                     name_components.OtherName, name_components.FamilyName,
                                                     name_components.Suffix, PersonNameId))
            num_rows_read += 1
        cnx.commit()
        print(datetime.datetime.now(), start_row+num_rows_read)
        if num_rows_read != num_rows_to_get:
            get_another_chunk = False
        start_row += num_rows_to_get

    read_cursor.close()
    write_cursor.close()
    cnx.close()
    return


def from_citeseerx(username, password, host, database, table):
    """
    Reads person names from the given table that are in the same format as names from ExPORTER,
    parses them, and writes the parts back out to the tables.

    Note that in this function we couldn't use the limit x,y mechanism. I believe
    that is because we are changing	values in the database that are also used in
    the 'where' clause of the select statement. So instead we are getting rows in
    order by PersonNameId.

    """

    num_rows_to_get = 10000
    total_rows_processed = 0
    get_another_chunk = True
    last_person_nameid_processed = 0

    # Connect to the database.
    cnx = mysql.connector.connect(user=username, password=password, database=database,
                                  host=host)
    read_cursor = cnx.cursor(buffered=True)
    write_cursor = cnx.cursor()

    while get_another_chunk:
        query_string = "select PersonNameId, FullName from {0} pn inner join PersonAttribute pa"\
            " on pa.PersonId=pn.PersonId and pa.RelationshipCode='CITESEERX_CLUSTER'"\
            " where GivenName is null and FamilyName is null and pn.PersonNameId > %s"\
            " order by pn.PersonNameId limit %s;".format(table)
#        query_string = "select PersonNameId, FullName from {0} pn inner join PersonAttribute pa on pa.PersonId=pn.PersonId and pa.RelationshipCode='CITESEERX_CLUSTER' where pn.PersonNameId > %s order by pn.PersonNameId limit %s;".format(table)
        read_cursor.execute(query_string, (last_person_nameid_processed, num_rows_to_get))

        num_rows_read = 0
        for (PersonNameId, FullName) in read_cursor:
            name_components = NameParser.parse_name(NameParser.NameFormat.CITESEERX, FullName)
            if (name_components.Prefix is not None) or (name_components.GivenName is not None)\
                    or (name_components.OtherName is not None) or (name_components.FamilyName is not None)\
                    or (name_components.Suffix is not None) or (name_components.NickName is not None):
                query_string = "UPDATE {0} SET Prefix=%s, GivenName=%s, OtherName=%s, FamilyName=%s, Suffix=%s"\
                    " WHERE PersonNameId=%s".format(table)
                write_cursor.execute(query_string, (name_components.Prefix, name_components.GivenName,
                                                    name_components.OtherName, name_components.FamilyName,
                                                    name_components.Suffix, PersonNameId))
            num_rows_read += 1
            last_person_nameid_processed = PersonNameId

        cnx.commit()
        total_rows_processed += num_rows_read
        print(datetime.datetime.now(), total_rows_processed)
        if num_rows_read != num_rows_to_get:
            get_another_chunk = False

    read_cursor.close()
    write_cursor.close()
    cnx.close()
    return
