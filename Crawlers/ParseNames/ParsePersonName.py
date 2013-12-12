__author__ = 'gregy'
import mysql.connector
import NameParser
import datetime


def FromExPORTER(username, password, host, database, table):
    # Connect to the database.
    cnx = mysql.connector.connect(user=username,password=password,database=database,
                                  host=host)
    cursorRead = cnx.cursor(buffered=True)
    cursorWrite = cnx.cursor()

    startRow = 0
    numRowsToGet = 1000
    getAnotherChunk = True

    while getAnotherChunk:
        queryString = "select PersonNameId, FullName from {0} pn inner join PersonAttribute pa on pa.PersonId=pn.PersonId and pa.RelationshipCode='NIH_PI_ID' limit %s,%s;".format(table)
        cursorRead.execute(queryString, (startRow, numRowsToGet))
        numRowsRead = 0
        for (PersonNameId, FullName) in cursorRead:
            nameComponents = NameParser.ParseName(NameParser.NameFormat.ExPORTER, FullName)
            if (nameComponents.Prefix != None) or (nameComponents.GivenName != None) or (nameComponents.OtherName != None)\
                or (nameComponents.FamilyName != None) or (nameComponents.Suffix != None)\
                or (nameComponents.NickName != None):
                queryString = "UPDATE {0} SET Prefix=%s, GivenName=%s, OtherName=%s, FamilyName=%s, Suffix=%s WHERE PersonNameId=%s".format(table)
                cursorWrite.execute (queryString, (nameComponents.Prefix, nameComponents.GivenName, nameComponents.OtherName,
                                                   nameComponents.FamilyName, nameComponents.Suffix, PersonNameId))
            numRowsRead += 1
        cnx.commit()
        print (datetime.datetime.now(), startRow+numRowsRead)
        if numRowsRead != numRowsToGet:
            getAnotherChunk = False
        startRow += numRowsToGet


    cursorRead.close()
    cursorWrite.close()
    cnx.close()

    return

# Note that in this function we couldn't use the limit x,y mechanism. I believe that is because we are changing
# values in the database that are also used in the 'where' clause of the select statement. So instead we are getting
# rows in order by PersonNameId.
def FromCiteSeerX(username, password, host, database, table):
    numRowsToGet = 10000
    totalRowsProcessed = 0
    getAnotherChunk = True
    lastPersonNameIdProcessed = 0

    # Connect to the database.
    cnx = mysql.connector.connect(user=username,password=password,database=database,
                                  host=host)
    cursorRead = cnx.cursor(buffered=True)
    cursorWrite = cnx.cursor()

    while getAnotherChunk:
        queryString = "select PersonNameId, FullName from {0} pn inner join PersonAttribute pa on pa.PersonId=pn.PersonId and pa.RelationshipCode='CITESEERX_CLUSTER' where GivenName is null and FamilyName is null and pn.PersonNameId > %s order by pn.PersonNameId limit %s;".format(table)
#        queryString = "select PersonNameId, FullName from {0} pn inner join PersonAttribute pa on pa.PersonId=pn.PersonId and pa.RelationshipCode='CITESEERX_CLUSTER' where pn.PersonNameId > %s order by pn.PersonNameId limit %s;".format(table)
        cursorRead.execute(queryString, (lastPersonNameIdProcessed, numRowsToGet))

        numRowsRead = 0
        for (PersonNameId, FullName) in cursorRead:
            nameComponents = NameParser.ParseName(NameParser.NameFormat.CiteSeerX, FullName)
            if (nameComponents.Prefix != None) or (nameComponents.GivenName != None) or (nameComponents.OtherName != None)\
                or (nameComponents.FamilyName != None) or (nameComponents.Suffix != None)\
                or (nameComponents.NickName != None):
                queryString = "UPDATE {0} SET Prefix=%s, GivenName=%s, OtherName=%s, FamilyName=%s, Suffix=%s WHERE PersonNameId=%s".format(table)
                cursorWrite.execute (queryString, (nameComponents.Prefix, nameComponents.GivenName, nameComponents.OtherName,
                                                   nameComponents.FamilyName, nameComponents.Suffix, PersonNameId))
            numRowsRead += 1
            lastPersonNameIdProcessed = PersonNameId

        cnx.commit()
        totalRowsProcessed += numRowsRead
        print (datetime.datetime.now(), totalRowsProcessed)
        if numRowsRead != numRowsToGet:
            getAnotherChunk = False

    cursorRead.close()
    cursorWrite.close()
    cnx.close()

    return
