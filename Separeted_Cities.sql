
-- MAXIMALLY-SEPARATED CITIES

-- write a query to return the furthest-separated pair of cities for each state, 
-- and the corresponding distance (in degrees, rounded to 2 decimal places) between those two cities.

create database if not exists practicedb;
use practicedb;

create table if not exists stations (
id integer not null, 
city varchar (40), 
state varchar (40), 
latitude decimal (4,1), 
longitude decimal (4,1));
/*
insert into stations (id, city, state, latitude, longitude)
VALUES
(1, 'Asheville', 'North Carolina', 35.6, 82.6),
(2, 'Burlington', 'North Carolina', 36.1, 79.4),
(3, 'Chapel Hill', 'North Carolina', 35.9, 79.1),
(4, 'Davidson', 'North Carolina', 35.5, 80.8),
(5, 'Elizabeth City', 'North Carolina', 36.3, 76.3),
(6, 'Fargo', 'North Dakota', 46.9, 96.8),
(7, 'Grand Forks', 'North Dakota', 47.9, 97.0),
(8, 'Hettinger', 'North Dakota', 46.0, 102.6),
(9, 'Inkster', 'North Dakota', 48.2, 97.6);
*/

select * from stations;

with t1 as (
select a.state,a.city as city_1,b.city as city_2, (sqrt(power((a.latitude - b.latitude),2) + power((a.longitude - b.longitude),2))) as dist 
from stations a 
join stations b 
on a.state = b.state 
where a.city < b.city
)
select * 
from t1 
where dist in (
select max(dist) 
from t1 
group by state
);

-- MEDIAN LATITUDE
-- Write a query to return the median latitude of weather stations from each state, 
-- rounding to the nearest tenth of a degree.

with t1 as (
select * , row_number()over(partition by state order by latitude) lat_no, count(*) over(partition by state) lat_count 
from stations
)
select * 
from t1 
where lat_no >= lat_count/2 and lat_no <= lat_count/2 + 1 
;
