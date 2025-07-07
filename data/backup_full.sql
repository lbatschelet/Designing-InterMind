

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."question_type_enum" AS ENUM (
    'single_choice',
    'multiple_choice',
    'slider',
    'text',
    'info_screen'
);


ALTER TYPE "public"."question_type_enum" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."debug_auth"() RETURNS TABLE("user_id" "text", "is_anonymous" boolean, "jwt_claims" "jsonb")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY SELECT 
        auth.uid()::text,
        coalesce((auth.jwt() ->> 'is_anonymous')::boolean, false),
        auth.jwt();
END;
$$;


ALTER FUNCTION "public"."debug_auth"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_auth_user_id"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    NEW.auth_user_id := auth.uid();
    RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."set_auth_user_id"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_auth_user_id_for_surveys"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
BEGIN
    -- We're not actually setting IDs here since there's no way to know
    -- which anonymous user should own which survey without login info
    -- This is just a placeholder for the function 
    RAISE NOTICE 'Migrating surveys: this would set auth_user_id for existing surveys if we had login data';
END;
$$;


ALTER FUNCTION "public"."set_auth_user_id_for_surveys"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."languages" (
    "code" "text" NOT NULL,
    "name" "text" NOT NULL,
    "native_name" "text" NOT NULL,
    "is_active" boolean DEFAULT true
);


ALTER TABLE "public"."languages" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."questions" (
    "id" "text" NOT NULL,
    "type" "public"."question_type_enum" NOT NULL,
    "category" "text",
    "sequence_number" integer DEFAULT 9999,
    "image_source" "text",
    "options_structure" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."questions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."responses" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "survey_id" "uuid",
    "question_id" "text",
    "response" "jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "auth_user_id" "uuid"
);


ALTER TABLE "public"."responses" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."screen_content" (
    "id" "text" NOT NULL,
    "type" "text" NOT NULL,
    "image_key" "text",
    "is_active" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."screen_content" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."screen_content_translations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "content_id" "text" NOT NULL,
    "language" "text" NOT NULL,
    "title" "text" NOT NULL,
    "content" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."screen_content_translations" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."surveys" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "device_id" "text" NOT NULL,
    "created_at" timestamp without time zone DEFAULT "now"(),
    "completed" boolean DEFAULT false,
    "language" "text" DEFAULT 'en'::"text" NOT NULL,
    "location_lat" double precision,
    "location_lng" double precision,
    "auth_user_id" "uuid"
);


ALTER TABLE "public"."surveys" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."translations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "question_id" "text" NOT NULL,
    "language" "text" NOT NULL,
    "title" "text",
    "text" "text" NOT NULL,
    "options_content" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."translations" OWNER TO "postgres";


ALTER TABLE ONLY "public"."languages"
    ADD CONSTRAINT "languages_pkey" PRIMARY KEY ("code");



ALTER TABLE ONLY "public"."questions"
    ADD CONSTRAINT "questions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."responses"
    ADD CONSTRAINT "responses_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."screen_content"
    ADD CONSTRAINT "screen_content_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."screen_content_translations"
    ADD CONSTRAINT "screen_content_translations_content_id_language_key" UNIQUE ("content_id", "language");



ALTER TABLE ONLY "public"."screen_content_translations"
    ADD CONSTRAINT "screen_content_translations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."surveys"
    ADD CONSTRAINT "surveys_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."translations"
    ADD CONSTRAINT "translations_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."translations"
    ADD CONSTRAINT "translations_question_id_language_key" UNIQUE ("question_id", "language");



CREATE INDEX "idx_questions_category" ON "public"."questions" USING "btree" ("category");



CREATE INDEX "idx_questions_sequence" ON "public"."questions" USING "btree" ("sequence_number");



CREATE INDEX "idx_responses_question_id" ON "public"."responses" USING "btree" ("question_id");



CREATE INDEX "idx_responses_survey_id" ON "public"."responses" USING "btree" ("survey_id");



CREATE INDEX "idx_screen_content_translations_content_id" ON "public"."screen_content_translations" USING "btree" ("content_id");



CREATE INDEX "idx_screen_content_translations_language" ON "public"."screen_content_translations" USING "btree" ("language");



CREATE INDEX "idx_surveys_device_id" ON "public"."surveys" USING "btree" ("device_id");



CREATE INDEX "idx_surveys_language" ON "public"."surveys" USING "btree" ("language");



CREATE INDEX "idx_surveys_location" ON "public"."surveys" USING "btree" ("location_lat", "location_lng");



CREATE INDEX "idx_translations_language" ON "public"."translations" USING "btree" ("language");



CREATE OR REPLACE TRIGGER "set_auth_user_id_on_responses" BEFORE INSERT ON "public"."responses" FOR EACH ROW EXECUTE FUNCTION "public"."set_auth_user_id"();



CREATE OR REPLACE TRIGGER "set_auth_user_id_on_surveys" BEFORE INSERT ON "public"."surveys" FOR EACH ROW EXECUTE FUNCTION "public"."set_auth_user_id"();



ALTER TABLE ONLY "public"."responses"
    ADD CONSTRAINT "responses_auth_user_id_fkey" FOREIGN KEY ("auth_user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."responses"
    ADD CONSTRAINT "responses_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."questions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."responses"
    ADD CONSTRAINT "responses_survey_id_fkey" FOREIGN KEY ("survey_id") REFERENCES "public"."surveys"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."screen_content_translations"
    ADD CONSTRAINT "screen_content_translations_content_id_fkey" FOREIGN KEY ("content_id") REFERENCES "public"."screen_content"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."screen_content_translations"
    ADD CONSTRAINT "screen_content_translations_language_fkey" FOREIGN KEY ("language") REFERENCES "public"."languages"("code") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."surveys"
    ADD CONSTRAINT "surveys_auth_user_id_fkey" FOREIGN KEY ("auth_user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."surveys"
    ADD CONSTRAINT "surveys_language_fkey" FOREIGN KEY ("language") REFERENCES "public"."languages"("code");



ALTER TABLE ONLY "public"."translations"
    ADD CONSTRAINT "translations_language_fkey" FOREIGN KEY ("language") REFERENCES "public"."languages"("code") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."translations"
    ADD CONSTRAINT "translations_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "public"."questions"("id") ON DELETE CASCADE;



CREATE POLICY "Allow all to read languages" ON "public"."languages" FOR SELECT USING (true);



CREATE POLICY "Allow all to read questions" ON "public"."questions" FOR SELECT USING (true);



CREATE POLICY "Allow all to read translations" ON "public"."translations" FOR SELECT USING (true);



CREATE POLICY "Allow anyone to read screen content" ON "public"."screen_content" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Allow anyone to read screen content translations" ON "public"."screen_content_translations" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Allow inserting responses for own surveys" ON "public"."responses" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."surveys" "s"
  WHERE (("s"."id" = "responses"."survey_id") AND ("s"."auth_user_id" = "auth"."uid"())))));



CREATE POLICY "Allow users to delete own surveys" ON "public"."surveys" FOR DELETE TO "authenticated" USING (("auth_user_id" = "auth"."uid"()));



CREATE POLICY "Allow users to insert surveys" ON "public"."surveys" FOR INSERT TO "authenticated" WITH CHECK (true);



CREATE POLICY "Allow users to see own surveys" ON "public"."surveys" FOR SELECT TO "authenticated" USING (("auth_user_id" = "auth"."uid"()));



CREATE POLICY "Allow users to update own surveys" ON "public"."surveys" FOR UPDATE TO "authenticated" USING (("auth_user_id" = "auth"."uid"()));



CREATE POLICY "Allow viewing own responses" ON "public"."responses" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."surveys" "s"
  WHERE (("s"."id" = "responses"."survey_id") AND ("s"."auth_user_id" = "auth"."uid"())))));



ALTER TABLE "public"."languages" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."questions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."responses" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."screen_content" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."screen_content_translations" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."surveys" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."translations" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";











































































































































































GRANT ALL ON FUNCTION "public"."debug_auth"() TO "anon";
GRANT ALL ON FUNCTION "public"."debug_auth"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."debug_auth"() TO "service_role";



GRANT ALL ON FUNCTION "public"."set_auth_user_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_auth_user_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_auth_user_id"() TO "service_role";



GRANT ALL ON FUNCTION "public"."set_auth_user_id_for_surveys"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_auth_user_id_for_surveys"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_auth_user_id_for_surveys"() TO "service_role";


















GRANT ALL ON TABLE "public"."languages" TO "anon";
GRANT ALL ON TABLE "public"."languages" TO "authenticated";
GRANT ALL ON TABLE "public"."languages" TO "service_role";



GRANT ALL ON TABLE "public"."questions" TO "anon";
GRANT ALL ON TABLE "public"."questions" TO "authenticated";
GRANT ALL ON TABLE "public"."questions" TO "service_role";



GRANT ALL ON TABLE "public"."responses" TO "anon";
GRANT ALL ON TABLE "public"."responses" TO "authenticated";
GRANT ALL ON TABLE "public"."responses" TO "service_role";



GRANT ALL ON TABLE "public"."screen_content" TO "anon";
GRANT ALL ON TABLE "public"."screen_content" TO "authenticated";
GRANT ALL ON TABLE "public"."screen_content" TO "service_role";



GRANT ALL ON TABLE "public"."screen_content_translations" TO "anon";
GRANT ALL ON TABLE "public"."screen_content_translations" TO "authenticated";
GRANT ALL ON TABLE "public"."screen_content_translations" TO "service_role";



GRANT ALL ON TABLE "public"."surveys" TO "anon";
GRANT ALL ON TABLE "public"."surveys" TO "authenticated";
GRANT ALL ON TABLE "public"."surveys" TO "service_role";



GRANT ALL ON TABLE "public"."translations" TO "anon";
GRANT ALL ON TABLE "public"."translations" TO "authenticated";
GRANT ALL ON TABLE "public"."translations" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
