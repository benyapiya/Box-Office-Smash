--Script to create analytical table by parsing genre field into 3 fields
--Add principal names for each title
--Add keywords and parse them into individual fields

--create extension fuzzystrmatch;

drop table if exists analytical_table;
create temp table analytical_table as
select distinct
		t.primarytitle,
		t.startyear,
		t.runtimeminutes,
		split_part(t.genres,',',1) as genre1,
		split_part(t.genres,',',2) as genre2,
		split_part(t.genres,',',3) as genre3,
		r.name1,
		r.name2,
		r.name3,
		r.name4,
		r.name5,
		r.name6,
		r.name7,
		r.name8
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

drop table if exists movies_analytical_table2;
create table movies_analytical_table2 as
select
	a.*,
	d.keywords,
	split_part(d.keywords,',',1) as keyword1,
	split_part(d.keywords,',',2) as keyword2,
	split_part(d.keywords,',',3) as keyword3,
	b.studio,
	c.releasedate,
	cast(replace(replace(c.productionbudget,'$',''),',','') as bigint) as productionbudget,
	cast(replace(replace(c.domesticgross,'$',''),',','') as bigint) as domesticgross
from analytical_table as a
left join box_office_mojo_title_year as b on slugify(a.primarytitle) = slugify(b.title) and a.startyear=b.yearnum
left join title_rev_html_year as c on slugify(a.primarytitle) = slugify(c.title) and a.startyear=c.releaseyear
left join title_dtls_html as d on c.title=d.title
where c.domesticgross is not null;