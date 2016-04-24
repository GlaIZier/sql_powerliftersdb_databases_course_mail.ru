-- get powerlifter_id using last_name
select powerlifter_id
from powerlifter
where last_name = 'Power1';

-- all info about powerlifter
select * from
powerlifter 
join city
on city.city_id = powerlifter.city_id
join country
on country.country_id = powerlifter.country_id;

-- all info about powerlifter
select * from
powerlifter 
join city
on city.city_id = powerlifter.city_id
join country
on country.country_id = powerlifter.country_id
where powerlifter_id = 1;

-- all info about powerlifter without duplicate ids
select * from
powerlifter 
join city
using (city_id)
join country
using (country_id);

-- all info about competition without duplicate ids
select * from
competition 
join city
using (city_id)
join country
using (country_id)
join federation
using (federation_id)
where competition_id = 1;

-- all info about competition_result without duplicate ids
select *
from competition_result
join powerlifter
using (powerlifter_id)
join competition
using (competition_id);

select *
from competition_result
join powerlifter
using (powerlifter_id)
join competition
using (competition_id)
where powerlifter_id = 1;

select *
from competition_result
join powerlifter
	join country as cop
	using (country_id)
	join city as cip
	using (city_id)
using (powerlifter_id)
join competition
	join federation
	using (federation_id)
	join country as coc
	using (country_id)
	join city as cic
	using (city_id)
using (competition_id);

select *
from competition_result
join powerlifter
	join country as cop
	using (country_id)
	join city as cip
	using (city_id)
using (powerlifter_id)
join competition
	join federation
	using (federation_id)
	join country as coc
	using (country_id)
	join city as cic
	using (city_id)
using (competition_id)
where powerlifter_id = 1;

-- all info about competition_result_exercise without duplicate ids
select *
from exercise_result
join exercise
using (exercise_id)
join competition_result
using (competition_result_id);

-- all exercise results 
select *
from exercise_result
join exercise
using (exercise_id)
join competition_result
	join powerlifter
		join country as cop
		using (country_id)
		join city as cip
		using (city_id)
	using (powerlifter_id)
	join competition
		join federation
		using (federation_id)
		join country as coc
		using (country_id)
		join city as cic
		using (city_id)
	using (competition_id)
using (competition_result_id);

select *
from exercise_result
join exercise
using (exercise_id)
join competition_result
	join powerlifter
		join country as cop
		using (country_id)
		join city as cip
		using (city_id)
	using (powerlifter_id)
	join competition
		join federation
		using (federation_id)
		join country as coc
		using (country_id)
		join city as cic
		using (city_id)
	using (competition_id)
using (competition_result_id)
where powerlifter_id = 1;

-- show all info about powerlifter
select * 
from powerlifter
join city
using (city_id)
join country
using (country_id)
where last_name ='Power53';

select * from
powerlifter 
join city
using (city_id)
join country
using (country_id)
join competition_result
using (powerlifter_id)
where last_name ='Power53';

-- show all places in competiotions for powerlifter
select place, count(*) from
powerlifter 
join competition_result
using (powerlifter_id)
where last_name ='Power53'
group by place
order by place;

-- the same but with powerlifter id
select place, count(*), (select
	powerlifter_id
	from powerlifter
	where last_name = 'Power53') from
powerlifter 
join competition_result
using (powerlifter_id)
where last_name ='Power53'
group by place
order by place;

-- the same but with last_name and first_name
select place, places_count, last_name, first_name
from powerlifter
join
	(select place, count(*) as places_count, (select
		powerlifter_id
		from powerlifter
		where last_name = 'Power53') from
	powerlifter as in_powerlifter
	join competition_result
	using (powerlifter_id)
	where in_powerlifter.last_name ='Power53'
	group by place) as place_aggregate_powerlifter
on powerlifter.powerlifter_id = place_aggregate_powerlifter.powerlifter_id
order by place;

-- biggest squat for powerlifter
select last_name, first_name, sex, birthdate, result_kg as max_squat_result
from exercise_result
join competition_result
using (competition_result_id)
join powerlifter
using (powerlifter_id)
where exercise_result_id = 
	(select exercise_result_id
		from exercise_result
		join competition_result
		using (competition_result_id)
		join exercise
		using (exercise_id)
		join powerlifter
		using (powerlifter_id)
		where last_name = 'Power500'
			and exercise_name = 'Squat'
		order by result_kg desc
		limit 1);

-- show all benches for powerlifter
select powerlifter.*, exercise_name, result_kg, exercise_result_id
from exercise_result
join exercise
using (exercise_id)
join competition_result
using (competition_result_id)
join powerlifter
using (powerlifter_id)
where exercise_result_id in 
	(select exercise_result_id
		from exercise_result
		join competition_result
		using (competition_result_id)
		join powerlifter
		using (powerlifter_id)
		join exercise
		using (exercise_id)
		where last_name = 'Power333'
			and exercise_name = 'Bench press')
order by result_kg desc;

-- table with results of powerlifter competitions and movements
select powerlifter.powerlifter_id, powerlifter.last_name, powerlifter.first_name, federation.federation_name, federation.equipment, competition.start_date, competition.end_date,
	country.country_name, city.city_name, competition_result.place, competition_result.participants_number, weight_class.weight_class_kg, age_class.age_class_years,
	exercise.exercise_name, exercise_result.result_kg, competition_sum
from exercise_result
join competition_result
using (competition_result_id)
join competition
using (competition_id)
join federation
using (federation_id)
join country
using (country_id)
join city
using (city_id)
join weight_class
using (weight_class_id)
join age_class
using (age_class_id)
join exercise
using (exercise_id)
join powerlifter
using (powerlifter_id)
join 
   (select competition_result_id, sum(result_kg) as competition_sum
   from exercise_result
   group by competition_result_id) as competition_sums
using (competition_result_id)
where powerlifter.powerlifter_id = 1
order by competition_sum desc;

-- when there are several tables with same foreign key on the left of join u need to use inner join with special word 'on'
select powerlifter.powerlifter_id, powerlifter.last_name, powerlifter.first_name, federation.federation_name, federation.equipment, competition.start_date, competition.end_date,
	country.country_name, city.city_name, competition_result.place, competition_result.participants_number, weight_class.weight_class_kg, age_class.age_class_years,
	exercise.exercise_name, exercise_result.result_kg
from powerlifter
join competition_result
using (powerlifter_id)
join exercise_result
using (competition_result_id)
join exercise
using (exercise_id)
join competition
using (competition_id)
join federation
using (federation_id)
join country
on competition.country_id = country.country_id
join city
on competition.city_id = city.city_id
join weight_class
using (weight_class_id)
join age_class
using (age_class_id)
where powerlifter.powerlifter_id = 1;

-- Set full table scan off. Usefull to understand why postgres doesb't use indeces
SET enable_seqscan = off;
-- Cost of random IO
show random_page_cost;
SET random_page_cost = 1.1 

select powerlifter.powerlifter_id, powerlifter.last_name, powerlifter.first_name, competition.competition_id, competition_result.participants_number
from powerlifter
join competition_result
using (powerlifter_id)
join competition
using (competition_id)
where powerlifter.powerlifter_id = 1;