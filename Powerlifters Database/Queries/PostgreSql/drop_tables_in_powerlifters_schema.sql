-- select 'drop table if exists "' || tablename || '" cascade;' 
-- from pg_tables
-- where schemaname = 'powerlifters'; -- or any other schema

drop schema powerlifters cascade;
create schema powerlifters;