drop tablespace in_the_clear including contents and datafiles;
drop table t;


create tablespace in_the_clear
datafile '/tmp/in_the_clear.dbf' size 1m
/

create table t
( id           varchar2(30) primary key,
  ssn          varchar2(11),
  address      varchar2(80),
  credit_card  varchar2(30)
)
tablespace in_the_clear;

insert into t (id, ssn, address, credit_card )
values ( 'Look for me', '123-45-6789', 
         '123 Main Street', '1234-5678-9876-5432' );
commit;


alter system checkpoint;

!strings -a /tmp/in_the_clear.dbf | egrep '(Look for me|123)'

delete from t where id = 'Look for me';
commit;
alter system checkpoint;

!strings -a /tmp/in_the_clear.dbf | egrep '(Look for me|123)'


column member new_val redo
select a.member 
  from v$logfile a, v$log b 
 where a.group# = b.group# 
   and b.status = 'CURRENT' 
   and rownum = 1;

!strings -a &REDO | egrep '(Look for me|123)'


drop tablespace in_the_clear including contents and datafiles;
drop table t;
