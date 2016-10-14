select tch, file#, dbablk,
      case when obj = 4294967295
           then 'rbs/compat segment'
           else (select max( '('||object_type||') ' ||
                             owner || '.' || object_name  ) ||
                        decode( count(*), 1, '', ' maybe!' )
                   from dba_objects
                  where data_object_id = X.OBJ )
       end what
 from (
select tch, file#, dbablk, obj
  from x$bh
 where state <> 0
 order by tch desc
      ) x
where rownum <= 5
/


select data_object_id, count(*)
  from dba_objects
 where data_object_id is not null
 group by data_object_id
having count(*) > 1;


select tch, file#, dbablk, DUMMY
  from x$bh, (select dummy from dual)
 where obj = (select data_object_id
                from dba_objects
               where object_name = 'DUAL'
                 and data_object_id is not null)
/
exec dbms_lock.sleep(3.2);
/
exec dbms_lock.sleep(3.2);
/
exec dbms_lock.sleep(3.2);
/
exec dbms_lock.sleep(3.2);
/
