-- Operator classes and families (if any custom ones exist)
DO $$
DECLARE r RECORD;
BEGIN
    FOR r IN
        SELECT opcname, amname
        FROM pg_opclass oc
        JOIN pg_namespace n ON oc.opcnamespace = n.oid
        JOIN pg_am am ON oc.opcmethod = am.oid
        WHERE n.nspname = 'public'
    LOOP
        EXECUTE format('ALTER OPERATOR CLASS public.%I USING %I SET SCHEMA sso', r.opcname, r.amname);
    END LOOP;
END $$;
