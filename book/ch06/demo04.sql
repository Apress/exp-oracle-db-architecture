connect scott/tiger
set echo on
drop table demo;
create table demo ( x int primary key );
create or replace trigger demo_bifer
before insert on demo
for each row
declare
    l_lock_id   number;
    resource_busy   exception;
    pragma exception_init( resource_busy, -54 );
	l_request number;
begin
    l_lock_id := 
	  dbms_utility.get_hash_value( to_char( :new.x ), 0, 102400 );
    l_request := ( dbms_lock.request
             (  id                => l_lock_id,
                lockmode          => dbms_lock.x_mode,
                timeout           => 0,
                release_on_commit => TRUE ) );
	if ( l_request not in (0,4) )
    then
		dbms_output.put_line( 'request = ' || l_request );
        raise resource_busy;
    end if;
end;
/

insert into demo(x) values (1);

declare
    pragma autonomous_transaction;
begin
    insert into demo(x) values (1);
    commit;
end;
/

rollback;
commit;
insert into demo select rownum+1 from all_objects where rownum <= 10000;
