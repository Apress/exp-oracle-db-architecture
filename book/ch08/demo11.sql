set echo on
drop table t;

create table t ( msg varchar2(25) );
create or replace procedure Autonomous_Insert
as
        pragma autonomous_transaction;
begin
        insert into t values ( 'Autonomous Insert' );
        commit;
end;
/
create or replace procedure NonAutonomous_Insert
as
begin
        insert into t values ( 'NonAutonomous Insert' );
        commit;
end;
/
begin
        insert into t values ( 'Anonymous Block' );
        NonAutonomous_Insert;
        rollback;
end;
/
select * from t;
delete from t;
commit;
begin
        insert into t values ( 'Anonymous Block' );
        Autonomous_Insert;
        rollback;
end;
/
select * from t;

