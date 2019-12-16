-- script to filter moviesdb.table_basics table for only movies after 1999
-- convert \N entries to NULL and convert some columns to numeric

drop table if exists titles_us;
create temp table titles_us as
	select distinct "titleId", region
	from title_akas
	where region = 'US';

drop table if exists title_basics_movies_us;
create temp table title_basics_movies_us as 
	select title_basics.*, titles_us.region 
	from title_basics inner join titles_us on
		title_basics.tconst = titles_us."titleId"
	where titletype = 'movie';

update title_basics_movies_us
	set startyear = NULL
	where startyear = '\N';

update title_basics_movies_us
	set endyear = NULL
	where endyear = '\N';

update title_basics_movies_us
	set runtimeminutes = NULL
	where runtimeminutes = '\N';

update title_basics_movies_us
	set genres = NULL
	where genres = '\N';

alter table title_basics_movies_us
	alter column startyear type integer using startyear::integer,
	alter column endyear type integer using endyear::integer,
	alter column runtimeminutes type integer using runtimeminutes::integer;

drop table if exists title_basics_movies_us_all;
create table if not exists title_basics_movies_us_all as
	select distinct * 
	from title_basics_movies_us;