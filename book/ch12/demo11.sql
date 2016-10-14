set echo on

drop table t;


create table t
( dt   date,
  ts   timestamp(0)
)
/
insert into t values ( sysdate, systimestamp );
select dump(dt,10) dump, dump(ts,10) dump
  from t;


drop table t;


create table t
( dt   date,
  ts   timestamp(9)
)
/
insert into t values ( sysdate, systimestamp );
select dump(dt,10) dump, dump(ts,10) dump
  from t;
alter session set nls_date_format = 'dd-mon-yyyy hh24:mi:ss';
select * from t;
select dump(ts,16) dump from t;
select to_number('2c65c0d0','xxxxxxxx') from dual;
alter session set nls_date_format = 'dd-mon-yyyy hh24:mi:ss';
select systimestamp ts, systimestamp+1 dt
from dual;
select systimestamp ts, systimestamp +numtodsinterval(1,'day') dt
from dual;
select dt2-dt1
  from (select to_timestamp('29-feb-2000 01:02:03.122000',
                            'dd-mon-yyyy hh24:mi:ss.ff') dt1,
               to_timestamp('15-mar-2001 11:22:33.000000',
                                         'dd-mon-yyyy hh24:mi:ss.ff') dt2
          from dual )
/
select numtoyminterval
       (trunc(months_between(dt2,dt1)),'month')
           years_months,
       dt2-add_months(dt1,trunc(months_between(dt2,dt1)))
               days_hours
  from (select to_timestamp('29-feb-2000 01:02:03.122000',
                            'dd-mon-yyyy hh24:mi:ss.ff') dt1,
               to_timestamp('15-mar-2001 11:22:33.000000',
                            'dd-mon-yyyy hh24:mi:ss.ff') dt2
          from dual )
/
select numtoyminterval
       (trunc(months_between(dt2,dt1)),'month')
           years_months,
       dt2-(dt1 + numtoyminterval( trunc(months_between(dt2,dt1)),'month' ))
               days_hours
  from (select to_timestamp('29-feb-2000 01:02:03.122000',
                            'dd-mon-yyyy hh24:mi:ss.ff') dt1,
               to_timestamp('15-mar-2001 11:22:33.000000',
                             'dd-mon-yyyy hh24:mi:ss.ff') dt2
          from dual )
/


drop table t;


create table t
(
  ts    timestamp,
  ts_tz timestamp with time zone
)
/
insert into t ( ts, ts_tz )
values ( systimestamp, systimestamp );
select * from t;
select dump(ts), dump(ts_tz) from t;


drop table t;


create table t
( ts1  timestamp with time zone,
  ts2  timestamp with time zone
)
/
insert into t (ts1, ts2)
values ( timestamp'2010-02-27 16:02:32.212 US/Eastern',
         timestamp'2010-02-27 16:02:32.212 US/Pacific' );
select ts1-ts2 from t;


drop table t;


create table t
( dt   date,
  ts1  timestamp with time zone,
  ts2  timestamp with local time zone
)
/
insert into t (dt, ts1, ts2)
values ( timestamp'2010-02-27 16:02:32.212 US/Pacific',
         timestamp'2010-02-27 16:02:32.212 US/Pacific',
         timestamp'2010-02-27 16:02:32.212 US/Pacific' );
select dbtimezone from dual;
select dump(dt), dump(ts1), dump(ts2) from t;
select ts1, ts2 from t;
alter database set time_zone = 'PST';

delete from t;
insert into t (dt, ts1, ts2)
values ( timestamp'2010-04-12 16:02:32.212 US/Pacific',
         timestamp'2010-04-12 16:02:32.212 US/Pacific',
         timestamp'2010-04-12 16:02:32.212 US/Pacific' );
select ts1, ts2 from t;

