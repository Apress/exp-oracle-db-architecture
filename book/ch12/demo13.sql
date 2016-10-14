create table t
( id int primary key,
  txt clob
)
/
select dbms_metadata.get_ddl( 'TABLE', 'T' )
  from dual;
select segment_name, segment_type
from user_segments;


drop table t;


create table t
( id int   primary key,
  in_row   clob,
  out_row  clob
)
lob (in_row)  store as ( enable  storage in row )
lob (out_row) store as ( disable storage in row )
/
insert into t
select rownum,
       owner || ' ' || object_name || ' ' || object_type || ' ' || status,
       owner || ' ' || object_name || ' ' || object_type || ' ' || status
  from all_objects
/
commit;
declare
        l_cnt    number;
        l_data   varchar2(32765);
begin
        select count(*)
          into l_cnt
          from t;

        dbms_monitor.session_trace_enable;
        for i in 1 .. l_cnt
        loop
                select in_row  into l_data from t where id = i;
                select out_row into l_data from t where id = i;
        end loop;
end;
/


create sequence s start with 100000;
declare
        l_cnt    number;
        l_data   varchar2(32765);
begin
        dbms_monitor.session_trace_enable;
        for i in 1 .. 100
        loop
                update t set in_row  = 
                to_char(sysdate,'dd-mon-yyyy hh24:mi:ss') where id = i;
                update t set out_row = 
                to_char(sysdate,'dd-mon-yyyy hh24:mi:ss') where id = i;
                insert into t (id, in_row) values ( s.nextval, 'Hello World' );
                insert into t (id,out_row) values ( s.nextval, 'Hello World' );
        end loop;
end;
/



drop table t;


create table t
( id int   primary key,
  txt      clob
)
lob( txt) store as ( disable storage in row )
/
 
insert into t values ( 1, 'hello world' );
 
commit;
declare
        l_clob  clob;

        cursor c is select id from t;
        l_id    number;
begin
        select txt into l_clob from t;
        open c;

        update t set id = 2, txt = 'Goodbye';
        commit;

        dbms_output.put_line( dbms_lob.substr( l_clob, 100, 1 ) );
        fetch c into l_id;
        dbms_output.put_line( 'id = ' || l_id );
        close c;
end;
/
select * from t;

