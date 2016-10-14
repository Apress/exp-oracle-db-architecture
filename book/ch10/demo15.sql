connect / as sysdba
break on cluster_name
select cluster_name, table_name
  from user_tables
 where cluster_name is not null
 order by 1;
connect /
