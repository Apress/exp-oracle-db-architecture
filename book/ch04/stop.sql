begin
    dbms_alert.signal( 'WAITING', '' );
    commit;
end;
/
