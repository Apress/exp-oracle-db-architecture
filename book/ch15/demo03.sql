create or replace directory dir1   as '/tmp/';
create or replace directory "dir2" as '/tmp/';
create table demo
( id        int primary key,
  theClob   clob
)
/
host echo 'Hello World!' > /tmp/test.txt
declare
    l_clob    clob;
    l_bfile   bfile;
begin
    insert into demo values ( 1, empty_clob() )
     returning theclob into l_clob;

    l_bfile := bfilename( 'DIR1', 'test.txt' );
    dbms_lob.fileopen( l_bfile );

    dbms_lob.loadfromfile( l_clob, l_bfile,
                           dbms_lob.getlength( l_bfile ) );

    dbms_lob.fileclose( l_bfile );
end;
 /
select dbms_lob.getlength(theClob), theClob from demo
/
rollback;

declare
    l_clob    clob;
    l_bfile   bfile;
begin
    insert into demo values ( 1, empty_clob() )
     returning theclob into l_clob;

    l_bfile := bfilename( 'dir1', 'test.txt' );
    dbms_lob.fileopen( l_bfile );

    dbms_lob.loadfromfile( l_clob, l_bfile,
                           dbms_lob.getlength( l_bfile ) );

    dbms_lob.fileclose( l_bfile );
end;
/
declare
    l_clob    clob;
    l_bfile   bfile;
begin
    insert into demo values ( 1, empty_clob() )
     returning theclob into l_clob;

    l_bfile := bfilename( 'dir2', 'test.txt' );
    dbms_lob.fileopen( l_bfile );

    dbms_lob.loadfromfile( l_clob, l_bfile,
                           dbms_lob.getlength( l_bfile ) );

    dbms_lob.fileclose( l_bfile );
end;
/
