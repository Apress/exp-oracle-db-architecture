drop table schedules purge;
drop table resources purge;

create table resources 
( resource_name varchar2(25) primary key, 
  other_data    varchar2(25)
);
create table schedules
( resource_name varchar2(25) references resources,
  start_time    date,
  end_time      date 
);

insert into resources
( resource_name, other_data )
values
( 'conference room', 'xxx' );
insert into schedules
( resource_name, start_time, end_time )
values
( 'conference room',
   to_date( '01-jan-2010 9am', 'dd-mon-yyyy hham' ),
   to_date( '01-jan-2010 10am', 'dd-mon-yyyy hham' )
);

variable resource_name varchar2(25)
variable new_start_time varchar2(30)
variable new_end_time varchar2(30)


set autoprint on
alter session set nls_date_format = 'dd-mon-yyyy hh:miam';
begin
	:resource_name := 'conference room';
    :new_start_time := to_date( '01-jan-2010 9:30am', 'dd-mon-yyyy hh:miam' );
    :new_end_time := to_date( '01-jan-2010 10:00am', 'dd-mon-yyyy hh:miam' );
end;
/
select count(*) 
  from schedules 
 where resource_name = :resource_name
   and (start_time < :new_end_time) 
   AND (end_time > :new_start_time)
/

insert into schedules
( resource_name, start_time, end_time )
values
( :resource_name, 
   to_date( :new_start_time ),
   to_date( :new_end_time )
);

select count(*) 
  from schedules 
 where resource_name = :resource_name
   and (start_time < :new_end_time) 
   AND (end_time > :new_start_time)
/

