drop table sess_stats;
                                                                                
create table sess_stats
( name varchar2(64), value number, diff number );
                                                                                
variable sid number
exec :sid := &1

