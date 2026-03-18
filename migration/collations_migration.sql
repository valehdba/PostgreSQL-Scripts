-- Collations
DO $$
DECLARE r RECORD;
BEGIN
    FOR r IN
        SELECT collname FROM pg_collation c
        JOIN pg_namespace n ON c.collnamespace = n.oid
        WHERE n.nspname = 'public'
    LOOP
        EXECUTE format('ALTER COLLATION public.%I SET SCHEMA sso', r.collname);
    END LOOP;
END $$;
