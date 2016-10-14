set echo on

set linesize 1000
/*

drop table t;


create table t 
as
select * 
  from all_objects
/
create index t_idx 
on t(owner,object_type,object_name);
begin
	dbms_stats.gather_table_stats
	( user, 'T', method_opt=>'for all indexed columns' );
end;
/

set autotrace traceonly explain
select owner, object_type
  from t
 where owner between 'T' and 'Z'
   and object_type is not null
 order by owner DESC, object_type DESC;
select owner, object_type
  from t
 where owner between 'T' and 'Z'
   and object_type is not null
 order by owner DESC, object_type ASC;
create index desc_t_idx on t(owner desc,object_type asc);
select owner, object_type
  from t
 where owner between 'T' and 'Z'
   and object_type is not null
 order by owner DESC, object_type ASC;
*/

set autotrace traceonly explain
select owner, status
  from t
 where owner = USER;

select count(*)
  from t
 where owner = user;

