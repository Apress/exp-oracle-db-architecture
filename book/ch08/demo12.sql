set echo on

drop table error_log;
create table error_log
( ts   timestamp,
  err1 clob,
  err2 clob )
/

create or replace 
procedure log_error
( p_err1 in varchar2, p_err2 in varchar2 )
as
    pragma autonomous_transaction;
begin
    insert into error_log( ts, err1, err2 )
    values ( systimestamp, p_err1, p_err2 );
    commit;
end;
/

drop table t;
create table t ( x int check (x>0) );

create or replace procedure p1( p_n in number )
as
begin
    -- some code here
    insert into t (x) values ( p_n );
end;
/
create or replace procedure p2( p_n in number )
as
begin
    -- code
    -- code
    p1(p_n);
end;
/

begin
    p2( 1 );
    p2( 2 );
    p2( -1);
exception
    when others
    then
        log_error( sqlerrm, dbms_utility.format_error_backtrace );
        RAISE;
end;
/

select * from t;
rollback;
select * from error_log;
