set echo on
set linesize 1000

rem select count(status) from big_table;
alter table big_table noparallel;
explain plan for
select count(status) from big_table;
select * from table(dbms_xplan.display);
alter table big_table parallel 4;
alter table big_table parallel;
explain plan for
select count(status) from big_table;
select * from table(dbms_xplan.display);
host  ps -aef | grep '^ora11gr2.*ora_p00._ora11gr2'
select count(status) from big_table;
host  ps -aef | grep '^ora11gr2.*ora_p00._ora11gr2'
select sid from v$mystat where rownum = 1;
select sid, qcsid, server#, degree
from v$px_session
where qcsid = 162
/
select sid, username, program
from v$session
where sid in ( select sid
                 from v$px_session
                where qcsid = 162 )
/

