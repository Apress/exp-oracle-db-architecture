column name format a4
select paddr, name, description
  from v$bgprocess
 order by name -- paddr desc
/

select paddr, name, description
  from v$bgprocess
 where paddr <> '00'
 order by paddr desc
/
