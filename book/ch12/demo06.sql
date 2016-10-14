create table t ( num_col number(5,0) );
insert into t (num_col) values ( 12345 );
insert into t (num_col) values ( 123456 );

drop table t;

create table t ( msg varchar2(10), num_col number(5,2) );
insert into t (msg,num_col) values ( '123.45',  123.45 );
insert into t (msg,num_col) values ( '123.456', 123.456 );
select * from t;
insert into t (msg,num_col) values ( '1234', 1234 );

drop table t;

create table t ( msg varchar2(10), num_col number(5,-2) );
insert into t (msg,num_col) values ( '123.45',  123.45 );
insert into t (msg,num_col) values ( '123.456', 123.456 );
select * from t;
insert into t (msg,num_col) values ( '1234567', 1234567 );
select * from t;
insert into t (msg,num_col) values ( '12345678', 12345678 );

drop table t;

create table t ( x number, y number );
insert into t ( x )
select to_number(rpad('9',rownum*2,'9'))
  from all_objects
 where rownum <= 14;
update t set y = x+1;
set numformat 99999999999999999999999999999
column v1 format 99
column v2 format 99
select x, y, vsize(x) v1, vsize(y) v2
  from t order by x;

