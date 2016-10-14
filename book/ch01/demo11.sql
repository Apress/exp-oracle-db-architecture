connect /
set echo on

select /* TAG */ substr( username, 1, 1 ) 
  from all_users au1 
 where rownum = 1; 
 
alter session set cursor_sharing=force; 
 
select /* TAG */ substr( username, 1, 1 ) 
  from all_users au2 
 where rownum = 1; 
 
select sql_text from v$sql where sql_text like 'select /* TAG */ %'; 
 
