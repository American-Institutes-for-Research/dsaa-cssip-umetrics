__author__ = 'gregy'
from collections import namedtuple


# Since enums aren't supported in Python 3.3 (they are in 3.4), we're going to use constants, which it turns out
# aren't really constants, but it's what Python has
class NameFormat:
    ExPORTER, Authority, CiteSeerX = range(3)

NameComponents=namedtuple("NameComponents","Prefix GivenName OtherName FamilyName Suffix NickName")

Suffixes = ["JR","SR","II","III","IV","V","VI","PHD","MD","RN","DR","JD","MED","MPH","PHMD","DRPH","FAAN","MD PHD","MP"]
Prefixes = ["DR","MR","MRS","MS","PROF"]

def ParseName(nameFormat, nameString):
    components = NameComponents(Prefix=None, FamilyName=None, GivenName=None, OtherName=None,
                                Suffix=None, NickName=None)
    nameString = nameString.replace("&nbsp;"," ")
    if nameFormat == NameFormat.ExPORTER:
        components = ParseNameForExPORTER(nameString)
    elif nameFormat == NameFormat.CiteSeerX:
        components = ParseNameForCiteSeerX(nameString)
    return components


def ParseNameForCiteSeerX(nameString):
    prefix = None
    givenName = None
    otherName = None
    familyName = None
    suffix = None
    nickName = None

    nameString = nameString.strip(",").strip()
    # If there is an unclosed left paren, the trash it and everything to the right of it
    if (nameString.count("(") > 0) and (nameString.count(")") == 0):
        nameString = nameString.split("(", 1)[0]
    spaceSeparated = nameString.split(" ", 1)
    # Check to see if the first string is a prefix
    if StringContainsOnlyPrefixes(spaceSeparated[0]):
        prefix = spaceSeparated[0]
        spaceSeparated = spaceSeparated[1].strip().split(" ", 1) # Strip off the prefix and continue on
    # If there is only one word, then don't return any results
    if len(spaceSeparated) == 1:
        prefix = None
    else:
        givenName = spaceSeparated[0]
        spaceSeparated = spaceSeparated[1].strip().rsplit(" ", 1)
        if len(spaceSeparated) == 1:
            familyName = spaceSeparated[0]
        else:
            if StringContainsOnlySuffixes(spaceSeparated[1]):
                suffix = spaceSeparated[1]
                spaceSeparated = spaceSeparated[0].strip().rsplit(" ", 1)
            if len(spaceSeparated) == 1:
                familyName = spaceSeparated[0]
            else:
                # If the last piece is only one character, ignore it
                if len(spaceSeparated[1]) == 1:
                    spaceSeparated = spaceSeparated[0].strip().rsplit(" ", 1)
                if len(spaceSeparated) == 1:
                    familyName = spaceSeparated[0]
                else:
                    otherName = spaceSeparated[0]
                    familyName = spaceSeparated[1]

    if prefix != None: prefix = prefix.strip()
    if givenName != None: givenName = givenName.strip()
    if otherName != None: otherName = otherName.strip()
    if familyName != None: familyName = familyName.strip()
    if suffix != None: suffix = suffix.strip()

    return NameComponents(Prefix=prefix, GivenName=givenName, OtherName=otherName,
                      FamilyName=familyName, Suffix=suffix, NickName=nickName)



# This function handles names with these patterns:
# [familyname], [givenname] [othername]
# [familyname], [suffix], [givenname] [othername]
# [familyname] [suffix], [givenname] [othername]
# [familyname], [givenname]
# [familyname], [suffix], [givenname]
# [familyname] [suffix], [givenname]
# [familyname], [givenname], [suffix]
# [familyname], [givenname] [othername], [suffix]
# familyname and othername can have blanks in them, but suffix and givenname cannot
def ParseNameForExPORTER(nameString):
    prefix = None
    givenName = None
    otherName = None
    familyName = None
    suffix = None
    nickName = None

    nameString = nameString.strip(",").strip() # get rid of leading and trailing commas and whitespace
    commaSeparated = nameString.split(",", 1)

    # If there are 3 commas, then there are may be multiple suffixes. Those will either appear at the end
    # or after the family name.

    # If there are 3 or more commas, check everything between the first and last comma to see if it contains only suffixes
    if (nameString.count(",") >= 3) and (StringContainsOnlySuffixes(commaSeparated[1].rsplit(",",1)[0].strip())):
        suffix = commaSeparated[1].rsplit(",",1)[0] # everything between the first and last comma
        familyName = commaSeparated[0] # everything before the first comma
        remainder = commaSeparated[1].rsplit(",",1)[1].strip() # everything after the last comma
        spaceSeparated = remainder.split(" ", 1)
        givenName = spaceSeparated[0].strip(",") # up to the first blank in remainder
        if len(spaceSeparated) > 1: # if there is a blank...
            otherName = spaceSeparated[1] # everything after the first blank in remainder
    else:
        commaSeparated = nameString.split(",", 2) # Only break into at most 3 parts by the first two commas
        if len(commaSeparated) > 1: # If there aren't any commas then this is the wrong function to call
            # If there is only one comma, then the part before the comma contains familyname and optionally suffix,
            # and the part after the comma contains givenname and optionally othername
            if len(commaSeparated) == 2:
                familyNameComponents = ParseFamilyName(commaSeparated[0])
                familyName = familyNameComponents.FamilyName
                suffix = familyNameComponents.Suffix
                remainder = commaSeparated[1].strip()
            # If there are two commas (i.e. 3 parts)
            elif len(commaSeparated) == 3:
                # It's possible that the third part is actually a suffix, so check that first
                if StringContainsOnlySuffixes(commaSeparated[2]):
                    suffix = commaSeparated[2]
                    familyName = commaSeparated[0]
                    remainder = commaSeparated[1].strip()
                else:
                    familyName = commaSeparated[0]
                    suffix = commaSeparated[1]
                    remainder = commaSeparated[2].strip()
            spaceSeparated = remainder.split(" ", 1)
            givenName = spaceSeparated[0].strip(",")
            if len(spaceSeparated) > 1:
                otherName = spaceSeparated[1]
    if familyName != None: familyName = familyName.strip()
    if givenName != None: givenName = givenName.strip()
    if otherName != None: otherName = otherName.strip()
    if suffix != None: suffix = suffix.strip()
    return NameComponents(Prefix=prefix, GivenName=givenName, OtherName=otherName,
                          FamilyName=familyName, Suffix=suffix, NickName=nickName)

# Parses a string that contains a family name and perhaps a suffix.
def ParseFamilyName(nameString):
    familyName = nameString
    suffix = None
    separated = nameString.rsplit(" ",1) #rsplit is important here. If there are multiple blanks, everything before the last one is considered familyname
    if len(separated) > 1:
        if any(x == separated[1].upper().strip() for x in Suffixes):
            familyName = separated[0]
            suffix = separated[1]
    if familyName != None: familyName = familyName.strip()
    if suffix != None: suffix = suffix.strip()
    return NameComponents(Prefix=None, GivenName=None, OtherName=None,
                          FamilyName=familyName, Suffix=suffix, NickName=None)

# Give it a string, it will return bool as to whether the string contains only suffixes or not.
# Suffixes can be separated by commas or spaces, but not a mixture
def StringContainsOnlySuffixes(suffixString):
    rc = True
    suffixString = suffixString.strip().replace(".","")
    commaSeparated = suffixString.split(",")
    if len(commaSeparated) > 1:
        for (part) in commaSeparated:
            if all(x != part.upper().strip() for x in Suffixes):
                rc = False
    else:
        spaceSeparated = suffixString.split(" ")
        for (part) in spaceSeparated:
            if all(x != part.upper().strip() for x in Suffixes):
                rc = False
    return rc

# Give it a string, it will return bool as to whether the string contains only prefixes or not.
# Prefixes can be separated by commas or spaces, but not a mixture
def StringContainsOnlyPrefixes(prefixString):
    rc = True
    prefixString = prefixString.strip().replace(".","")
    commaSeparated = prefixString.split(",")
    if len(commaSeparated) > 1:
        for (part) in commaSeparated:
            if all(x != part.upper().strip() for x in Prefixes):
                rc = False
    else:
        spaceSeparated = prefixString.split(" ")
        for (part) in spaceSeparated:
            if all(x != part.upper().strip() for x in Prefixes):
                rc = False
    return rc

if __name__ == "__main__":
    print("A\t",ParseName(NameFormat.ExPORTER,"FamilyName, GivenName OtherName")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="OtherName", Suffix=None, NickName=None))
    print("B\t",ParseName(NameFormat.ExPORTER,"FamilyName, GivenName Other Name")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="Other Name", Suffix=None, NickName=None))
    print("C\t",ParseName(NameFormat.ExPORTER,"Family Name, GivenName OtherName")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="OtherName", Suffix=None, NickName=None))
    print("D\t",ParseName(NameFormat.ExPORTER,"Family VName, GivenName OtherName")
                == NameComponents(Prefix=None, FamilyName="Family VName", GivenName="GivenName", OtherName="OtherName", Suffix=None, NickName=None))
    print("E\t",ParseName(NameFormat.ExPORTER,"Family Name, GivenName Other Name")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="Other Name", Suffix=None, NickName=None))
    print("F\t",ParseName(NameFormat.ExPORTER,"FamilyName, GivenName Double Other Name")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="Double Other Name", Suffix=None, NickName=None))
    print("G\t",ParseName(NameFormat.ExPORTER,"FamilyName JR, GivenName OtherName")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="OtherName", Suffix="JR", NickName=None))
    print("H\t",ParseName(NameFormat.ExPORTER,"FamilyName, III, GivenName OtherName")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="OtherName", Suffix="III", NickName=None))
    print("I\t",ParseName(NameFormat.ExPORTER,"Family Name IV, GivenName OtherName")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="OtherName", Suffix="IV", NickName=None))
    print("J\t",ParseName(NameFormat.ExPORTER,"Family Name, PhD, GivenName OtherName")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="OtherName", Suffix="PhD", NickName=None))
    print("K\t",ParseName(NameFormat.ExPORTER,"FamilyName, GivenName OtherName,")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="OtherName", Suffix=None, NickName=None))
    print("L\t",ParseName(NameFormat.ExPORTER,"FamilyName, GivenName, jr.")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName=None, Suffix="jr.", NickName=None))
    print("M\t",ParseName(NameFormat.ExPORTER,"Family Name, SR, GivenName OtherName")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="OtherName", Suffix="SR", NickName=None))
    print("N\t",ParseName(NameFormat.ExPORTER,"Family Name, GivenName OtherName, MD")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="OtherName", Suffix="MD", NickName=None))
    print("O\t",ParseName(NameFormat.ExPORTER,"Family Name, GivenName OtherName, M.D., PhD")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="OtherName", Suffix="M.D., PhD", NickName=None))
    print("P\t",ParseName(NameFormat.ExPORTER,"Family Name, GivenName OtherName, MD Ph.D")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="OtherName", Suffix="MD Ph.D", NickName=None))
    print("Q\t",ParseName(NameFormat.ExPORTER,"Family Name, MD, Ph.D., GivenName OtherName")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="OtherName", Suffix="MD, Ph.D.", NickName=None))
    print("R\t",ParseName(NameFormat.ExPORTER,"Family Name, MD, Ph.D, GivenName Other Name")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="Other Name", Suffix="MD, Ph.D", NickName=None))
    print("S\t",ParseName(NameFormat.ExPORTER,"Family Name, GivenName Other Name, MD Ph.D")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="Other Name", Suffix="MD Ph.D", NickName=None))
    print("T\t",ParseName(NameFormat.ExPORTER,"Family Name, GivenName Other Name, III, MD, Ph.D")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="Other Name", Suffix="III, MD, Ph.D", NickName=None))
    print("U\t",ParseName(NameFormat.ExPORTER,"Family Name, Sr., MD, Ph.D., GivenName Other Name")
                == NameComponents(Prefix=None, FamilyName="Family Name", GivenName="GivenName", OtherName="Other Name", Suffix="Sr., MD, Ph.D.", NickName=None))
    print("V\t",ParseName(NameFormat.ExPORTER,"FamilyName, GivenName")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName=None, Suffix=None, NickName=None))


    print("AA\t",ParseName(NameFormat.CiteSeerX,"GivenName FamilyName")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName=None, Suffix=None, NickName=None))
    print("BB\t",ParseName(NameFormat.CiteSeerX,"GivenName OtherName FamilyName")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="OtherName", Suffix=None, NickName=None))
    print("CC\t",ParseName(NameFormat.CiteSeerX,"Dr. GivenName OtherName FamilyName")
                == NameComponents(Prefix="Dr.", FamilyName="FamilyName", GivenName="GivenName", OtherName="OtherName", Suffix=None, NickName=None))
    print("DD\t",ParseName(NameFormat.CiteSeerX,"GivenName Multiple Other Name FamilyName")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="Multiple Other Name", Suffix=None, NickName=None))
    print("EE\t",ParseName(NameFormat.CiteSeerX,"GivenName OtherName FamilyName Jr")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="OtherName", Suffix="Jr", NickName=None))
    print("FF\t",ParseName(NameFormat.CiteSeerX,"Dr GivenName OtherName FamilyName III")
                == NameComponents(Prefix="Dr", FamilyName="FamilyName", GivenName="GivenName", OtherName="OtherName", Suffix="III", NickName=None))
    print("GG\t",ParseName(NameFormat.CiteSeerX,"GivenName OtherName FamilyName&nbsp;III")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="OtherName", Suffix="III", NickName=None))
    print("HH\t",ParseName(NameFormat.CiteSeerX,"GivenName OtherName FamilyName (III")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="OtherName", Suffix=None, NickName=None))
    print("II\t",ParseName(NameFormat.CiteSeerX,"WhoKnows")
                == NameComponents(Prefix=None, FamilyName=None, GivenName=None, OtherName=None, Suffix=None, NickName=None))
    print("JJ\t",ParseName(NameFormat.CiteSeerX,"Dr. WhoKnows")
                == NameComponents(Prefix=None, FamilyName=None, GivenName=None, OtherName=None, Suffix=None, NickName=None))
    print("KK\t",ParseName(NameFormat.CiteSeerX,"GivenName FamilyName V")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName=None, Suffix="V", NickName=None))
    print("LL\t",ParseName(NameFormat.CiteSeerX,"GivenName(s) FamilyName")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName(s)", OtherName=None, Suffix=None, NickName=None))
    print("MM\t",ParseName(NameFormat.CiteSeerX,"GivenName FamilyName Q")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName=None, Suffix=None, NickName=None))
    print("NN\t",ParseName(NameFormat.CiteSeerX,"GivenName Other Name FamilyName Q")
                == NameComponents(Prefix=None, FamilyName="FamilyName", GivenName="GivenName", OtherName="Other Name", Suffix=None, NickName=None))
    print("OO\t",ParseName(NameFormat.CiteSeerX," I.V. Basawa")
                == NameComponents(Prefix=None, FamilyName="Basawa", GivenName="I.V.", OtherName=None, Suffix=None, NickName=None))

