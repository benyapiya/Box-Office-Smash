drop table if exists top_genre1;

create temp table top_genre1 as
select genre1, count(genre1) 
from movies_analytical_table2 
group by genre1 
having count(genre1)>50
order by count(genre1) desc;

select a.*, b.genre1 as top_genre1 from movies_analytical_table2 as a left join top_genre1 as b on a.genre1=b.genre1;