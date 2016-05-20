-- -----------------------------------------------------
-- Table powerlifters.city
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Table powerlifters.country
-- -----------------------------------------------------
create or replace function fill_index_to_string_table (
      in table_name text,
      in string_base_value text,
      in start_appendix_index int,
      in rows_num int
   )
   returns void as $$
   declare appendix int := start_appendix_index;
  declare row int := 0;
   begin 
      for row in 0..rows_num - 1
      loop
         execute 
            'insert into powerlifters.' || table_name ||
            ' (' || table_name || '_name) values ' ||
            '(''' || string_base_value || appendix || ''')';     
         appendix := appendix + 1;
      end loop;
   end;
$$ language plpgsql;

-- -----------------------------------------------------
-- Table powerlifters.powerlifter
-- -----------------------------------------------------
create or replace function fill_powerlifter_table (
    in random_start_fk int,
    in random_end_fk int,
    in random_start_date date,
    in random_end_date date,
    in start_appendix_index int,
    in rows_num int
   )
   returns void as $$
   declare random_city int := 0;
   declare random_country int :=0;
   declare sex smallint :=0;
   declare birthdate date := '1970-01-01';
   declare appendix int := start_appendix_index;
   declare row int := 0;
   begin 
      for row in 0..rows_num - 1
      loop
         random_city := floor(random_start_fk + (random_end_fk - random_start_fk + 1) * random());
         random_country := floor(random_start_fk + (random_end_fk - random_start_fk + 1) * random());
         sex := floor(1 + (2 - 1 + 1) * random());
         birthdate := random_start_date + cast(((random_end_date - random_start_date) * random()) as int); -- cast to int 0.5 -> 1, not 0, so it works like round not floor
         insert into powerlifters.powerlifter
          (last_name, first_name, sex, birthdate, country_id, city_id)
          values
          ('Power' || appendix, 'Lifter' || appendix, sex, birthdate, random_country, random_city);
         appendix := appendix + 1; 
      end loop;
   end;
$$ language plpgsql;

-- -----------------------------------------------------
-- Table powerlifters.federation
-- -----------------------------------------------------
create or replace function fill_federation_table (
  in federation_name_base text,
  in equipment_base text,
  in start_federation_appendix_index int,
  in rows_num int 
  )
  returns void as $$
  declare federation_appendix int := start_federation_appendix_index;
  declare equipment_appendix int := 1;
  declare row int := 1; 
  begin 
      for row in 1..rows_num
      loop
         insert into powerlifters.federation
          (federation_name, equipment)
          values
          (federation_name_base || federation_appendix, equipment_base || equipment_appendix);
          if (row % 3 = 0) then 
            federation_appendix := federation_appendix + 1;
            equipment_appendix := 1;
          else
            equipment_appendix := equipment_appendix + 1;
          end if;
      end loop;
   end
;$$ language plpgsql;

-- -----------------------------------------------------
-- Table powerlifters.competition
-- -----------------------------------------------------
create or replace function fill_competition_table (
    in competition_name_base text,
    in random_start_fk int,
    in random_end_fk int,
    in random_start_date date,
    in random_end_date date,
    in start_appendix_index int,
    in rows_num int
   )
   returns void as $$
   declare start_date date := '1970-01-01';
   declare end_date date := '1970-01-03';
   declare random_federation int := 0;
   declare random_city int := 0;
   declare random_country int :=0;
   declare appendix int := start_appendix_index;
   declare row int := 0;
   begin 
      for row in 0..rows_num - 1
      loop
         random_federation := floor(random_start_fk + (random_end_fk - random_start_fk + 1) * random());
         random_city := floor(random_start_fk + (random_end_fk - random_start_fk + 1) * random());
         random_country := floor(random_start_fk + (random_end_fk - random_start_fk + 1) * random());
         start_date := random_start_date + cast(((random_end_date - random_start_date) * random()) as int); -- cast to int 0.5 -> 1, not 0, so it works like round not floor
         end_date := start_date + 2;
         insert into powerlifters.competition
          (competition_name, start_date, end_date, federation_id, country_id, city_id)
          values
          (competition_name_base || appendix, start_date, end_date, random_federation, random_country, random_city);
         appendix := appendix + 1; 
      end loop;
   end;
$$ language plpgsql;

-- -----------------------------------------------------
-- Table powerlifters.weight_class
-- ----------------------------------------------------- 
create or replace function fill_weight_class_table ()
  returns void as $$
  begin 
    insert into powerlifters.weight_class
      (weight_class_kg)
      values
      ('56'), ('60'), ('66'), ('74'), ('83'), ('93'), ('105'), ('120'), ('120+');
   end;
$$ language plpgsql;

-- -----------------------------------------------------
-- Table powerlifters.age_class
-- -----------------------------------------------------
create or replace function fill_age_class_table ()
  returns void as $$
  begin 
    insert into powerlifters.age_class
      (age_class_years)
      values
      ('18'), ('23'), ('39'), ('49'), ('59'), ('69'), ('70+');
   end;
$$ language plpgsql;

-- -----------------------------------------------------
-- Table powerlifters.competition_result
-- -----------------------------------------------------
create or replace function fill_competition_result_table (
    in random_start_fk_powerlifter int,
    in random_end_fk_powerlifter int,
    in random_start_fk_competition int,
    in random_end_fk_competition int,
    in competition_number int
   )
   returns void as $$
   declare random_powerlifter int := 0;
   declare random_competition int := 0;
   declare place int := 0;
   declare participants_number int := 0;
   declare random_weight_class int := 0;
   declare random_age_class int := 0;
   declare competition_index int := 0;
   declare place_index int := 0;
   begin 
      for competition_index in 0..competition_number - 1
      loop
         random_competition := floor(random_start_fk_competition + (random_end_fk_competition - random_start_fk_competition + 1) * random());
         participants_number := floor(3 + (15 - 3 + 1) * random()); 
         random_weight_class := floor(1 + (9 -1 + 1) * random());
         random_age_class := floor(1 + (7 -1 + 1) * random());
         for place_index in 1..participants_number
         loop
          random_powerlifter := floor(random_start_fk_powerlifter + (random_end_fk_powerlifter - random_start_fk_powerlifter + 1) * random());
          insert into powerlifters.competition_result
            (powerlifter_id, competition_id, place, participants_number, weight_class_id, age_class_id)
            values
            (random_powerlifter, random_competition, place_index, participants_number, random_weight_class, random_age_class);
         end loop;
      end loop;
   end;
$$ language plpgsql;

-- -----------------------------------------------------
-- Table powerlifters.exercise
-- -----------------------------------------------------
create or replace function fill_exercise_table ()
  returns void as $$
  begin 
    insert into powerlifters.exercise
      (exercise_name)
      values
      ('Squat'), ('Bench press'), ('Deadlift');
   end;
$$ language plpgsql;

-- -----------------------------------------------------
-- Table powerlifters.exercise_result
-- -----------------------------------------------------
create or replace function fill_exercise_result_table ()
   returns void as $$
   declare competition_result_id int := 0;
   declare exercise_id int := 0;
   declare result_kg int := 0;
   begin
      for competition_result_id in
        select powerlifters.competition_result.competition_result_id
        from powerlifters.competition_result
      loop
         for exercise_id in 1..3
         loop
            if (exercise_id = 1) then
              result_kg := floor(100 + (350 - 100 + 1) * random());
            elsif (exercise_id = 2) then
              result_kg := floor(50 + (300 - 50 + 1) * random());
            else 
              result_kg := floor(150 + (400 - 150 + 1) * random());
            end if;  
            insert into powerlifters.exercise_result
              (result_kg, competition_result_id, exercise_id)
              values
              (result_kg, competition_result_id, exercise_id);
         end loop;
      end loop;
   end;
$$ language plpgsql;
