insert into author
(
	RawID,
	Cluster,
	AuthorID,
	ClusterSize,
	YearRange,
	TotalTimesCited,
	HIndex,
	AuthorID_10Recent,
	ClusterSize_10Recent,
	YearRange_10Recent,
	TotalTimesCited_10Recent,
	HIndex_10Recent
)
select
	RawID,
	Cluster,
	AuthorID,
	ClusterSize,
	YearRange,
	TotalTimesCited,
	HIndex,
	AuthorID_10Recent,
	ClusterSize_10Recent,
	YearRange_10Recent,
	TotalTimesCited_10Recent,
	HIndex_10Recent
from raw
order by rawid
