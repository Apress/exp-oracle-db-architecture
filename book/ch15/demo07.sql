create or replace package unloader
AUTHID CURRENT_USER
as
/* Function run -- unloads data from any query into a file
                   and creates a control file to reload that
                   data into another table

    p_query      = SQL query to "unload".  May be virtually any query.
    p_tname      = Table to load into.  Will be put into control file.
    p_mode       = REPLACE|APPEND|TRUNCATE -- how to reload the data
    p_dir        = directory we will write the ctl and dat file to.
    p_filename   = name of file to write to.  I will add .ctl and .dat
                   to this name
    p_separator  = field delimiter.  I default this to a comma.
    p_enclosure  = what each field will be wrapped in
    p_terminator = end of line character.  We use this so we can unload
              and reload data with newlines in it.  I default to
             "|\n" (a pipe and a newline together) and "|\r\n" on NT.
              You need only to override this if you believe your
              data will have that sequence in it. I ALWAYS add the
              OS "end of line" marker to this sequence, you should not
    */
    function run( p_query     in varchar2,
                  p_tname     in varchar2,
                  p_mode      in varchar2 default 'REPLACE',
                  p_dir       in varchar2,
                  p_filename  in varchar2,
                  p_separator in varchar2 default ',',
                  p_enclosure in varchar2 default '"',
                  p_terminator in varchar2 default '|' )
    return number;
end;
/
create or replace package body unloader
as


g_theCursor     integer default dbms_sql.open_cursor;
g_descTbl       dbms_sql.desc_tab;
g_nl            varchar2(2) default chr(10);


function to_hex( p_str in varchar2 ) return varchar2
is
begin
    return to_char( ascii(p_str), 'fm0x' );
end;

function is_windows return boolean
is
        l_cfiles varchar2(4000);
        l_dummy  number;
begin
 if (dbms_utility.get_parameter_value( 'control_files', l_dummy, l_cfiles )>0)
 then
       return instr( l_cfiles, '\' ) > 0;
 else
       return FALSE;
 end if;
end;

procedure  dump_ctl( p_dir        in varchar2,
                     p_filename   in varchar2,
                     p_tname      in varchar2,
                     p_mode       in varchar2,
                     p_separator  in varchar2,
                     p_enclosure  in varchar2,
                     p_terminator in varchar2 )
is
    l_output        utl_file.file_type;
    l_sep           varchar2(5);
    l_str           varchar2(5) := chr(10);
    
begin
    if ( is_windows )
    then
        l_str := chr(13) || chr(10);
    end if;

    l_output := utl_file.fopen( p_dir, p_filename || '.ctl', 'w' );

    utl_file.put_line( l_output, 'load data' );
    utl_file.put_line( l_output, 'infile ''' ||
                                  p_filename || '.dat'' "str x''' ||
                                  utl_raw.cast_to_raw( p_terminator ||
                                  l_str ) || '''"' );
    utl_file.put_line( l_output, 'into table ' || p_tname );
    utl_file.put_line( l_output, p_mode );
    utl_file.put_line( l_output, 'fields terminated by X''' ||
                                  to_hex(p_separator) ||
                                 ''' enclosed by X''' ||
                                  to_hex(p_enclosure) || ''' ' );
    utl_file.put_line( l_output, '(' );

    for i in 1 .. g_descTbl.count
    loop
        if ( g_descTbl(i).col_type = 12 )
        then
            utl_file.put( l_output, l_sep || g_descTbl(i).col_name ||
                               ' date ''ddmmyyyyhh24miss'' ');
        else
            utl_file.put( l_output, l_sep || g_descTbl(i).col_name ||
                          ' char(' ||
                          to_char(g_descTbl(i).col_max_len*2) ||' )' );
        end if;
        l_sep := ','||g_nl ;
    end loop;
    utl_file.put_line( l_output, g_nl || ')' );
    utl_file.fclose( l_output );
end;

function quote(p_str in varchar2, p_enclosure in varchar2)
         return varchar2
is
begin
    return p_enclosure ||
           replace( p_str, p_enclosure, p_enclosure||p_enclosure ) ||
           p_enclosure;
end;

function run( p_query        in varchar2,
              p_tname     in varchar2,
              p_mode      in varchar2 default 'REPLACE',
              p_dir       in varchar2,
              p_filename  in varchar2,
              p_separator in varchar2 default ',',
              p_enclosure in varchar2 default '"',
              p_terminator in varchar2 default '|' ) return number
is
    l_output        utl_file.file_type;
    l_columnValue   varchar2(4000);
    l_colCnt        number default 0;
    l_separator     varchar2(10) default '';
    l_cnt           number default 0;
    l_line          long;
    l_datefmt       varchar2(255);
    l_descTbl       dbms_sql.desc_tab;
begin
    select value
      into l_datefmt
      from nls_session_parameters
     where parameter = 'NLS_DATE_FORMAT';

    /*
       Set the date format to a big numeric string. Avoids
       all NLS issues and saves both the time and date.
    */
    execute immediate
       'alter session set nls_date_format=''ddmmyyyyhh24miss'' ';

    /*
       Set up an exception block so that in the event of any
       error, we can at least reset the date format.
    */
    begin
        /*
           Parse and describe the query. We reset the
           descTbl to an empty table so .count on it
           will be reliable.
        */
        dbms_sql.parse( g_theCursor, p_query, dbms_sql.native );
        g_descTbl := l_descTbl;
        dbms_sql.describe_columns( g_theCursor, l_colCnt, g_descTbl );

        /*
           Create a control file to reload this data
           into the desired table.
        */
        dump_ctl( p_dir, p_filename, p_tname, p_mode, p_separator,
                         p_enclosure, p_terminator );

        /*
           Bind every single column to a varchar2(4000). We don't care
           if we are fetching a number or a date or whatever.
           Everything can be a string.
        */
        for i in 1 .. l_colCnt loop
           dbms_sql.define_column( g_theCursor, i, l_columnValue, 4000);
        end loop;

        /*
           Run the query - ignore the output of execute. It is only
           valid when the DML is an insert/update or delete.
        */
        l_cnt := dbms_sql.execute(g_theCursor);

        /*
           Open the file to write output to and then write the
           delimited data to it.
        */
        l_output := utl_file.fopen( p_dir, p_filename || '.dat', 'w',
                                           32760 );
        loop
            exit when ( dbms_sql.fetch_rows(g_theCursor) <= 0 );
            l_separator := '';
            l_line := null;
            for i in 1 .. l_colCnt loop
                dbms_sql.column_value( g_theCursor, i,
                                       l_columnValue );
                l_line := l_line || l_separator ||
                           quote( l_columnValue, p_enclosure );
                l_separator := p_separator;
            end loop;
            l_line := l_line || p_terminator;
            utl_file.put_line( l_output, l_line );
            l_cnt := l_cnt+1;
        end loop;
        utl_file.fclose( l_output );

        /*
           Now reset the date format and return the number of rows
           written to the output file.
        */
        execute immediate
           'alter session set nls_date_format=''' || l_datefmt || '''';
        return l_cnt;
exception
        /*
           In the event of ANY error, reset the data format and
           re-raise the error.
        */
        when others then
           execute immediate
           'alter session set nls_date_format=''' || l_datefmt || '''';
           RAISE;
    end;
end run;


end unloader;
/
set serveroutput on
create or replace directory my_dir as '/tmp';
declare
    l_rows    number;
begin
    l_rows := unloader.run
              ( p_query      => 'select * from scott.emp order by empno',
                p_tname      => 'emp',
                p_mode       => 'replace',
                p_dir        => 'MY_DIR',
                p_filename   => 'emp',
                p_separator  => ',',
                p_enclosure  => '"',
                p_terminator => '~' );

    dbms_output.put_line( to_char(l_rows) ||
                          ' rows extracted to ascii file' );
end;
/

