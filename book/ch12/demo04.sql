create table t ( raw_data raw(16) );
insert into t values ( sys_guid() );
select * from t;
select dump(raw_data,16) from t;
insert into t values ( 'abcdef' );
insert into t values ( 'abcdefgh' );
select rawtohex(raw_data) from t;
insert into t values ( hextoraw('abcdef') );
