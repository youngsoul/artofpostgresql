create table factbook
 (
   year    int,
   date    date,
   shares  text,
   trades  text,
   dollars text
 );

create table factbook_tmp
 (
   year    int,
   date    text,
   shares  text,
   trades  text,
   dollars text
 );

insert into factbook ( select year, DATE(date), shares, trades, dollars  from factbook_tmp );


select * from factbook_tmp;
select * from factbook;
select * from factbook limit 2;

delete from factbook;

alter table factbook
   alter shares
    type bigint
   using replace(shares, ',', '')::bigint,

   alter trades
    type bigint
   using replace(trades, ',', '')::bigint,

   alter dollars
    type bigint
   using substring(replace(dollars, ',', '') from 2)::numeric;

select date,
       to_char(shares, '99G999G999G999') as shares,
       to_char(trades, '99G999G999') as trades,
       to_char(dollars, 'L99G999G999G999') as dollars
from factbook
where date >= DATE('2017-02-01')
and date < DATE('2017-02-01') + interval '1 month'
order by date;

select cast(calender.entry as date) as date,
       coalesce(shares, 0) as shares,
       coalesce(trades, 0) as trades,
       to_char(
           coalesce(dollars, 0), 'L99G999G999G999'
           ) as dollars
from
    generate_series(
        DATE('2017-02-01'),
        DATE('2017-02-01') + interval '1 month' - interval '1 day',
        interval '1 day'
        ) as calender(entry)
    left join factbook on factbook.date = calender.entry
order by date;


-- set start '2017-02-01';

with computed_data as
(
  select cast(calendar.date as date)  as date,
         to_char(date, 'Dy')  as day,
         coalesce(dollars, 0) as dollars,
         lag(dollars, 1)
           over(
             partition by extract('isodow' from date)
                 order by date
           )
         as last_week_dollars
    from /*
          * Generate the month calendar, plus a week before
          * so that we have values to compare dollars against
          * even for the first week of the month.
          */
         generate_series(DATE('2017-02-01') - interval '1 week',
                         DATE('2017-02-01') + interval '1 month'
                                       - interval '1 day',
                         interval '1 day'
         )
         as calendar(date)
         left join factbook using(date)
)
  select date, day,
         to_char(
             coalesce(dollars, 0),
             'L99G999G999G999'
         ) as dollars,
         case when dollars is not null
               and dollars <> 0
              then round(  100.0
                         * (dollars - last_week_dollars)
                         / dollars
                       , 2)
          end
         as "WoW %"
    from computed_data
   where date >= DATE('2017-02-01')
order by date;

