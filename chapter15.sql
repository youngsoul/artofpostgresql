
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


