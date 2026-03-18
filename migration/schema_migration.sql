--migrata all tables with data to other schema
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'source_schema_name'
    LOOP
        EXECUTE format('ALTER TABLE public.%I SET SCHEMA target_schema_name', r.tablename);
    END LOOP;
END $$;
