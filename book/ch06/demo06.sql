column columns format a30 word_wrapped
column tablename format a15 word_wrapped
column constraint_name format a15 word_wrapped

select table_name, constraint_name,
     cname1 || nvl2(cname2,','||cname2,null) ||
     nvl2(cname3,','||cname3,null) || nvl2(cname4,','||cname4,null) ||
     nvl2(cname5,','||cname5,null) || nvl2(cname6,','||cname6,null) ||
     nvl2(cname7,','||cname7,null) || nvl2(cname8,','||cname8,null)
            columns
  from ( select b.table_name,
                b.constraint_name,
                max(decode( position, 1, column_name, null )) cname1,
                max(decode( position, 2, column_name, null )) cname2,
                max(decode( position, 3, column_name, null )) cname3,
                max(decode( position, 4, column_name, null )) cname4,
                max(decode( position, 5, column_name, null )) cname5,
                max(decode( position, 6, column_name, null )) cname6,
                max(decode( position, 7, column_name, null )) cname7,
                max(decode( position, 8, column_name, null )) cname8,
                count(*) col_cnt
           from (select substr(table_name,1,30) table_name,
                        substr(constraint_name,1,30) constraint_name,
                        substr(column_name,1,30) column_name,
                        position
                   from user_cons_columns ) a,
                user_constraints b
          where a.constraint_name = b.constraint_name
            and b.constraint_type = 'R'
          group by b.table_name, b.constraint_name
       ) cons
 where col_cnt > ALL
         ( select count(*)
             from user_ind_columns i
            where i.table_name = cons.table_name
              and i.column_name in (cname1, cname2, cname3, cname4,
                                    cname5, cname6, cname7, cname8 )
              and i.column_position <= cons.col_cnt
            group by i.index_name
         )
/

