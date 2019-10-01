create table if not exists title_basics_movies as 
	select * 
	from title_basics
	where titletype = 'movie';

update title_basics_movies
	set startyear = NULL
	where startyear = '\N';

update title_basics_movies
	set endyear = NULL
	where endyear = '\N';
	
update title_basics_movies
	set runtimeminutes = NULL
	where runtimeminutes = '\N';

alter table title_basics_movies
	alter column startyear type integer using startyear::integer,
	alter column endyear type integer using endyear::integer,
	alter column runtimeminutes type integer using runtimeminutes::integer;

create table if not exists title_basics_movies_recent as
	select * 
	from title_basics_movies
	where startyear > 1999;
	
update title_basics_movies_recent
	set genres = NULL
	where genres = '\N';