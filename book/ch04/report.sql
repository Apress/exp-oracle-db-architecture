column active format 999
column pga format 999.9
column "tot PGA" format 999.9
column pga_diff format 999.99
column "temp write" format 9,999
column "tot writes temp" format 99,999,999
column writes_diff format 9,999,999
select active, 
       pga, 
       "tot PGA",
       "tot PGA"-lag( "tot PGA" ) over (order by active) pga_diff,
       "temp write",
       "tot writes temp",
       "tot writes temp"-lag( "tot writes temp" ) over (order by active) writes_diff
  from (
select *
  from (
select active, 
       name,
       case when name like '%ga mem%' then round(value/1024/1024,1) else value end val
  from sess_stats
 where active < 275
       )
 pivot ( max(val) for name in  (
            'session pga memory' as "PGA",
            'total: session pga memory' as "tot PGA",
            'physical writes direct temporary tablespace' as "temp write",
            'total: physical writes direct temporary tablespace' as "tot writes temp"
            ) )
       )
 order by active
/

select active, 
       pga, 
       "tot PGA",
       "tot PGA"-lag( "tot PGA" ) over (order by active) pga_diff,
       "temp write",
       "tot writes temp",
       "tot writes temp"-lag( "tot writes temp" ) over (order by active) writes_diff
  from (
select *
  from (
select active, 
       max( decode(name,'session pga memory',val) ) pga,
       max( decode(name,'total: session pga memory',val) ) as "tot PGA",
       max( decode(name,'physical writes direct temporary tablespace',val) ) as "temp write",
       max( decode(name,'total: physical writes direct temporary tablespace',val) ) as "tot writes temp"
  from (
select active, 
       name,
       case when name like '%ga mem%' then round(value/1024/1024,1) else value end val
  from sess_stats
 where active < 225
       )
 group by active
       )
       )
 order by active
/
select * 
  from (
select active, 
       name,
       case when name like '%ga mem%' then round(value/1024/1024,1) else value end val
  from sess_stats
 where active < 225
       )
 pivot ( max(val) for name in  (
            'session pga memory' as "PGA",
            'total: session pga memory' as "tot PGA",
            'physical writes direct temporary tablespace' as "temp write",
            'total: physical writes direct temporary tablespace' as "tot writes temp"
            ) )
/
