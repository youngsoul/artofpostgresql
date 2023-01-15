# Art of PostgreSql

Repo of code working through the book, `The Art of PostgreSQL`.  https://theartofpostgresql.com




## Chapter 10

Formula1 DB.

The easiest way to load this dataset, IMHO, is to use the CSV files.

Or... I have created `sql` files from my postgres 14.x database that can be used.

http://ergast.com/mrd/db/#csv

see either:

`data/f1db_csv`

When importing pit_stops.csv you have to change the type for duration to TEXT because some of the times are of the form '19:23.987' - which is a crazy long pitstop.  Not sure if there is an issue with the data or what.



or

`data/f1db_postgres_sql`

I used datagrip to import the csv or sql files.
