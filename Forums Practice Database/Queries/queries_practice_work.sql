use `forumsdb`;

drop database if exists forumsdb;

-- ----------- change tables --------------------
alter table `forum` AUTO_INCREMENT = 1;

alter table `user` AUTO_INCREMENT = 1;

alter table topic AUTO_INCREMENT = 1;

alter table message AUTO_INCREMENT = 1;

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

call fill_index_to_string_table('forum', 'forum', 1, 10);
call fill_index_to_string_table('user', 'user', 1, 15);
call fill_topic_table(1, 10, 1, 20);
call fill_message_table(1, 10, 1, 15, 1, 200);


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

select count(*) from `forum`;

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

select forum_id, count(topic_id) as count_topic, name from topic group by forum_id having count_topic > 2; 

select forum_id, count(topic_id), name from topic where forum_id % 2 = 0 group by forum_id having count(topic_id) > 2; 

select forum_id, count(topic_id), name from topic where forum_id % 2 = 0 group by forum_id having count(topic_id) > 2 order by count(topic_id) desc, forum_id desc;
 
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

select forum_id, count(topic_id) from topic group by forum_id;

select * from topic as topic_outer where (select count(topic_id) from topic where topic.forum_id = topic_outer.forum_id) = 1;

-- all forums with one topic
select forum_id, count(topic_id) from topic as topic_outer where (select count(topic_id) from topic where topic.forum_id = topic_outer.forum_id) = 1 group by topic_id;

select * from forum where (select count(topic_id) from topic where topic.forum_id = forum.forum_id) = 1;

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
where themes_count = 1;    

-- compare performance to this query. This has indexes but will be several subqueries. That will have only one subquery but no indexes in subtable
select *
from forum
where 1 = 
	(select count(*)
    from topic
    where forum.forum_id = topic.forum_id
    group by forum_id);
    
    

    
delete from message where message_id = message_id;
     
delete from message where message_id > 200;     
