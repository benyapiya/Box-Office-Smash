--Script to filter title_principals table for recent US releases and de-normalize list of principals
--Add principal names from name_basics table

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

create table recent_us_principals_names as
select
	t.tconst,
	t.nconst1,
	n1."primaryName" as name1,
	t.category1,
	t.nconst2,
	n2."primaryName" as name2,
	t.category2,
	t.nconst3,
	n3."primaryName" as name3,
	t.category3,
	t.nconst4,
	n4."primaryName" as name4,
	t.category4,
	t.nconst5,
	n5."primaryName" as name5,
	t.category5,
	t.nconst6,
	n6."primaryName" as name6,
	t.category6,
	t.nconst7,
	n7."primaryName" as name7,
	t.category7,
	t.nconst8,
	n8."primaryName" as name8,
	t.category8
from recent_us_principals_by_title as t
left join name_basics as n1 on t.nconst1=n1.nconst
left join name_basics as n2 on t.nconst2=n2.nconst
left join name_basics as n3 on t.nconst3=n3.nconst
left join name_basics as n4 on t.nconst4=n4.nconst
left join name_basics as n5 on t.nconst5=n5.nconst
left join name_basics as n6 on t.nconst6=n6.nconst
left join name_basics as n7 on t.nconst7=n7.nconst
left join name_basics as n8 on t.nconst8=n8.nconst;
	