create cluster hash_cluster
( hash_key number )
hashkeys 1000
size 8192
tablespace mssm
/
exec show_space( 'HASH_CLUSTER', user, 'CLUSTER' )

