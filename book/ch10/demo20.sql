drop table dept_and_emp;
drop type emp_tab_type;
drop type emp_type;

create or replace type emp_type
as object
(empno       number(4),
 ename       varchar2(10),
 job         varchar2(9),
 mgr         number(4),
 hiredate    date,
 sal         number(7, 2),
 comm        number(7, 2)
);
/
create or replace type emp_tab_type
as table of emp_type
/
create table dept_and_emp
(deptno number(2) primary key,
 dname     varchar2(14),
 loc       varchar2(13),
 emps      emp_tab_type
)
nested table emps store as emps_nt;
alter table emps_nt add constraint
emps_empno_unique unique(empno)
/

begin
   dbms_metadata.set_transform_param
   ( DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', false );
end;
/
select dbms_metadata.get_ddl( 'TABLE', 'DEPT_AND_EMP' ) from dual;

drop table dept_and_emp;

CREATE TABLE "OPS$TKYTE"."DEPT_AND_EMP"
("DEPTNO" NUMBER(2, 0),
 "DNAME"  VARCHAR2(14),
 "LOC"    VARCHAR2(13),
"EMPS" "EMP_TAB_TYPE")
PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 LOGGING
STORAGE(INITIAL 131072 NEXT 131072
        MINEXTENTS 1 MAXEXTENTS 4096
        PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
        BUFFER_POOL DEFAULT)
TABLESPACE "USERS"
NESTED TABLE "EMPS"
   STORE AS "EMPS_NT"
   ( (empno NOT NULL, unique (empno), primary key(nested_table_id,empno))
     organization index compress 1 )
   RETURN AS VALUE
/
