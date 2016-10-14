set echo on
drop table child;
drop table parent;

create table parent
( pk  int primary key )
/
create table child
( fk  constraint child_fk_parent
      references parent(pk)
      deferrable
      initially immediate
)
/
insert into parent values ( 1 );
insert into child values ( 1 );
update parent set pk = 2;
set constraint child_fk_parent deferred;
update parent set pk = 2;
set constraint child_fk_parent immediate;
update child set fk = 2;
set constraint child_fk_parent immediate;
commit;
