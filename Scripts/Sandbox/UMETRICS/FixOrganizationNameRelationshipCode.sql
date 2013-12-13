################################################################################
# Copyright (c) 2013, AMERICAN INSTITUTES FOR RESEARCH
# All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

/*

	Some quick and dirty code to fix the naming inconsistency in the RelationshipCode
	column in the OrganizationName table.

	This code is, obviously, not terribly sophisticated.  It does not verify that the
	naming inconsistency even exists before doing its thing.  Re-run at your own risk.

*/


ALTER TABLE `OrganizationName`
	ALTER `RelationshipCode` DROP DEFAULT;

ALTER TABLE `OrganizationName`
	CHANGE COLUMN `RelationshipCode` `RelationshipCode` ENUM('ALIAS','PRIMARY ACRONYM','PRIMARY FULL','PRIMARY_ACRONYM','PRIMARY_FULL') NOT NULL COMMENT 'Describes the name\'s relationship to the organization.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!' AFTER `OrganizationId`;

update OrganizationName set RelationshipCode = 'PRIMARY_FULL' where RelationshipCode = 'PRIMARY FULL';

update OrganizationName set RelationshipCode = 'PRIMARY_ACRONYM' where RelationshipCode = 'PRIMARY ACRONYM';

ALTER TABLE `OrganizationName`
	ALTER `RelationshipCode` DROP DEFAULT;

ALTER TABLE `OrganizationName`
	CHANGE COLUMN `RelationshipCode` `RelationshipCode` ENUM('ALIAS','PRIMARY_ACRONYM','PRIMARY_FULL') NOT NULL COMMENT 'Describes the name\'s relationship to the organization.  THESE SHOULD BE STORED IN ALPHABETICAL ORDER AND SHOULD NEVER BE REFERRED TO BY UNDERLYING NUMERIC VALUE, ONLY BY TEXTUAL VALUE AS THE UNDERLYING NUMERIC VALUE WILL CHANGE OVER TIME!' AFTER `OrganizationId`;

