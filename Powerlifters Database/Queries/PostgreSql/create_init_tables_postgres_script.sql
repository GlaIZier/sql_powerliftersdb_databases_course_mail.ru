-- -----------------------------------------------------
-- Schema Powerlifters
-- -----------------------------------------------------
CREATE SCHEMA powerlifters;
ALTER ROLE powerlifter SET search_path TO "$user", public, powerlifters; -- need to reconnect
SET search_path TO "$user", public, powerlifters; -- for current session

-- -----------------------------------------------------
-- Table powerlifters.city
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS powerlifters.city (
	city_id			serial PRIMARY KEY,
	city_name		text NOT NULL
);
CREATE UNIQUE INDEX city_unique on powerlifters.city (city_name);

-- -----------------------------------------------------
-- Table powerlifters.country
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS powerlifters.country (
	country_id			serial PRIMARY KEY,
	country_name		text NOT NULL
);
CREATE UNIQUE INDEX country_unique on powerlifters.country (country_name);

-- -----------------------------------------------------
-- Table powerlifters.powerlifter
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS powerlifters.powerlifter (
  powerlifter_id serial PRIMARY KEY,
  last_name text NOT NULL DEFAULT '',
  first_name text NOT NULL DEFAULT '',
  sex smallint NOT NULL DEFAULT 0,
  birthdate date NOT NULL DEFAULT '1970-01-01',
  country_id int NOT NULL,
  city_id int NOT NULL,
  CONSTRAINT fk_powerlifter_country
    FOREIGN KEY (country_id)
    REFERENCES powerlifters.country (country_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_powerlifter_city
    FOREIGN KEY (city_id)
    REFERENCES powerlifters.city (city_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
CREATE INDEX fk_powerlifter_city ON powerlifters.powerlifter (city_id);
CREATE INDEX fk_powerlifter_country ON powerlifters.powerlifter (country_id);
CREATE INDEX powerlifter_last_name ON powerlifters.powerlifter (last_name);

-- -----------------------------------------------------
-- Table powerlifters.federation
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS powerlifters.federation (
  federation_id serial NOT NULL PRIMARY KEY,
  federation_name text NOT NULL,
  equipment text NOT NULL
);
CREATE INDEX federation_name ON powerlifters.federation (federation_name);


-- -----------------------------------------------------
-- Table powerlifters.competition
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS powerlifters.competition (
  competition_id serial NOT NULL PRIMARY KEY,
  competition_name text NOT NULL DEFAULT '',
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  federation_id INT NOT NULL,
  country_id INT NOT NULL,
  city_id INT NOT NULL,
  CONSTRAINT fk_competition_federation
    FOREIGN KEY (federation_id)
    REFERENCES powerlifters.federation (federation_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_competition_country
    FOREIGN KEY (country_id)
    REFERENCES powerlifters.country (country_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_competition_city
    FOREIGN KEY (city_id)
    REFERENCES powerlifters.city (city_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
CREATE INDEX fk_competition_federation ON powerlifters.competition (federation_id);
CREATE INDEX fk_competition_country ON powerlifters.competition (country_id);
CREATE INDEX fk_competition_city ON powerlifters.competition (city_id);
CREATE INDEX competition_name ON powerlifters.competition (competition_name);
CREATE INDEX start_date ON powerlifters.competition (start_date);


-- -----------------------------------------------------
-- Table powerlifters.weight_class
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS powerlifters.weight_class (
  weight_class_id serial NOT NULL PRIMARY KEY,
  weight_class_kg text NOT NULL
);
CREATE UNIQUE INDEX weight_class_kg_unique ON powerlifters.weight_class (weight_class_kg);


-- -----------------------------------------------------
-- Table powerlifters.age_class
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS powerlifters.age_class (
  age_class_id serial NOT NULL PRIMARY KEY,
  age_class_years text NOT NULL
);
CREATE UNIQUE INDEX age_class_years_unique ON powerlifters.age_class (age_class_years);


-- -----------------------------------------------------
-- Table powerlifters.competition_result
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS powerlifters.competition_result (
  competition_result_id serial NOT NULL PRIMARY KEY,
  powerlifter_id int NOT NULL,
  competition_id int NOT NULL,
  place smallint NOT NULL DEFAULT -1,
  participants_number smallint NOT NULL DEFAULT -1,
  weight_class_id int NOT NULL,
  age_class_id int NOT NULL,
  CONSTRAINT fk_competition_result_powerlifter
    FOREIGN KEY (powerlifter_id)
    REFERENCES powerlifters.powerlifter (powerlifter_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_competition_result_competition
    FOREIGN KEY (competition_id)
    REFERENCES powerlifters.competition (competition_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_competition_result_weight_class
    FOREIGN KEY (weight_class_id)
    REFERENCES powerlifters.weight_class (weight_class_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_competition_result_age_class
    FOREIGN KEY (age_class_id)
    REFERENCES powerlifters.age_class (age_class_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
CREATE INDEX fk_competition_result_powerlifter ON powerlifters.competition_result (powerlifter_id);
CREATE INDEX fk_competition_result_competition ON powerlifters.competition_result (competition_id);
CREATE INDEX fk_competition_result_weight_class ON powerlifters.competition_result (weight_class_id);
CREATE INDEX fk_competition_result_age_class ON powerlifters.competition_result (age_class_id);
CREATE INDEX place ON powerlifters.competition_result (place);


-- -----------------------------------------------------
-- Table powerlifters.exercise
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS powerlifters.exercise (
  exercise_id serial NOT NULL PRIMARY KEY,
  exercise_name text NULL
);
CREATE UNIQUE INDEX exercise_name_unique ON powerlifters.exercise (exercise_name);


-- -----------------------------------------------------
-- Table powerlifters.exercise_result
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS powerlifters.exercise_result (
  exercise_result_id serial NOT NULL PRIMARY KEY,
  result_kg smallint NOT NULL,
  competition_result_id INT NOT NULL,
  exercise_id INT NOT NULL,
  CONSTRAINT fk_exercise_result_competition_result
    FOREIGN KEY (competition_result_id)
    REFERENCES powerlifters.competition_result (competition_result_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_exercise_result_exercise
    FOREIGN KEY (exercise_id)
    REFERENCES powerlifters.exercise (exercise_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
CREATE INDEX fk_exercise_result_competition_result ON powerlifters.exercise_result (competition_result_id);
CREATE INDEX fk_exercise_result_exercise ON powerlifters.exercise_result (exercise_id);
CREATE INDEX result_kg ON powerlifters.exercise_result (result_kg);

-- insert into country (country_name) values ('Russia');
-- insert into city (city_name) values ('Moscow');
-- insert into powerlifter (last_name, city_id, country_id) values ('Aaa', 1, 1);
-- DELETE from powerlifter where last_name = 'Aaa';
-- DELETE from city where city_name = 'Moscow';