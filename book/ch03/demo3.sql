with home
as
(select value home
   from v$diag_info
  where name = 'ADR Home'
)
select name, 
       case when value <> home.home 
	        then replace(value,home.home,'$home$') 
			else value
	    end value
  from v$diag_info, home
/

select value 
  from v$diag_info
 where name = 'Default Trace File'
/
