create or replace function get_stat_val( p_name in varchar2 ) return number
as
 	l_val number;
begin
    select b.value
	  into l_val
      from v$statname a, v$mystat b
     where a.statistic# = b.statistic#
       and a.name = p_name;

	return l_val;
end;
/
