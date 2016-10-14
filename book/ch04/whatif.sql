column total_pga format 9,999
with data(users)
as
(select 1 users from dual
 union all
 select users+25 from data where users+25 <= 550)
select users, 7 my_pga, 7*users total_pga
  from data
 order by users
/

