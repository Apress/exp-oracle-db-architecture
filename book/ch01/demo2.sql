set echo on
drop table t purge;

create table t 
( id       number primary key,
  processed_flag varchar2(1),
  payload  varchar2(20)
);
create index 
t_idx on 
t( decode( processed_flag, 'N', 'N' ) );

insert into t 
select r, 
       case when mod(r,2) = 0 then 'N' else 'Y' end, 
       'payload ' || r
  from (select level r 
          from dual  
       connect by level <= 5)
/ 
select * from t;

create or replace 
function get_first_unlocked_row 
return t%rowtype
as
    resource_busy exception;
    pragma exception_init( resource_busy, -54 );
    l_rec t%rowtype;
begin
    for x in ( select rowid rid 
                 from t 
                 where decode(processed_flag,'N','N') = 'N')
    loop
    begin
        select * into l_rec 
          from t 
         where rowid = x.rid and processed_flag='N'
           for update nowait;
        return l_rec;
    exception
        when resource_busy then null;
    end;
    end loop;
    return null;
end;
/

set serveroutput on
declare
    l_rec  t%rowtype;
begin
    l_rec := get_first_unlocked_row;
    dbms_output.put_line( 'I got row ' || l_rec.id || ', ' || l_rec.payload );
end;
/

declare
    pragma autonomous_transaction;
    l_rec  t%rowtype;
begin
    l_rec := get_first_unlocked_row;
    dbms_output.put_line( 'I got row ' || l_rec.id || ', ' || l_rec.payload );
    commit;
end;
/


commit;

declare
    l_rec t%rowtype;
    cursor c 
    is
    select *
      from t 
     where decode(processed_flag,'N','N') = 'N'
       FOR UPDATE
      SKIP LOCKED;
begin
    open c;
    fetch c into l_rec;
    if ( c%found )
    then
        dbms_output.put_line( 'I got row ' || l_rec.id || ', ' || l_rec.payload );
    end if;
    close c;
end;
/

declare
    pragma autonomous_transaction;
    l_rec t%rowtype;
    cursor c 
    is
    select *
      from t 
     where decode(processed_flag,'N','N') = 'N'
       FOR UPDATE
      SKIP LOCKED;
begin
    open c;
    fetch c into l_rec;
    if ( c%found )
    then
        dbms_output.put_line( 'I got row ' || l_rec.id || ', ' || l_rec.payload );
    end if;
    close c;
    commit;
end;
/
