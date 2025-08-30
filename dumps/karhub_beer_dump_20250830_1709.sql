--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

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
-- Name: karhub_beer; Type: SCHEMA; Schema: -; Owner: karhub
--

CREATE SCHEMA karhub_beer;


ALTER SCHEMA karhub_beer OWNER TO karhub;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: karhub_beer; Owner: karhub
--

CREATE FUNCTION karhub_beer.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.updated_at = now();
   RETURN NEW;
END;
$$;


ALTER FUNCTION karhub_beer.update_updated_at_column() OWNER TO karhub;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: beer_styles; Type: TABLE; Schema: karhub_beer; Owner: karhub
--

CREATE TABLE karhub_beer.beer_styles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    min_temperature numeric(5,2) NOT NULL,
    max_temperature numeric(5,2) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE karhub_beer.beer_styles OWNER TO karhub;

--
-- Name: TABLE beer_styles; Type: COMMENT; Schema: karhub_beer; Owner: karhub
--

COMMENT ON TABLE karhub_beer.beer_styles IS 'Tabela que armazena os estilos de cerveja e suas temperaturas ideais de consumo.';


--
-- Name: COLUMN beer_styles.name; Type: COMMENT; Schema: karhub_beer; Owner: karhub
--

COMMENT ON COLUMN karhub_beer.beer_styles.name IS 'Nome único do estilo de cerveja (ex: IPA, Pilsens, Dunkel).';


--
-- Name: COLUMN beer_styles.min_temperature; Type: COMMENT; Schema: karhub_beer; Owner: karhub
--

COMMENT ON COLUMN karhub_beer.beer_styles.min_temperature IS 'Temperatura mínima ideal de consumo do estilo.';


--
-- Name: COLUMN beer_styles.max_temperature; Type: COMMENT; Schema: karhub_beer; Owner: karhub
--

COMMENT ON COLUMN karhub_beer.beer_styles.max_temperature IS 'Temperatura máxima ideal de consumo do estilo.';


--
-- Name: flyway_schema_history; Type: TABLE; Schema: karhub_beer; Owner: karhub
--

CREATE TABLE karhub_beer.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE karhub_beer.flyway_schema_history OWNER TO karhub;

--
-- Name: playlists; Type: TABLE; Schema: karhub_beer; Owner: karhub
--

CREATE TABLE karhub_beer.playlists (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    beer_style_id uuid NOT NULL,
    spotify_id character varying(100) NOT NULL,
    name character varying(200) NOT NULL,
    url text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE karhub_beer.playlists OWNER TO karhub;

--
-- Name: TABLE playlists; Type: COMMENT; Schema: karhub_beer; Owner: karhub
--

COMMENT ON TABLE karhub_beer.playlists IS 'Tabela que armazena playlists do Spotify relacionadas a estilos de cerveja.';


--
-- Name: COLUMN playlists.spotify_id; Type: COMMENT; Schema: karhub_beer; Owner: karhub
--

COMMENT ON COLUMN karhub_beer.playlists.spotify_id IS 'ID da playlist no Spotify.';


--
-- Name: COLUMN playlists.url; Type: COMMENT; Schema: karhub_beer; Owner: karhub
--

COMMENT ON COLUMN karhub_beer.playlists.url IS 'URL pública da playlist no Spotify.';


--
-- Name: recommendations; Type: TABLE; Schema: karhub_beer; Owner: karhub
--

CREATE TABLE karhub_beer.recommendations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    beer_style_id uuid NOT NULL,
    input_temperature numeric(5,2) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE karhub_beer.recommendations OWNER TO karhub;

--
-- Name: TABLE recommendations; Type: COMMENT; Schema: karhub_beer; Owner: karhub
--

COMMENT ON TABLE karhub_beer.recommendations IS 'Tabela que armazena as recomendações realizadas pelo sistema.';


--
-- Name: COLUMN recommendations.input_temperature; Type: COMMENT; Schema: karhub_beer; Owner: karhub
--

COMMENT ON COLUMN karhub_beer.recommendations.input_temperature IS 'Temperatura fornecida pelo usuário que originou a recomendação.';


--
-- Data for Name: beer_styles; Type: TABLE DATA; Schema: karhub_beer; Owner: karhub
--

COPY karhub_beer.beer_styles (id, name, min_temperature, max_temperature, created_at, updated_at) FROM stdin;
a6cfa97c-316d-4f5e-b84f-6b85f62f6e9a	Weissbier	-1.00	3.00	2025-08-26 01:49:25.629339+00	2025-08-26 01:49:25.629339+00
d60ffcd4-4d46-4c73-a7c1-b6ff0d6e77e2	Pilsens	-2.00	4.00	2025-08-26 01:49:25.629339+00	2025-08-26 01:49:25.629339+00
f98a3dfb-77ab-441d-8c6d-d6c8655e5ac7	Weizenbier	-4.00	6.00	2025-08-26 01:49:25.629339+00	2025-08-26 01:49:25.629339+00
0f1f5c52-5a76-4d54-9a3f-75b1cb18c332	Red ale	-5.00	5.00	2025-08-26 01:49:25.629339+00	2025-08-26 01:49:25.629339+00
7b3a5a6b-93a1-4f4a-82cb-3fdf6a22c4af	India pale ale	-6.00	7.00	2025-08-26 01:49:25.629339+00	2025-08-26 01:49:25.629339+00
f2a4f81a-21a4-4b8c-b5c0-56c8e45fda67	IPA	-7.00	10.00	2025-08-26 01:49:25.629339+00	2025-08-26 01:49:25.629339+00
9e2b7a2d-34e2-41d0-bf58-1f0bb69e4b3d	Dunkel	-8.00	2.00	2025-08-26 01:49:25.629339+00	2025-08-26 01:49:25.629339+00
dfcf4b29-5e26-4e91-9d4d-9c119cf0a7c8	Imperial Stouts	-10.00	13.00	2025-08-26 01:49:25.629339+00	2025-08-26 01:49:25.629339+00
2b7c6d52-d92d-4c85-9e64-0f5b1b5dbf9a	Brown ale	0.00	14.00	2025-08-26 01:49:25.629339+00	2025-08-26 01:49:25.629339+00
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: karhub_beer; Owner: karhub
--

COPY karhub_beer.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
0	\N	<< Flyway Schema Creation >>	SCHEMA	"karhub_beer"	\N	karhub	2025-08-26 18:13:20.236465	0	t
1	20250825232717	create beer tables	SQL	V20250825232717__create_beer_tables.sql	-1406611785	karhub	2025-08-26 18:13:20.264093	32	t
\.


--
-- Data for Name: playlists; Type: TABLE DATA; Schema: karhub_beer; Owner: karhub
--

COPY karhub_beer.playlists (id, beer_style_id, spotify_id, name, url, created_at) FROM stdin;
\.


--
-- Data for Name: recommendations; Type: TABLE DATA; Schema: karhub_beer; Owner: karhub
--

COPY karhub_beer.recommendations (id, beer_style_id, input_temperature, created_at) FROM stdin;
\.


--
-- Name: beer_styles beer_styles_name_key; Type: CONSTRAINT; Schema: karhub_beer; Owner: karhub
--

ALTER TABLE ONLY karhub_beer.beer_styles
    ADD CONSTRAINT beer_styles_name_key UNIQUE (name);


--
-- Name: beer_styles beer_styles_pkey; Type: CONSTRAINT; Schema: karhub_beer; Owner: karhub
--

ALTER TABLE ONLY karhub_beer.beer_styles
    ADD CONSTRAINT beer_styles_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: karhub_beer; Owner: karhub
--

ALTER TABLE ONLY karhub_beer.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: playlists playlists_beer_style_id_spotify_id_key; Type: CONSTRAINT; Schema: karhub_beer; Owner: karhub
--

ALTER TABLE ONLY karhub_beer.playlists
    ADD CONSTRAINT playlists_beer_style_id_spotify_id_key UNIQUE (beer_style_id, spotify_id);


--
-- Name: playlists playlists_pkey; Type: CONSTRAINT; Schema: karhub_beer; Owner: karhub
--

ALTER TABLE ONLY karhub_beer.playlists
    ADD CONSTRAINT playlists_pkey PRIMARY KEY (id);


--
-- Name: recommendations recommendations_pkey; Type: CONSTRAINT; Schema: karhub_beer; Owner: karhub
--

ALTER TABLE ONLY karhub_beer.recommendations
    ADD CONSTRAINT recommendations_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: karhub_beer; Owner: karhub
--

CREATE INDEX flyway_schema_history_s_idx ON karhub_beer.flyway_schema_history USING btree (success);


--
-- Name: idx_beer_styles_name; Type: INDEX; Schema: karhub_beer; Owner: karhub
--

CREATE INDEX idx_beer_styles_name ON karhub_beer.beer_styles USING btree (name);


--
-- Name: idx_playlists_beer_style; Type: INDEX; Schema: karhub_beer; Owner: karhub
--

CREATE INDEX idx_playlists_beer_style ON karhub_beer.playlists USING btree (beer_style_id);


--
-- Name: idx_recommendations_beer_style; Type: INDEX; Schema: karhub_beer; Owner: karhub
--

CREATE INDEX idx_recommendations_beer_style ON karhub_beer.recommendations USING btree (beer_style_id);


--
-- Name: beer_styles set_timestamp; Type: TRIGGER; Schema: karhub_beer; Owner: karhub
--

CREATE TRIGGER set_timestamp BEFORE UPDATE ON karhub_beer.beer_styles FOR EACH ROW EXECUTE FUNCTION karhub_beer.update_updated_at_column();


--
-- Name: playlists playlists_beer_style_id_fkey; Type: FK CONSTRAINT; Schema: karhub_beer; Owner: karhub
--

ALTER TABLE ONLY karhub_beer.playlists
    ADD CONSTRAINT playlists_beer_style_id_fkey FOREIGN KEY (beer_style_id) REFERENCES karhub_beer.beer_styles(id) ON DELETE CASCADE;


--
-- Name: recommendations recommendations_beer_style_id_fkey; Type: FK CONSTRAINT; Schema: karhub_beer; Owner: karhub
--

ALTER TABLE ONLY karhub_beer.recommendations
    ADD CONSTRAINT recommendations_beer_style_id_fkey FOREIGN KEY (beer_style_id) REFERENCES karhub_beer.beer_styles(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

