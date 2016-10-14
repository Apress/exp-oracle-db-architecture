set echo on

drop tablespace encrypted including contents and datafiles;
drop tablespace clear including contents and datafiles;


create tablespace encrypted
datafile '/tmp/encrypted.dbf' size 1m
ENCRYPTION default storage ( ENCRYPT );

create tablespace clear
datafile '/tmp/clear.dbf' size 1m;

create table t
tablespace clear
as
select * 
  from all_users
/

create index t_idx
on t(lower(username))
tablespace clear;

alter system checkpoint;
!strings /tmp/clear.dbf | grep -i ops.tkyte

alter table t 
modify username encrypt;

alter table t move
tablespace encrypted;
alter index t_idx rebuild
tablespace encrypted;


alter system checkpoint;
!strings /tmp/encrypted.dbf | grep -i ops.tkyte
!strings /tmp/encrypted.dbf | head
!strings /tmp/clear.dbf | grep -i ops.tkyte

drop tablespace encrypted including contents and datafiles;
drop tablespace clear including contents and datafiles;
