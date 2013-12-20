################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################
import re, os, sys
sys.path.append(os.path.abspath('../ThirdParty'))
from unidecode import unidecode


# Used for stripping non-word characters.  This is slightly different than the regex definition.  We want to strip
# non-letters and non-numbers, but keep spaces.  Stripping spaces is a whole other thing.
_non_word_pattern = re.compile("[^\w ]|_")
_whitespace_pattern = re.compile("\s+")


# Just an encapsulation of a common function.  Passing in anything other than an iterable containing strings has
# interesting results...  Use at your own risk.  Spaces are concatenated between strings.
def make_string(iterable):
    if iterable is None:
        return None
    return " ".join(filter(None, iterable))


# Clean up spaces.  This includes removing tabs and other non-space white space characters, removing doubled up spaces,
# and eliminating whitespace on either end of the string.
def clean_whitespace(text):
    if text is None:
        return None
    return _whitespace_pattern.sub(" ", text).strip()


# Remove whitespace.
def remove_whitespace(text):
    if text is None:
        return None
    return _whitespace_pattern.sub("", text)


# This will replace diacritics and other non-ASCII characters with their ASCII equivalent character.  This is used to
# "standardize" text a bit as text is recorded inconsistently in our source data.
def remove_diacritics(text):
    if text is None:
        return None
    return unidecode(text)


# Replace non-word characters in a string with spaces.  For the most part, this is anything but a letter, number, or space.
def replace_non_word_characters(text):
    if text is None:
        return None
    return _non_word_pattern.sub(' ', text)


# Remove non-word characters in a string.  For the most part, this is anything but a letter, number, or space.
def remove_non_word_characters(text):
    if text is None:
        return None
    return _non_word_pattern.sub('', text)


# Common function.
def nullify_blanks(text):
    if text is None:
        return None
    if text.strip() == "":
        return None
    return text
