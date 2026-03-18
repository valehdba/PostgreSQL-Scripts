-- migrate all tables with data from source_schema to target_schema schema
-- moves the table and its data, indexes, constraints, and triggers in place. No copying involved.
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'source_schema_name'
    LOOP
        EXECUTE format('ALTER TABLE public.%I SET SCHEMA target_schema_name', r.tablename);
    END LOOP;
END $$;
