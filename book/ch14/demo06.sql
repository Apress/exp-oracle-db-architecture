set echo on
set linesize 1000
droip table t2 purge;

create table t2
as
select object_id id, object_name text, 0 session_id
  from big_table
 where 1=0;
create table job_parms
( job        number primary key,
  lo_rid  rowid,
  hi_rid  rowid
)
/
create or replace
procedure serial( p_job in number )
is
    l_rec        job_parms%rowtype;
begin
    select * into l_rec
      from job_parms
     where job = p_job;

    for x in ( select object_id id, object_name text
                 from big_table
                where rowid between l_rec.lo_rid
                                and l_rec.hi_rid )
    loop
        -- complex process here
        insert into t2 (id, text, session_id )
        values ( x.id, x.text, p_job );
    end loop;

    delete from job_parms where job = p_job;
    commit;
end;
/
declare
        l_job number;
begin
for x in (
select dbms_rowid.rowid_create
       ( 1, data_object_id, lo_fno, lo_block, 0 ) min_rid,
       dbms_rowid.rowid_create
       ( 1, data_object_id, hi_fno, hi_block, 10000 ) max_rid
  from (
select distinct grp,
       first_value(relative_fno) 
         over (partition by grp order by relative_fno, block_id
         rows between unbounded preceding and unbounded following) lo_fno,
       first_value(block_id    ) 
         over (partition by grp order by relative_fno, block_id
         rows between unbounded preceding and unbounded following) lo_block,
       last_value(relative_fno) 
         over (partition by grp order by relative_fno, block_id
         rows between unbounded preceding and unbounded following) hi_fno,
       last_value(block_id+blocks-1) 
         over (partition by grp order by relative_fno, block_id
         rows between unbounded preceding and unbounded following) hi_block,
       sum(blocks) over (partition by grp) sum_blocks
  from (
select relative_fno,
       block_id,
       blocks,
       trunc( (sum(blocks) over (order by relative_fno, block_id)-0.01) /
              (sum(blocks) over ()/8) ) grp
  from dba_extents
 where segment_name = upper('BIG_TABLE')
   and owner = user order by block_id
       )
       ),
       (select data_object_id 
          from user_objects where object_name = upper('BIG_TABLE') )
)
loop
        dbms_job.submit( l_job, 'serial(JOB);' );
        insert into job_parms(job, lo_rid, hi_rid)
        values ( l_job, x.min_rid, x.max_rid );
end loop;
end;
/
select * from job_parms;
commit;
select session_id, count(*)
  from t2
 group by session_id;

