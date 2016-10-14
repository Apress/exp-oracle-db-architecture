drop table t;
create table t ( x int )
segment creation deferred;
select extent_id, bytes, blocks
  from user_extents
 where segment_name = 'T'
 order by extent_id;
insert into t(x) values (1);
rollback;
select extent_id, bytes, blocks
  from user_extents
 where segment_name = 'T'
 order by extent_id;
