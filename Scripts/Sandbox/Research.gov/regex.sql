#'[^a-z0-9,.&\' -]'
select distinct PDPIPhone from ResearchGovRaw where PDPIPhone regexp '[^0-9() -]' order by PDPIPhone
select PDPIPhone from ResearchGovRaw where PDPIPhone not regexp '[(][0-9]{3}[)] [0-9]{3}-[0-9]{4}.*' and PDPIPhone != '' order by PDPIPhone
select PDPIEmail from ResearchGovRaw where PDPIEmail regexp '[^a-z0-9@._-]' order by PDPIPhone
select CoPDsCoPIs from ResearchGovRaw where CoPDsCoPIs regexp '[^a-z., -]' order by CoPDsCoPIs
select distinct AwardDate from ResearchGovRaw