create or replace function dt_or_null (s text, fmt text)
returns date
as
$$
begin
return to_date(s, fmt);
exception
when others then return null;
end;
$$ language plpgsql;

drop table if exists analytical_table;
create temp table analytical_table as
select distinct
		id,
		t.tconst,
		t.titletype,
		t.primarytitle,
		t.startyear,
		t.endyear,
		split_part(t.genres,',',1) as genre1,
		split_part(t.genres,',',2) as genre2,
		split_part(t.genres,',',3) as genre3,
		r.nconst1,
		r.name1,
		r.category1,
		r.nconst5,
		r.name5,
		r.category5
from title_basics_movies_us_all as t
left join us_principals_names as r on t.tconst=r.tconst;

drop table if exists title_rev_html_year;
create temp table title_rev_html_year as
select *,
		cast(right(releasedate,4) as integer) as releaseyear
from title_rev_html1
where right(releasedate,4) <> 'nown' and releasedate is not null;

drop table if exists movies_financials;
create temp table movies_financials as
select
	a.tconst,
	a.primarytitle,
	dt_or_null(c.releasedate, 'Mon DD, YYYY') as release_date,
	a.genre1,
	a.genre2,
	a.genre3,
	a.nconst1,
	a.name1,
	a.category1,
	a.nconst5,
	a.name5,
	a.category5,
	cast(replace(replace(c.productionbudget,'$',''),',','') as bigint) as productionbudget,
	cast(replace(replace(c.domesticgross,'$',''),',','') as bigint) as domesticgross
from analytical_table as a
left join title_rev_html_year as c on slugify(a.primarytitle) = slugify(c.title) and a.startyear=c.releaseyear
left join title_dtls_html as d on c.id=d.id
where c.domesticgross is not null;

drop table if exists lead_actor_history_features;
create table lead_actor_history_features as
select 
	t1.tconst,
	t1.primarytitle,
	t1.release_date,
	t1.nconst1,
	t1.name1,
	t1.category1,
	t1.domesticgross,
	avg(t2.domesticgross) as lead_prior_avg_sales,
	count(t2.tconst) as lead_prior_lead_count
from movies_financials as t1
inner join movies_financials as t2
	on (t1.release_date > t2.release_date and t1.nconst1 = t2.nconst1)
where t1.category1 in ('actor','actress')
group by t1.tconst, t1.primarytitle, t1.release_date, t1.nconst1, t1.name1, t1.category1, t1.domesticgross
order by t1.nconst1, t1.release_date
;

drop table if exists director_history_features;
create table director_history_features as
select 
	t1.tconst,
	t1.primarytitle,
	t1.release_date,
	t1.nconst5,
	t1.name5,
	t1.category5,
	t1.domesticgross,
	avg(t2.domesticgross) as director_prior_avg_sales,
	count(t2.tconst) as director_prior_count
from movies_financials as t1
inner join movies_financials as t2
	on (t1.release_date > t2.release_date and t1.nconst5 = t2.nconst5)
where t1.category5 in ('director')
group by t1.tconst, t1.primarytitle, t1.release_date, t1.nconst5, t1.name5, t1.category5, t1.domesticgross
order by t1.nconst5, t1.release_date
;

drop table if exists genre_history_features;
create table genre_history_features as
select 
	t1.tconst,
	t1.primarytitle,
	t1.release_date,
	t1.genre1,
	t1.domesticgross,
	avg(t2.domesticgross) as genre_year_avg_sales
from movies_financials as t1
inner join movies_financials as t2
	on (t1.release_date - interval '90 days' > t2.release_date and t2.release_date > t1.release_date - interval '455 days' 
		and t1.genre1 = t2.genre1)
group by t1.tconst, t1.primarytitle, t1.release_date, t1.genre1, t1.domesticgross
order by t1.genre1, t1.release_date
;
