################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

# There's a bug in the USPTO data whereby patent titles are truncated to something
# like 36 characters.  This code SHOULD correct that issue for MOST patents.
#
# Step 1: Import the titles
# Step 2: Update the titles

# Drop table.
drop table if exists uspto.patno_title;

# Create table.
create table uspto.patno_title
(
	patent_number varchar(64) not null,
	patent_title text not null,
	primary key (patent_number)
)
collate='latin1_swedish_ci'
engine=InnoDB;

# Load patno_title.tsv.
load data local infile
	'F:\\PatentsView\\Add Longer Titles\\patno_title.tsv' ignore
into table
	uspto.patno_title
character set utf8
fields terminated by '\t'
optionally enclosed by ''
escaped by ''
lines terminated by '\n'
(
	@patent_number, @patent_title
)
set
	patent_number = nullif(@patent_number, ''),
	patent_title = nullif(@patent_title, '');

# Fix titles where possible.
update
	PatentsView.patent pvp
	inner join PatentsView.patent_text pvpt on pvpt.patent_id = pvp.patent_id
	inner join uspto.patno_title pt on pt.patent_number = pvp.number
set
	pvpt.title = pt.patent_title
where
	pvpt.title != pt.patent_title;
