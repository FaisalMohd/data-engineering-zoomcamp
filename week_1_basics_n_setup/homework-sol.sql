
-- 1
select count(*) from yellow_taxi_trips
where date(tpep_pickup_datetime) = '2021-01-15'; 


--2 (confusion ? Is it max tip per trip on these dates or max (sum (trip)) for each day ??

select date(tpep_pickup_datetime) as pick_up_date, max(tip_amount) as tip 
from yellow_taxi_trips
where 
	date(tpep_pickup_datetime) in ('2021-01-20', '2021-01-04', '2021-01-01', '2021-01-21')
group by 1
;

-- 3
select zones.* from 
zones 
join 
	(
	select 
		trips."DOLocationID", count(trips."DOLocationID") as cnt
	from 
	yellow_taxi_trips trips
	where 
		date(tpep_pickup_datetime) in ('2021-01-14')
		and trips."PULocationID" = (select "LocationID" from zones where "Zone" = 'Central Park')
	group by 1
	order by 2 desc
	limit 1
	) d1 on d1."DOLocationID" = zones."LocationID"
;

-- 4
select pick_up."Zone" as pu_zone, drop_off."Zone" as du_zone 
	   , concat(pick_up."Zone", '/' ,coalesce(drop_off."Zone",'Unknown')) as pair
from 
	(
	select 
		trips."PULocationID", trips."DOLocationID"
		, avg (trips."total_amount") as avg_amt
	from yellow_taxi_trips trips
	group by 1, 2
	order by 3 desc
	limit 1
	) pair_pu_do
	join zones pick_up on pick_up."LocationID" = pair_pu_do."PULocationID"
	join zones drop_off on "drop_off"."LocationID" = pair_pu_do."DOLocationID"
;

