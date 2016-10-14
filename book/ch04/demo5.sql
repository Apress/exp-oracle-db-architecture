connect /

create tablespace ts_16k
datafile '/tmp/ts_16k.dbf' 
size 5m
blocksize 16k;
show parameter 16k

alter system set sga_target = 256m scope=spfile;
alter system set db_16k_cache_size = 16m scope=spfile;
connect / as sysdba
startup force
show parameter 16k

