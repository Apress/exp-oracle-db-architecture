drop table t;

create table t 
( x int primary key, 
  y varchar2(4000)
)
/

insert into t (x,y)
select rownum, rpad('*',148,'*') 
  from dual
connect by level <= 46;

select length(y), 
       dbms_rowid.rowid_block_number(rowid) blk, 
       count(*), min(x), max(x)
  from t
 group by length(y), dbms_rowid.rowid_block_number(rowid);

create or replace procedure do_update( p_n in number )
as
    pragma autonomous_transaction;
    l_rec t%rowtype;
    resource_busy exception;
    pragma exception_init( resource_busy, -54 );
begin
    select * 
      into l_rec 
      from t 
     where x = p_n 
       for update NOWAIT;

    do_update( p_n+1 );
    commit;
exception
when resource_busy 
then
    dbms_output.put_line( 'locked out trying to select row ' || p_n );
    commit;
when no_data_found
then
    dbms_output.put_line( 'we finished - no problems' );
    commit;
end;
/
exec do_update(1);
truncate table t;
insert into t (x,y)
select rownum, rpad('*',147,'*') 
  from dual
connect by level <= 46;

select length(y), 
       dbms_rowid.rowid_block_number(rowid) blk, 
       count(*), min(x), max(x)
  from t
 group by length(y), dbms_rowid.rowid_block_number(rowid);
exec do_update(1);
