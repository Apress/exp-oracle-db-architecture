set echo on

drop table people;
drop type person_type;
drop type address_type;

create or replace type address_type
as object
( city    varchar2(30),
  street  varchar2(30),
  state   varchar2(2),
  zip     number
)
/
create or replace type person_type
as object
( name             varchar2(30),
  dob              date,
  home_address     address_type,
  work_address     address_type
)
/
create table people of person_type
/
desc people


insert into people values ( 'Tom', '15-mar-1965',
address_type( 'Reston', '123 Main Street', 'Va', '45678' ),
address_type( 'Redwood', '1 Oracle Way', 'Ca', '23456' ) );
select name, dob, p.home_address Home, p.work_address work 
  from people p;

select name, segcollength
  from sys.col$
 where obj# = ( select object_id
                  from user_objects
                 where object_name = 'PEOPLE' )
/

column ddl format a72 word_wrapped
select dbms_metadata.get_ddl( 'TABLE', 'PEOPLE' ) ddl 
  from dual;
