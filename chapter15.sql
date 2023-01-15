select count(*) from races;

select * from races limit 1;

select code,
       format('%s %s', forename, surname) as fullname,
       forename,
       surname
from drivers;

select date::date,
       extract('isodow' from date) as dow,
       to_char(date, 'dy') as day,
       extract('isoyear' from date) as "iso year",
       extract('week' from date) as week,
       extract('day' from (date+interval '2 month - 1 day')) as feb,
       extract('year' from date ) as year,
       extract('day' from (date + interval '2 month - 1 day')) = 29 as leap
from generate_series(date '2000-01-01',
                     date '2030-01-01',
                     interval '1 year') as t(date);

select code, forename, surname, count(*) as wins
from drivers
    join results r on drivers.driverid = r.driverid
where position = 1
group by code, forename, surname
order by wins desc
limit 3;

select date::date, name, drivers.surname as winner
from races
    left join results on results.raceid = races.raceid
        and results.position = 1
    left join drivers using (driverid)
where date::date >= date('2017-04-01')
    and date::date < date('2017-04-01') + 3 * interval '1 month';

select date('2017-04-01') + 3 * interval '1 month';

with decades as
    (
        select extract('year' from date_trunc('decade', date(date))) as decade
        from races
        group by decade
    )
select decade,
       rank() over(partition by decade order by wins desc) as rank,
       forename,
       surname,
       wins
from decades
    left join lateral (
        select code, forename, surname, count(*) as wins
        from drivers
            join results on results.driverid = drivers.driverid and results.position = 1
            join races r on results.raceid = r.raceid
        where extract('year' from date_trunc('decade', date(r.date))) = decades.decade
        group by code, forename, surname
        order by wins desc
        limit 3
    )
as winners on true
order by decade asc, wins desc;

select extract('year' from date_trunc('decade', date(date))) as decade
        from races
        group by decade
order by decade;


with decades as
    (
        select extract('year' from date_trunc('decade', date(date))) as decade
        from races
        group by decade
    )
select * from decades;


select date_trunc('year', date(date)) as year,
       count(*) filter(where position is null) as outs,
       bool_and(position is null) as never_finished
from drivers
    join results using (driverid)
    join races r on results.raceid = r.raceid
group by date_trunc('year', date(date)), driverid;

with counts as
    (
        select date_trunc('year', date(date)) as year,
       count(*) filter(where position is null) as outs,
       bool_and(position is null) as never_finished
from drivers
    join results using (driverid)
    join races r on results.raceid = r.raceid
group by date_trunc('year', date(date)), driverid
    )
select extract(year from year) as season,
       sum(outs) as "outs"
from counts
where never_finished
group by season
order by 2 desc
limit 5;


-- chap15

select drivers.surname as driver,
       constructors.name as constructor,
       sum(points) as points
from results
    join races using (raceid)
    join drivers using (driverid)
    join constructors using (constructorid)
where date(date) >= date('1978-01-01')
    and date(date) < date('1978-01-01') + interval '1 year'
group by grouping sets ((drivers.surname), (constructors.name))
having sum(points) > 20
order by constructors.name is not null,
         drivers.surname is not null,
         points desc;

select drivers.surname as driver,
       constructors.name as constructor,
       sum(points) as points
from results
    join races using (raceid)
    join drivers using (driverid)
    join constructors using (constructorid)
where drivers.surname in ('Prost', 'Senna')
group by rollup (drivers.surname, constructors.name)
order by drivers.surname, constructors.name asc;


select extract(year from date(races.date)) as season,
       count(*) filter(where status = 'Accident') as accidents
from results
    join status using (statusid)
    join races using (raceid)
group by season
order by accidents desc
limit 5;

with accidents as (
select extract(year from date(races.date)) as season,
       count(*) as participants,
       count(*) filter(where status = 'Accident') as accidents
from results
    join status using (statusid)
    join races using (raceid)
group by season
)
select season,
       round(100.0 * accidents / participants, 2) as pct,
       repeat(text '=', ceil(100*accidents/participants)::int) as bar
from accidents
where season between 1974 and 1990
order by season;


with points as
 (
    select year as season, driverid, constructorid,
           sum(points) as points
      from results join races using(raceid)
  group by grouping sets((year, driverid),
                         (year, constructorid))
    having sum(points) > 0
  order by season, points desc
 ),
 tops as
 (
    select season,
           max(points) filter(where driverid is null) as ctops,
           max(points) filter(where constructorid is null) as dtops
      from points
  group by season
  order by season, dtops, ctops
 ),
 champs as
 (
    select tops.season,
           champ_driver.driverid,
           champ_driver.points,
           champ_constructor.constructorid,
           champ_constructor.points

      from tops
           join points as champ_driver
             on champ_driver.season = tops.season
            and champ_driver.constructorid is null
            and champ_driver.points = tops.dtops

           join points as champ_constructor
             on champ_constructor.season = tops.season
            and champ_constructor.driverid is null
            and champ_constructor.points = tops.ctops
  )
  select season,
         format('%s %s', drivers.forename, drivers.surname)
            as "Driver's Champion",
         constructors.name
            as "Constructor's champion"
    from champs
         join drivers using(driverid)
         join constructors using(constructorid)
order by season;


select * from f1db.pg_catalog.pg_extension;

SELECT
    (total_exec_time / 1000 / 60 ) as total_minutes,
    (total_exec_time/calls) as avg_ms,
    query
FROM pg_stat_statements
order by 2 desc
limit 100;

select queryid, count(*) from f1db.public.pg_stat_statements
group by queryid
having count(*) > 1
order by count(*) desc;

select * from f1db.public.pg_stat_statements where queryid = '7359907064077516378';

ALTER SYSTEM SET compute_query_id = 'on';
select * from f1db.pg_catalog.pg_stat_activity;

select * from f1db.public.pg_stat_statements
order by calls desc;

select extract('year' from date_trunc('decade', DATE(date))) as decade, count(*)
from races
group by decade
order by decade;

with races_per_decade
as (
select extract('year' from date_trunc('decade', DATE(date))) as decade, count(*) as nbraces
from races
group by decade
order by decade
    )
select decade, nbraces,
    case
        when lag(nbraces, 1) over(order by decade) is null
        then ''

        when nbraces-lag(nbraces, 1) over(order by decade) < 0
        then format('-%3s', lag(nbraces, 1) over(order by decade) - nbraces)

        else format('+%3s', nbraces- lag(nbraces, 1) over(order by decade))

        end as evolution

from races_per_decade;

with counts as
    (
        select driverid, forename, surname, count(*) as races, bool_and(position is null) as never_finished
        from drivers
            join results using (driverid)
            join races using (raceid)
        group by driverid, forename, surname
    )
select driverid, forename, surname, races
from counts
where never_finished
order by races desc;

with counts as
    (
        select date_trunc('year', DATE(date)) as year,
               count(*) filter ( where position is null ) as outs,
               bool_and(position is null) as never_finished
        from drivers
            join results using (driverid)
            join races using (raceid)
        group by date_trunc('year', DATE(date)), driverid
    )
select extract(year from year) as season,
       sum(outs) as "#times any driver did not finish a race"
from counts
where never_finished
group by season
order by sum(outs) desc
limit 5;


select status, count(*)
from results
    join races using (raceid)
    join status using (statusid)
where DATE(date) >= DATE('1978-01-01') and DATE(date) < DATE('1978-01-01') +  interval '1 year'
and position is null
group by status
having count(*) > 0
order by count(*) desc;