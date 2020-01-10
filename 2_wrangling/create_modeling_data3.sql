--create extension fuzzystrmatch;

drop table if exists analytical_table;
create temp table analytical_table as
select distinct
		t.tconst,
		t.primarytitle,
		t.startyear,
		t.runtimeminutes,
		case 
			when position('Action' in t.genres) is null then 0
			when position('Action' in t.genres) = 0 then 0
			else 1
		end as action,
		case 
			when position('Comedy' in t.genres) is null then 0
			when position('Comedy' in t.genres) = 0 then 0
			else 1
		end as comedy,
		case 
			when position('Drama' in t.genres) is null then 0
			when position('Drama' in t.genres) = 0 then 0
			else 1
		end as drama,
		case 
			when position('Adventure' in t.genres) is null then 0
			when position('Adventure' in t.genres) = 0 then 0
			else 1
		end as adventure,
		case 
			when position('Biography' in t.genres) is null then 0
			when position('Biography' in t.genres) = 0 then 0
			else 1
		end as biography,
		case 
			when position('Horror' in t.genres) is null then 0
			when position('Horror' in t.genres) = 0 then 0
			else 1
		end as horror,
		case 
			when position('Crime' in t.genres) is null then 0
			when position('Crime' in t.genres) = 0 then 0
			else 1
		end as crime,
		case 
			when position('Documentary' in t.genres) is null then 0
			when position('Documentary' in t.genres) = 0 then 0
			else 1
		end as documentary,
		case 
			when position('Animation' in t.genres) is null then 0
			when position('Animation' in t.genres) = 0 then 0
			else 1
		end as animation,
		case 
			when position('Romance' in t.genres) is null then 0
			when position('Romance' in t.genres) = 0 then 0
			else 1
		end as romance,
		case 
			when position('Mystery' in t.genres) is null then 0
			when position('Mystery' in t.genres) = 0 then 0
			else 1
		end as mystery,
		case 
			when position('Thriller' in t.genres) is null then 0
			when position('Thriller' in t.genres) = 0 then 0
			else 1
		end as thriller,
		case 
			when position('Sci-Fi' in t.genres) is null then 0
			when position('Sci-Fi' in t.genres) = 0 then 0
			else 1
		end as scifi,
		case 
			when position('Fantasy' in t.genres) is null then 0
			when position('Fantasy' in t.genres) = 0 then 0
			else 1
		end as fantasy,
		case 
			when position('Family' in t.genres) is null then 0
			when position('Family' in t.genres) = 0 then 0
			else 1
		end as family,
		case
			when r.category1 = 'actor' then 1
			else 0
		end as male_lead,
		concat_ws(',',r.name1,r.name2,r.name3,r.name4,r.name5,r.name6,r.name7,r.name8) as names
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
from title_rev_html1
where right(releasedate,4) <> 'nown' and releasedate is not null;

drop table if exists modeling_data3;
create table modeling_data3 as
select
	a.primarytitle,
	cast(replace(replace(c.domesticgross,'$',''),',','') as bigint) as domesticgross,
	cast(replace(replace(c.productionbudget,'$',''),',','') as bigint) as productionbudget,
	a.runtimeminutes,
	cast(date_part('year', to_date(c.releasedate, 'Mon DD, YYYY')) as integer) as release_year,
	cast(date_part('week', to_date(c.releasedate, 'Mon DD, YYYY')) as integer) as release_week,
	case 
		when left(d.rating,1) = 'G' then 1
		else 0
	end as G_rating,
	case 
		when left(d.rating,2) = 'PG' and left(d.rating,5) <> 'PG-13' then 1
		else 0
	end as PG_rating,
	case 
		when left(d.rating,5) = 'PG-13' then 1
		else 0
	end as PG13_rating,
	case 
		when left(d.rating,1) = 'R' then 1
		else 0
	end as R_rating,
	coalesce(genre.genre_year_avg_sales,0) as genre_year_avg_sales,
	a.action,
	a.comedy,
	a.drama,
	a.adventure,
	a.biography,
	a.horror,
	a.crime,
	a.documentary,
	a.animation,
	a.romance,
	a.mystery,
	a.thriller,
	a.scifi,
	a.fantasy,
	a.family,
	case 
		when position('3-D' in d.keywords) is null then 0
		when position('3-D' in d.keywords) = 0 then 0
		else 1
	end as threed,
	case 
		when position('Animal Lead' in d.keywords) is null then 0
		when position('Animal Lead' in d.keywords) = 0 then 0
		else 1
	end as animallead,
	case 
		when position('Dysfunctional Family' in d.keywords) is null then 0
		when position('Dysfunctional Family' in d.keywords) = 0 then 0
		else 1
	end as dysfunctionalfamily,
	case 
		when position('African-American' in d.keywords) is null then 0
		when position('African-American' in d.keywords) = 0 then 0
		else 1
	end as africanamerican,
	case 
		when position('Marvel Comics' in d.keywords) is null then 0
		when position('Marvel Comics' in d.keywords) = 0 then 0
		else 1
	end as marvelcomics,
	case 
		when position('Religious' in d.keywords) is null then 0
		when position('Religious' in d.keywords) = 0 then 0
		else 1
	end as religious,
	case 
		when position('Talking Animals' in d.keywords) is null then 0
		when position('Talking Animlas' in d.keywords) = 0 then 0
		else 1
	end as talkinganimals,
	case 
		when position('Visual Effects' in d.keywords) is null then 0
		when position('Visual Effects' in d.keywords) = 0 then 0
		else 1
	end as visualeffects,
	case 
		when position('Revenge' in d.keywords) is null then 0
		when position('Revenge' in d.keywords) = 0 then 0
		else 1
	end as revenge,
	a.male_lead,
	coalesce(lead.lead_prior_avg_sales,0) as lead_prior_avg_sales,
	coalesce(lead.lead_prior_lead_count,0) as lead_prior_lead_count,
	case 
		when position('Matt Damon' in a.names) is null then 0
		when position('Matt Damon' in a.names) = 0 then 0
		else 1
	end as matt_damon,
	case 
		when position('Nicolas Cage' in a.names) is null then 0
		when position('Nicolas Cage' in a.names) = 0 then 0
		else 1
	end as nicolas_cage,
	case 
		when position('Owen Wilson' in a.names) is null then 0
		when position('Owen Wilson' in a.names) = 0 then 0
		else 1
	end as owen_wilson,
	case 
		when position('Samuel L. Jackson' in a.names) is null then 0
		when position('Samuel L. Jackson' in a.names) = 0 then 0
		else 1
	end as samuel_l_jackson,
	case 
		when position('Mark Wahlberg' in a.names) is null then 0
		when position('Mark Wahlberg' in a.names) = 0 then 0
		else 1
	end as mark_wahlberg,
	case 
		when position('Adam Sandler' in a.names) is null then 0
		when position('Adam Sandler' in a.names) = 0 then 0
		else 1
	end as adam_sandler,
	case 
		when position('Denzel Washington' in a.names) is null then 0
		when position('Denzel Washington' in a.names) = 0 then 0
		else 1
	end as denzel_washington,
	case 
		when position('Dwayne Johnson' in a.names) is null then 0
		when position('Dwayne Johnson' in a.names) = 0 then 0
		else 1
	end as dwayne_johnson,
	case 
		when position('Gerard Butler' in a.names) is null then 0
		when position('Gerard Butler' in a.names) = 0 then 0
		else 1
	end as gerard_butler,
	case 
		when position('George Clooney' in a.names) is null then 0
		when position('George Clooney' in a.names) = 0 then 0
		else 1
	end as george_clooney,
	case 
		when position('Ben Stiller' in a.names) is null then 0
		when position('Ben Stiller' in a.names) = 0 then 0
		else 1
	end as ben_stiller,
	case 
		when position('Robert De Niro' in a.names) is null then 0
		when position('Robert De Niro' in a.names) = 0 then 0
		else 1
	end as robert_de_niro,
	case 
		when position('Bruce Willis' in a.names) is null then 0
		when position('Bruce Willis' in a.names) = 0 then 0
		else 1
	end as bruce_willis,
	case 
		when position('Will Smith' in a.names) is null then 0
		when position('Will Smith' in a.names) = 0 then 0
		else 1
	end as will_smith,
	case 
		when position('Ben Affleck' in a.names) is null then 0
		when position('Ben Affleck' in a.names) = 0 then 0
		else 1
	end as ben_affleck,
	case 
		when position('Will Ferrell' in a.names) is null then 0
		when position('Will Ferrell' in a.names) = 0 then 0
		else 1
	end as will_ferrell,
	case 
		when position('Tom Hanks' in a.names) is null then 0
		when position('Tom Hanks' in a.names) = 0 then 0
		else 1
	end as tom_hanks,
	case 
		when position('Tom Cruise' in a.names) is null then 0
		when position('Tom Cruise' in a.names) = 0 then 0
		else 1
	end as tom_cruise,
	case 
		when position('Keanu Reeves' in a.names) is null then 0
		when position('Keanu Reeves' in a.names) = 0 then 0
		else 1
	end as keanu_reeves,
	case 
		when position('Leonardo DiCaprio' in a.names) is null then 0
		when position('Leonardo DiCaprio' in a.names) = 0 then 0
		else 1
	end as leonardo_dicaprio,
	case 
		when position('Jake Gyllenhaal' in a.names) is null then 0
		when position('Jake Gyllenhaal' in a.names) = 0 then 0
		else 1
	end as jake_gyllenhaal,
	case 
		when position('Steve Carell' in a.names) is null then 0
		when position('Steve Carell' in a.names) = 0 then 0
		else 1
	end as steve_carell,
	case 
		when position('Johnny Depp' in a.names) is null then 0
		when position('Johnny Depp' in a.names) = 0 then 0
		else 1
	end as johnny_depp,
	case 
		when position('Matthew McConaughey' in a.names) is null then 0
		when position('Matthew McConaughey' in a.names) = 0 then 0
		else 1
	end as matthew_mcconaughey,
	case 
		when position('Jason Statham' in a.names) is null then 0
		when position('Jason Statham' in a.names) = 0 then 0
		else 1
	end as jason_statham,
	case 
		when position('Vin Diesel' in a.names) is null then 0
		when position('Vin Diesel' in a.names) = 0 then 0
		else 1
	end as vin_diesel,
	case 
		when position('Robert Downey Jr.' in a.names) is null then 0
		when position('Robert Downey Jr.' in a.names) = 0 then 0
		else 1
	end as robert_downey_jr,
	case 
		when position('Christian Bale' in a.names) is null then 0
		when position('Christian Bale' in a.names) = 0 then 0
		else 1
	end as christian_bale,
	case 
		when position('Reese Witherspoon' in a.names) is null then 0
		when position('Reese Witherspoon' in a.names) = 0 then 0
		else 1
	end as reese_witherspoon,
	case 
		when position('Russell Crowe' in a.names) is null then 0
		when position('Russell Crowe' in a.names) = 0 then 0
		else 1
	end as russell_crowe,
	case 
		when position('Ice Cube' in a.names) is null then 0
		when position('Ice Cube' in a.names) = 0 then 0
		else 1
	end as ice_cube,
	case 
		when position('Sandra Bullock' in a.names) is null then 0
		when position('Sandra Bullock' in a.names) = 0 then 0
		else 1
	end as sandra_bullock,
	case 
		when position('Jackie Chan' in a.names) is null then 0
		when position('Jackie Chan' in a.names) = 0 then 0
		else 1
	end as jackie_chan,
	case 
		when position('Cate Blanchett' in a.names) is null then 0
		when position('Cate Blanchett' in a.names) = 0 then 0
		else 1
	end as cate_blanchett,
	case 
		when position('Brad Pitt' in a.names) is null then 0
		when position('Brad Pitt' in a.names) = 0 then 0
		else 1
	end as brad_pitt,
	case 
		when position('John Goodman' in a.names) is null then 0
		when position('John Goodman' in a.names) = 0 then 0
		else 1
	end as john_goodman,
	case 
		when position('Channing Tatum' in a.names) is null then 0
		when position('Channing Tatum' in a.names) = 0 then 0
		else 1
	end as channing_tatum,
	case 
		when position('Jim Carrey' in a.names) is null then 0
		when position('Jim Carrey' in a.names) = 0 then 0
		else 1
	end as jim_carrey,
	case 
		when position('Jack Black' in a.names) is null then 0
		when position('Jack Black' in a.names) = 0 then 0
		else 1
	end as jack_black,
	case 
		when position('Colin Farrell' in a.names) is null then 0
		when position('Colin Farrell' in a.names) = 0 then 0
		else 1
	end as colin_farrell,
	case 
		when position('Hugh Jackman' in a.names) is null then 0
		when position('Hugh Jackman' in a.names) = 0 then 0
		else 1
	end as hugh_jackman,
	coalesce(director.director_prior_avg_sales,0) as director_prior_avg_sales,
	coalesce(director.director_prior_count,0) as director_prior_count,
	case 
		when position('Steven Soderbergh' in a.names) is null then 0
		when position('Steven Soderbergh' in a.names) = 0 then 0
		else 1
	end as stephen_soderbergh,
	case 
		when position('Ridley Scott' in a.names) is null then 0
		when position('Ridley Scott' in a.names) = 0 then 0
		else 1
	end as ridley_scott,
	case 
		when position('Steven Spielberg' in a.names) is null then 0
		when position('Steven Spielberg' in a.names) = 0 then 0
		else 1
	end as steven_spielberg,
	case 
		when position('Ron Howard' in a.names) is null then 0
		when position('Ron Howard' in a.names) = 0 then 0
		else 1
	end as ron_howard,
	case 
		when position('Tim Burton' in a.names) is null then 0
		when position('Tim Burton' in a.names) = 0 then 0
		else 1
	end as tim_burton,
	case 
		when position('Clint Eastwood' in a.names) is null then 0
		when position('Clint Eastwood' in a.names) = 0 then 0
		else 1
	end as clint_eastwood,
	case 
		when position('Shawn Levy' in a.names) is null then 0
		when position('Shawn Levy' in a.names) = 0 then 0
		else 1
	end as shawn_levy,
	case 
		when position('Michael Bay' in a.names) is null then 0
		when position('Michael Bay' in a.names) = 0 then 0
		else 1
	end as michael_bay,
	case
		when position('M\\. Night Shyamalan' in a.names) is null then 0
		when position('M\\. Night Shyamalan' in a.names) = 0 then 0
		else 1
	end as m_night_shyamalan,
	case 
		when position('Martin Scorsese' in a.names) is null then 0
		when position('Martin Scorsese' in a.names) = 0 then 0
		else 1
	end as martin_scorsese,
	case 
		when position('Peter Jackson' in a.names) is null then 0
		when position('Peter Jackson' in a.names) = 0 then 0
		else 1
	end as peter_jackson,
	case 
		when position('Guy Ritchie' in a.names) is null then 0
		when position('Guy Ritchie' in a.names) = 0 then 0
		else 1
	end as guy_ritchie,
	case 
		when position('David Gordon Green' in a.names) is null then 0
		when position('David Gordon Green' in a.names) = 0 then 0
		else 1
	end as david_gordon_green,
	case 
		when position('Christopher Nolan' in a.names) is null then 0
		when position('Christopher Nolan' in a.names) = 0 then 0
		else 1
	end as christopher_nolan,
	case 
		when position('Todd Phillips' in a.names) is null then 0
		when position('Todd Phillips' in a.names) = 0 then 0
		else 1
	end as todd_phillips,
	case
		when b.studio = 'WB' then 1
		else 0
	end as warner_bros,
	case
		when b.studio = 'Uni.' then 1
		else 0
	end as universal,
	case
		when b.studio = 'Fox' then 1
		else 0
	end as fox,
	case
		when b.studio = 'BV' then 1
		else 0
	end as buena_vista,
	case
		when b.studio = 'Sony' then 1
		else 0
	end as sony,
	case
		when b.studio = 'Par.' then 1
		else 0
	end as paramount
from analytical_table as a
left join box_office_mojo_title_year as b on slugify(a.primarytitle) = slugify(b.title) and a.startyear=b.yearnum
left join title_rev_html_year as c on slugify(a.primarytitle) = slugify(c.title) and a.startyear=c.releaseyear
left join title_dtls_html as d on c.id=d.id
left join lead_actor_history_features as lead on a.tconst=lead.tconst
left join director_history_features as director on a.tconst=director.tconst
left join genre_history_features as genre on a.tconst=genre.tconst
where c.domesticgross is not null and cast(replace(replace(c.domesticgross,'$',''),',','') as bigint) <> 0;