create table t ( x date );
insert into t (x) values
( to_date( '25-jun-2005 12:01:00',
           'dd-mon-yyyy hh24:mi:ss' ) );
select x, dump(x,10) d from t;
insert into t (x) values
( to_date( '01-jan-4712bc',
           'dd-mon-yyyybc hh24:mi:ss' ) );
select x, dump(x,10) d from t;
insert into t (x) values
( to_date( '01-jan-4710bc',
           'dd-mon-yyyybc hh24:mi:ss' ) );
select x, dump(x,10) d from t;

drop table t;


create table t ( what varchar2(10), x date );
insert into t (what, x) values
( 'orig',
  to_date( '25-jun-2005 12:01:00',
           'dd-mon-yyyy hh24:mi:ss' ) );
insert into t (what, x)
select 'minute', trunc(x,'mi') from t
union all
select 'day', trunc(x,'dd') from t
union all
select 'month', trunc(x,'mm') from t
union all
select 'year', trunc(x,'y') from t
/
select what, x, dump(x,10) d from t;

drop table t;


create table t
as
select created from all_objects;
exec dbms_stats.gather_table_stats( user, 'T' );
select count(*)
from
 t where to_char(created,'yyyy') = '2005';
select count(*)
from
 t where trunc(created,'y') = to_date('01-jan-2005','dd-mon-yyyy');
select count(*) from t
where created >= to_date('01-jan-2005','dd-mon-yyyy')
  and created <  to_date('01-jan-2006','dd-mon-yyyy');

