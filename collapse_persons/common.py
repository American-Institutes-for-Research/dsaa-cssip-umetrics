################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import os, sys
sys.path.append(os.path.abspath('../Shared'))
sys.path.append(os.path.abspath('../ThirdParty'))
import __string__ as s
from jellyfish import jellyfish


def standardize_text(text):
    """For standardizing text in a consistent manner."""

    if text is None:
        return None
    return s.nullify_blanks(
        s.clean_whitespace(
            s.remove_non_word_characters(
                s.remove_diacritics(text))).upper())


def names_conflict(name1, name2):
    """
    For comparing name parts.  We're just checking for conflicts.  The following examples should help:

      None does not conflict with a
      a does not conflict with a
      ambrose does not conflict with ambrose
      a does not conflict with ambrose

      t does conflict with ambrose
      am does conflict with ambrose

      ambrost does not conflict with ambrose # our fuzzy matching

    Again, we're just trying to ensure there are no conflicts between the names.  A single letter is considered an
    initial which is why a single letter does not conflict with a full name, but two letters can.

    We've introduced a wee little bit of fuzziness to the matching by allowing there to be one Damerau-Levenshtein
    edit distance between names, provided the names have a little meat to them (obviously, "A" is one edit distance
    from "Z", so we need to ensure the names have a little bit of length to them).
    """

    return not (name1 is None or
                name2 is None or
                name1 == name2 or
                ((len(name1) == 1 or len(name2) == 1) and name1[0] == name2[0]) or
                (len(name1) > 3 and len(name2) > 3 and jellyfish.damerau_levenshtein_distance(name1, name2) < 2))
