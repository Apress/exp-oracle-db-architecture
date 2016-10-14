select *
from nls_database_parameters
where parameter = 'NLS_CHARACTERSET';
host echo $NLS_LANG
create table t ( data varchar2(1) );
insert into t values ( chr(224) );
insert into t values ( chr(225) );
insert into t values ( chr(226) );
select data, dump(data) dump
from t;
commit;


prompt need another window for next bit
pause

select data, dump(data) dump
from t;
variable d varchar2(1)
variable r varchar2(20)
begin
select data, rowid into :d, :r from t where rownum = 1;
end;
/
update t set data = :d where rowid = chartorowid(:r);
commit;
prompt back to first window for next bit
pause
select data, dump(data) dump
from t;
