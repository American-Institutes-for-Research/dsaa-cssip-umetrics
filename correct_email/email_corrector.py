###############################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################
import string
from email.utils import parseaddr
import os
import sys
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)),"..\\ThirdParty\\py_email_validation-1.0.0.3"))
import email_validation

_ValidEmailCharacters = string.ascii_letters+string.digits+" .@(),:;<>[]\\!#$%&'*+-/=?^_`{|}~"


def email_corrector(email):
    """
    Corrects a candidate email string, returns None if it is not valid.
    """

    is_valid = False
    corrected_email = email

    if email is not None:
        # If it is already valid coming in, then leave everything alone and go to the next one,
        # unless it has a blank in it (we want to process to remove that blank)
        if (email_validation.valid_email_address(corrected_email)) and (" " not in corrected_email):
            is_valid = True
        else:
            # First get rid of all invalid characters.
            corrected_email = "".join(c for c in corrected_email if c in _ValidEmailCharacters).strip()
            corrected_email = corrected_email.replace(" @", "@")

            # Go through each space-delimited word and check for validity
            space_separated = corrected_email.split(" ")
            for one_word in space_separated:
                one_word = one_word.strip(".").strip(",").strip("(").strip(")").strip("#").strip("[").strip("]")\
                    .strip("{").strip("}").strip("%")
                if email_validation.valid_email_address(one_word):
                    corrected_email = one_word
                    is_valid = True
                    break

            if not is_valid:
                # Try parsing it and keep if valid.
                parsed_email = parseaddr(corrected_email)
                if parsed_email[1] != "":
                    corrected_email = parsed_email[1].strip(".").strip(",").strip("(").strip(")").strip("#")\
                        .strip("[").strip("]").strip("{").strip("}").strip("%")
                is_valid = email_validation.valid_email_address(corrected_email)

    if not is_valid:
        corrected_email = None

    return corrected_email


if __name__ == "__main__":
    # Test cases

    print("A\t", email_corrector("valid@email.com") == "valid@email.com")
    print("B\t", email_corrector("invalid at email.com") is None)
    print("C\t", email_corrector("valid @email.com") == "valid@email.com")
    print("D\t", email_corrector("[valid@email.com]") == "valid@email.com")
    print("E\t", email_corrector("Clark Kent: valid@email.com") == "valid@email.com")
    print("F\t", email_corrector("valid@email.com@") == "valid@email.com")
    print("G\t", email_corrector("i.have.a-very-long$email+with_odd!stuff @email.com ")
                 == "i.have.a-very-long$email+with_odd!stuff@email.com")
    print("H\t", email_corrector("try this one (<invalid@email.com>)") is None)
    print("I\t", email_corrector("refer to this one: it's good (valid@email.com") == "valid@email.com")
    print("J\t", email_corrector("yes-it's-valid@email") == "yes-it's-valid@email")
    print("K\t", email_corrector("You can try to reach me, Mister Bill, here: valid@email.com,"
                                 " but not by phone @ 123-456-7890") == "valid@email.com")
    print("L\t", email_corrector("valid @ email . com") == "valid@email.com")
    print("M\t", email_corrector("Joe Friday valid @ email . com") is None)
    print("N\t", email_corrector("doesnt_check@forvalid.domains") == "doesnt_check@forvalid.domains")

