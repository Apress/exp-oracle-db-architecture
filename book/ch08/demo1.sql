drop table t2;
drop table t;
set echo on


create table t2 ( cnt int );
insert into t2 values ( 0 );
commit;
create table t ( x int check ( x>0 ) );
create trigger t_trigger
before insert or delete on t for each row
begin
   if ( inserting ) then
        update t2 set cnt = cnt +1;
   else
        update t2 set cnt = cnt -1;
   end if;
   dbms_output.put_line( 'I fired and updated '  ||
                                   sql%rowcount || ' rows' );
end;
/

set serveroutput on
insert into t values (1);
insert into t values(-1);
select * from t2;

