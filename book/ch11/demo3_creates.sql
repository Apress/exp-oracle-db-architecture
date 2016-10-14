drop table t;
drop sequence s;


create table t tablespace assm
as
select 0 id, a.*
  from all_objects a
 where 1=0;
                                      
alter table t
add constraint t_pk
primary key (id)
using index (create index t_pk on t(id) &1 tablespace assm);

create sequence s cache 1000;

create or replace procedure do_sql
as
begin
    for x in ( select rownum r, all_objects.* from all_objects )
    loop
        insert into t
        ( id, OWNER, OBJECT_NAME, SUBOBJECT_NAME,
          OBJECT_ID, DATA_OBJECT_ID, OBJECT_TYPE, CREATED,
          LAST_DDL_TIME, TIMESTAMP, STATUS, TEMPORARY,
          GENERATED, SECONDARY, NAMESPACE, EDITION_NAME )
        values
        ( s.nextval, x.OWNER, x.OBJECT_NAME, x.SUBOBJECT_NAME,
          x.OBJECT_ID, x.DATA_OBJECT_ID, x.OBJECT_TYPE, x.CREATED,
          x.LAST_DDL_TIME, x.TIMESTAMP, x.STATUS, x.TEMPORARY,
          x.GENERATED, x.SECONDARY, x.NAMESPACE, x.EDITION_NAME );
        if ( mod(x.r,100) = 0 )
        then
            commit;
        end if;
    end loop;
    commit;
end;
/

