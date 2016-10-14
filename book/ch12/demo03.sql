select *
  from nls_database_parameters
 where parameter = 'NLS_CHARACTERSET';
create table t
( a varchar2(1),
  b varchar2(1 char),
  c varchar2(4000 char)
)
/
insert into t (a) values (unistr('\00d6'));
insert into t (b) values (unistr('\00d6'));
select length(b), lengthb(b), dump(b) dump from t;
declare
        l_data varchar2(4000 char);
        l_ch   varchar2(1 char) := unistr( '\00d6' );
begin
        l_data := rpad( l_ch, 4000, l_ch );
        insert into t ( c )  values ( l_data );
end;
/
declare
        l_data varchar2(4000 char);
        l_ch   varchar2(1 char) := unistr( '\00d6' );
begin
        l_data := rpad( l_ch, 2000, l_ch );
        insert into t ( c ) values ( l_data );
end;
/
select length( c ), lengthb( c )
  from t
 where c is not null;
