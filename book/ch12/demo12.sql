select dt2-dt1
  from (select to_timestamp('29-feb-2000 01:02:03.122000',
                            'dd-mon-yyyy hh24:mi:ss.ff') dt1,
               to_timestamp('15-mar-2001 11:22:33.000000',
                            'dd-mon-yyyy hh24:mi:ss.ff') dt2
          from dual )
/
select extract( day    from dt2-dt1 ) day,
       extract( hour   from dt2-dt1 ) hour,
       extract( minute from dt2-dt1 ) minute,
       extract( second from dt2-dt1 ) second
  from (select to_timestamp('29-feb-2000 01:02:03.122000',
                            'dd-mon-yyyy hh24:mi:ss.ff') dt1,
               to_timestamp('15-mar-2001 11:22:33.000000',
                            'dd-mon-yyyy hh24:mi:ss.ff') dt2
          from dual )
/
select numtoyminterval(5,'year')+numtoyminterval(2,'month')
from dual;
select numtoyminterval(5*12+2,'month')
from dual;
select to_yminterval( '5-2' ) from dual;
select interval '5-2' year to month from dual;
select numtodsinterval( 10, 'day' )+
numtodsinterval( 2, 'hour' )+
numtodsinterval( 3, 'minute' )+
numtodsinterval( 2.3312, 'second' )
from dual;
select numtodsinterval( 10*86400+2*3600+3*60+2.3312, 'second' )
from dual;
select to_dsinterval( '10 02:03:02.3312' )
from dual;
select interval '10 02:03:02.3312' day to second
from dual;

