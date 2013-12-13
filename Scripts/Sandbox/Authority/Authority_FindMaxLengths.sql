################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

select max(length(RawID)) from raw;
select max(length(Blocks)) from raw; --758
select max(length(Probabilities)) from raw; --108
select max(length(Cluster)) from raw; --10
select max(length(AuthorID)) from raw; --93
select max(length(ClusterSize)) from raw; --4
select max(length(NameVariants)) from raw; --1204
select max(length(LastNameVariants)) from raw; --433
select max(length(FirstNameVariants)) from raw; --227
select max(length(MiddleInitialVariants)) from raw; --11
select max(length(SuffixVariants)) from raw; --12
select max(length(Emails)) from raw; --154
select max(length(YearRange)) from raw; --9
select max(length(Affiliations)) from raw; --357
select max(length(MeSHTerms)) from raw; --639
select max(length(Journals)) from raw; --2420
select max(length(TitleWords)) from raw; --379
select max(length(CoauthorNames)) from raw; --2083
select max(length(CoauthorIDs)) from raw; --71715
select max(length(AuthorNameInstances)) from raw; --18855
select max(length(GrantIDs)) from raw; --1242
select max(length(TotalTimesCited)) from raw; --5
select max(length(HIndex)) from raw; --2
select max(length(CitationCounts)) from raw; --11647
select max(length(Cited)) from raw; --11968
select max(length(CitedBy)) from raw; --12062
select max(length(AuthorID_10Year)) from raw; --48
select max(length(ClusterSize_10Year)) from raw; --2
select max(length(NameVariants_10Year)) from raw; --285
select max(length(LastNameVariants_10Year)) from raw; --144
select max(length(FirstNameVariants_10Year)) from raw; --93
select max(length(MiddleInitialVariants_10Year)) from raw; --9
select max(length(SuffixVariants_10Year)) from raw; --9
select max(length(Emails_10Year)) from raw; --107
select max(length(YearRange_10Year)) from raw; --9
select max(length(Affiliations_10Year)) from raw; --340
select max(length(MeSHTerms_10Year)) from raw; --675
select max(length(Journals_10Year)) from raw; --339
select max(length(TitleWords_10Year)) from raw; --380
select max(length(CoauthorNames_10Year)) from raw; --1179
select max(length(CoauthorIDs_10Year)) from raw; --29402
select max(length(AuthorNameInstances_10Year)) from raw; --129
select max(length(GrantIDs_10Year)) from raw; --1087
select max(length(TotalTimesCited_10Year)) from raw; --4
select max(length(HIndex_10Year)) from raw; --1
select max(length(CitationCounts_10Year)) from raw; --131
select max(length(Cited_10Year)) from raw; --10193
select max(length(CitedBy_10Year)) from raw; --11999
