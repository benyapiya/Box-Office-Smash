--Script to create analytical table by parsing genre field into 3 fields
--Add principal names for each title
--Add keywords and parse them into individual fields

--create extension fuzzystrmatch;

drop table if exists analytical_table;
create temp table analytical_table as
select distinct
		id,
		t.tconst,
		t.titletype,
		t.primarytitle,
		t.originaltitle,
		t.region,
		cast(t.isadult as integer) as isadult,
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

drop table if exists box_office_mojo_title_year;
create temp table box_office_mojo_title_year as
select *,
		cast(left(year,4) as integer) as yearnum
from box_office_mojo_title
where year <> 'n/a';

drop table if exists title_rev_html_year;
create temp table title_rev_html_year as
select *,
		cast(right(releasedate,4) as integer) as releaseyear
from title_rev_html
where right(releasedate,4) <> 'nown' and releasedate is not null;

drop table if exists movies_analytical_table;
create table movies_analytical_table as
select
	a.*,
	b.title as mojo_title,
	c.title as numbers_title,
	d.keywords,
	split_part(d.keywords,',',1) as keyword1,
	split_part(d.keywords,',',2) as keyword2,
	split_part(d.keywords,',',3) as keyword3,
	split_part(d.keywords,',',4) as keyword4,
	split_part(d.keywords,',',5) as keyword5,
	split_part(d.keywords,',',6) as keyword6,
	split_part(d.keywords,',',7) as keyword7,
	split_part(d.keywords,',',8) as keyword8,
	split_part(d.keywords,',',9) as keyword9,
	split_part(d.keywords,',',10) as keyword10,
	split_part(d.keywords,',',11) as keyword11,
	split_part(d.keywords,',',12) as keyword12,
	split_part(d.keywords,',',13) as keyword13,
	split_part(d.keywords,',',14) as keyword14,
	split_part(d.keywords,',',15) as keyword15,
	split_part(d.keywords,',',16) as keyword16,
	split_part(d.keywords,',',17) as keyword17,
	split_part(d.keywords,',',18) as keyword18,
	split_part(d.keywords,',',19) as keyword19,
	split_part(d.keywords,',',20) as keyword20,
	split_part(d.keywords,',',21) as keyword21,
	split_part(d.keywords,',',22) as keyword22,
	split_part(d.keywords,',',23) as keyword23,
	split_part(d.keywords,',',24) as keyword24,
	split_part(d.keywords,',',25) as keyword25,
	split_part(d.keywords,',',26) as keyword26,
	split_part(d.keywords,',',27) as keyword27,
	split_part(d.keywords,',',28) as keyword28,
	split_part(d.keywords,',',29) as keyword29,
	split_part(d.keywords,',',30) as keyword30,
	split_part(d.keywords,',',30) as keyword31,
	b.studio,
	c.releasedate,
	cast(replace(replace(b.lifetime_gross,'$',''),',','') as bigint) as lifetime_gross,
	cast(replace(replace(c.productionbudget,'$',''),',','') as bigint) as productionbudget,
	cast(replace(replace(c.domesticgross,'$',''),',','') as bigint) as domesticgross,
	cast(replace(replace(c.worldwidegross,'$',''),',','') as bigint) as worldwidegross
from analytical_table as a
left join box_office_mojo_title_year as b on slugify(a.primarytitle) = slugify(b.title) and a.startyear=b.yearnum
left join title_rev_html_year as c on slugify(a.primarytitle) = slugify(c.title) and a.startyear=c.releaseyear
left join title_dtls_html as d on c.id=d.id;