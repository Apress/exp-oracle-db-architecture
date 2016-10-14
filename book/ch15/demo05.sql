create table et_bad
( text1 varchar2(4000) ,
  text2 varchar2(4000) ,
  text3 varchar2(4000)
)
organization external
(type oracle_loader
 default directory SYS_SQLLDR_XT_TMPDIR_00000
 access parameters
 (
   records delimited by newline
   fields
   missing field values are null
   ( text1 position(1:4000),
     text2 position(4001:8000),
     text3 position(8001:12000)
   )
 )
 location ('demo1.bad')
)
/

