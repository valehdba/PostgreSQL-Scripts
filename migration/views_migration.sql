-- Views (including materialized views)
DO $$
DECLARE r RECORD;
BEGIN
    -- Regular views
    FOR r IN SELECT viewname FROM pg_views WHERE schemaname = 'public'
    LOOP
        EXECUTE format('ALTER VIEW public.%I SET SCHEMA sso', r.viewname);
    END LOOP;
    -- Materialized views
    FOR r IN SELECT matviewname FROM pg_matviews WHERE schemaname = 'public'
    LOOP
        EXECUTE format('ALTER MATERIALIZED VIEW public.%I SET SCHEMA sso', r.matviewname);
    END LOOP;
END $$;
