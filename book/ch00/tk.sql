column trace new_val TRACE

select c.value || '/' || d.instance_name || '_ora_' || a.spid || '.trc' trace
  from v$process a, v$session b, v$parameter c, v$instance d
 where a.addr = b.paddr
   and b.audsid = userenv('sessionid')
   and c.name = 'user_dump_dest'
/

disconnect
!tkprof &TRACE ./tk.prf &1
connect /
edit tk.prf

