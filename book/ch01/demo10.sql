set echo on
connect /
create profile one_session limit sessions_per_user 1;
alter user scott profile one_session;
alter system set resource_limit=true;
connect scott/tiger
host sqlplus scott/tiger


connect /
alter user scott profile default;
drop profile one_session;
