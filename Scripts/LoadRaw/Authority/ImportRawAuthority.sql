################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

# Clear out our raw table.
#truncate table raw;

# Load Program. You'll need to run this for each file.
set @SourceFile = 'D:\\Raw Data\\Authority\\authority2009.part00';

load data local infile
	'D:\\Raw Data\\Authority\\authority2009.part00' ignore
into table
	raw
character set latin1
fields terminated by '\t'
optionally enclosed by '"'
escaped by ''
lines terminated by '\n'
(
	@Blocks,
	@Probabilities,
	@Cluster,
	@AuthorId,
	@ClusterSize,
	@NameVariants,
	@LastNameVariants,
	@FirstNameVariants,
	@MiddleInitialVariants,
	@SuffixVariants,
	@Emails,
	@YearRange,
	@Affiliations,
	@MeSHTerms,
	@Journals,
	@TitleWords,
	@CoauthorNames,
	@CoauthorIds,
	@AuthorNameInstances,
	@GrantIds,
	@TotalTimesCited,
	@HIndex,
	@CitationCounts,
	@Cited,
	@CitedBy,
	@AuthorId_10Year,
	@ClusterSize_10Year,
	@NameVariants_10Year,
	@LastNameVariants_10Year,
	@FirstNameVariants_10Year,
	@MiddleInitialVariants_10Year,
	@SuffixVariants_10Year,
	@Emails_10Year,
	@YearRange_10Year,
	@Affiliations_10Year,
	@MeSHTerms_10Year,
	@Journals_10Year,
	@TitleWords_10Year,
	@CoauthorNames_10Year,
	@CoauthorIds_10Year,
	@AuthorNameInstances_10Year,
	@GrantIds_10Year,
	@TotalTimesCited_10Year,
	@HIndex_10Year,
	@CitationCounts_10Year,
	@Cited_10Year,
	@CitedBy_10Year
)
set
	SourceFile = @SourceFile,
	Blocks = nullif(@Blocks, ''),
	Probabilities = nullif(@Probabilities, ''),
	Cluster = nullif(@Cluster, ''),
	AuthorId = nullif(@AuthorId, ''),
	ClusterSize = cast(nullif(@ClusterSize, '') as unsigned integer),
	NameVariants = nullif(@NameVariants, ''),
	LastNameVariants = nullif(@LastNameVariants, ''),
	FirstNameVariants = nullif(@FirstNameVariants, ''),
	MiddleInitialVariants = nullif(@MiddleInitialVariants, ''),
	SuffixVariants = nullif(@SuffixVariants, ''),
	Emails = nullif(@Emails, ''),
	YearRange = nullif(@YearRange, ''),
	Affiliations = nullif(@Affiliations, ''),
	MeSHTerms = nullif(@MeSHTerms, ''),
	Journals = nullif(@Journals, ''),
	TitleWords = nullif(@TitleWords, ''),
	CoauthorNames = nullif(@CoauthorNames, ''),
	CoauthorIds = nullif(@CoauthorIds, ''),
	AuthorNameInstances = nullif(@AuthorNameInstances, ''),
	GrantIds = nullif(@GrantIds, ''),
	TotalTimesCited = cast(nullif(@TotalTimesCited, '') as unsigned int),
	HIndex = cast(nullif(@HIndex, '') as decimal),
	CitationCounts = nullif(@CitationCounts, ''),
	Cited = nullif(@Cited, ''),
	CitedBy = nullif(@CitedBy, ''),
	AuthorId_10Year = nullif(@AuthorId_10Year, ''),
	ClusterSize_10Year = cast(nullif(@ClusterSize_10Year, '') as unsigned int),
	NameVariants_10Year = nullif(@NameVariants_10Year, ''),
	LastNameVariants_10Year = nullif(@LastNameVariants_10Year, ''),
	FirstNameVariants_10Year = nullif(@FirstNameVariants_10Year, ''),
	MiddleInitialVariants_10Year = nullif(@MiddleInitialVariants_10Year, ''),
	SuffixVariants_10Year = nullif(@SuffixVariants_10Year, ''),
	Emails_10Year = nullif(@Emails_10Year, ''),
	YearRange_10Year = nullif(@YearRange_10Year, ''),
	Affiliations_10Year = nullif(@Affiliations_10Year, ''),
	MeSHTerms_10Year = nullif(@MeSHTerms_10Year, ''),
	Journals_10Year = nullif(@Journals_10Year, ''),
	TitleWords_10Year = nullif(@TitleWords_10Year, ''),
	CoauthorNames_10Year = nullif(@CoauthorNames_10Year, ''),
	CoauthorIds_10Year = nullif(@CoauthorIds_10Year, ''),
	AuthorNameInstances_10Year = nullif(@AuthorNameInstances_10Year, ''),
	GrantIds_10Year = nullif(@GrantIds_10Year, ''),
	TotalTimesCited_10Year = cast(nullif(@TotalTimesCited_10Year, '') as unsigned int),
	HIndex_10Year = cast(nullif(@HIndex_10Year, '') as decimal),
	CitationCounts_10Year = nullif(@CitationCounts_10Year, ''),
	Cited_10Year = nullif(@Cited_10Year, ''),
	CitedBy_10Year = nullif(@CitedBy_10Year, '')