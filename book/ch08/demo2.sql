create or replace procedure p
as
begin
        insert into t values ( 1 );
        insert into t values (-1 );
end;
/
delete from t;
update t2 set cnt = 0;
commit;
select * from t;
select * from t2;
begin
    p;
end;
/
select * from t;
select * from t2;
begin
    p;
exception
    when others then
        dbms_output.put_line( 'Error!!!! ' || sqlerrm );
end;
/
select * from t;
select * from t2;
rollback;


select * from t;
select * from t2;
begin
    savepoint sp;
    p;
exception
    when others then
        rollback to sp;
        dbms_output.put_line( 'Error!!!! ' || sqlerrm );
end;
/
select * from t;
select * from t2;
