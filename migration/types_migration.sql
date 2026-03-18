--Custom types (enums, composites, domains)
DO $$
DECLARE r RECORD;
BEGIN
    -- Enums and composite types
    FOR r IN
        SELECT t.typname
        FROM pg_type t
        JOIN pg_namespace n ON t.typnamespace = n.oid
        WHERE n.nspname = 'public'
          AND t.typtype IN ('e', 'c')  -- enum, composite
          AND t.typname NOT LIKE '\_%'  -- skip internal array types
    LOOP
        EXECUTE format('ALTER TYPE public.%I SET SCHEMA sso', r.typname);
    END LOOP;
    -- Domains
    FOR r IN
        SELECT domain_name FROM information_schema.domains WHERE domain_schema = 'public'
    LOOP
        EXECUTE format('ALTER DOMAIN public.%I SET SCHEMA sso', r.domain_name);
    END LOOP;
END $$;
