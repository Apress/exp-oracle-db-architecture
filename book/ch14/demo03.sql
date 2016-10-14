create table user_info as select * from all_users;
alter table user_info parallel;
exec dbms_stats.gather_table_stats( user, 'USER_INFO' );
create table new_table parallel 
as 
select a.*, b.user_id, b.created user_created 
  from big_table a, user_info b 
 where a.owner = b.username
/
