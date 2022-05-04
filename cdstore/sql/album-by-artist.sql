-- name: list-albums-by-artist
-- List the album titles and duration of a given artist
select album.title as album_title,
         sum(milliseconds) * interval '1 ms' as duration
    from album
         join artist using(artistid)
         left join track using(albumid)
   where artist.name = :name
group by album_title
order by album_title;
