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

--
-- Name: gen_uuid_v7(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.gen_uuid_v7() RETURNS uuid
    LANGUAGE plpgsql
    AS $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$;


--
-- Name: is_uuid_v4(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_uuid_v4(val uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
begin
  return get_byte(uuid_send($1), 6) >> 4 = 4;
end
$_$;


--
-- Name: is_uuid_v7(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_uuid_v7(val uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
begin
  return get_byte(uuid_send($1), 6) >> 4 = 7;
end
$_$;


--
-- Name: max(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.max(uuid, uuid) RETURNS uuid
    LANGUAGE plpgsql IMMUTABLE PARALLEL SAFE
    AS $_$
BEGIN
    return GREATEST($1, $2);
END
$_$;


--
-- Name: min(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.min(uuid, uuid) RETURNS uuid
    LANGUAGE plpgsql IMMUTABLE PARALLEL SAFE
    AS $_$
BEGIN
    return LEAST($1, $2);
END
$_$;


--
-- Name: max(uuid); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE public.max(uuid) (
    SFUNC = public.max,
    STYPE = uuid,
    COMBINEFUNC = public.max,
    SORTOP = OPERATOR(pg_catalog.>),
    PARALLEL = safe
);


--
-- Name: min(uuid); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE public.min(uuid) (
    SFUNC = public.min,
    STYPE = uuid,
    COMBINEFUNC = public.min,
    SORTOP = OPERATOR(pg_catalog.<),
    PARALLEL = safe
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: user2s; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user2s (
    id uuid DEFAULT public.gen_uuid_v7() NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    CONSTRAINT id_is_uuid_v7 CHECK (public.is_uuid_v7(id))
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: user2s user2s_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user2s
    ADD CONSTRAINT user2s_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_users_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_created_at ON public.users USING btree (created_at);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20240111112320'),
('20240111112321'),
('20240111191427');


