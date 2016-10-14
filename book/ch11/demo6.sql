set echo on
set linesize 1000
drop table t;


create table t
( gender not null,
  location not null,
  age_group not null,
  data
)
as
select decode( ceil(dbms_random.value(1,2)),
               1, 'M',
               2, 'F' ) gender,
       ceil(dbms_random.value(1,50)) location,
       decode( ceil(dbms_random.value(1,5)),
               1,'18 and under',
               2,'19-25',
               3,'26-30',
               4,'31-40',
               5,'41 and over'),
       rpad( '*', 20, '*')
  from big_table.big_table
 where rownum <= 100000;
create bitmap index gender_idx on t(gender);
create bitmap index location_idx on t(location);
create bitmap index age_group_idx on t(age_group);
exec dbms_stats.gather_table_stats( user, 'T');
Select count(*)
  from T
 where gender = 'M'
   and location in ( 1, 10, 30 )
   and age_group = '41 and over';
select *
  from t
 where (   ( gender = 'M' and location = 20 )
        or ( gender = 'F' and location = 22 ))
   and age_group = '18 and under';



