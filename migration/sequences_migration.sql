--migrates all sequences from source schema to target schema
DO $$
  DECLARE
      r RECORD;
  BEGIN
      FOR r IN SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'source_schema_name'
      LOOP
          EXECUTE format('ALTER SEQUENCE public.%I SET SCHEMA target_schema_name', r.sequence_name);
      END LOOP;
  END $$;
