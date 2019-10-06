create temp table recent_us_principals as 
	select title_principals.* 
	from title_principals inner join title_basics_movies_us_recent on
		title_principals.tconst=title_basics_movies_us_recent.tconst;

alter table recent_us_principals
alter column ordering type integer using ordering::integer;

create table recent_us_principals_by_title as select distinct
	t.tconst,
	t1.nconst as nconst1,
	t1.category as category1,
	t2.nconst as nconst2,
	t2.category as category2,
	t3.nconst as nconst3,
	t3.category as category3,
	t4.nconst as nconst4,
	t4.category as category4,
	t5.nconst as nconst5,
	t5.category as category5,
	t6.nconst as nconst6,
	t6.category as category6,
	t7.nconst as nconst7,
	t7.category as category7,
	t8.nconst as nconst8,
	t8.category as category8
from recent_us_principals as t
left join recent_us_principals as t1 on (t1.ordering=1 and t.tconst=t1.tconst)
left join recent_us_principals as t2 on (t2.ordering=2 and t.tconst=t2.tconst)
left join recent_us_principals as t3 on (t3.ordering=3 and t.tconst=t3.tconst)
left join recent_us_principals as t4 on (t4.ordering=4 and t.tconst=t4.tconst)
left join recent_us_principals as t5 on (t5.ordering=5 and t.tconst=t5.tconst)
left join recent_us_principals as t6 on (t6.ordering=6 and t.tconst=t6.tconst)
left join recent_us_principals as t7 on (t7.ordering=7 and t.tconst=t7.tconst)
left join recent_us_principals as t8 on (t8.ordering=8 and t.tconst=t8.tconst);