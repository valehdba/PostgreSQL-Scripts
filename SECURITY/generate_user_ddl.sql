--Generate create user script with password
SELECT 'CREATE ROLE ' || rolname || ' WITH '
  || CASE WHEN rolsuper THEN 'SUPERUSER ' ELSE 'NOSUPERUSER ' END
  || CASE WHEN rolinherit THEN 'INHERIT ' ELSE 'NOINHERIT ' END
  || CASE WHEN rolcreaterole THEN 'CREATEROLE ' ELSE 'NOCREATEROLE ' END
  || CASE WHEN rolcreatedb THEN 'CREATEDB ' ELSE 'NOCREATEDB ' END
  || CASE WHEN rolcanlogin THEN 'LOGIN ' ELSE 'NOLOGIN ' END
  || CASE WHEN rolreplication THEN 'REPLICATION ' ELSE 'NOREPLICATION ' END
  || 'ENCRYPTED PASSWORD ' || quote_literal(rolpassword) || ' '
  || CASE WHEN rolvaliduntil IS NOT NULL THEN 'VALID UNTIL ' || quote_literal(rolvaliduntil::text) || ' ' ELSE '' END
  || ';'
FROM pg_authid
WHERE rolname = 'iemapps';

-- Table-level grants
SELECT 'GRANT ' || privilege_type || ' ON ' || table_schema || '.' || table_name || ' TO ' || grantee || ';'
FROM information_schema.table_privileges WHERE grantee = 'iemapps';
