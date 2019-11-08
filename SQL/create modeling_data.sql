--Get lists of the most prevalent genres in each genre field to populate modeling table
--Less frequent genre descriptions will be coded as 'Other'

drop table if exists top_genre1;
create temp table top_genre1 as
select genre1, count(genre1) 
from movies_analytical_table2 
group by genre1 
having count(genre1)>=50
order by count(genre1) desc;

drop table if exists top_genre2;
create temp table top_genre2 as
select genre2, count(genre2) 
from movies_analytical_table2 
group by genre2 
having count(genre2)>=50
order by count(genre2) desc;

drop table if exists top_genre3;
create temp table top_genre3 as
select genre3, count(genre3) 
from movies_analytical_table2 
group by genre3 
having count(genre3)>=50
order by count(genre3) desc;

--Get lists of the most prevalent keywords in each keyword field to populate modeling table
--Less frequent keyword descriptions will be coded as 'Other'

drop table if exists top_keyword1;
create temp table top_keyword1 as
select keyword1, count(keyword1) 
from movies_analytical_table2 
group by keyword1 
having count(keyword1)>=30
order by count(keyword1) desc;

drop table if exists top_keyword2;
create temp table top_keyword2 as
select keyword2, count(keyword2) 
from movies_analytical_table2 
group by keyword2 
having count(keyword2)>=20
order by count(keyword2) desc;

drop table if exists top_keyword3;
create temp table top_keyword3 as
select keyword3, count(keyword3) 
from movies_analytical_table2 
group by keyword3 
having count(keyword3)>=20
order by count(keyword3) desc;

--Get list of the most prevalent studios to populate modeling table
--Less frequent studios will be coded as 'Other'

drop table if exists top_studio;
create temp table top_studio as
select studio, count(studio) 
from movies_analytical_table2 
group by studio 
having count(studio)>=100
order by count(studio) desc;

--Handle top names

drop table if exists top_name1;
create temp table top_name1 as
select name1, count(name1) 
from movies_analytical_table2 
group by name1 
having count(name1)>=10
order by count(name1) desc;

drop table if exists top_name2;
create temp table top_name2 as
select name2, count(name2) 
from movies_analytical_table2 
group by name2 
having count(name2)>=8
order by count(name2) desc;

drop table if exists top_name3;
create temp table top_name3 as
select name3, count(name3) 
from movies_analytical_table2 
group by name3 
having count(name3)>=7
order by count(name3) desc;

drop table if exists top_name5;
create temp table top_name5 as
select name5, count(name5) 
from movies_analytical_table2 
group by name5 
having count(name5)>=9
order by count(name5) desc;

--Create final modeling table

drop table if exists modeling_data;
create table modeling_data as select
	a.primarytitle,
	a.domesticgross,
	a.productionbudget,
	a.releasedate,
	a.startyear,
	coalesce(h.studio,'Other') as studio,
	a.runtimeminutes,
	coalesce(b.genre1,'Other') as genre1,
	coalesce(c.genre2,'Other') as genre2,
	coalesce(d.genre3,'Other') as genre3,
	coalesce(e.keyword1,'Other') as keyword1,
	coalesce(f.keyword2,'Other') as keyword2,
	coalesce(g.keyword3,'Other') as keyword3,
	a.keywords,
	coalesce(i.name1,'Other') as name1,
	coalesce(j.name2,'Other') as name2,
	coalesce(k.name3,'Other') as name3,
	coalesce(l.name5,'Other') as name5
from movies_analytical_table2 as a 
left join top_genre1 as b on a.genre1=b.genre1
left join top_genre2 as c on a.genre2=c.genre2
left join top_genre3 as d on a.genre3=d.genre3
left join top_keyword1 as e on a.keyword1=e.keyword1
left join top_keyword2 as f on a.keyword2=f.keyword2
left join top_keyword3 as g on a.keyword3=g.keyword3
left join top_studio as h on a.studio=h.studio
left join top_name1 as i on a.name1=i.name1
left join top_name2 as j on a.name2=j.name2
left join top_name3 as k on a.name3=k.name3
left join top_name5 as l on a.name5=l.name5
;