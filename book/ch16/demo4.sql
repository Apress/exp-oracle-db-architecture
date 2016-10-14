connect /
set echo on
drop table t;

drop table stage;
create table stage as select object_name from all_objects;

create or replace package encryption_wrapper
as    
    function encrypt( p_string in varchar2,
                      p_key    in varchar2 ) 
    return raw;

    function decrypt( p_raw in raw,
                      p_key in varchar2 )
    return varchar2;
end;
/

create or replace package body encryption_wrapper
as
   g_encrypt_typ     constant PLS_INTEGER default
                     DBMS_CRYPTO.ENCRYPT_AES256 
                     + DBMS_CRYPTO.CHAIN_CBC 
                     + DBMS_CRYPTO.PAD_PKCS5;

function padkey( p_key in varchar2 ) return raw
is
begin
    return utl_raw.cast_to_raw(rpad(p_key,32));
end;

function encrypt( p_string in varchar2,
                  p_key    in varchar2 ) 
return raw
is
begin
   return DBMS_CRYPTO.ENCRYPT
          ( src => UTL_I18N.STRING_TO_RAW (p_string,  'AL32UTF8'),
            typ => g_encrypt_typ,
            key => padkey( p_key ) );
end;

function decrypt( p_raw in raw,
                  p_key in varchar2 )
return varchar2
is
begin
    return utl_i18n.raw_to_char( 
              dbms_crypto.decrypt
              ( src => p_raw,
                typ => g_encrypt_typ,
                key => padkey(p_key) ), 
              'AL32UTF8' );
end;

end;
/
set termout on


create table t
( last_name      varchar2(30),
  encrypted_name raw(32)
)
/

declare
    l_start number := dbms_utility.get_cpu_time;
begin
    for x in (select object_name from stage)
    loop
        insert into t (last_name) values ( x.object_name );
    end loop;
    dbms_output.put_line( (dbms_utility.get_cpu_time-l_start) || ' hsecs' );
end;
/
truncate table t;
declare
    l_start number := dbms_utility.get_cpu_time;
begin
    for x in (select object_name from stage)
    loop
        insert into t (encrypted_name) 
        values ( encryption_wrapper.encrypt
                 (x.object_name, 
                  'Secret Key Secret Key Secret Key'));
    end loop;
    dbms_output.put_line( (dbms_utility.get_cpu_time-l_start) || ' hsecs' );
end;
/
truncate table t;
declare
    l_start number := dbms_utility.get_cpu_time;
begin
    insert into t (last_name) select object_name from stage;
    dbms_output.put_line( (dbms_utility.get_cpu_time-l_start) || ' hsecs' );
end;
/
truncate table t;
declare
    l_start number := dbms_utility.get_cpu_time;
begin
        insert into t (encrypted_name) 
        select encryption_wrapper.encrypt
                 (object_name, 
                  'Secret Key Secret Key Secret Key')
          from stage;
    dbms_output.put_line( (dbms_utility.get_cpu_time-l_start) || ' hsecs' );
end;
/

truncate table t;

insert into t (last_name, encrypted_name) 
select object_name, 
       encryption_wrapper.encrypt
       (object_name, 
        'Secret Key Secret Key Secret Key')
  from stage;
commit;


declare
    l_start number := dbms_utility.get_cpu_time;
begin
	for x in (select last_name from t)
	loop
		null;
	end loop;
    dbms_output.put_line( (dbms_utility.get_cpu_time-l_start) || ' hsecs' );
end;
/
declare
    l_start number := dbms_utility.get_cpu_time;
begin
	for x in ( select encryption_wrapper.decrypt
                 (encrypted_name, 
                  'Secret Key Secret Key Secret Key')
                 from t )
	loop
		null;
	end loop;
    dbms_output.put_line( (dbms_utility.get_cpu_time-l_start) || ' hsecs' );
end;
/
