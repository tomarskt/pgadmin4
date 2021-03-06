SELECT quote_ident(c.table_schema)||'.'||quote_ident(c.table_name) AS table
FROM information_schema.tables c
where c.table_type = 'BASE TABLE'
      AND c.table_schema NOT LIKE 'pg\_%'
      AND c.table_schema NOT LIKE 'pgagent'
      AND c.table_schema NOT IN ('information_schema') ORDER BY 1;
