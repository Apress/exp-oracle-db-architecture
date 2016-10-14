connect /
set serveroutput off
set echo on
column sid new_val SID
select sid from v$mystat where rownum = 1;
alter session set workarea_size_policy=manual;
alter session set sort_area_size = &1;
prompt run @reset_stat &SID and @watch_stat in another session here!
pause
set termout off
select * from t order by 1, 2, 3, 4;
set termout on
prompt run @watch_stat in another session here!
pause
