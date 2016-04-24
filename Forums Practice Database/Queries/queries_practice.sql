use `forumsdb`;

drop database if exists forumsdb;

select * from information_schema.tables where table_schema = 'forumsdb';

-- ----------- change tables --------------------
alter table `forum` AUTO_INCREMENT = 1;

alter table `user` AUTO_INCREMENT = 1;

alter table topic AUTO_INCREMENT = 1;

alter table message AUTO_INCREMENT = 201;

alter table message drop column forum_id;


-- ------------fill tables---------------------

drop procedure if exists fill_index_to_string_table;
delimiter ;;
create procedure fill_index_to_string_table (
		in table_name varchar(50), 
        in string_value varchar(50),
		in start_index int,
		in rows int
	)
    begin
    declare appendix int default start_index;
	declare row int default 0;
	declare exit handler
		for 1046
        select 'error 1046'; -- no database selected
    while row < rows do
		set @sql_insert = concat('insert into ', table_name, 
			' (name) values (\'', 
				concat(string_value, appendix), '\')');
                
		prepare statement from @sql_insert;
        execute statement;
        deallocate prepare statement;
        
        set row = row + 1;
        set appendix = appendix + 1;
    end while;
end ;;
delimiter ;

drop procedure if exists fill_topic_table;
delimiter ;;
create procedure fill_topic_table (
		in random_start_fk int,
        in random_end_fk int,
		in start_index int,
		in rows int
	)
    begin
    declare appendix int default start_index;
	declare row int default 0;
    declare random_forum int default 0;
    declare random_user int default 0;
    while row < rows do
		set random_forum = floor(random_start_fk + mod(rand() * 100, random_end_fk - random_start_fk + 1));
        set random_user = floor(random_start_fk + mod(rand() * 100, random_end_fk - random_start_fk + 1));
		insert into `topic`
			(forum_id, user_id, name, creation_date) values
				(random_forum,
				random_user,
                concat('topic', appendix),
                now());
		set row = row + 1;
        set appendix = appendix + 1;        
    end while;
end ;;
delimiter ;

drop procedure if exists fill_message_table;
delimiter ;;
create procedure fill_message_table (
        in random_start_topic_fk int,
        in random_end_topic_fk int,
        in random_start_user_fk int,
        in random_end_user_fk int,
		in start_index int,
		in rows int
	)
    begin
    declare appendix int default start_index;
	declare row int default 0;
    declare random_forum int default 1;
    declare random_user int default 1;
    declare random_topic int default 1;
    while row < rows do
        set random_topic = floor(random_start_topic_fk + mod(rand() * 100, random_end_topic_fk - random_start_topic_fk + 1));
		set random_user = floor(random_start_user_fk + mod(rand() * 100, random_end_user_fk - random_start_user_fk + 1));
		insert into `message`
			(topic_id, user_id, text, creation_date) values
				(random_topic,
				random_user,
                concat('text', appendix),
                now());
		set row = row + 1;
        set appendix = appendix + 1;        
    end while;
end ;;
delimiter ;

call fill_index_to_string_table('forum', 'forum', 101, 100); -- 1 10
call fill_index_to_string_table('user', 'user', 16, 485); -- 1 15
call fill_topic_table(1, 200, 21, 980); -- 1 20
call fill_message_table(1, 100, 1, 100, 42001, 58000);

-- ---------------------FORUM TABLE----------------------------------------------

insert into `forumsdb`.`forum`
	(name)
    values 
		('forum1'), 
        ('forum2'), 
        ('forum3'), 
        ('forum4'), 
        ('forum5');
        
select * from `forumsdb`.`forum`;

select * from forum where forum_id = forum_id group by forum_id asc;

select * from forum where forum_id = forum_id group by name asc;

select count(*) from forum;

delete from forum where forum_id = forum_id;

-- ---------------------USER TABLE----------------------------------------------

insert into `user` 
	(name)
    values
		('user1'),
        ('user2'),
        ('user3'),
        ('user4'),
        ('user5'),
        ('user6'),
        ('user7');

insert into `user` 
	(name)
    values
		('user10'),
        ('user8'),
        ('user9');    
        
select * from `user`;        
        
select * from `user` where user_id = user_id group by user_id asc;        
        
select count(*) from `user`;        

delete from user where user_id = user_id; 

-- ----------------TOPIC TABLE-------------------------------------

insert into `topic`
	(forum_id, user_id, name, creation_date)
    values 
		('1', '1', 'name1', now()),
        ('1', '2', 'name1', now()),
        ('4', '4', 'name1', now()),
        ('5', '5', 'name1', now()),
        ('5', '7', 'name1', now());
        
select * from `topic`;

select count(*) from `topic`;

select forum_id, count(topic_id) from topic group by forum_id;

delete from topic where forum_id = forum_id;     
        
-- ----------------MESSAGE TABLE-------------------------------------
 
select * from message;

select * from message where message_id > 90000;

select count(*) from message;

-- Lection 2

select * from message where topic_id = 4 group by message_id asc;

select message_id, topic_id, user_id from message;

select message_id, topic_id, user_id from message where user_id in (1, 2, 10);

select message_id, topic_id, user_id from message where user_id = 1;

select count(*) from message where user_id = 1;

select * from message where user_id between 5 and 10;

select * from message where text like'%1%1';

select message_id, topic_id, user_id from message group by topic_id;

select topic_id, count(message_id) from message group by topic_id;

select topic_id, count(message_id) from message group by topic_id order by null;

select topic_id, user_id, count(message_id) from message group by topic_id, user_id;

select topic_id, user_id, count(message_id) from message group by topic_id, user_id with rollup; -- + general number of messages for current topic_id

select max(message_id), user_id from message group by user_id; 

select topic_id, user_id, message_id from message where user_id = 6 and topic_id = 1;

select  message_id, topic_id, user_id, 
	case
		when message_id > 100 then text
    else creation_date
    end as case_attribute
    from message;
        
select * from message where if(message_id > 100, 1, 0) = 0;   

select message_id from message where user_id = 1 and topic_id = 1; 

select forum_id, count(topic_id), name from topic group by forum_id; 

select forum_id, avg(topic_id), group_concat(name) from topic group by forum_id; 

select forum_id, sum(if (topic_id < 5, 1, 0)) as if_condition, group_concat(name) from topic group by forum_id; 

select forum_id, count(if (topic_id < 5, 1, null)) as if_condition, group_concat(name) from topic group by forum_id; 

select forum_id, count(topic_id) as count_topic, name from topic group by forum_id having count_topic > 10; 

select forum_id, count(topic_id), name from topic where forum_id % 2 = 0 group by forum_id having count(topic_id) > 2; 

select forum_id, count(topic_id), name from topic where forum_id % 2 = 0 group by forum_id having count(topic_id) > 10 order by count(topic_id) desc, forum_id desc;
 
select forum_id, count(topic_id), name from topic where forum_id % 2 = 0 group by forum_id having count(topic_id) > 2 order by count(topic_id) limit 2;
 
select forum_id, count(topic_id), name from topic where forum_id % 2 = 0 group by forum_id having count(topic_id) > 2 order by count(topic_id) limit 1, 2; 

select max(message_id) from message;

-- Lection 3
select * from message;

insert into message (topic_id, user_id , text, creation_date) 
	values
    (1, 1, 'insert_text1', now()),
    (2, 2, 'insert_text2', now());
    
insert into message 
	set message_id = 206,
		topic_id = 3,
		user_id = 3,
		text = 'insert_text3',
		creation_date = default;

insert into message 
	set message_id = 206,
		topic_id = 5,
		user_id = 5,
		text = 'insert_text5',
		creation_date = default
    on duplicate key update
		topic_id = 4;
        
insert into message (topic_id, user_id, text, creation_date)
	select topic_id, user_id, text, creation_date 
		from message where text like '%9';

update message
    set text = concat(text, ' update')
    where message_id > 206
    order by message_id asc
    limit 10;
    
set @i := 0;
select @i := @i + 1 as idafas, message_id from message order by message_id;  

select forum_id, count(topic_id) from topic group by forum_id order by count(topic_id) desc;

select * from topic as topic_outer where (select count(topic_id) from topic where topic.forum_id = topic_outer.forum_id) = 1;

-- all forums with count of topics = 10
select forum_id, count(topic_id) from topic as topic_outer where (select count(topic_id) from topic where topic.forum_id = topic_outer.forum_id) = 10 group by forum_id;

select * from forum where (select count(topic_id) from topic where topic.forum_id = forum.forum_id) = 10;

-- forum with max topic count

select count(topic_id) from topic group by forum_id;

select forum_id, max(topic_id) from topic group by forum_id; 

select max(count_table.count) from (select forum_id, count(topic_id) as count from topic group by forum_id) count_table;

select maximum 
from 
	(select max(count_table.count) as maximum 
    from
		(select forum_id, count(topic_id) as count from topic group by forum_id) as count_table
     ) 
maximum_table;   

select forum_id, count
from 
	(select forum_id, count(topic_id) as count 
	from topic 
    group by forum_id 
    order by count desc
    limit 1
    ) count_table
;

select * 
from forum
where forum_id = 
	(select forum_id 
    from 
		(select forum_id, count(*) as count
		from topic
		group by forum_id
        order by count desc
        limit 1
        ) count_table
    )
;    


select *
from forum
join
	(select forum_id, count(topic_id) as count 
	from topic 
    group by forum_id 
    order by count desc
    limit 1
    ) count_table
 using (forum_id);   
--  End of forum with max topic count


select * 
from forum 
where 10 = 
	(select count(*) 
    from topic
    where topic.forum_id = forum.forum_id)
;

-- any in
select *
from user
where user_id > any
	(select user_id
    from message)
order by user_id;

select *
from message
where user_id = 
	(select max(user_id)
    from user
    );

select *
from user
where user_id not in
	(select user_id
    from message
    where user_id > 1)
order by user_id;

select *
from message
where message_id > all
	(select message_id
    from message
    where topic_id > 10)
order by message_id;

-- 05.03

-- compare sets

select *
from topic
where (user_id, topic_id) in
	(select user_id, topic_id
    from message
    where message_id > 190);
 
-- exists 
    
select * 
from forum    
where exists 
	(select *
    from topic
    where forum.forum_id = topic.forum_id);
    
-- subquery in from. This temporary table doesnt has index in table!

select *
from 
	(select forum_id, count(*) as themes_count 
    from topic
    group by forum_id) themes_count_table
where themes_count = 10;    

-- compare performance to this query. This has indexes but will be several subqueries. That will have only one subquery but no indexes in subtable
select *
from forum
where 10 = 
	(select count(*)
    from topic
    where forum.forum_id = topic.forum_id
    group by forum_id);

    

-- Cross join

select *
from topic
cross join user;    

select *
from topic
cross join user
order by topic.topic_id, user.user_id;   

select *
from topic, user
order by topic.topic_id, user.user_id;  
    
select *
from topic, user
where topic.user_id = user.user_id
order by topic.topic_id, user.user_id;  
 
-- Inner join

select *
from topic
inner join user
on user.user_id = topic.user_id;
-- ==
select *
from topic
join user 
on topic.user_id = user.user_id;


select *
from topic
inner join user
on user.user_id = topic.user_id
order by user.user_id, topic.topic_id;

-- natural join
select *
from topic
natural join user;

select *
from topic
join user using (user_id);

-- left, right join
select *
from user
left join topic
on user.user_id = topic.user_id
order by user.user_id;

select *
from topic
right join user
on user.user_id = topic.user_id
order by user.user_id;

select *
from user
right join topic
on user.user_id = topic.user_id;

-- full join. No support in Mysql

-- select *
-- from user
-- full join topic
-- on (user.user_id = topic.user_id)
-- order by user.user_id;

select *
from user
left join topic
on user.user_id = topic.user_id
union
select *
from user
right join topic
on user.user_id = topic.user_id;

-- self join
select *
from topic as topic_out
inner join topic as topic_in
on topic_out.user_id = topic_in.user_id
order by topic_out.user_id;

select *
from topic as topic_out
inner join topic as topic_in
on topic_out.user_id = topic_in.user_id
where topic_out.topic_id > topic_in.topic_id
order by topic_out.user_id;

-- find spaces in auto_increment
drop table if exists key_value;

create table key_value (
id int auto_increment not null,
name varchar(25), 
country varchar(25),
primary key (id))
engine = InnoDB;

insert into key_value
(name, country)
values
('a', 'Russia'),
(null, 'Russia'),
('c', 'USSR'),
('d', 'Russia'),
('e', 'USSR'),
('f', null),
(null, 'Ukraine'),
('h', null);

select * from key_value;

delete
from key_value
where id = 5; 

select *
from key_value as o
join key_value as i
on o.id + 1 = i.id;

select *
from key_value as o
left join key_value as i
on o.id + 1 = i.id
order by o.id;

-- equal right join
select *
from key_value as o
right join key_value as i
on o.id = i.id + 1
order by i.id;

-- another right join. spaces before
select *
from key_value as o
right join key_value as i
on o.id + 1 = i.id
order by i.id;

-- just tried to found out whats happening when it will be full outer join
select *
from key_value as o
right join key_value as i
on o.id = i.id + 1
union 
select *
from key_value as o
right join key_value as i
on o.id + 1 = i.id;

select country, group_concat(name order by name  separator ' ')
from key_value
group by country;

-- Views
drop view if exists old_messages;

create view old_messages
as 
	select *
    from message
    where 100 < message.message_id;
    
select *
from old_messages;  

-- Lecture 4
-- Handlers and cursors
drop procedure if exists test_handlers;
delimiter ;;
create procedure test_handlers ()
    begin
    declare cname varchar(25);
    declare done int default 0;
    declare curs cursor for 
		select name 
        from key_value;
	declare exit handler
		for 1146
        select 'error 1146';
    declare continue handler
		for sqlstate '02000' set done = 1; -- If no more rows are available, a No Data condition occurs with SQLSTATE value '02000' 
    open curs;
    while done = 0 do
		fetch curs into cname;
        select cname;
    end while;    
    close curs;    
	select * from no_such_table; -- go to 1146 handler
end ;;
delimiter ;
call test_handlers();

-- Triggers
drop trigger if exists add_new_null_row;
delimiter ;;
create trigger add_new_null_row
after delete 
on message
for each row 
begin
	insert into key_value 
    (id, name, country)
    values
    (old.message_id, null, null);
end;;    
delimiter ;

insert into message 
	set message_id = 206,
		topic_id = 1,
		user_id = 11,
		text = 'text206',
		creation_date = '2015-03-23 12:49:51';
    
delete from message
where message_id = 206;

select * from message
where message_id = 206;

select * from key_value;

-- Transactions
insert into user
(name)
values
('tran1'),
('tran2');

drop procedure if exists transaction_with_error_check;
delimiter ;;
create procedure transaction_with_error_check()
    begin
    declare cname varchar(25);
    declare _rollback int default 0;
	 declare continue handler
		for sqlexception
        set _rollback = 1;
	
    start transaction;

		update user 
		set name = 'aftertrantran1'
		where name = 'aftertran1';
		
		update user 
		set name = 'aftertrantran2'
		where name = 'aftertran2'; 
	
     if (_rollback = 1) then 
		rollback; -- transaction works only with a command rollback!!! Without it in case of exception there will be some changes in the part before exception
     else 
		commit;
     end if;
end ;;
delimiter ;
call transaction_with_error_check();

show databases;
show tables;
use test;

select *
from key_value;

select * 
from user;

delete from user
where user_id > 15;

-- Lecture 5

explain
select * 
from message 
where message_id = 52348; 

explain 
select * 
from message 
where message_id = 52348 or message_id = 10010; 

explain
select * 
from message 
where message_id between 345 and 500 and text = 'text500'; 

explain
select * 
from message 
where message_id between 50 and 100 and (creation_date = '2015-03-23 13:54:19' or creation_date = '2015-03-23 13:54:20'); 


create index message_text_index
on message (text (16));
explain
select * 
from message 
where text = 'text52346'; 
drop index message_text_index
on message;

create index id_creation_date_index
on message (message_id, creation_date);
explain 
select * 
from message 
where message_id between 50000 and 100000 and (creation_date = '2015-03-23 13:54:19' or creation_date = '2015-03-23 13:54:20' or creation_date = '2015-03-23 13:54:21'); 
drop index id_creation_date_index
on message;

select * 
from message 
where creation_date = '2015-03-23 13:54:21'
limit 1; 

explain
select *
from message 
where text like 'text10%';

create index creation_date_index
on message (creation_date);
explain
select * 
from message 
where creation_date between '2015-03-23 13:54:01' and '2015-03-23 13:54:21';
drop index creation_date_index
on message;

explain
select * 
from message
where user_id = 20;

-- cover index
explain
select message_id, user_id
from message
where message_id > 50 and message_id < 100;

select * 
from message
where user_id = 10 and topic_id = 10;

-- check indexes with joins
explain
select *
from forum 
cross join message;

explain extended
select *
from topic
join user
on topic.user_id = user.user_id
join forum 
on forum.forum_id = topic.forum_id;

-- index with order by and group by
create index message_text_date_index
on message (text (16), creation_date);
explain
select * 
from message 
where text like 'text100%'
order by creation_date desc;
drop index message_text_date_index
on message;

-- query from the book 554 page
select topic_id, user_id, count(*)
from topic
group by user_id
having count(*) > 1; -- the same result for: count(topic_id). this expression could be added to select section to show result more clearly
select *
from topic;
-- count(*) includes null, count(topic_id) doesn't 

-- Lecture 6 ------------------------

select
	(select user_id 
    from topic
    where user.user_id = user_id
    order by creation_date desc
    limit 1) as u_id, name 
from user;    

select *
from user
left join topic 
on user.user_id = topic.user_id
order by topic.creation_date desc;

-- select latest topic for each user. Using subqueries

select topic_id 
from topic 
where 39 = user_id
order by creation_date desc, topic_id desc -- need to order by two params because creation_date can be equal for the same user
limit 1;

select distinct
	(select topic_id 
    from topic 
    where outer_latest_topic.user_id = user_id
    order by creation_date desc, topic_id desc
    limit 1) as latest_topic_id, user_id
from topic as outer_latest_topic
order by user_id;   

-- Result query using subqueries and order by
select *
from topic 
where topic_id in  
	(select distinct
		(select topic_id 
		from topic 
		where outer_latest_topic.user_id = user_id 
		order by creation_date desc, topic_id desc
		limit 1) as latest_topic_id
	from topic as outer_latest_topic)
order by topic_id desc;   
    
-- select latest topic for each user. Using grouping.
select user_id, max(creation_date) as latest_date
from topic
group by user_id;

select topic_id, user_id
from topic
where (user_id, creation_date) in 
	-- (1, '2015-03-23 13:35:03');
    (select user_id, max(creation_date) as latest_date
	from topic
	group by user_id) and user_id = 39 
order by topic_id desc limit 1;

-- Result query using grouping
select *
from topic t_out
where topic_id = 
	(select topic_id
	from topic t_in
	where (user_id, creation_date) in 
		(select user_id, max(creation_date) as latest_date
		from topic
		group by user_id) and t_in.user_id = t_out.user_id  
	order by topic_id desc limit 1)
order by topic_id desc;

-- Result query using join.
select * -- need this hack for join work with group by
from (
	 (select topic_id 
     from topic t_out
     where topic_id =
		(select topic_id 
		from topic t_in
		where (user_id, creation_date) in
			(select user_id, max(creation_date) as max_creation_date
			from topic
			group by user_id) 
            and t_in.user_id = t_out.user_id
            order by topic_id desc 
            limit 1
		)
	) max_dates_topic 
    join topic -- using (topic_id)
    on topic.topic_id = max_dates_topic.topic_id 
);  

-- Result query using joins.
select * from
	(select max(topic_id_dates.topic_id) as max_topic_id, topic_id_dates.user_id 
	from (
		(select user_id, max(creation_date) as max_creation_date
		from topic
		group by user_id) as max_dates
		join 
		(select topic_id, creation_date, user_id
		from topic
		) as topic_id_dates
		on (topic_id_dates.creation_date = max_dates.max_creation_date and 
			max_dates.user_id = topic_id_dates.user_id)   
	) group by topic_id_dates.user_id) as max_topic_ids
join topic
on (topic.topic_id = max_topic_ids.max_topic_id);

-- Result query from Timur
select *
from 
	(select max(topic_id) max_topic
	from topic 
    where creation_date in
		(select max(creation_date)
        from topic
        group by user_id)
    group by user_id) as t2
    join topic t1
    on (t1.topic_id = t2.max_topic)
;

-- Result query from lecture. Doesnt work properly. It takes first one. Not the last one
create index topic_id_creation_date
on topic (topic_id, creation_date);
select topic_id, creation_date, user_id
from topic 
force index (topic_id_creation_date)
group by user_id;
drop index topic_id_creation_date
on topic;

set profiling = 1;
show profiles;
set profiling = 0;

explain
update user
set user_id = 20
where user_id = 20;

-- If there is difficult function from the left side of =, there will be no index usage at all. + queries with func current date wont be in cache 
explain
select *
from user
where user_id + 1 = 4;

-- Covering indexes
explain
select message_id, topic_id
from message;

explain
select message_id, topic_id
from message
where user_id = 3;

explain
select topic_id, creation_date
from message
where user_id = 3;

explain
select message_id
from message
where message_id = 43 and topic_id = 2
order by user_id;

explain
select message_id
from message
where message_id = 43 and topic_id in (1, 2)
order by user_id;

-- Cluster index is index inside one page of db. Several rows are in one page. 
-- If u want one row from page u will load the whole page and then one row from there. Several rows from one page is much faster then from different
-- Data in cluster index is in the order using index, so insert with random primary key is bad because all data must be moved in cluster
-- Cluster indeces are stored with data, so they move not only pointers but data
-- In Mysql clustered index is primary index or other unique index. Mysql chooses it by itself
-- One more thing. In innodb there is a mechanism to avoid lots of movement of data in cluster index. It saves space in one page in case of insert smth here.
-- So there is could be smth like lots of unused space. So u could use optimize tables command.

-- U could use advantages of cluster index (that they are in one page) to store connected data together. Eg, comment_id PK-> topic_id, comment_id PK. So to download several comments in one topic faster because they are very close to each other
-- Secondary indeces (not cluster) store values of PK in the leafs of B+ Tree

-- covering index
explain
select message_id, topic_id
from message 
where user_id = 12;

-- wo covering index
explain
select message_id, topic_id
from message 
where creation_date = '2015-03-23 13:54:21';

-- Covering index in join
explain
select message.message_id, user.name
from message
join user
on message.user_id = user.user_id
where message.user_id = 12;

explain
select message.message_id, user.name
from message
join user
on message.user_id = user.user_id;

explain
select *
from message
where message_id = 20013;

explain
select *
from user
where user_id = 16;

-- 1. Rule for indeces. U need to isolate the attribute to make index work: where num + 1 = 5 -> num = 4; 
-- to_days(current_date) - to_days(date_col) <= 10 -> date_col >= date_sub(current_date, interval 10 day);
-- BY the way: querries cache doesnt work with queries like current_date. Avoid them!

-- In MyIsam there is no differences between PK and SK. They all links to the index of the Row
-- IN InnoDb PK - cluster index (store with data). SK link to the PK and PK - to the data. Plus it PK stores TransactionID and RecoverId to support MVCC control for transactions

-- Covering index. We get the full data only from index. It's very useful for innoDb because SK stores PK in the leafs. So there will be only one search for a query
-- Covering index works like this: search with sk and then get data from PK (from leafs eg). So if we ask for two attributes in defferent SK index won't work. It only works like: ask for sk and pk. So it use SK to extract data and get additional PK from leafs (covering index)

-- Use denormalization for optimization. Because u don't need joins. But there will be difficulties with updates and deletes=( Triggers will help

-- Denormalization. Counters tables
-- update ht_counter set cnt = cnt + 1 // problems when there are lots of users. They lock attribute
-- update hit_counter set cnt = cnt + 1
-- where slot = rand() * 100;
-- select sum(cnt) from hit_counter;  gwt all counts to table

-- daily counter. (day, slot) - PK.
-- insert into daily(day, slot, cnt) 
-- values (current_date, rand() * 100, 1)
-- on duplicate key update cnt = cnt + 1;

-- DB VCS
-- 1. Store script for every version (from one version to the other - incremental method). And handle it with table of versions in database.
-- 2. Indepotent method. Every version has full list of changes (baseline.sql and changes.sql). If we have already accept the changes then we don't do anything. 
-- 3 (the best). Store database structure (scheme) like code sources. Create ur own system (or download from internet) that will store, update and control ur database structure (for every table there will be a file that will describe table structure: indeces. attributes with types, etc). -: separate storage data and scheme, need to code ur own automation system.

-- Lecture 7
-- Optimization

-- Do not get unnecessary rows or cols, do not get all cols from join (choose only necessary ones)
-- U can avoid joins and suqueries. U can use several simple queries insted of joins or subqueris (u can use group_concat...)
-- Use cache on maximum

show full processlist; -- shows queries running right now and its statuses
-- cache works only at the moment when tables are not chanded

-- usually needed for right query time wo cache
select sql_no_cache *
from user; 

-- system can change the order of joins. To avoid it u can use:
-- do like this wo optimization
select straight_join message.message_id, user.name
from message
join user
on message.user_id = user.user_id;

-- Optimizor can transform ur conditions to make them simplier
-- Often u can see smth like this: (1 = 1  and a > 4). It is made in code to use always concatinaion with "and" and dont check if it is a first condition or not.

-- Sorting optimizer.
-- 2 times going (first sort only cols in order by, second: other cols) - legacy
-- 1 time going (sorts full rows)

show status;
show status like 'select';

explain
select * 
from message
where message_id = -1;


-- Joins and subqueries use inner loops

-- Split joins or subqueries in the application on several simple queries. 
-- use group concat and the second query instead of subquery in in expression

-- mysql can use merge index if we have indecies on user_id and topic_id
-- index (user_id, topic_id) wont help. But u can use union all operation.
select *
from message_id
where user_id = 1 or topic_id = 2;

select min(message_id)
from message
where text = 'text100';
-- optimization using primary index ->
select message_id
from message use index (PRIMARY)
where text = 'text100'
limit 1;

-- u can use join instead of subquery for update values (u can't update inside subqueries)
-- count(*) works fast for Myisam, because table stores counter for number of rows inside table
-- count(*) counts number of rows include null
-- count(row) count number of values of col exclude null  

-- when u use group by db always do order additionaly. if u don't want:
select user_id, count(user_id)
from message
group by user_id
order by null;

-- when u join create index in the second table on the col in the join condition

-- Use group by with index! not with text field. If u use group by u need in selection group operations. So u can do self join with index usage.
select user.name, count(*)
from topic 
join user
on topic.user_id = user.user_id
group by user.name;
-- ->
select user.name, count(*)
from topic 
join user
on topic.user_id = user.user_id
group by user.user_id;

-- use covering index in join query for fast search last 50 rows
select message_id, text
from message
order by creation_date
limit 99830, 50;
-- ->
select message_id, text
from message
join 
(select message_id 
from message
order by creation_date
limit 99810, 50
) as covering_indx_message_table
using (message_id);
-- it's better to transform limit to between for index field. Denormalizaion
-- ->
select message_id, text
from message
where position between 99831 and 99881;

-- sql_calc_found_rows will count all rows in table even the query has a limit
-- use count(index_field) instead

-- merge tables can be used for storing union tables eg for statistics
-- it doesnt use additional space and doenst duplcate data
-- partitions (partition by ...) can be used to split big table into small ones

-- LECTURE 8

-- Define size of ram that mysql will use; (usually 80% of ram) 
-- Define size for sorting and temporary tables
-- Define size for OS
-- All unused ram - for caches

-- key_buffer_size - 25-50% of space for caches

-- MYISAM (cahce stores in OS)
-- for MyIsam only. Load indeces into cache. This commands can be stored in script file (init file) that will be loaded while initializing system (init_file param in config file):
-- Commands:
-- cache index t1, t2 in key_buffer_1;
-- load index into cache t1, t2;

-- key_cache_block_size useful to make it equal to page size

-- Inno DB (cache stores by DB)
-- innodb_buffer_pool_size -- up to 80% of RAM

-- delay_key_write -- use delay before storing keys to hard drive

-- inno_flush_log_at_trx_commit -- write to hard drive or not after each transaction


show status;

show status like 'Thread%';

set @@global.thread_cache_size:=10; -- max threads in cache

show global status;

show master status;

show slave status;

-- LECTURE 9


-- backup: logical (commands in text file) and physical (files in OS)
-- To backup: data, logs, transaction logs, sources (triggers, procedures), replication configs, server configs, OS files (crons, users configs, sudo files)

-- security
-- tables: user, db, host, tables_priv, columns_priv, procs_priv
-- Authentification: login, host, passwords

-- grant <all> prev on object (*.* - all db and tables) to user identified by passwd;
-- revoke <all> prev on object from user;
-- drop user;

-- sql injection using --
-- get data right from query string (get user without any password): http://news?login=admin;--
-- select * from user where login = 'admin' and pass = '123' ->
-- select * from user where login = 'admin'; -- and pass = '123' 

-- if u give all priv for user u can't revoke prev on one table, col or db 

-- if u use search in db with '%' symbols u need to filter user input because he can ddos u, doing smth like this: %flsakf%. index doesn't work here.

-- using union 1, 2, ... or using group by 3 (grouping using 3rd col in result set) we can get the number of col in table. Then we can use INFORMATION_SCHEMA table to get info about tables.

-- in sql injection u can send php script and execute in on server

-- DDOS on the DB server
select benchmark(10, md5(current_time));

-- if u want to store hierarchical structures in db u can do it three ways: adjacency list, nested set, materialized path and combined method

-- Lecture 10

-- disadvantages of sql
-- in sql u don't have nested structures
-- in sql u don't have normal distribuited system
-- lot's of data

-- advantages: 
-- standartized sql
-- acid (Atomicity (transaction), Consistency(one state -> another), Isolation, Durability)

-- advantages of Nosql (no relational, no schema, avoid joins)
-- clusters friendly
-- open-source
-- schemaless
-- can store nested structures

-- aggreagation using map-reduce
-- full scan using multi machine map-reduce
-- key-value (dynamo db, redis), big tables (one key -> several columns -> column-value: hbase, cassandra), document oriented (MongoDb), graph (Neo4j) 

-- Cap theorem for distributed system 
-- Availavility (each client can always read and write)
-- Consistency (all clients always have the same view of data)
-- Partition tolerance (the system works well despite physical network partition)

-- if u don't have consistancy sometime the system will be consistent but we don't know when. Using gossips algorithms (push, pull, pull-push). It is reolved using different consistency algorithms

-- adv/disadv 
-- Mongo 3 config servers -> no fault tolerance. Map/reduce 1 thread, blocked i/o, written on JS. Can be 
-- Redis: key/value in RAM, uses more RAM then needed to store data (up to 2x). Persist inly using snapshot or using fsync. Requires lots of io.
-- Neo4j: shareware or u need to open ur sources
-- Cassandra: no indeces

-- If u need scalability
-- HBase - lots of data to store, no need to get difficult queries and transactions
-- Cassandra, Riak - lot's of data to write, no need  consistency  
-- MongoDb, Redis - fast data (clicks, stocks), persistent

-- If u need transactions
-- Relational
-- Hbase - atomic on rows
-- Cassandra, Riak - low consistency
-- Mongo, Redis - atomic on document\record




-- ---------------------

use forumsdb;




-- ----------------

-- delete from message where message_id = message_id;
     
-- delete from message where message_id > 200;     