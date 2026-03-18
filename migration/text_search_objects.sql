-- Text search objects
DO $$
DECLARE r RECORD;
BEGIN
    -- Configurations
    FOR r IN SELECT cfgname FROM pg_ts_config c JOIN pg_namespace n ON c.cfgnamespace = n.oid WHERE n.nspname = 'public'
    LOOP
        EXECUTE format('ALTER TEXT SEARCH CONFIGURATION public.%I SET SCHEMA sso', r.cfgname);
    END LOOP;
    -- Dictionaries
    FOR r IN SELECT dictname FROM pg_ts_dict d JOIN pg_namespace n ON d.dictnamespace = n.oid WHERE n.nspname = 'public'
    LOOP
        EXECUTE format('ALTER TEXT SEARCH DICTIONARY public.%I SET SCHEMA sso', r.dictname);
    END LOOP;
    -- Parsers
    FOR r IN SELECT prsname FROM pg_ts_parser p JOIN pg_namespace n ON p.prsnamespace = n.oid WHERE n.nspname = 'public'
    LOOP
        EXECUTE format('ALTER TEXT SEARCH PARSER public.%I SET SCHEMA sso', r.prsname);
    END LOOP;
    -- Templates
    FOR r IN SELECT tmplname FROM pg_ts_template t JOIN pg_namespace n ON t.tmplnamespace = n.oid WHERE n.nspname = 'public'
    LOOP
        EXECUTE format('ALTER TEXT SEARCH TEMPLATE public.%I SET SCHEMA sso', r.tmplname);
    END LOOP;
END $$;
