declare
    l_msg   long;
    l_status number;
begin
    dbms_alert.register( 'WAITING' );
    for i in 1 .. 999999 loop
        dbms_application_info.set_client_info( i );
        dbms_alert.waitone( 'WAITING', l_msg, l_status, 0 );
        exit when l_status = 0;
        for x in ( select * from t order by 1, 2, 3, 4 )
        loop
            null;
        end loop;
    end loop;
end;
/
exit
