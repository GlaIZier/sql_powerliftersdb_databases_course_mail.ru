-- -----------------------------------------------------
-- Database powerliftersdb and role to control
-- -----------------------------------------------------
DROP DATABASE IF EXISTS powerliftersdb;
DROP ROLE IF EXISTS powerlifter;

CREATE ROLE powerlifter WITH PASSWORD 'password' LOGIN;

CREATE DATABASE powerliftersdb 
	WITH OWNER powerlifter 
	ENCODING UTF8 
	LC_CTYPE 'ru_RU.UTF-8' 
	LC_COLLATE 'ru_RU.UTF-8';