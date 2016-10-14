set echo on
drop table t purge;

create table t 
( processed_flag varchar2(1) 
);
create bitmap index
t_idx on t(processed_flag);
insert into t values ( 'N' );
declare
    pragma autonomous_transaction;
begin
    insert into t values ( 'N' );
    commit;
end;
/
