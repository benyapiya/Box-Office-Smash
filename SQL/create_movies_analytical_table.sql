--Script to create analytical table by parsing genre field into 3 fields
--Add principal names for each title

create temp table analytical_table as
select 	id,
		t.tconst,
		t.titletype,
		t.primarytitle,
		t.originaltitle,
		t.region,
		cast(t.isadult as integer),
		t.startyear,
		t.endyear,
		t.runtimeminutes,
		split_part(t.genres,',',1) as genre1,
		split_part(t.genres,',',2) as genre2,
		split_part(t.genres,',',3) as genre3,
		r.nconst1,
		r.name1,
		r.category1,
		r.nconst2,
		r.name2,
		r.category2,
		r.nconst3,
		r.name3,
		r.category3,
		r.nconst4,
		r.name4,
		r.category4,
		r.nconst5,
		r.name5,
		r.category5,
		r.nconst6,
		r.name6,
		r.category6,
		r.nconst7,
		r.name7,
		r.category7,
		r.nconst8,
		r.name8,
		r.category8
from title_basics_movies_us_recent as t
left join recent_us_principals_names as r on t.tconst=r.tconst;

create table movies_analytical_table as
select
	a.*,
	b.studio,
	cast(replace(replace(b.lifetime_gross,'$',''),',','') as integer)
from analytical_table as a
left join box_office_mojo_title as b on a.primarytitle=b.title

union select
	a.*,
	b.studio,
	cast(replace(replace(b.lifetime_gross,'$',''),',','') as integer)
from analytical_table as a
left join box_office_mojo_title as b on a.originaltitle=b.title;