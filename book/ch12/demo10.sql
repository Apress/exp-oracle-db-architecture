alter session set nls_date_format = 'dd-mon-yyyy hh24:mi:ss';
select dt, add_months(dt,1)
  from (select to_date('29-feb-2000','dd-mon-yyyy') dt from dual )
/
select dt, add_months(dt,1)
  from (select to_date('28-feb-2001','dd-mon-yyyy') dt from dual )
/
select dt, add_months(dt,1)
  from (select to_date('30-jan-2001','dd-mon-yyyy') dt from dual )
/
select dt, add_months(dt,1)
  from (select to_date('30-jan-2000','dd-mon-yyyy') dt from dual )
/
select dt, dt+numtoyminterval(1,'month')
  from (select to_date('29-feb-2000','dd-mon-yyyy') dt from dual )
/
select dt, dt+numtoyminterval(1,'month')
  from (select to_date('28-feb-2001','dd-mon-yyyy') dt from dual )
/
select dt, dt+numtoyminterval(1,'month')
  from (select to_date('30-jan-2001','dd-mon-yyyy') dt from dual )
/
select dt, dt+numtoyminterval(1,'month')
  from (select to_date('30-jan-2000','dd-mon-yyyy') dt from dual )
/
select dt2-dt1 ,
       months_between(dt2,dt1) months_btwn,
       numtodsinterval(dt2-dt1,'day') days,
       numtoyminterval(trunc(months_between(dt2,dt1)),'month') months
  from (select to_date('29-feb-2000 01:02:03','dd-mon-yyyy hh24:mi:ss') dt1,
               to_date('15-mar-2001 11:22:33','dd-mon-yyyy hh24:mi:ss') dt2
          from dual )
/
select numtoyminterval
       (trunc(months_between(dt2,dt1)),'month')
           years_months,
       numtodsinterval
           (dt2-add_months( dt1, trunc(months_between(dt2,dt1)) ),
            'day' )
           days_hours
  from (select to_date('29-feb-2000 01:02:03','dd-mon-yyyy hh24:mi:ss') dt1,
               to_date('15-mar-2001 11:22:33','dd-mon-yyyy hh24:mi:ss') dt2
          from dual )
/
