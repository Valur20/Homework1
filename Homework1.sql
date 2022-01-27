--Homework 1.  Hópur
--Valur Guðmundsson, valur20@ru.is
--Helga Magnúsdóttir, helgam20@ru.is
--Jökull Viðar Gunnarsson, jokullg17@ru.is

--a)
/*(a) In the database, 372 songs have a duration of at most 1 minute. How many songs
have a duration of over 1 hour?  */
select count(duration) as number_of_songs_with_duration_over_1_hour
from songs
where extract(epoch from duration) >3600;

--b)
/*(b) What is the total duration, in seconds, of all songs in the database?  */

select sum(extract(epoch from duration)) as Total_duration_sec
from songs;

--c)
/*The database contains 12 albums by the artist Queen. How many albums by the
artist Tom Waits are in the database?
*/

select count(*) as albums_by_Tom_Waits
from albums as a
join albumartists as aa on a.albumid = aa.albumid
join artists as ar on aa.artistid = ar.artistid
where ar.artist = 'Tom Waits';

--d)
/*
The database contains 187 different albums with a genre whose name starts with
Ele. How many different albums have a genre whose name starts with Alt?
*/

select count(distinct(a.album)) as different_albums_with_Ele
from albums as a 
join albumgenres as ag on a.albumid = ag.albumid
join genres as g on ag.genreid = g.genreid
where g.genre like 'Alt%';

--e)
/*There is a surprising number of duplicate song titles in the database. For how many
songs does there exist another song (or songs) in the database with the same title?
*/

--Óvist hvort rétt svar en líklegt
select count (distinct s.title)
from songs s
join(select title, count(*)
	from songs
	group by title
	having count(*)>1) s2
	on s.title = s2.title
	;

--f)
/*An album can have multiple genres. The average number of albums per genre is
about 24.15. What is the average number of genres per album?
*/
--select 1.0*(select count(*) from albumgenres) / (select count(*) from genres) as avg_nr_albumbs_per_genre;

select 1.0*(select count(*) from albumgenres)/ (select count(*) from albums) as avg_genre_per_album;

--g)An album can have multiple genres. How many albums do not have the genre Rock?

--veit ekki hvort eigi að nota distinct

select count( distinct ag.albumid )
from albumgenres as ag
join genres as g
on ag.genreid = g.genreid
where genre != 'Rock';

--h)
/*The database contains just 5 songs released in 1953. What is the largest number of
songs released in a single year?*/
select max(g.number_of_songs)
from (select count(title) as number_of_songs
	from songs
	group by extract(year from releasedate)
) g;

--i)
/* The database contains just 5 songs released in 1953. In which year was the largest
number of songs released?
*/

--Ekki tilbúið

select *
from (select extract(year from releasedate) as what_year, count(title) as number_of_songs
	from songs
	group by extract(year from releasedate)
	order by extract(year from releasedate)
) g
group by g.number_of_songs

having max(g.number_of_songs);

--j)
/*Write a query that returns the SongId and Title of songs that (a) are released in
1979, (b) are longer than 3 minutes, and (c) share at least one genre with an album
they appeared on. The result should have one row per song, and be ordered by the
song title.
*/


select distinct s.songid, s.title
from songs as s
join songgenres as sg
on s.songid = sg.songid
join albumsongs as als
on s.songid = als.songid
join albums as a
on als.albumid = a.albumid
join genres as g
on g.genreid =sg.genreid
join albumgenres as ag
on als.albumid = ag.albumid
where extract(year from releasedate)=1979 and extract(epoch from s.duration)>360 and sg.genreid =ag.genreid
order by s.title;