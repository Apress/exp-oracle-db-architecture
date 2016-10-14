drop table id_table purge;
drop table t purge;
drop sequence t_seq;


create table id_table
( id_name  varchar2(30) primary key,
  id_value number );
insert into id_table values ( 'MY_KEY', 0 );
commit;
update id_table
   set id_value = id_value+1
 where id_name = 'MY_KEY';
select id_value
  from id_table
 where id_name = 'MY_KEY';



create table t 
( pk number primary key,
  other_data varchar2(20)
)
/
create sequence t_seq;

create trigger t before insert on t 
for each row
begin
	:new.pk := t_seq.nextval;
end;
/
