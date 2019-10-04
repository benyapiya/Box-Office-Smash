--Script to create tables of most prolific actors, actresses, directors, etc
--Cut off criteria determined judgmentally

create temp table title_principals_us_recent as 
select distinct title_principals.tconst,
				title_principals.nconst,
				title_principals.category
from title_principals inner join title_basics_movies_us_recent on
	title_principals.tconst = title_basics_movies_us_recent.tconst;

create temp table summed_principals as
select nconst, category, count(tconst)
from title_principals_us_recent
group by nconst, category
order by count(tconst) desc;

create table if not exists top_actors as
select summed_principals.*, name_basics."primaryName"
from summed_principals left join name_basics on
	summed_principals.nconst = name_basics.nconst
where category = 'actor' and count >= 20;

create table if not exists top_actresses as
select summed_principals.*, name_basics."primaryName"
from summed_principals left join name_basics on
	summed_principals.nconst = name_basics.nconst
where category = 'actress' and count >= 15;

create table if not exists top_directors as
select summed_principals.*, name_basics."primaryName"
from summed_principals left join name_basics on
	summed_principals.nconst = name_basics.nconst
where category = 'director' and count >= 10;

create table if not exists top_producers as
select summed_principals.*, name_basics."primaryName"
from summed_principals left join name_basics on
	summed_principals.nconst = name_basics.nconst
where category = 'producer' and count >=25;

create table if not exists top_writers as
select summed_principals.*, name_basics."primaryName"
from summed_principals left join name_basics on
	summed_principals.nconst = name_basics.nconst
where category = 'writer' and count >= 10;

create table if not exists top_self as
select summed_principals.*, name_basics."primaryName"
from summed_principals left join name_basics on
	summed_principals.nconst = name_basics.nconst
where category = 'self' and count >= 10;

create table if not exists top_composers as
select summed_principals.*, name_basics."primaryName"
from summed_principals left join name_basics on
	summed_principals.nconst = name_basics.nconst
where category = 'composer' and count >= 35;