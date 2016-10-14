drop tablespace temp_huge including contents and datafiles;

!df -h /tmp
create temporary tablespace temp_huge
tempfile '/tmp/temp_huge.dbf' size 2048m;
!df -h /tmp

!cp --sparse=never /tmp/temp_huge.dbf /tmp/temp_huge_not_sparse.dbf
!df -h /tmp
drop tablespace temp_huge including contents and datafiles;
create temporary tablespace temp_huge
tempfile '/tmp/temp_huge_not_sparse.dbf' reuse;
!df -h /tmp

drop tablespace temp_huge including contents and datafiles;
