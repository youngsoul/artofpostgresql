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