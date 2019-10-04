--Script to create analytical table by parsing genre field into 3 fields
--Need to add code to attach top principals data to this analytical table...

create table movies_analytical_table as
select 	id,
		tconst,
		titletype,
		primarytitle,
		originaltitle,
		region,
		isadult,
		startyear,
		endyear,
		runtimeminutes,
		split_part(genres,',',1) as genre1,
		split_part(genres,',',2) as genre2,
		split_part(genres,',',3) as genre3
from title_basics_movies_us_recent;