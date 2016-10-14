set echo on

drop table t;

create table t
as
select * 
  from all_objects
 where 1=0
/

create or replace procedure p
as
begin
    for x in ( select * from all_objects )
    loop
        insert into t values X;
        commit;
    end loop;
end;
/

create or replace procedure p
as
begin
    for x in ( select * from all_objects )
    loop
        insert into t values X;
        commit write NOWAIT;
    end loop;

    -- make internal call here to ensure
    -- redo was written by LGWR
end;
/
