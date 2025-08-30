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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO karhub;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO karhub;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO karhub;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO karhub;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO karhub;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO karhub;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO karhub;

--
-- Name: client; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO karhub;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO karhub;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO karhub;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO karhub;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO karhub;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO karhub;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO karhub;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO karhub;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO karhub;

--
-- Name: component; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO karhub;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO karhub;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO karhub;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO karhub;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO karhub;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO karhub;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO karhub;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO karhub;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO karhub;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO karhub;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO karhub;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO karhub;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO karhub;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO karhub;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO karhub;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO karhub;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO karhub;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO karhub;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO karhub;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL,
    organization_id character varying(255),
    hide_on_login boolean DEFAULT false
);


ALTER TABLE public.identity_provider OWNER TO karhub;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO karhub;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO karhub;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO karhub;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36),
    type integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.keycloak_group OWNER TO karhub;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO karhub;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO karhub;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.offline_client_session OWNER TO karhub;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0
);


ALTER TABLE public.offline_user_session OWNER TO karhub;

--
-- Name: org; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000),
    alias character varying(255) NOT NULL,
    redirect_url character varying(2048)
);


ALTER TABLE public.org OWNER TO karhub;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO karhub;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO karhub;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO karhub;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO karhub;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO karhub;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO karhub;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO karhub;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO karhub;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO karhub;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO karhub;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO karhub;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO karhub;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO karhub;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO karhub;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO karhub;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO karhub;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO karhub;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO karhub;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO karhub;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO karhub;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO karhub;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO karhub;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO karhub;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO karhub;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO karhub;

--
-- Name: revoked_token; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.revoked_token (
    id character varying(255) NOT NULL,
    expire bigint NOT NULL
);


ALTER TABLE public.revoked_token OWNER TO karhub;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO karhub;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO karhub;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO karhub;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO karhub;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO karhub;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO karhub;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO karhub;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO karhub;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO karhub;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO karhub;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO karhub;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL,
    membership_type character varying(255) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO karhub;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO karhub;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO karhub;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO karhub;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: karhub
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO karhub;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
d0512c85-1659-4684-a2f5-db9ad3a93126	\N	auth-cookie	d40720ce-7492-4ad3-84a5-148310a9b1c1	7765d321-a7e7-4df3-b6fc-534e11d9a67c	2	10	f	\N	\N
e4a70ef2-ed13-4562-bd11-703fafa065c8	\N	auth-spnego	d40720ce-7492-4ad3-84a5-148310a9b1c1	7765d321-a7e7-4df3-b6fc-534e11d9a67c	3	20	f	\N	\N
81ba8c6b-6a61-48c3-82ac-03a2e55a249a	\N	identity-provider-redirector	d40720ce-7492-4ad3-84a5-148310a9b1c1	7765d321-a7e7-4df3-b6fc-534e11d9a67c	2	25	f	\N	\N
5812f614-b4b5-44da-ba55-ebe46a551a61	\N	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	7765d321-a7e7-4df3-b6fc-534e11d9a67c	2	30	t	9ba9e7d8-d833-4ebe-9c07-70fcf007b87f	\N
bb2c6256-a94f-45d9-aec0-71f124459c66	\N	auth-username-password-form	d40720ce-7492-4ad3-84a5-148310a9b1c1	9ba9e7d8-d833-4ebe-9c07-70fcf007b87f	0	10	f	\N	\N
78dc840f-6b6d-49a1-8f43-1cc79b49c84c	\N	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	9ba9e7d8-d833-4ebe-9c07-70fcf007b87f	1	20	t	df00e204-8df5-4807-b363-221f078e49bf	\N
4e3431b0-d9bb-476a-a9cc-ee314716ac5a	\N	conditional-user-configured	d40720ce-7492-4ad3-84a5-148310a9b1c1	df00e204-8df5-4807-b363-221f078e49bf	0	10	f	\N	\N
b14a1a65-7fbc-48a8-bdac-4fa5410ef91c	\N	auth-otp-form	d40720ce-7492-4ad3-84a5-148310a9b1c1	df00e204-8df5-4807-b363-221f078e49bf	0	20	f	\N	\N
b3116ce6-bf36-4f56-8faa-249196d48a3e	\N	direct-grant-validate-username	d40720ce-7492-4ad3-84a5-148310a9b1c1	a9d38246-086e-4008-a738-54ece994a633	0	10	f	\N	\N
35a34d71-1218-42a1-b181-40e881092e8c	\N	direct-grant-validate-password	d40720ce-7492-4ad3-84a5-148310a9b1c1	a9d38246-086e-4008-a738-54ece994a633	0	20	f	\N	\N
c71ceab8-5ab9-4f34-8d2d-119c27de1bd1	\N	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	a9d38246-086e-4008-a738-54ece994a633	1	30	t	a3dd8786-5760-45bd-9d06-bccb5ea7c167	\N
14fec7f5-2329-454e-ac84-7b156916fdcf	\N	conditional-user-configured	d40720ce-7492-4ad3-84a5-148310a9b1c1	a3dd8786-5760-45bd-9d06-bccb5ea7c167	0	10	f	\N	\N
c9b898aa-28e6-4904-8741-900bd7c9d846	\N	direct-grant-validate-otp	d40720ce-7492-4ad3-84a5-148310a9b1c1	a3dd8786-5760-45bd-9d06-bccb5ea7c167	0	20	f	\N	\N
9001d54b-334b-46c9-ad5e-604fd0b37cb3	\N	registration-page-form	d40720ce-7492-4ad3-84a5-148310a9b1c1	46c74d59-3dfc-4746-9221-23875f868ecc	0	10	t	50a18ce4-c611-4d23-b2fc-1ffc25a59af8	\N
057c28be-2370-41bf-93de-dac169c99897	\N	registration-user-creation	d40720ce-7492-4ad3-84a5-148310a9b1c1	50a18ce4-c611-4d23-b2fc-1ffc25a59af8	0	20	f	\N	\N
60a7c9e6-940a-4121-a0ce-dbcb41a7a6b3	\N	registration-password-action	d40720ce-7492-4ad3-84a5-148310a9b1c1	50a18ce4-c611-4d23-b2fc-1ffc25a59af8	0	50	f	\N	\N
4d0e82f5-09d4-4984-b662-a4fd7e1ebfdf	\N	registration-recaptcha-action	d40720ce-7492-4ad3-84a5-148310a9b1c1	50a18ce4-c611-4d23-b2fc-1ffc25a59af8	3	60	f	\N	\N
2d5592a1-360e-4501-ac26-2cf231c096a9	\N	registration-terms-and-conditions	d40720ce-7492-4ad3-84a5-148310a9b1c1	50a18ce4-c611-4d23-b2fc-1ffc25a59af8	3	70	f	\N	\N
1c6a3b5a-2bd7-443c-8f45-1a52d823334b	\N	reset-credentials-choose-user	d40720ce-7492-4ad3-84a5-148310a9b1c1	1ed0a45b-f03e-4649-b048-0adad6a3fdee	0	10	f	\N	\N
1fc21cdf-6115-4ea8-9d7e-163633bb5cda	\N	reset-credential-email	d40720ce-7492-4ad3-84a5-148310a9b1c1	1ed0a45b-f03e-4649-b048-0adad6a3fdee	0	20	f	\N	\N
042c0452-783d-4801-96c8-7619cada8704	\N	reset-password	d40720ce-7492-4ad3-84a5-148310a9b1c1	1ed0a45b-f03e-4649-b048-0adad6a3fdee	0	30	f	\N	\N
44730fbf-8a24-4bbc-b7f4-f29fe2f74d2c	\N	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	1ed0a45b-f03e-4649-b048-0adad6a3fdee	1	40	t	8d075991-52a4-469a-b1e8-d4b0cb5fd2d5	\N
4d79de53-fffc-410e-b297-09aaf496bbb9	\N	conditional-user-configured	d40720ce-7492-4ad3-84a5-148310a9b1c1	8d075991-52a4-469a-b1e8-d4b0cb5fd2d5	0	10	f	\N	\N
2d293529-30fc-4b71-a3a6-239841299340	\N	reset-otp	d40720ce-7492-4ad3-84a5-148310a9b1c1	8d075991-52a4-469a-b1e8-d4b0cb5fd2d5	0	20	f	\N	\N
ed578c2d-0e8a-468e-a674-a0b632bfd9a6	\N	client-secret	d40720ce-7492-4ad3-84a5-148310a9b1c1	fd9dfd50-fec1-4c0e-9cb6-98a154cbc11f	2	10	f	\N	\N
c655a46e-b00b-4252-9d6b-66ca33658b15	\N	client-jwt	d40720ce-7492-4ad3-84a5-148310a9b1c1	fd9dfd50-fec1-4c0e-9cb6-98a154cbc11f	2	20	f	\N	\N
527b62ba-7012-4b13-8815-b7855a92d04a	\N	client-secret-jwt	d40720ce-7492-4ad3-84a5-148310a9b1c1	fd9dfd50-fec1-4c0e-9cb6-98a154cbc11f	2	30	f	\N	\N
3f6c0a6d-5528-47d8-a9f9-0a41cc0c185d	\N	client-x509	d40720ce-7492-4ad3-84a5-148310a9b1c1	fd9dfd50-fec1-4c0e-9cb6-98a154cbc11f	2	40	f	\N	\N
98b0396b-7e17-459f-b02e-21b9c3ea5d10	\N	idp-review-profile	d40720ce-7492-4ad3-84a5-148310a9b1c1	b50d0470-8911-4391-9619-39cba0554c8f	0	10	f	\N	9e08c5fe-61fd-4e9b-9fe0-41fa931d4552
29c8d6ac-401a-4640-a331-5e2ffbe4d1df	\N	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	b50d0470-8911-4391-9619-39cba0554c8f	0	20	t	3c3120a2-ac83-404a-8117-c9e404356f38	\N
da4d3189-f7db-4eaf-ad0f-972a8b5e8176	\N	idp-create-user-if-unique	d40720ce-7492-4ad3-84a5-148310a9b1c1	3c3120a2-ac83-404a-8117-c9e404356f38	2	10	f	\N	716e198b-64d5-4995-be37-16aac1632176
a448999d-1667-4f4b-ba55-02657c9abb42	\N	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	3c3120a2-ac83-404a-8117-c9e404356f38	2	20	t	ffef44f4-c3c4-4046-b84a-954f0ca10acc	\N
1785da77-c878-447f-96f7-e11015fe3513	\N	idp-confirm-link	d40720ce-7492-4ad3-84a5-148310a9b1c1	ffef44f4-c3c4-4046-b84a-954f0ca10acc	0	10	f	\N	\N
55c81378-2aac-4eb7-8d5c-2a0e78b30cac	\N	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	ffef44f4-c3c4-4046-b84a-954f0ca10acc	0	20	t	1412d994-af9e-4e1e-84c2-d17f777f228a	\N
390c015d-5f9b-4e34-8f3f-05d134d8af26	\N	idp-email-verification	d40720ce-7492-4ad3-84a5-148310a9b1c1	1412d994-af9e-4e1e-84c2-d17f777f228a	2	10	f	\N	\N
bcc26752-1d80-422d-94eb-e8eaed08d630	\N	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	1412d994-af9e-4e1e-84c2-d17f777f228a	2	20	t	3691347b-80b8-4c2b-96c7-9ae724cfd157	\N
85ee679a-95c9-42b7-a67e-a562dee5ada2	\N	idp-username-password-form	d40720ce-7492-4ad3-84a5-148310a9b1c1	3691347b-80b8-4c2b-96c7-9ae724cfd157	0	10	f	\N	\N
a6173842-699b-4deb-a5d8-c4ed0af6f960	\N	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	3691347b-80b8-4c2b-96c7-9ae724cfd157	1	20	t	7e992d6d-0124-4966-968d-21e41ebaa3dc	\N
04062088-1121-4bc5-9365-6a54896358ab	\N	conditional-user-configured	d40720ce-7492-4ad3-84a5-148310a9b1c1	7e992d6d-0124-4966-968d-21e41ebaa3dc	0	10	f	\N	\N
0192f6c0-e81b-4f8f-a530-9238b72bf648	\N	auth-otp-form	d40720ce-7492-4ad3-84a5-148310a9b1c1	7e992d6d-0124-4966-968d-21e41ebaa3dc	0	20	f	\N	\N
cfcf2991-b605-4f8a-bebe-93b5098769d7	\N	http-basic-authenticator	d40720ce-7492-4ad3-84a5-148310a9b1c1	1c9903a9-863f-4752-85ca-03ab63a27e77	0	10	f	\N	\N
38e017f4-c062-451a-afb9-9da01c94ba28	\N	docker-http-basic-authenticator	d40720ce-7492-4ad3-84a5-148310a9b1c1	c3481716-3c5b-428f-80cf-f54663122958	0	10	f	\N	\N
f7a4d9e5-d130-4642-9391-3fe7daa4cf53	\N	auth-cookie	71093b75-f667-4192-826f-bd9b1f26e9be	418074e1-b217-4d7a-95e0-8886d42cf6f1	2	10	f	\N	\N
7160a9b2-406b-417a-8da3-e4007a3ffdb2	\N	auth-spnego	71093b75-f667-4192-826f-bd9b1f26e9be	418074e1-b217-4d7a-95e0-8886d42cf6f1	3	20	f	\N	\N
d5c25bb4-790c-4433-8b0c-08f4dbb35323	\N	identity-provider-redirector	71093b75-f667-4192-826f-bd9b1f26e9be	418074e1-b217-4d7a-95e0-8886d42cf6f1	2	25	f	\N	\N
fb1b4d4f-62ab-4e54-93c1-7184ceb0487d	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	418074e1-b217-4d7a-95e0-8886d42cf6f1	2	30	t	60449c75-318e-43ee-906c-093034bb780c	\N
d0df5ad1-a8bc-497b-a9f5-174a62a4ab2a	\N	auth-username-password-form	71093b75-f667-4192-826f-bd9b1f26e9be	60449c75-318e-43ee-906c-093034bb780c	0	10	f	\N	\N
2da72dbe-a39d-48df-bc7e-4222c6aea27f	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	60449c75-318e-43ee-906c-093034bb780c	1	20	t	bd47acd0-c9a2-4f70-89ce-f74c205c6577	\N
f6252ba3-fc1f-4db2-89a8-974c7c005d80	\N	conditional-user-configured	71093b75-f667-4192-826f-bd9b1f26e9be	bd47acd0-c9a2-4f70-89ce-f74c205c6577	0	10	f	\N	\N
ff20d91d-f439-4fbd-a8d7-8d3710016e17	\N	auth-otp-form	71093b75-f667-4192-826f-bd9b1f26e9be	bd47acd0-c9a2-4f70-89ce-f74c205c6577	0	20	f	\N	\N
36e02fa8-8f93-4e48-b13a-60dfa88a4172	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	418074e1-b217-4d7a-95e0-8886d42cf6f1	2	26	t	9e001448-db10-4597-bb20-5f1636c971f7	\N
d23b54df-e4f9-434a-9493-34468334931b	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	9e001448-db10-4597-bb20-5f1636c971f7	1	10	t	0f01c953-cff2-4e10-aa8e-96a1f2774312	\N
8b775bc4-adc9-4a29-8ef5-40ffd4a1007b	\N	conditional-user-configured	71093b75-f667-4192-826f-bd9b1f26e9be	0f01c953-cff2-4e10-aa8e-96a1f2774312	0	10	f	\N	\N
422d7589-3322-45b0-9f34-55ebaabf7920	\N	organization	71093b75-f667-4192-826f-bd9b1f26e9be	0f01c953-cff2-4e10-aa8e-96a1f2774312	2	20	f	\N	\N
4aaa3a2e-19b9-49d0-84f4-09f8b9348884	\N	direct-grant-validate-username	71093b75-f667-4192-826f-bd9b1f26e9be	78da04c4-dcee-430b-9544-a526c2d14caf	0	10	f	\N	\N
196aa022-c16b-42e1-8206-683092137949	\N	direct-grant-validate-password	71093b75-f667-4192-826f-bd9b1f26e9be	78da04c4-dcee-430b-9544-a526c2d14caf	0	20	f	\N	\N
74a2ebfa-ab57-4b9a-9758-c2ad505a608d	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	78da04c4-dcee-430b-9544-a526c2d14caf	1	30	t	b8e7acfa-ce06-48e9-befb-b1c6866f776e	\N
54accb2f-7412-4e3e-bf85-980b54f8f3d0	\N	conditional-user-configured	71093b75-f667-4192-826f-bd9b1f26e9be	b8e7acfa-ce06-48e9-befb-b1c6866f776e	0	10	f	\N	\N
4ec5bb41-db8f-475f-8bc2-8908abcf884f	\N	direct-grant-validate-otp	71093b75-f667-4192-826f-bd9b1f26e9be	b8e7acfa-ce06-48e9-befb-b1c6866f776e	0	20	f	\N	\N
2c8dfd6d-8afc-4120-818d-fc26ad5befa9	\N	registration-page-form	71093b75-f667-4192-826f-bd9b1f26e9be	110e023e-03c4-4808-8cea-73e1c32f8860	0	10	t	55dbecd0-e27d-4d21-91cd-607b95b533b0	\N
52a7a740-c18c-4f97-981c-476b840c9d9e	\N	registration-user-creation	71093b75-f667-4192-826f-bd9b1f26e9be	55dbecd0-e27d-4d21-91cd-607b95b533b0	0	20	f	\N	\N
031f908d-f8c9-4b32-bc29-4effa44212cf	\N	registration-password-action	71093b75-f667-4192-826f-bd9b1f26e9be	55dbecd0-e27d-4d21-91cd-607b95b533b0	0	50	f	\N	\N
f681fb59-f6a7-4651-a3de-a527e5da6d23	\N	registration-recaptcha-action	71093b75-f667-4192-826f-bd9b1f26e9be	55dbecd0-e27d-4d21-91cd-607b95b533b0	3	60	f	\N	\N
c70774f9-b96d-4e97-b8da-a7adb8f29ffa	\N	registration-terms-and-conditions	71093b75-f667-4192-826f-bd9b1f26e9be	55dbecd0-e27d-4d21-91cd-607b95b533b0	3	70	f	\N	\N
e1e7912a-b856-4add-b8fb-866af7398e2a	\N	reset-credentials-choose-user	71093b75-f667-4192-826f-bd9b1f26e9be	4b54ca88-0b03-4c72-a229-6de4d20393ac	0	10	f	\N	\N
15dcd738-5e0c-4879-a27d-4a1682a9e1a5	\N	reset-credential-email	71093b75-f667-4192-826f-bd9b1f26e9be	4b54ca88-0b03-4c72-a229-6de4d20393ac	0	20	f	\N	\N
e961f855-334c-4af5-858a-80f6ecfb0283	\N	reset-password	71093b75-f667-4192-826f-bd9b1f26e9be	4b54ca88-0b03-4c72-a229-6de4d20393ac	0	30	f	\N	\N
131e5522-775e-43c5-8c7a-3f29cb5e2c7c	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	4b54ca88-0b03-4c72-a229-6de4d20393ac	1	40	t	2b2a08f3-aaa5-4ca9-846c-63ddf027e800	\N
b258df9b-fe18-40c8-a871-2a10393e94f1	\N	conditional-user-configured	71093b75-f667-4192-826f-bd9b1f26e9be	2b2a08f3-aaa5-4ca9-846c-63ddf027e800	0	10	f	\N	\N
ba9d2c3e-de72-4eb6-8ac6-243394fad271	\N	reset-otp	71093b75-f667-4192-826f-bd9b1f26e9be	2b2a08f3-aaa5-4ca9-846c-63ddf027e800	0	20	f	\N	\N
39af21c5-c657-431b-9768-466f0821dd80	\N	client-secret	71093b75-f667-4192-826f-bd9b1f26e9be	9ae18d00-1003-451b-a6a5-5ed776ea6679	2	10	f	\N	\N
ea605781-a1a9-4239-830a-452e921f61a1	\N	client-jwt	71093b75-f667-4192-826f-bd9b1f26e9be	9ae18d00-1003-451b-a6a5-5ed776ea6679	2	20	f	\N	\N
7f5014f7-cd46-4852-b15c-8ce4462b4ed9	\N	client-secret-jwt	71093b75-f667-4192-826f-bd9b1f26e9be	9ae18d00-1003-451b-a6a5-5ed776ea6679	2	30	f	\N	\N
d93d8b51-dc22-4ef3-a5f9-9f95823f0d2b	\N	client-x509	71093b75-f667-4192-826f-bd9b1f26e9be	9ae18d00-1003-451b-a6a5-5ed776ea6679	2	40	f	\N	\N
7458f8ce-6054-4e00-bf46-a88f7e22f03f	\N	idp-review-profile	71093b75-f667-4192-826f-bd9b1f26e9be	9b058fc5-ccd5-49dc-8264-dd06790251bf	0	10	f	\N	8005b27d-bc56-410c-ad4c-2abf2aba9289
5ad758df-1f4b-4ef5-b2e3-c2409ee7405c	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	9b058fc5-ccd5-49dc-8264-dd06790251bf	0	20	t	88ecb221-fa53-4587-ab03-055a52b7a55e	\N
63816c11-390e-4128-8e7b-fdfcb30da062	\N	idp-create-user-if-unique	71093b75-f667-4192-826f-bd9b1f26e9be	88ecb221-fa53-4587-ab03-055a52b7a55e	2	10	f	\N	2c147617-7788-448b-af99-124e29217843
5a98e6ba-d701-4cbe-94cd-17bf048a8a32	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	88ecb221-fa53-4587-ab03-055a52b7a55e	2	20	t	5b19130e-25a3-455a-b23e-6d536e8fbe59	\N
9bf79306-a0b7-4ea9-96dc-3d1a1f139a19	\N	idp-confirm-link	71093b75-f667-4192-826f-bd9b1f26e9be	5b19130e-25a3-455a-b23e-6d536e8fbe59	0	10	f	\N	\N
5030ee8a-1053-4bbe-aa7b-7579ee8c3801	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	5b19130e-25a3-455a-b23e-6d536e8fbe59	0	20	t	8b1f1c13-fea4-4e9c-9dcc-cbd7af9dc19e	\N
7512de85-011f-4e18-b961-0ac5e7297e63	\N	idp-email-verification	71093b75-f667-4192-826f-bd9b1f26e9be	8b1f1c13-fea4-4e9c-9dcc-cbd7af9dc19e	2	10	f	\N	\N
f300b22f-0e08-4e15-b198-c89c7b2a6cb3	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	8b1f1c13-fea4-4e9c-9dcc-cbd7af9dc19e	2	20	t	ac44edb8-4ab7-478b-b851-05deee742fc8	\N
c50e1176-6e7a-4775-bd7f-dfdb4c935aa0	\N	idp-username-password-form	71093b75-f667-4192-826f-bd9b1f26e9be	ac44edb8-4ab7-478b-b851-05deee742fc8	0	10	f	\N	\N
13a0e4bd-b453-4d12-a578-7a4b6c55708c	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	ac44edb8-4ab7-478b-b851-05deee742fc8	1	20	t	6afd6ff0-7533-47a4-b2ce-9a1c10bc30e9	\N
af71a836-6306-4e4d-9b04-b6c5c42d2ebf	\N	conditional-user-configured	71093b75-f667-4192-826f-bd9b1f26e9be	6afd6ff0-7533-47a4-b2ce-9a1c10bc30e9	0	10	f	\N	\N
e6b8447a-36a3-4f43-8603-e970410ca9e5	\N	auth-otp-form	71093b75-f667-4192-826f-bd9b1f26e9be	6afd6ff0-7533-47a4-b2ce-9a1c10bc30e9	0	20	f	\N	\N
af8035d3-ce33-4b82-82ad-68fcd1cda754	\N	\N	71093b75-f667-4192-826f-bd9b1f26e9be	9b058fc5-ccd5-49dc-8264-dd06790251bf	1	50	t	219d74d5-f22f-41a8-9653-b98c622b9847	\N
f248a4a2-76ac-47a0-9ffb-199171ebb175	\N	conditional-user-configured	71093b75-f667-4192-826f-bd9b1f26e9be	219d74d5-f22f-41a8-9653-b98c622b9847	0	10	f	\N	\N
05bdd35f-4990-42a4-8037-fd007aad8eef	\N	idp-add-organization-member	71093b75-f667-4192-826f-bd9b1f26e9be	219d74d5-f22f-41a8-9653-b98c622b9847	0	20	f	\N	\N
1f910291-9a4a-4135-9fe6-999b18bc0709	\N	http-basic-authenticator	71093b75-f667-4192-826f-bd9b1f26e9be	b03d57d2-7413-4f1a-aeb7-179195a7869d	0	10	f	\N	\N
512166f1-bf00-467f-aebd-306853285801	\N	docker-http-basic-authenticator	71093b75-f667-4192-826f-bd9b1f26e9be	3d6fd9ad-a5be-4cdb-b0cc-be53a8047fd0	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
7765d321-a7e7-4df3-b6fc-534e11d9a67c	browser	Browser based authentication	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	t	t
9ba9e7d8-d833-4ebe-9c07-70fcf007b87f	forms	Username, password, otp and other auth forms.	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	f	t
df00e204-8df5-4807-b363-221f078e49bf	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	f	t
a9d38246-086e-4008-a738-54ece994a633	direct grant	OpenID Connect Resource Owner Grant	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	t	t
a3dd8786-5760-45bd-9d06-bccb5ea7c167	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	f	t
46c74d59-3dfc-4746-9221-23875f868ecc	registration	Registration flow	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	t	t
50a18ce4-c611-4d23-b2fc-1ffc25a59af8	registration form	Registration form	d40720ce-7492-4ad3-84a5-148310a9b1c1	form-flow	f	t
1ed0a45b-f03e-4649-b048-0adad6a3fdee	reset credentials	Reset credentials for a user if they forgot their password or something	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	t	t
8d075991-52a4-469a-b1e8-d4b0cb5fd2d5	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	f	t
fd9dfd50-fec1-4c0e-9cb6-98a154cbc11f	clients	Base authentication for clients	d40720ce-7492-4ad3-84a5-148310a9b1c1	client-flow	t	t
b50d0470-8911-4391-9619-39cba0554c8f	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	t	t
3c3120a2-ac83-404a-8117-c9e404356f38	User creation or linking	Flow for the existing/non-existing user alternatives	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	f	t
ffef44f4-c3c4-4046-b84a-954f0ca10acc	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	f	t
1412d994-af9e-4e1e-84c2-d17f777f228a	Account verification options	Method with which to verity the existing account	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	f	t
3691347b-80b8-4c2b-96c7-9ae724cfd157	Verify Existing Account by Re-authentication	Reauthentication of existing account	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	f	t
7e992d6d-0124-4966-968d-21e41ebaa3dc	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	f	t
1c9903a9-863f-4752-85ca-03ab63a27e77	saml ecp	SAML ECP Profile Authentication Flow	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	t	t
c3481716-3c5b-428f-80cf-f54663122958	docker auth	Used by Docker clients to authenticate against the IDP	d40720ce-7492-4ad3-84a5-148310a9b1c1	basic-flow	t	t
418074e1-b217-4d7a-95e0-8886d42cf6f1	browser	Browser based authentication	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	t	t
60449c75-318e-43ee-906c-093034bb780c	forms	Username, password, otp and other auth forms.	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
bd47acd0-c9a2-4f70-89ce-f74c205c6577	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
9e001448-db10-4597-bb20-5f1636c971f7	Organization	\N	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
0f01c953-cff2-4e10-aa8e-96a1f2774312	Browser - Conditional Organization	Flow to determine if the organization identity-first login is to be used	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
78da04c4-dcee-430b-9544-a526c2d14caf	direct grant	OpenID Connect Resource Owner Grant	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	t	t
b8e7acfa-ce06-48e9-befb-b1c6866f776e	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
110e023e-03c4-4808-8cea-73e1c32f8860	registration	Registration flow	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	t	t
55dbecd0-e27d-4d21-91cd-607b95b533b0	registration form	Registration form	71093b75-f667-4192-826f-bd9b1f26e9be	form-flow	f	t
4b54ca88-0b03-4c72-a229-6de4d20393ac	reset credentials	Reset credentials for a user if they forgot their password or something	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	t	t
2b2a08f3-aaa5-4ca9-846c-63ddf027e800	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
9ae18d00-1003-451b-a6a5-5ed776ea6679	clients	Base authentication for clients	71093b75-f667-4192-826f-bd9b1f26e9be	client-flow	t	t
9b058fc5-ccd5-49dc-8264-dd06790251bf	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	t	t
88ecb221-fa53-4587-ab03-055a52b7a55e	User creation or linking	Flow for the existing/non-existing user alternatives	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
5b19130e-25a3-455a-b23e-6d536e8fbe59	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
8b1f1c13-fea4-4e9c-9dcc-cbd7af9dc19e	Account verification options	Method with which to verity the existing account	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
ac44edb8-4ab7-478b-b851-05deee742fc8	Verify Existing Account by Re-authentication	Reauthentication of existing account	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
6afd6ff0-7533-47a4-b2ce-9a1c10bc30e9	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
219d74d5-f22f-41a8-9653-b98c622b9847	First Broker Login - Conditional Organization	Flow to determine if the authenticator that adds organization members is to be used	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	f	t
b03d57d2-7413-4f1a-aeb7-179195a7869d	saml ecp	SAML ECP Profile Authentication Flow	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	t	t
3d6fd9ad-a5be-4cdb-b0cc-be53a8047fd0	docker auth	Used by Docker clients to authenticate against the IDP	71093b75-f667-4192-826f-bd9b1f26e9be	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
9e08c5fe-61fd-4e9b-9fe0-41fa931d4552	review profile config	d40720ce-7492-4ad3-84a5-148310a9b1c1
716e198b-64d5-4995-be37-16aac1632176	create unique user config	d40720ce-7492-4ad3-84a5-148310a9b1c1
8005b27d-bc56-410c-ad4c-2abf2aba9289	review profile config	71093b75-f667-4192-826f-bd9b1f26e9be
2c147617-7788-448b-af99-124e29217843	create unique user config	71093b75-f667-4192-826f-bd9b1f26e9be
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
716e198b-64d5-4995-be37-16aac1632176	false	require.password.update.after.registration
9e08c5fe-61fd-4e9b-9fe0-41fa931d4552	missing	update.profile.on.first.login
2c147617-7788-448b-af99-124e29217843	false	require.password.update.after.registration
8005b27d-bc56-410c-ad4c-2abf2aba9289	missing	update.profile.on.first.login
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
49690866-2d77-4fac-9963-cb59b8fcd25f	t	f	master-realm	0	f	\N	\N	t	\N	f	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	d40720ce-7492-4ad3-84a5-148310a9b1c1	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	d40720ce-7492-4ad3-84a5-148310a9b1c1	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
2978863b-accd-411e-ae79-7ddf474e3a56	t	f	broker	0	f	\N	\N	t	\N	f	d40720ce-7492-4ad3-84a5-148310a9b1c1	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	t	t	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	d40720ce-7492-4ad3-84a5-148310a9b1c1	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
90e215ad-ae6c-46a8-af78-8719fc6ddd67	t	t	admin-cli	0	t	\N	\N	f	\N	f	d40720ce-7492-4ad3-84a5-148310a9b1c1	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
decc8268-c8bc-4e20-b15e-760d32d05e4f	t	f	karhub-beer-realm	0	f	\N	\N	t	\N	f	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N	0	f	f	karhub-beer Realm	f	client-secret	\N	\N	\N	t	f	f	f
4a6b1732-20df-4d7a-8174-25a88c05e430	t	f	realm-management	0	f	\N	\N	t	\N	f	71093b75-f667-4192-826f-bd9b1f26e9be	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	t	f	account	0	t	\N	/realms/karhub-beer/account/	f	\N	f	71093b75-f667-4192-826f-bd9b1f26e9be	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
df8dc7fb-12f6-4519-a7b2-884651fad866	t	f	account-console	0	t	\N	/realms/karhub-beer/account/	f	\N	f	71093b75-f667-4192-826f-bd9b1f26e9be	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
dcc4bb07-e78c-4b16-97f0-15717787e4d8	t	f	broker	0	f	\N	\N	t	\N	f	71093b75-f667-4192-826f-bd9b1f26e9be	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	t	t	security-admin-console	0	t	\N	/admin/karhub-beer/console/	f	\N	f	71093b75-f667-4192-826f-bd9b1f26e9be	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
d01db925-26f5-4291-9c5f-5078dcfc2dce	t	t	admin-cli	0	t	\N	\N	f	\N	f	71093b75-f667-4192-826f-bd9b1f26e9be	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
72c394f7-ad70-432e-a0f4-715ee92e6ad2	t	t	karhub-beer-api	0	t	\N		f		f	71093b75-f667-4192-826f-bd9b1f26e9be	openid-connect	-1	t	f		f	client-secret			\N	t	f	t	t
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	post.logout.redirect.uris	+
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	post.logout.redirect.uris	+
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	pkce.code.challenge.method	S256
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	post.logout.redirect.uris	+
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	pkce.code.challenge.method	S256
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	client.use.lightweight.access.token.enabled	true
90e215ad-ae6c-46a8-af78-8719fc6ddd67	client.use.lightweight.access.token.enabled	true
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	post.logout.redirect.uris	+
df8dc7fb-12f6-4519-a7b2-884651fad866	post.logout.redirect.uris	+
df8dc7fb-12f6-4519-a7b2-884651fad866	pkce.code.challenge.method	S256
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	post.logout.redirect.uris	+
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	pkce.code.challenge.method	S256
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	client.use.lightweight.access.token.enabled	true
d01db925-26f5-4291-9c5f-5078dcfc2dce	client.use.lightweight.access.token.enabled	true
72c394f7-ad70-432e-a0f4-715ee92e6ad2	oauth2.device.authorization.grant.enabled	false
72c394f7-ad70-432e-a0f4-715ee92e6ad2	oidc.ciba.grant.enabled	false
72c394f7-ad70-432e-a0f4-715ee92e6ad2	backchannel.logout.session.required	true
72c394f7-ad70-432e-a0f4-715ee92e6ad2	backchannel.logout.revoke.offline.tokens	false
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	offline_access	d40720ce-7492-4ad3-84a5-148310a9b1c1	OpenID Connect built-in scope: offline_access	openid-connect
b956e36d-c3a5-4d3d-bc73-7fe3fbd2aa94	role_list	d40720ce-7492-4ad3-84a5-148310a9b1c1	SAML role list	saml
cb0bd8c9-6358-4607-b85e-970309cf6569	saml_organization	d40720ce-7492-4ad3-84a5-148310a9b1c1	Organization Membership	saml
ca0de01c-4114-4dcf-a79d-54c719e436bb	profile	d40720ce-7492-4ad3-84a5-148310a9b1c1	OpenID Connect built-in scope: profile	openid-connect
a1aaa576-32b8-4a19-811d-7f95bc9785f2	email	d40720ce-7492-4ad3-84a5-148310a9b1c1	OpenID Connect built-in scope: email	openid-connect
3612307b-8507-42ba-b8d0-f2de49f0aaba	address	d40720ce-7492-4ad3-84a5-148310a9b1c1	OpenID Connect built-in scope: address	openid-connect
fda8b94a-9da8-4266-a569-f8fa99fcd881	phone	d40720ce-7492-4ad3-84a5-148310a9b1c1	OpenID Connect built-in scope: phone	openid-connect
fda9647d-e610-4642-b958-d2caacea8f99	roles	d40720ce-7492-4ad3-84a5-148310a9b1c1	OpenID Connect scope for add user roles to the access token	openid-connect
5f19e33d-5896-4eb1-9a23-5e1aea15b2cc	web-origins	d40720ce-7492-4ad3-84a5-148310a9b1c1	OpenID Connect scope for add allowed web origins to the access token	openid-connect
02724f9e-2e88-4f35-a095-196dfe89763a	microprofile-jwt	d40720ce-7492-4ad3-84a5-148310a9b1c1	Microprofile - JWT built-in scope	openid-connect
f127b484-edd6-4d0e-84ac-bfb476827f14	acr	d40720ce-7492-4ad3-84a5-148310a9b1c1	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
4b8ddae4-b4be-4067-96cd-024e0f99d621	basic	d40720ce-7492-4ad3-84a5-148310a9b1c1	OpenID Connect scope for add all basic claims to the token	openid-connect
7f62e7be-a9e2-4b14-826e-da679a297e4e	organization	d40720ce-7492-4ad3-84a5-148310a9b1c1	Additional claims about the organization a subject belongs to	openid-connect
e777f7a5-1014-427b-bcd5-55b94f30f368	offline_access	71093b75-f667-4192-826f-bd9b1f26e9be	OpenID Connect built-in scope: offline_access	openid-connect
7051ae3b-476b-4e26-a82f-876abf141579	role_list	71093b75-f667-4192-826f-bd9b1f26e9be	SAML role list	saml
5f438baa-1928-4e43-8bd9-e1dd6f361ad5	saml_organization	71093b75-f667-4192-826f-bd9b1f26e9be	Organization Membership	saml
55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	profile	71093b75-f667-4192-826f-bd9b1f26e9be	OpenID Connect built-in scope: profile	openid-connect
f3285eab-4a6a-4db0-bec7-8108df07e640	email	71093b75-f667-4192-826f-bd9b1f26e9be	OpenID Connect built-in scope: email	openid-connect
3781dcb5-17d2-4a11-89bc-15dfcf3ea938	address	71093b75-f667-4192-826f-bd9b1f26e9be	OpenID Connect built-in scope: address	openid-connect
a2cc037a-46b1-4731-9640-9d336586f984	phone	71093b75-f667-4192-826f-bd9b1f26e9be	OpenID Connect built-in scope: phone	openid-connect
a65db840-4e0c-4cba-bc96-f26e53c1c750	roles	71093b75-f667-4192-826f-bd9b1f26e9be	OpenID Connect scope for add user roles to the access token	openid-connect
fc988eed-3626-4ce5-93b3-c73e75bd07e4	web-origins	71093b75-f667-4192-826f-bd9b1f26e9be	OpenID Connect scope for add allowed web origins to the access token	openid-connect
e8b14079-c5b8-441d-8156-71b4d78d032a	microprofile-jwt	71093b75-f667-4192-826f-bd9b1f26e9be	Microprofile - JWT built-in scope	openid-connect
eae3a44f-b905-4154-bfd7-98fad0bb7c07	acr	71093b75-f667-4192-826f-bd9b1f26e9be	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
39f4c888-537c-493f-a486-8adc4ebb9299	basic	71093b75-f667-4192-826f-bd9b1f26e9be	OpenID Connect scope for add all basic claims to the token	openid-connect
d60c96ab-8381-4996-a39f-a3ba6718ece2	organization	71093b75-f667-4192-826f-bd9b1f26e9be	Additional claims about the organization a subject belongs to	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	true	display.on.consent.screen
bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	${offlineAccessScopeConsentText}	consent.screen.text
b956e36d-c3a5-4d3d-bc73-7fe3fbd2aa94	true	display.on.consent.screen
b956e36d-c3a5-4d3d-bc73-7fe3fbd2aa94	${samlRoleListScopeConsentText}	consent.screen.text
cb0bd8c9-6358-4607-b85e-970309cf6569	false	display.on.consent.screen
ca0de01c-4114-4dcf-a79d-54c719e436bb	true	display.on.consent.screen
ca0de01c-4114-4dcf-a79d-54c719e436bb	${profileScopeConsentText}	consent.screen.text
ca0de01c-4114-4dcf-a79d-54c719e436bb	true	include.in.token.scope
a1aaa576-32b8-4a19-811d-7f95bc9785f2	true	display.on.consent.screen
a1aaa576-32b8-4a19-811d-7f95bc9785f2	${emailScopeConsentText}	consent.screen.text
a1aaa576-32b8-4a19-811d-7f95bc9785f2	true	include.in.token.scope
3612307b-8507-42ba-b8d0-f2de49f0aaba	true	display.on.consent.screen
3612307b-8507-42ba-b8d0-f2de49f0aaba	${addressScopeConsentText}	consent.screen.text
3612307b-8507-42ba-b8d0-f2de49f0aaba	true	include.in.token.scope
fda8b94a-9da8-4266-a569-f8fa99fcd881	true	display.on.consent.screen
fda8b94a-9da8-4266-a569-f8fa99fcd881	${phoneScopeConsentText}	consent.screen.text
fda8b94a-9da8-4266-a569-f8fa99fcd881	true	include.in.token.scope
fda9647d-e610-4642-b958-d2caacea8f99	true	display.on.consent.screen
fda9647d-e610-4642-b958-d2caacea8f99	${rolesScopeConsentText}	consent.screen.text
fda9647d-e610-4642-b958-d2caacea8f99	false	include.in.token.scope
5f19e33d-5896-4eb1-9a23-5e1aea15b2cc	false	display.on.consent.screen
5f19e33d-5896-4eb1-9a23-5e1aea15b2cc		consent.screen.text
5f19e33d-5896-4eb1-9a23-5e1aea15b2cc	false	include.in.token.scope
02724f9e-2e88-4f35-a095-196dfe89763a	false	display.on.consent.screen
02724f9e-2e88-4f35-a095-196dfe89763a	true	include.in.token.scope
f127b484-edd6-4d0e-84ac-bfb476827f14	false	display.on.consent.screen
f127b484-edd6-4d0e-84ac-bfb476827f14	false	include.in.token.scope
4b8ddae4-b4be-4067-96cd-024e0f99d621	false	display.on.consent.screen
4b8ddae4-b4be-4067-96cd-024e0f99d621	false	include.in.token.scope
7f62e7be-a9e2-4b14-826e-da679a297e4e	true	display.on.consent.screen
7f62e7be-a9e2-4b14-826e-da679a297e4e	${organizationScopeConsentText}	consent.screen.text
7f62e7be-a9e2-4b14-826e-da679a297e4e	true	include.in.token.scope
e777f7a5-1014-427b-bcd5-55b94f30f368	true	display.on.consent.screen
e777f7a5-1014-427b-bcd5-55b94f30f368	${offlineAccessScopeConsentText}	consent.screen.text
7051ae3b-476b-4e26-a82f-876abf141579	true	display.on.consent.screen
7051ae3b-476b-4e26-a82f-876abf141579	${samlRoleListScopeConsentText}	consent.screen.text
5f438baa-1928-4e43-8bd9-e1dd6f361ad5	false	display.on.consent.screen
55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	true	display.on.consent.screen
55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	${profileScopeConsentText}	consent.screen.text
55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	true	include.in.token.scope
f3285eab-4a6a-4db0-bec7-8108df07e640	true	display.on.consent.screen
f3285eab-4a6a-4db0-bec7-8108df07e640	${emailScopeConsentText}	consent.screen.text
f3285eab-4a6a-4db0-bec7-8108df07e640	true	include.in.token.scope
3781dcb5-17d2-4a11-89bc-15dfcf3ea938	true	display.on.consent.screen
3781dcb5-17d2-4a11-89bc-15dfcf3ea938	${addressScopeConsentText}	consent.screen.text
3781dcb5-17d2-4a11-89bc-15dfcf3ea938	true	include.in.token.scope
a2cc037a-46b1-4731-9640-9d336586f984	true	display.on.consent.screen
a2cc037a-46b1-4731-9640-9d336586f984	${phoneScopeConsentText}	consent.screen.text
a2cc037a-46b1-4731-9640-9d336586f984	true	include.in.token.scope
a65db840-4e0c-4cba-bc96-f26e53c1c750	true	display.on.consent.screen
a65db840-4e0c-4cba-bc96-f26e53c1c750	${rolesScopeConsentText}	consent.screen.text
a65db840-4e0c-4cba-bc96-f26e53c1c750	false	include.in.token.scope
fc988eed-3626-4ce5-93b3-c73e75bd07e4	false	display.on.consent.screen
fc988eed-3626-4ce5-93b3-c73e75bd07e4		consent.screen.text
fc988eed-3626-4ce5-93b3-c73e75bd07e4	false	include.in.token.scope
e8b14079-c5b8-441d-8156-71b4d78d032a	false	display.on.consent.screen
e8b14079-c5b8-441d-8156-71b4d78d032a	true	include.in.token.scope
eae3a44f-b905-4154-bfd7-98fad0bb7c07	false	display.on.consent.screen
eae3a44f-b905-4154-bfd7-98fad0bb7c07	false	include.in.token.scope
39f4c888-537c-493f-a486-8adc4ebb9299	false	display.on.consent.screen
39f4c888-537c-493f-a486-8adc4ebb9299	false	include.in.token.scope
d60c96ab-8381-4996-a39f-a3ba6718ece2	true	display.on.consent.screen
d60c96ab-8381-4996-a39f-a3ba6718ece2	${organizationScopeConsentText}	consent.screen.text
d60c96ab-8381-4996-a39f-a3ba6718ece2	true	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	5f19e33d-5896-4eb1-9a23-5e1aea15b2cc	t
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	ca0de01c-4114-4dcf-a79d-54c719e436bb	t
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	f127b484-edd6-4d0e-84ac-bfb476827f14	t
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	fda9647d-e610-4642-b958-d2caacea8f99	t
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	4b8ddae4-b4be-4067-96cd-024e0f99d621	t
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	a1aaa576-32b8-4a19-811d-7f95bc9785f2	t
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	f
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	fda8b94a-9da8-4266-a569-f8fa99fcd881	f
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	02724f9e-2e88-4f35-a095-196dfe89763a	f
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	7f62e7be-a9e2-4b14-826e-da679a297e4e	f
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	3612307b-8507-42ba-b8d0-f2de49f0aaba	f
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	5f19e33d-5896-4eb1-9a23-5e1aea15b2cc	t
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	ca0de01c-4114-4dcf-a79d-54c719e436bb	t
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	f127b484-edd6-4d0e-84ac-bfb476827f14	t
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	fda9647d-e610-4642-b958-d2caacea8f99	t
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	4b8ddae4-b4be-4067-96cd-024e0f99d621	t
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	a1aaa576-32b8-4a19-811d-7f95bc9785f2	t
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	f
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	fda8b94a-9da8-4266-a569-f8fa99fcd881	f
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	02724f9e-2e88-4f35-a095-196dfe89763a	f
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	7f62e7be-a9e2-4b14-826e-da679a297e4e	f
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	3612307b-8507-42ba-b8d0-f2de49f0aaba	f
90e215ad-ae6c-46a8-af78-8719fc6ddd67	5f19e33d-5896-4eb1-9a23-5e1aea15b2cc	t
90e215ad-ae6c-46a8-af78-8719fc6ddd67	ca0de01c-4114-4dcf-a79d-54c719e436bb	t
90e215ad-ae6c-46a8-af78-8719fc6ddd67	f127b484-edd6-4d0e-84ac-bfb476827f14	t
90e215ad-ae6c-46a8-af78-8719fc6ddd67	fda9647d-e610-4642-b958-d2caacea8f99	t
90e215ad-ae6c-46a8-af78-8719fc6ddd67	4b8ddae4-b4be-4067-96cd-024e0f99d621	t
90e215ad-ae6c-46a8-af78-8719fc6ddd67	a1aaa576-32b8-4a19-811d-7f95bc9785f2	t
90e215ad-ae6c-46a8-af78-8719fc6ddd67	bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	f
90e215ad-ae6c-46a8-af78-8719fc6ddd67	fda8b94a-9da8-4266-a569-f8fa99fcd881	f
90e215ad-ae6c-46a8-af78-8719fc6ddd67	02724f9e-2e88-4f35-a095-196dfe89763a	f
90e215ad-ae6c-46a8-af78-8719fc6ddd67	7f62e7be-a9e2-4b14-826e-da679a297e4e	f
90e215ad-ae6c-46a8-af78-8719fc6ddd67	3612307b-8507-42ba-b8d0-f2de49f0aaba	f
2978863b-accd-411e-ae79-7ddf474e3a56	5f19e33d-5896-4eb1-9a23-5e1aea15b2cc	t
2978863b-accd-411e-ae79-7ddf474e3a56	ca0de01c-4114-4dcf-a79d-54c719e436bb	t
2978863b-accd-411e-ae79-7ddf474e3a56	f127b484-edd6-4d0e-84ac-bfb476827f14	t
2978863b-accd-411e-ae79-7ddf474e3a56	fda9647d-e610-4642-b958-d2caacea8f99	t
2978863b-accd-411e-ae79-7ddf474e3a56	4b8ddae4-b4be-4067-96cd-024e0f99d621	t
2978863b-accd-411e-ae79-7ddf474e3a56	a1aaa576-32b8-4a19-811d-7f95bc9785f2	t
2978863b-accd-411e-ae79-7ddf474e3a56	bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	f
2978863b-accd-411e-ae79-7ddf474e3a56	fda8b94a-9da8-4266-a569-f8fa99fcd881	f
2978863b-accd-411e-ae79-7ddf474e3a56	02724f9e-2e88-4f35-a095-196dfe89763a	f
2978863b-accd-411e-ae79-7ddf474e3a56	7f62e7be-a9e2-4b14-826e-da679a297e4e	f
2978863b-accd-411e-ae79-7ddf474e3a56	3612307b-8507-42ba-b8d0-f2de49f0aaba	f
49690866-2d77-4fac-9963-cb59b8fcd25f	5f19e33d-5896-4eb1-9a23-5e1aea15b2cc	t
49690866-2d77-4fac-9963-cb59b8fcd25f	ca0de01c-4114-4dcf-a79d-54c719e436bb	t
49690866-2d77-4fac-9963-cb59b8fcd25f	f127b484-edd6-4d0e-84ac-bfb476827f14	t
49690866-2d77-4fac-9963-cb59b8fcd25f	fda9647d-e610-4642-b958-d2caacea8f99	t
49690866-2d77-4fac-9963-cb59b8fcd25f	4b8ddae4-b4be-4067-96cd-024e0f99d621	t
49690866-2d77-4fac-9963-cb59b8fcd25f	a1aaa576-32b8-4a19-811d-7f95bc9785f2	t
49690866-2d77-4fac-9963-cb59b8fcd25f	bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	f
49690866-2d77-4fac-9963-cb59b8fcd25f	fda8b94a-9da8-4266-a569-f8fa99fcd881	f
49690866-2d77-4fac-9963-cb59b8fcd25f	02724f9e-2e88-4f35-a095-196dfe89763a	f
49690866-2d77-4fac-9963-cb59b8fcd25f	7f62e7be-a9e2-4b14-826e-da679a297e4e	f
49690866-2d77-4fac-9963-cb59b8fcd25f	3612307b-8507-42ba-b8d0-f2de49f0aaba	f
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	5f19e33d-5896-4eb1-9a23-5e1aea15b2cc	t
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	ca0de01c-4114-4dcf-a79d-54c719e436bb	t
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	f127b484-edd6-4d0e-84ac-bfb476827f14	t
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	fda9647d-e610-4642-b958-d2caacea8f99	t
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	4b8ddae4-b4be-4067-96cd-024e0f99d621	t
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	a1aaa576-32b8-4a19-811d-7f95bc9785f2	t
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	f
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	fda8b94a-9da8-4266-a569-f8fa99fcd881	f
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	02724f9e-2e88-4f35-a095-196dfe89763a	f
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	7f62e7be-a9e2-4b14-826e-da679a297e4e	f
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	3612307b-8507-42ba-b8d0-f2de49f0aaba	f
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	t
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	f3285eab-4a6a-4db0-bec7-8108df07e640	t
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	a65db840-4e0c-4cba-bc96-f26e53c1c750	t
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	fc988eed-3626-4ce5-93b3-c73e75bd07e4	t
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	39f4c888-537c-493f-a486-8adc4ebb9299	t
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	eae3a44f-b905-4154-bfd7-98fad0bb7c07	t
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	a2cc037a-46b1-4731-9640-9d336586f984	f
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	3781dcb5-17d2-4a11-89bc-15dfcf3ea938	f
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	e8b14079-c5b8-441d-8156-71b4d78d032a	f
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	e777f7a5-1014-427b-bcd5-55b94f30f368	f
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	d60c96ab-8381-4996-a39f-a3ba6718ece2	f
df8dc7fb-12f6-4519-a7b2-884651fad866	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	t
df8dc7fb-12f6-4519-a7b2-884651fad866	f3285eab-4a6a-4db0-bec7-8108df07e640	t
df8dc7fb-12f6-4519-a7b2-884651fad866	a65db840-4e0c-4cba-bc96-f26e53c1c750	t
df8dc7fb-12f6-4519-a7b2-884651fad866	fc988eed-3626-4ce5-93b3-c73e75bd07e4	t
df8dc7fb-12f6-4519-a7b2-884651fad866	39f4c888-537c-493f-a486-8adc4ebb9299	t
df8dc7fb-12f6-4519-a7b2-884651fad866	eae3a44f-b905-4154-bfd7-98fad0bb7c07	t
df8dc7fb-12f6-4519-a7b2-884651fad866	a2cc037a-46b1-4731-9640-9d336586f984	f
df8dc7fb-12f6-4519-a7b2-884651fad866	3781dcb5-17d2-4a11-89bc-15dfcf3ea938	f
df8dc7fb-12f6-4519-a7b2-884651fad866	e8b14079-c5b8-441d-8156-71b4d78d032a	f
df8dc7fb-12f6-4519-a7b2-884651fad866	e777f7a5-1014-427b-bcd5-55b94f30f368	f
df8dc7fb-12f6-4519-a7b2-884651fad866	d60c96ab-8381-4996-a39f-a3ba6718ece2	f
d01db925-26f5-4291-9c5f-5078dcfc2dce	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	t
d01db925-26f5-4291-9c5f-5078dcfc2dce	f3285eab-4a6a-4db0-bec7-8108df07e640	t
d01db925-26f5-4291-9c5f-5078dcfc2dce	a65db840-4e0c-4cba-bc96-f26e53c1c750	t
d01db925-26f5-4291-9c5f-5078dcfc2dce	fc988eed-3626-4ce5-93b3-c73e75bd07e4	t
d01db925-26f5-4291-9c5f-5078dcfc2dce	39f4c888-537c-493f-a486-8adc4ebb9299	t
d01db925-26f5-4291-9c5f-5078dcfc2dce	eae3a44f-b905-4154-bfd7-98fad0bb7c07	t
d01db925-26f5-4291-9c5f-5078dcfc2dce	a2cc037a-46b1-4731-9640-9d336586f984	f
d01db925-26f5-4291-9c5f-5078dcfc2dce	3781dcb5-17d2-4a11-89bc-15dfcf3ea938	f
d01db925-26f5-4291-9c5f-5078dcfc2dce	e8b14079-c5b8-441d-8156-71b4d78d032a	f
d01db925-26f5-4291-9c5f-5078dcfc2dce	e777f7a5-1014-427b-bcd5-55b94f30f368	f
d01db925-26f5-4291-9c5f-5078dcfc2dce	d60c96ab-8381-4996-a39f-a3ba6718ece2	f
dcc4bb07-e78c-4b16-97f0-15717787e4d8	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	t
dcc4bb07-e78c-4b16-97f0-15717787e4d8	f3285eab-4a6a-4db0-bec7-8108df07e640	t
dcc4bb07-e78c-4b16-97f0-15717787e4d8	a65db840-4e0c-4cba-bc96-f26e53c1c750	t
dcc4bb07-e78c-4b16-97f0-15717787e4d8	fc988eed-3626-4ce5-93b3-c73e75bd07e4	t
dcc4bb07-e78c-4b16-97f0-15717787e4d8	39f4c888-537c-493f-a486-8adc4ebb9299	t
dcc4bb07-e78c-4b16-97f0-15717787e4d8	eae3a44f-b905-4154-bfd7-98fad0bb7c07	t
dcc4bb07-e78c-4b16-97f0-15717787e4d8	a2cc037a-46b1-4731-9640-9d336586f984	f
dcc4bb07-e78c-4b16-97f0-15717787e4d8	3781dcb5-17d2-4a11-89bc-15dfcf3ea938	f
dcc4bb07-e78c-4b16-97f0-15717787e4d8	e8b14079-c5b8-441d-8156-71b4d78d032a	f
dcc4bb07-e78c-4b16-97f0-15717787e4d8	e777f7a5-1014-427b-bcd5-55b94f30f368	f
dcc4bb07-e78c-4b16-97f0-15717787e4d8	d60c96ab-8381-4996-a39f-a3ba6718ece2	f
4a6b1732-20df-4d7a-8174-25a88c05e430	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	t
4a6b1732-20df-4d7a-8174-25a88c05e430	f3285eab-4a6a-4db0-bec7-8108df07e640	t
4a6b1732-20df-4d7a-8174-25a88c05e430	a65db840-4e0c-4cba-bc96-f26e53c1c750	t
4a6b1732-20df-4d7a-8174-25a88c05e430	fc988eed-3626-4ce5-93b3-c73e75bd07e4	t
4a6b1732-20df-4d7a-8174-25a88c05e430	39f4c888-537c-493f-a486-8adc4ebb9299	t
4a6b1732-20df-4d7a-8174-25a88c05e430	eae3a44f-b905-4154-bfd7-98fad0bb7c07	t
4a6b1732-20df-4d7a-8174-25a88c05e430	a2cc037a-46b1-4731-9640-9d336586f984	f
4a6b1732-20df-4d7a-8174-25a88c05e430	3781dcb5-17d2-4a11-89bc-15dfcf3ea938	f
4a6b1732-20df-4d7a-8174-25a88c05e430	e8b14079-c5b8-441d-8156-71b4d78d032a	f
4a6b1732-20df-4d7a-8174-25a88c05e430	e777f7a5-1014-427b-bcd5-55b94f30f368	f
4a6b1732-20df-4d7a-8174-25a88c05e430	d60c96ab-8381-4996-a39f-a3ba6718ece2	f
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	t
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	f3285eab-4a6a-4db0-bec7-8108df07e640	t
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	a65db840-4e0c-4cba-bc96-f26e53c1c750	t
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	fc988eed-3626-4ce5-93b3-c73e75bd07e4	t
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	39f4c888-537c-493f-a486-8adc4ebb9299	t
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	eae3a44f-b905-4154-bfd7-98fad0bb7c07	t
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	a2cc037a-46b1-4731-9640-9d336586f984	f
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	3781dcb5-17d2-4a11-89bc-15dfcf3ea938	f
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	e8b14079-c5b8-441d-8156-71b4d78d032a	f
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	e777f7a5-1014-427b-bcd5-55b94f30f368	f
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	d60c96ab-8381-4996-a39f-a3ba6718ece2	f
72c394f7-ad70-432e-a0f4-715ee92e6ad2	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	t
72c394f7-ad70-432e-a0f4-715ee92e6ad2	f3285eab-4a6a-4db0-bec7-8108df07e640	t
72c394f7-ad70-432e-a0f4-715ee92e6ad2	a65db840-4e0c-4cba-bc96-f26e53c1c750	t
72c394f7-ad70-432e-a0f4-715ee92e6ad2	fc988eed-3626-4ce5-93b3-c73e75bd07e4	t
72c394f7-ad70-432e-a0f4-715ee92e6ad2	39f4c888-537c-493f-a486-8adc4ebb9299	t
72c394f7-ad70-432e-a0f4-715ee92e6ad2	eae3a44f-b905-4154-bfd7-98fad0bb7c07	t
72c394f7-ad70-432e-a0f4-715ee92e6ad2	a2cc037a-46b1-4731-9640-9d336586f984	f
72c394f7-ad70-432e-a0f4-715ee92e6ad2	3781dcb5-17d2-4a11-89bc-15dfcf3ea938	f
72c394f7-ad70-432e-a0f4-715ee92e6ad2	e8b14079-c5b8-441d-8156-71b4d78d032a	f
72c394f7-ad70-432e-a0f4-715ee92e6ad2	e777f7a5-1014-427b-bcd5-55b94f30f368	f
72c394f7-ad70-432e-a0f4-715ee92e6ad2	d60c96ab-8381-4996-a39f-a3ba6718ece2	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	eaa4fb16-c359-41be-93f1-37525ac18e91
e777f7a5-1014-427b-bcd5-55b94f30f368	a4291b41-533f-4fbc-b40c-9bd5c6436268
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
e37de791-da6a-4066-bb72-3ab1a5c1ad7f	Trusted Hosts	d40720ce-7492-4ad3-84a5-148310a9b1c1	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d40720ce-7492-4ad3-84a5-148310a9b1c1	anonymous
a14b90fd-ca3d-44ef-b477-388adb1f6908	Consent Required	d40720ce-7492-4ad3-84a5-148310a9b1c1	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d40720ce-7492-4ad3-84a5-148310a9b1c1	anonymous
6043c9b1-5bdd-4173-95f9-0389711314e3	Full Scope Disabled	d40720ce-7492-4ad3-84a5-148310a9b1c1	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d40720ce-7492-4ad3-84a5-148310a9b1c1	anonymous
23cfdfd3-973c-4433-a41f-7dcc4ab12a5f	Max Clients Limit	d40720ce-7492-4ad3-84a5-148310a9b1c1	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d40720ce-7492-4ad3-84a5-148310a9b1c1	anonymous
edd11c64-4b58-4519-87de-9250fafbae60	Allowed Protocol Mapper Types	d40720ce-7492-4ad3-84a5-148310a9b1c1	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d40720ce-7492-4ad3-84a5-148310a9b1c1	anonymous
4420f6df-4aeb-4f2e-a4b8-9c4d8c4db1cb	Allowed Client Scopes	d40720ce-7492-4ad3-84a5-148310a9b1c1	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d40720ce-7492-4ad3-84a5-148310a9b1c1	anonymous
e7fd3c08-e95d-4ea7-a2da-b5ca5d5aabfe	Allowed Protocol Mapper Types	d40720ce-7492-4ad3-84a5-148310a9b1c1	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d40720ce-7492-4ad3-84a5-148310a9b1c1	authenticated
e455608c-2c66-4f7a-a7eb-a7660cd1046c	Allowed Client Scopes	d40720ce-7492-4ad3-84a5-148310a9b1c1	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	d40720ce-7492-4ad3-84a5-148310a9b1c1	authenticated
d6f944e6-b0e3-49b1-aef3-05ed75c75094	rsa-generated	d40720ce-7492-4ad3-84a5-148310a9b1c1	rsa-generated	org.keycloak.keys.KeyProvider	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N
e8117b16-2293-4758-ac33-850803bd6c33	rsa-enc-generated	d40720ce-7492-4ad3-84a5-148310a9b1c1	rsa-enc-generated	org.keycloak.keys.KeyProvider	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N
23e3df7e-2c18-4ce9-b399-0898ec9bd678	hmac-generated-hs512	d40720ce-7492-4ad3-84a5-148310a9b1c1	hmac-generated	org.keycloak.keys.KeyProvider	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N
1e2d2cc7-65a7-4a3c-852b-43639c30862b	aes-generated	d40720ce-7492-4ad3-84a5-148310a9b1c1	aes-generated	org.keycloak.keys.KeyProvider	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N
1c1b6827-1019-4121-971d-9a94c752da6a	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N
52608fd7-3656-49fe-98ff-689c0fdf1f94	rsa-generated	71093b75-f667-4192-826f-bd9b1f26e9be	rsa-generated	org.keycloak.keys.KeyProvider	71093b75-f667-4192-826f-bd9b1f26e9be	\N
71b24254-fa6a-48b1-aef8-bb763264fb07	rsa-enc-generated	71093b75-f667-4192-826f-bd9b1f26e9be	rsa-enc-generated	org.keycloak.keys.KeyProvider	71093b75-f667-4192-826f-bd9b1f26e9be	\N
e84acedf-42ac-4c35-9dbe-345451b947db	hmac-generated-hs512	71093b75-f667-4192-826f-bd9b1f26e9be	hmac-generated	org.keycloak.keys.KeyProvider	71093b75-f667-4192-826f-bd9b1f26e9be	\N
2bd5b289-341f-4d58-a51c-5ee5825a06a5	aes-generated	71093b75-f667-4192-826f-bd9b1f26e9be	aes-generated	org.keycloak.keys.KeyProvider	71093b75-f667-4192-826f-bd9b1f26e9be	\N
04dc49b5-fe1f-48b9-b503-844a8fcb19c0	Trusted Hosts	71093b75-f667-4192-826f-bd9b1f26e9be	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	71093b75-f667-4192-826f-bd9b1f26e9be	anonymous
eef783ae-b2f1-44b3-b390-3903cb992f71	Consent Required	71093b75-f667-4192-826f-bd9b1f26e9be	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	71093b75-f667-4192-826f-bd9b1f26e9be	anonymous
d11720b7-f89b-4eaf-b50e-88fff81a82cc	Full Scope Disabled	71093b75-f667-4192-826f-bd9b1f26e9be	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	71093b75-f667-4192-826f-bd9b1f26e9be	anonymous
0fde0cf2-e75e-4db1-b3d0-0d05f569a6e5	Max Clients Limit	71093b75-f667-4192-826f-bd9b1f26e9be	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	71093b75-f667-4192-826f-bd9b1f26e9be	anonymous
ce9478d2-1e85-4c41-9997-4dbfa9a59d0b	Allowed Protocol Mapper Types	71093b75-f667-4192-826f-bd9b1f26e9be	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	71093b75-f667-4192-826f-bd9b1f26e9be	anonymous
224f2678-a767-4059-82e9-31e423bf7502	Allowed Client Scopes	71093b75-f667-4192-826f-bd9b1f26e9be	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	71093b75-f667-4192-826f-bd9b1f26e9be	anonymous
0a3b89e2-21ac-4736-bfd5-38008433d9e3	Allowed Protocol Mapper Types	71093b75-f667-4192-826f-bd9b1f26e9be	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	71093b75-f667-4192-826f-bd9b1f26e9be	authenticated
f2308738-efec-4a5d-948f-e947afa53b54	Allowed Client Scopes	71093b75-f667-4192-826f-bd9b1f26e9be	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	71093b75-f667-4192-826f-bd9b1f26e9be	authenticated
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
34180ce4-e568-4a9e-a9f4-c47036d47243	23cfdfd3-973c-4433-a41f-7dcc4ab12a5f	max-clients	200
0ee73181-56e7-4036-9a6d-1300e2750bbb	4420f6df-4aeb-4f2e-a4b8-9c4d8c4db1cb	allow-default-scopes	true
8216f1ea-a14f-4e61-aa13-b6fc1c4704e4	e37de791-da6a-4066-bb72-3ab1a5c1ad7f	host-sending-registration-request-must-match	true
e3487f5a-fb08-48df-acde-ecd217250271	e37de791-da6a-4066-bb72-3ab1a5c1ad7f	client-uris-must-match	true
a5ccfeba-437d-4c77-8e77-7032872dc9ee	e455608c-2c66-4f7a-a7eb-a7660cd1046c	allow-default-scopes	true
eeefca30-2503-4964-bdef-3d9875af924d	edd11c64-4b58-4519-87de-9250fafbae60	allowed-protocol-mapper-types	saml-user-property-mapper
f541d8cb-5f27-4652-9722-96bf44c06a5a	edd11c64-4b58-4519-87de-9250fafbae60	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
8ea9eedb-5bac-4127-be9d-f095f91ec3b2	edd11c64-4b58-4519-87de-9250fafbae60	allowed-protocol-mapper-types	saml-role-list-mapper
ecae6f12-87a5-4be4-9277-87f9279f9b1d	edd11c64-4b58-4519-87de-9250fafbae60	allowed-protocol-mapper-types	oidc-address-mapper
a9cfdb58-7851-4a97-aa35-72e9296b4859	edd11c64-4b58-4519-87de-9250fafbae60	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
56dc5b17-dc37-4541-a4cf-6c512f0e92d5	edd11c64-4b58-4519-87de-9250fafbae60	allowed-protocol-mapper-types	oidc-full-name-mapper
47e801b8-f135-41ca-aa6f-ce97521b8605	edd11c64-4b58-4519-87de-9250fafbae60	allowed-protocol-mapper-types	saml-user-attribute-mapper
f3bb8b32-074b-4626-bf24-de401805443c	edd11c64-4b58-4519-87de-9250fafbae60	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
d3d2eba4-10a1-408a-b864-8fa558d9a6b8	e7fd3c08-e95d-4ea7-a2da-b5ca5d5aabfe	allowed-protocol-mapper-types	oidc-full-name-mapper
4c6628c6-70ee-4800-946b-47c1a06cab14	e7fd3c08-e95d-4ea7-a2da-b5ca5d5aabfe	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
a3cd5dda-8fef-463c-9053-e47edc381f56	e7fd3c08-e95d-4ea7-a2da-b5ca5d5aabfe	allowed-protocol-mapper-types	oidc-address-mapper
a0fb4428-280f-4635-83f3-3f42a1e6289d	e7fd3c08-e95d-4ea7-a2da-b5ca5d5aabfe	allowed-protocol-mapper-types	saml-user-property-mapper
7e26ee55-ea9e-496a-a6d9-71aad583574b	e7fd3c08-e95d-4ea7-a2da-b5ca5d5aabfe	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
ba97dcd3-30f8-452c-89c9-90315c7d6a5b	e7fd3c08-e95d-4ea7-a2da-b5ca5d5aabfe	allowed-protocol-mapper-types	saml-role-list-mapper
5e3b87fd-d18a-43ae-bb31-04caeb30049c	e7fd3c08-e95d-4ea7-a2da-b5ca5d5aabfe	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
bd9cd680-5c3e-4ca5-9e27-dc1db35727cd	e7fd3c08-e95d-4ea7-a2da-b5ca5d5aabfe	allowed-protocol-mapper-types	saml-user-attribute-mapper
f977e9cb-362e-4d0f-876a-318beeacd39e	1c1b6827-1019-4121-971d-9a94c752da6a	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
31d7acab-3991-4679-bcd9-1bac02da2748	e8117b16-2293-4758-ac33-850803bd6c33	privateKey	MIIEpAIBAAKCAQEAvfN71WzmyFmvFfkG552sFKAIkECy/2xNLcRYwXpZeI5D6fj8RWMfS9xSvSjx5G6916+XxG50vofdcCUygnA3PhDpCMz/jargeHyeqZhpTUOI0ug4H40ROEB0rrhN4n8/dyHEfmL4rLbpZZ/jE0tq9coDmQobSH3METrYS93j05KvUvXHKhkLi7AicbQIBhaQA+VvQ2NZF5Uh+AYzSB7hsYiJkg2urPl0uqklMj1ASYHmBqgaRUSeM3Aq7pJtJCtHy+94HA8ocwr07Uxm3k52iRuPnF9s7+yilhfnXM40PIGeTLlgLyxqBQGVDgvccRS7s91cVH4nekQeZAt4v9QS+QIDAQABAoIBAADBsqiZJAGynsGwmKntRjudKBQlvGaCdSl1fZpf1k0UHdoseKM1VWyZKoVHDVCdiatfr1iYn67jrh837v+ysWlaruzzh/NsmjyMoPWF4IWldqHLJx3vfEqgshm3/0Js1XEd2Ggm+YXb4wVLznGOG16NzrdBE61H1bbQf6yaZ4rCN+7qXMsC0RSDJkB7pCEdlXuoKX0QzNu90pjwRp2P7t1ihWL5CVCRJE42fqvxk0dwhYisVQn79SVGsmjexFjP5Ff2t2x/qeAc6MyfC7DkGJWGFWmA0r4Wgc//zNW59YJi/C238+BKNowblIGdWmZwGnToVWlWsn9VMQYA7MBFXkECgYEA8L8UgGKreKPEI92l5GoYr8R7Cx19+fuulR5gVm2zR+pwk9rKJRF9/KIom1eVXxCtvl8Ax/hTgQjezyAUkV8qjEXITx1BHmsnKZTQtCKcr3/BlK6w45uIiaso3rXM+3biOONT5f4upGYGjxr3X6SUNzjHWhwUatytDE9CrdUsKjkCgYEAyfyASURjIp1yuy/fPQMMMPMUuP7TLn3FDRfVMhmkQHSIse9gQSqKfxXO+wDi4pdA22lfxZDfQ9j2E9I9sZgvNn2rx5QFlh0vRGhF4IAMlNGbC6v5xRQN5gXy0kVRXkH6HI6Vqd1owGK9IYgeKCSrNXDfTiOAtwj103YlcPGCLsECgYEAhQt0Twc4b/FBIfkKBtNDVU+mGBxyVEZs0uf4oYr6exHqqStOb3HdSFJtUnvyhpj3C7ABBIIN08+NIrY956DKKL8f1ej65c6d0/Lz67j9ElfuKTbpdr+rkzlN2tZps8adeobXBNGWATCJC2kBsI+JgYMVWI0QE4Zk89qRpPOb9rECgYBXWcFI7jBJKfoSBZPvWMAO8zDFCD7f3jg3f1UNw5UK4tqyyKjBxdn7N705Q5rbDzpXKOzoDczgFJXm4IcZpIzWbea5+sOntZtZZBbEDdxjB3qbw5XSqueP0IbAdIXJ05KMgwUqXrwMZycPt0QDbEg2ZkfMDQJ/JXraJj/u5iK8gQKBgQCwPimyCmz3zmxHF2/wPRJoRUkbaUGMtGHhrKnb8+HfBY3kGmB9OZYSyeo6Vbh4zPqXXuD/M7ks88DYBOiarGlkY1kTtWtDsEhigmfxWxkxRj1J7O5gAAMoaMc0Te4crJgREvZZypoHur6A5RX6eYf5ixGSCbuRwdNf8lPVapNatA==
19ebf88d-b916-4621-a8aa-fa8b429a5cdd	e8117b16-2293-4758-ac33-850803bd6c33	keyUse	ENC
5cbf6517-7737-45e6-97f7-e6e6e920e358	e8117b16-2293-4758-ac33-850803bd6c33	priority	100
b1d2a1da-283b-4eb7-a9a0-9e769eac3147	e8117b16-2293-4758-ac33-850803bd6c33	certificate	MIICmzCCAYMCBgGY533H5DANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwODI2MTc0NTM2WhcNMzUwODI2MTc0NzE2WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC983vVbObIWa8V+QbnnawUoAiQQLL/bE0txFjBell4jkPp+PxFYx9L3FK9KPHkbr3Xr5fEbnS+h91wJTKCcDc+EOkIzP+NquB4fJ6pmGlNQ4jS6DgfjRE4QHSuuE3ifz93IcR+Yvistulln+MTS2r1ygOZChtIfcwROthL3ePTkq9S9ccqGQuLsCJxtAgGFpAD5W9DY1kXlSH4BjNIHuGxiImSDa6s+XS6qSUyPUBJgeYGqBpFRJ4zcCrukm0kK0fL73gcDyhzCvTtTGbeTnaJG4+cX2zv7KKWF+dczjQ8gZ5MuWAvLGoFAZUOC9xxFLuz3VxUfid6RB5kC3i/1BL5AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAK5sI/sXgVJ7WFGlSCztq83p0UI99MMVkpzwSruC5mkAs2yc3iZ5ufRMzCIE55b1alw+kPefXcLa6/doX2eKV5w0/995QObrD2C2b/p6Vz9glkXbKLcka89umrbyttRW0oeFawIVWjabOjeGhHtiSEMIbfF540qY/J6yox7Y1iFG35H3ItkdI3hJ+9ghyM4NY0hrp/al48sWAirL6Oo1IqTZnC8caavCauZ4nXFJfWM1S+8EecOb8djyJmrgQRAhk/Ujk8BjwkDLz1NceILEDWqLvrMHu5ra9OQKd9p0gjGKEywWje/ZtT9PPJDLUsO5fFSrMHBqjxT7InVvLl7Czys=
469bdbad-a84d-413e-92f9-00353815154a	e8117b16-2293-4758-ac33-850803bd6c33	algorithm	RSA-OAEP
36f249fc-ca32-4b58-aee2-ceb124158491	71b24254-fa6a-48b1-aef8-bb763264fb07	algorithm	RSA-OAEP
f982a0cf-ad58-47c6-803a-643d5a34f252	d6f944e6-b0e3-49b1-aef3-05ed75c75094	certificate	MIICmzCCAYMCBgGY533G4zANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjUwODI2MTc0NTM2WhcNMzUwODI2MTc0NzE2WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCUacG2IrLsOcCD0izFvFj7E60PmufBjjTrdA8zCTUr8YGDM6GfI+84x3XD66kfSMRViKv0JwPPIRtDm+9JrWnAXqxHYmJByYVqQpoPfbIA5kJFTuwVC9HFatUmBNO6hWv7mGPL36eg0j5gQQLG2ikt+Fc941iGvQz3X5cPd7t0lnNFCJiaW6PxNRNWkHZYZLsZ4BFlqEX6IHYXS0kuJUp7kyT6T+1y69c9J7T1AKJMaWXHx9Tjx18/FGzJIIwRY/Xrt3l9ES4gJtvIfqAqJLiaOcKmQMnm4wf907bU6xZHqIq6EawyJ34pTc3G7QH8mONpiTtV3IcTH52blO55cHtJAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAJAuA15mWKdx7RNWaQcm7zOUFNMLe/kQGYOSvUIKGTCWBJGbKRVM7tYWLvNyhnZQmDVQOCxD1qBahlm2vKabDbPRfi/NOQm1kUPE+Cdvz6rqPqbkIPCqrqGw/2yOcIsmA/hGa9BVplGXs+Sk8cdbWx+Lnoq8vo67UqUdyfraVpDDNr20sIYqB7rfoznICiAUEK7fkqWqGCG5gZMZ47x9ZjQU/vh3Iwj72zIUohVRBbdP6bn6utNLpOaMv+V7bXf5DiINcR+SSy3ex8x2J0k0Tl34/Q5jIlW+rpFPz3VClML7EqhGAuUKKjjVM+WDBk2YUWRYFui2UMXLE0Xz2UTnU/k=
8b562723-cce9-4e3d-9692-158d98e25d86	d6f944e6-b0e3-49b1-aef3-05ed75c75094	priority	100
98ebbe75-c815-49e1-8756-8c1160ddbcc3	d6f944e6-b0e3-49b1-aef3-05ed75c75094	keyUse	SIG
f3ac7443-35c7-4131-82af-e3f2ec1bf13e	d6f944e6-b0e3-49b1-aef3-05ed75c75094	privateKey	MIIEpAIBAAKCAQEAlGnBtiKy7DnAg9IsxbxY+xOtD5rnwY4063QPMwk1K/GBgzOhnyPvOMd1w+upH0jEVYir9CcDzyEbQ5vvSa1pwF6sR2JiQcmFakKaD32yAOZCRU7sFQvRxWrVJgTTuoVr+5hjy9+noNI+YEECxtopLfhXPeNYhr0M91+XD3e7dJZzRQiYmluj8TUTVpB2WGS7GeARZahF+iB2F0tJLiVKe5Mk+k/tcuvXPSe09QCiTGllx8fU48dfPxRsySCMEWP167d5fREuICbbyH6gKiS4mjnCpkDJ5uMH/dO21OsWR6iKuhGsMid+KU3Nxu0B/JjjaYk7VdyHEx+dm5TueXB7SQIDAQABAoIBAAJ3X8fNe6Xcz36b+BtWG1rFc4S08+Eod5J/xH6PiocUgEI5p1fWwp4x2bAROGeDxPgl6V5JOrE5u94BAfY6ZULpioPfgOyryGWLvfXVcSc+LFTssD7Tn4oKvIg2oCfImVLeRVmejxwnT5riYa/ZHBeT5FaWiAKp3W9hSDLyhVaKi10zDHC3jfshEBFDsIxcv9s5O62OsU37YrWhsMYtmm8qRHBwnOFByXaMRY1+MCcvjSwp1D8EIoTN49dNlhvW6JamcxzXJec10XuAe/QPAZhOk+KzacZZbKXpfAOBIX3wMwIkN8AE3Lg5CrJH7mRHo2QsZ5OsqNS9RsKjB8S1m4ECgYEAw2NAqsBuSvGSRGpIVpjg39cK7nqYLKTMUBGIRMKF5MwJjmZ4iwPnJtzc+1oepSCIPyFiyJ+iYGObaq2tj/M9/fWEViaBe4YoKyilLjMG9WfzEJf6e1kiI32dyxvzdr9VCUq3ae2CixXSEcZaHlX6w2OBzsEV+hRccaTT2KVBowkCgYEAwnQCRP8CUcQ22ZSaSEikTVmSvEkO/soM0lFHW9C1LDCJvW5lUyVsxNN0j8fNDcrZfG+CAEt/n2DkBjvxld1OjZBK0TvmKX80aiYOlEso5Eksa+c5P0WaG7g4wku6cxwJPToE5hap6HV2Jq7NOM990qeaOBXdru0llWihnAfs5kECgYEAsP1piMODpTOq0XqNSJR3r4x2hIxc6KPnx+f5zn9/FkCVr363VwYUD6omKzH5bI9JnBY8C4w/ZJ0WHc5x2GH5F+GdHQUIacKfBGlvJ6hld0vQbImfBrk5KXkSxPfu1PSArUgXWUci56a+ggdxfuVXoEK1RXq207A6BV/P3wHjsTECgYBFJ1KjTPl7MMe8629O456i74cStPzDOgIDTeqNyZSU6ZIirz8Tqcyb1wOuGoVfMVPVQCbAihkSCjgty2WoQXMtPzKMZLv+6AEw+uXWcUBSp39HxIyEZvFeiE6PMrVVOJRElPynA0pbpGJncWUEni4GG5rp9UTIcAgcsYA/6EWkwQKBgQCbpLlMotKuU8Xk0AIglJW9owKsB2+J8NNclXPUVN6oETS0blAEUpx7HO/WJN0Ygn/jMwpjQZuM3kUG9LlZHmoNzKjKjzA5CPdcGl9GLXjXZhsGEZPxEFMaGN8uZ0stZ+uKn0HqwFTWKbi295sKaDQesqlSH+JgXNrzu4nvCNOuWw==
7f436d07-aa10-46f3-ae60-a374685d3a16	1e2d2cc7-65a7-4a3c-852b-43639c30862b	secret	a6OH-7EGq4jQzyAt9uRX6g
0853a8cb-6f21-4cec-877f-3f9125fef958	1e2d2cc7-65a7-4a3c-852b-43639c30862b	priority	100
212ac718-39a9-467a-b802-68a78ec193aa	1e2d2cc7-65a7-4a3c-852b-43639c30862b	kid	af51be9b-affd-4a36-bffc-6687459ee02b
d67567db-c070-4bd4-9001-d21c29f60342	23e3df7e-2c18-4ce9-b399-0898ec9bd678	kid	99dbe22f-19ef-4e65-9681-b5a0c77bea76
d51ed452-d031-4bde-8a23-b8ed37d74cc0	23e3df7e-2c18-4ce9-b399-0898ec9bd678	algorithm	HS512
a3245bf9-0fc6-4c29-a966-ae0bea78e7c1	23e3df7e-2c18-4ce9-b399-0898ec9bd678	priority	100
b7696a20-c7d5-4e19-b973-c9c54350a192	23e3df7e-2c18-4ce9-b399-0898ec9bd678	secret	3iSJrdOIIuF4MoCZAudEIJlZRXULcMimG4dgyjg-Gg7Vqg1fOQJ_UHJMvD35MSrhvjmm4Cg4TgUyqwXvyum6mIGNi3F6OyLOohgmTWn5bLHGzk7bTg32lqkS7bfa-ooXXkcQkjvZIzDq39bcY0D7PfTFJnuD29-aWOMt06he7kA
2f97761d-78e9-4957-901f-0bbed749aa4e	e84acedf-42ac-4c35-9dbe-345451b947db	secret	7TGtw0UpmohLPUMZnR-RjOEPbI6vwlaqQHK85f3Mwi21K0HbHp5k6kIdK0MsfCghwqzpCg-HqheUdO1yIHDhoOpmiNOcJPizl3wisjNhJzw0dHDrsZBHBZ-H0khDwrd2TS-d0oXLyQIuPPLd1b7ITKfOWL5OR3jMNLezQPTpSV0
c5763eac-f97f-46b6-9832-e65034787820	e84acedf-42ac-4c35-9dbe-345451b947db	kid	2f196c9d-3fe6-444c-aaa1-658b188fc32e
f4f3d1ac-d420-48b0-90e5-c1cf53e8ae79	e84acedf-42ac-4c35-9dbe-345451b947db	priority	100
048e7347-bd9f-4591-a419-6c1e356a82d4	e84acedf-42ac-4c35-9dbe-345451b947db	algorithm	HS512
80450082-d6f7-4d48-b552-a9741fe39269	2bd5b289-341f-4d58-a51c-5ee5825a06a5	priority	100
d27ae95a-a11e-4f27-91c0-601f79f97c48	2bd5b289-341f-4d58-a51c-5ee5825a06a5	kid	a674fa1c-9e96-443f-b275-af39047240dd
b01fa376-bc35-45b3-925a-459faf17f260	2bd5b289-341f-4d58-a51c-5ee5825a06a5	secret	gLSZVfRLjqIibzfkz49ELA
b3f3879e-1127-40e9-ad02-0e65402cf5b8	71b24254-fa6a-48b1-aef8-bb763264fb07	priority	100
1f6401c8-09d3-41f5-b0b8-763d5c90b870	71b24254-fa6a-48b1-aef8-bb763264fb07	privateKey	MIIEpAIBAAKCAQEApGJLhMMAMaM9H/v/FBTRe/mKQiXjz/JCsRo9tIIpztxVe4bWcZsrVaBr6MEF16p7vw3WSYbtji+bt5sSjQsmNrpki+IJokU2OphcSvmhcJE5Fpu6pMmqNJ/o+FJthpSbO9+xEJh9oBt4vzTxKisMfPWZSwW3s7AbD3CJMXs1XqrVMn5P2CHzdURiIcUJDkuaUDYIZLADV0yjhsWUguWOYLrFogQrV6Q/c/hUBwqxxQZJICLgXqYs91FBCzdJPoIiQclyUH7UoXghLuoXn4cOe5Sz3TuRd2QJlXGlfpDVTlzsZYVEWfHsBNnjdtZ3faQyaqQnCZN/lfKW3Uf1xYUi3wIDAQABAoIBACMZHbi+DgeLLBztKDx4aXYIBN40ytx2hIjd6njlJdoWL2ZNlvHwyKLiusealw3CR+O2J5/RYF1witX8FUzqKYGb8KXxYE82aeq+503W2QJ473CFVaejq2TLE+oZZ2tJxY9WJq89b+1EkFZ7DlcLlAIGSnG7Scri+hQk2hYnkXChv4O1XD7pVtMrVcVuvXfVetcTFJccZ7pHGN7GItLvDBgHdkoAZZMJ2h1YklcEP5Zu+B1mK+XOUFkxdTpLfSOfDzWHgJhBPY8BbZegXoTBv5o5i+aviQWxarW9sYsJ3NNnO458eH7xLbTAO0FfyT+FFFSb6xdNZpoEkZE95vdJN4kCgYEAzTsCQKkoCviqe0HiNOkqDlpUwa8uEnyf/79A1t7+0jYXhilVLArZ9yk2RH8X2tJ4/tq74xza6/EfDsrwlor53hb3unaR2nfmsW02onoZkV2mQblgcnidhMghQvSOy69tVha30CPpXumq8/O5S9c8tz15x37Az9t2FPtTOTA0OZMCgYEAzQyGpyK56uRwnIdLAF8bwNKN1ufWOmxzdzJ4XM3j73bFTqEe+DY+O4ATNEGhc/pj5akyDovK9V2cyvHL4G+6V6ioE6jJ6MvJ9OyHrONqOcYmY6Vy4d4vLSFRDn9VqnbjKmjtV5vQTQnzYr2MBqb3IpkxLzQF7p5YgrpIvivl0QUCgYEArEfX2T3m3mbmfffNk4sUAd50fe63p0805PTA0l953C8KSlZSKFmnpaLT6mYiOVArwA0QYlOrtxq/bqSPmGBr5rKzHLVCNPooD1NV5MjIw82wrkWWoCF+YaO6wEEZygSmrPj/LtumoUVYe9dh+jdhwZT6sKxH4XUiR/S+ZSiA/r8CgYBv6/JjsDTC3cYJ6l8p6MABU+xP7WOlqCSuX0ILheZwgufXr2J0IUd+ur3AvEIgR//XD69e+TbjDyHSNIEQFGwmBM0ZTfxHsVSe96xm1grZVisGIPzABMLDY3gW7bIYxaPhNjy2oTnlkxTiRIv15ZTnsa6DEWZbhNrTIFMsWlGq8QKBgQC33YA5YTwKh2UtVNbFjQi1MZwLKt90uSb+0Ez5bhNSXwQ/MmScjM98CTdVRvP4MrH0d8nUUfLMegs8RPP/TxCNbIbhUGXhj9t80EgCQFMjK2nEZQ0KzF+hH3QUluGyoYFfJrWn8BFGK+iYvi0klECUcTsFI+xVf7ogun2B1i30uA==
1a2954bf-7441-4197-bfc1-b0df2e88cc50	71b24254-fa6a-48b1-aef8-bb763264fb07	certificate	MIICpTCCAY0CBgGY535RmjANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDDAtrYXJodWItYmVlcjAeFw0yNTA4MjYxNzQ2MTJaFw0zNTA4MjYxNzQ3NTJaMBYxFDASBgNVBAMMC2thcmh1Yi1iZWVyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApGJLhMMAMaM9H/v/FBTRe/mKQiXjz/JCsRo9tIIpztxVe4bWcZsrVaBr6MEF16p7vw3WSYbtji+bt5sSjQsmNrpki+IJokU2OphcSvmhcJE5Fpu6pMmqNJ/o+FJthpSbO9+xEJh9oBt4vzTxKisMfPWZSwW3s7AbD3CJMXs1XqrVMn5P2CHzdURiIcUJDkuaUDYIZLADV0yjhsWUguWOYLrFogQrV6Q/c/hUBwqxxQZJICLgXqYs91FBCzdJPoIiQclyUH7UoXghLuoXn4cOe5Sz3TuRd2QJlXGlfpDVTlzsZYVEWfHsBNnjdtZ3faQyaqQnCZN/lfKW3Uf1xYUi3wIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQA2JciTpjzu5kMm6IaBpffjS9cqzPxtY3GC+yomkda+feki+lzWKABUqPHEymybZeMRJtHvtPiDerwIxzA0TsdBR07z7XWGI9HQtO+ouEhttHnvfNQqpQEVoineXKIFjj3djjM4mAzWV69FtUPDUZLjchY2iyXYGTQDtF4R7EAh2kQeL4g1jiy7DVmt154hNQq8+wRZ9yQJfgcThpzetQ95tq+ZI0y0WlEE2qQonul6Ahf6Jp2X4isOz12/Cs9h1HeJzBHxlc8k/yY3vRAlfHQ8RWkZSPsKD92P/wdGQi1yzF9WIOFO4WbtJq0aAybhjT/bMCrbwFQxs7PtqsyWO02Y
829d638a-df12-4c95-a923-e8f374d6721d	71b24254-fa6a-48b1-aef8-bb763264fb07	keyUse	ENC
e3cb7ac7-76b8-4638-9a24-57cac6d69269	52608fd7-3656-49fe-98ff-689c0fdf1f94	privateKey	MIIEowIBAAKCAQEAxKXC8PYdr/huZ6ljH+QY4LDU10E8J6k3HuJQC4MdcxzyGmny0k/WnEXgIIY2qSTfiWrehApsjRQ/u6tSMOkzYz3RiFp0h1bRkqdHOcW5uW2xs3VLPhYyuthLKTF4nfq9jRwcIHxaWjFCTzIXz3UBzduHhQbP7rkZRFQyGDfUMIHggJns3p1L8DNSkbHr2XoOpbTkPiz0lK+mAshjuVHzbWMl+OvYkRQnci5qAEfDMO8n7K0Mb2G/kjvo23Jfnp0nWKJTJcaZYqzltltaeXpYwzKGPN8sP7XIP3h0KsRCWkzYhuxGZnwfw4yDpSs/xSeI72Vs9JWBMb2FYYYxx/BN4wIDAQABAoIBAAFGdeosHmsquESR06O8TfD/FJJEyQgUz9eybgR1GDbL5EIJl9qHTAP9bAOp+ybDp3Nzrve6PZP4oqUr6j+I851cJES3GXRbOsaxsQON5bNvI6zfQNqpODEAABTHTlnv61TD7ubDB674DM8IqyDcSGO2Xb2eGrEYoDJSPXTsv8KEwi9mCd5SSokNzVwQLvbJRKbYOxpCRbSkuOrRTWBUs4fapjNKAO6XZdcCgubntCrFNOmThP3RHb76Xx1mSimmH+xMNwulog1JihL8EJy/QvR3qPI+5L9Tvq2o48jtpG9a76AExGesOkYliNFeDRPe76005jng84OxzpOIq016TbECgYEA6VrNwPAyiHWzdJPhl7aTUs28YyD64iWf9cxyF+oPMsEXmQLgDleGA23jMx/kAJ0cODZYOCQliyBpUfDX/MMLglXVwKhYc/JElBfzX49x/0ci0p6gZl/Wj3CpviiI4uwSJUoG4wGvmMV4Z5kJSPjAKMATjYy6x3SckIMhqwr3pfkCgYEA17sL3DQxoFWNeOCS30xS5LxVTGoSKy5aCteirZydypQXtym5vJ1Y37SSWFuB1ZEwff+O6mDa4xH6SfP/Piawn1XXNTVXcC3K4xKTl6OiIQbVoGZSp5+532p5gusVzt4LIEqDjUseerhSLF675frG0fGIbReieEuxW6pxRjKq2bsCgYB62YkUl9+io4RUTT4opr+sig8xiL1LrU8nEfjGyjwyFiGcNj1Kj51H1OQVmCZqhEvE9CdBdxYkxm1r7AVpVi2K8jFT+cyHTfX4mRtRJa14HTUh+Mys2KuWXFOgfqqB/JIY+33gqJSPMvaOY6zVs89GJMimbn4uXx/FnKNu7pkt0QKBgQCyVU1Ym0zq3c41PnArZ0yfCZD5ujWKvKZykA9KtU07SXDRWQzRfsEZLIxNvld11K/heIEL/0TysMnWmH1HQ3R+QtfEhHPjp/cv/wtDL2G3K48tKWjqaH+e0MXiE7PTbnqEFxTomFB54iULyMRLOSNiKeg9RmxoRSo4PI2nGftiQQKBgEts+Ixezf1sAhGuaTPQhoUF7upC0kBu1dC9qw/X/leVyS61oFu0f4r9eOX0CbvtzJAraLowvn9v+zPvzx3QcBqDzUsjI/ye063neu8DYqQqBUUzJudR44LVJO3pu7KkiyUapOkocTyuD54E7o5o0mF8Tm+vGPn35qrpHjqSgwyS
66308701-7c41-410a-848e-304e6bb6566b	52608fd7-3656-49fe-98ff-689c0fdf1f94	certificate	MIICpTCCAY0CBgGY535RMjANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDDAtrYXJodWItYmVlcjAeFw0yNTA4MjYxNzQ2MTFaFw0zNTA4MjYxNzQ3NTFaMBYxFDASBgNVBAMMC2thcmh1Yi1iZWVyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxKXC8PYdr/huZ6ljH+QY4LDU10E8J6k3HuJQC4MdcxzyGmny0k/WnEXgIIY2qSTfiWrehApsjRQ/u6tSMOkzYz3RiFp0h1bRkqdHOcW5uW2xs3VLPhYyuthLKTF4nfq9jRwcIHxaWjFCTzIXz3UBzduHhQbP7rkZRFQyGDfUMIHggJns3p1L8DNSkbHr2XoOpbTkPiz0lK+mAshjuVHzbWMl+OvYkRQnci5qAEfDMO8n7K0Mb2G/kjvo23Jfnp0nWKJTJcaZYqzltltaeXpYwzKGPN8sP7XIP3h0KsRCWkzYhuxGZnwfw4yDpSs/xSeI72Vs9JWBMb2FYYYxx/BN4wIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQBpz4T3byqW8Ztfh7uttGOOqRifAeInjuNxpfEuJ2J4yUrBpQ0/D5ktmJIXiuh84pjWv+6+qUsAsbmxKOE+AgGdnjr1MFseFXslg4/9qqPSDV10xV5aIASgLtKS6arq8fgO6IPai2DIzEphFlP8MmyGQqWkTFE2LG6GdaLPwcpGp+EYIwibCWFtzRxJWBLBGv+qLnbDpmMW/oI7SWFGnGpykR2eRK6hYUDl0rAtEWuq0o4rtazjyNNk+jfxZ0l7JvuUBYvwARc1+eygH2CyPg9Yeelm5/xDHtTrL0tSvWYajgeNvSMpfcbEaQBnAEIx2YmfdQAjMiJ4UXW74uLN5NHD
e7b275b6-e211-4ac3-8c8c-2466aeb9f4fc	52608fd7-3656-49fe-98ff-689c0fdf1f94	priority	100
a4c0c590-34c6-4c1a-a529-1f52616ae9f9	52608fd7-3656-49fe-98ff-689c0fdf1f94	keyUse	SIG
58725f56-89f4-4b5f-84f5-30777ac4b7c3	ce9478d2-1e85-4c41-9997-4dbfa9a59d0b	allowed-protocol-mapper-types	oidc-full-name-mapper
8d05733c-170f-4c77-908d-e148dd473924	ce9478d2-1e85-4c41-9997-4dbfa9a59d0b	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
eeb44318-c238-42f1-a6b7-28452ed92860	ce9478d2-1e85-4c41-9997-4dbfa9a59d0b	allowed-protocol-mapper-types	oidc-address-mapper
4eefac98-639c-4ca1-b727-f5f3c7344924	ce9478d2-1e85-4c41-9997-4dbfa9a59d0b	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
e81b4f92-5ec6-41b6-a37b-9505b3afbac8	ce9478d2-1e85-4c41-9997-4dbfa9a59d0b	allowed-protocol-mapper-types	saml-user-attribute-mapper
1a214762-d938-4b72-82b9-88460522d132	ce9478d2-1e85-4c41-9997-4dbfa9a59d0b	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
17f9dcca-c03d-4b93-ad45-a56adb2e907f	ce9478d2-1e85-4c41-9997-4dbfa9a59d0b	allowed-protocol-mapper-types	saml-user-property-mapper
35144f06-6180-4d4c-9788-7500774804b4	ce9478d2-1e85-4c41-9997-4dbfa9a59d0b	allowed-protocol-mapper-types	saml-role-list-mapper
e5e11d6e-1341-44e0-8c08-7b18aeed6377	0a3b89e2-21ac-4736-bfd5-38008433d9e3	allowed-protocol-mapper-types	saml-user-attribute-mapper
fbf1659c-c516-4263-ad3c-db84c7d7fef7	0a3b89e2-21ac-4736-bfd5-38008433d9e3	allowed-protocol-mapper-types	saml-user-property-mapper
dda7b9a4-8fe0-4546-bc18-658da6491232	0a3b89e2-21ac-4736-bfd5-38008433d9e3	allowed-protocol-mapper-types	oidc-address-mapper
4027177f-9192-46f2-a6ae-657c4186b0ff	0a3b89e2-21ac-4736-bfd5-38008433d9e3	allowed-protocol-mapper-types	saml-role-list-mapper
cc337376-40bf-4ee6-930e-89048a0da3a0	0a3b89e2-21ac-4736-bfd5-38008433d9e3	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
4beb7ed1-11f4-4946-a809-e34a0f900a51	0a3b89e2-21ac-4736-bfd5-38008433d9e3	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
19594ce3-f77b-4367-9722-8d21b742a2ae	0a3b89e2-21ac-4736-bfd5-38008433d9e3	allowed-protocol-mapper-types	oidc-full-name-mapper
38cf8b37-9114-4a61-8429-6294cf1881ea	0a3b89e2-21ac-4736-bfd5-38008433d9e3	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
7ac4ddf4-d2b3-418a-853d-8da462130706	f2308738-efec-4a5d-948f-e947afa53b54	allow-default-scopes	true
59f274a8-97b7-40ca-9afb-31c2f93b8b74	04dc49b5-fe1f-48b9-b503-844a8fcb19c0	host-sending-registration-request-must-match	true
66f5b36b-65a5-4ccc-b5d1-857685aefcb1	04dc49b5-fe1f-48b9-b503-844a8fcb19c0	client-uris-must-match	true
b3abd419-33a8-49e0-ab4f-167cf654fcc6	224f2678-a767-4059-82e9-31e423bf7502	allow-default-scopes	true
ffc8d2a7-30ef-4f13-9f66-351f34985196	0fde0cf2-e75e-4db1-b3d0-0d05f569a6e5	max-clients	200
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.composite_role (composite, child_role) FROM stdin;
8613ae31-d596-4ea0-838e-f99c67defba1	62a3c8e7-2950-4a28-b949-7bc82037184f
8613ae31-d596-4ea0-838e-f99c67defba1	eb9f3111-0cbf-49e9-b8ca-1120c4a09773
8613ae31-d596-4ea0-838e-f99c67defba1	99de1ba3-68e9-433d-a780-1313f0532db4
8613ae31-d596-4ea0-838e-f99c67defba1	0747e71a-40c9-4493-8692-195181549f4b
8613ae31-d596-4ea0-838e-f99c67defba1	23eeb889-04a3-426f-905e-632579b80286
8613ae31-d596-4ea0-838e-f99c67defba1	7259e5cc-7940-46b4-adeb-54633a47d78b
8613ae31-d596-4ea0-838e-f99c67defba1	ad65f360-32fb-4394-a475-5d5e35ca1e8a
8613ae31-d596-4ea0-838e-f99c67defba1	61d6cc83-7e70-42ad-819b-e1b985845def
8613ae31-d596-4ea0-838e-f99c67defba1	3a0229cf-563f-43ae-a82c-bd9b84187514
8613ae31-d596-4ea0-838e-f99c67defba1	8e42bb0a-11cc-484e-aa39-e12e59656eda
8613ae31-d596-4ea0-838e-f99c67defba1	0837f3e0-804b-4987-9518-0e48ed17ceec
8613ae31-d596-4ea0-838e-f99c67defba1	6e65d07b-1f82-459d-8d04-36d37aac7302
8613ae31-d596-4ea0-838e-f99c67defba1	926d4963-4f1d-4480-bc93-4df33e2975be
8613ae31-d596-4ea0-838e-f99c67defba1	dbcacf14-b509-4627-91ea-e1c913a530b4
8613ae31-d596-4ea0-838e-f99c67defba1	fd10e590-38c5-41ed-b6f6-540ce1d844b7
8613ae31-d596-4ea0-838e-f99c67defba1	fa9250e4-06db-4a7b-8903-f4e5ad15a055
8613ae31-d596-4ea0-838e-f99c67defba1	fc9122e6-cb5e-42cf-9ceb-5e8b0137c769
8613ae31-d596-4ea0-838e-f99c67defba1	7e481355-7535-40ed-b955-2fa8aed8a4c2
0747e71a-40c9-4493-8692-195181549f4b	fd10e590-38c5-41ed-b6f6-540ce1d844b7
0747e71a-40c9-4493-8692-195181549f4b	7e481355-7535-40ed-b955-2fa8aed8a4c2
09694323-0efb-4bcf-b6ce-691ba922605b	8ca66fe0-3cdb-438f-bee9-dad9b425f8d5
23eeb889-04a3-426f-905e-632579b80286	fa9250e4-06db-4a7b-8903-f4e5ad15a055
09694323-0efb-4bcf-b6ce-691ba922605b	0d6c7652-72d6-4bba-b70e-d9db79977011
0d6c7652-72d6-4bba-b70e-d9db79977011	3a142c30-91ec-4276-8c39-b3ebef59f87d
0ed4c9a9-a142-443d-a7d4-619a4c6906c3	60832d89-aea5-42cc-8813-7bc4cc2b70d2
8613ae31-d596-4ea0-838e-f99c67defba1	f104bc38-50b1-4c13-890c-33167cbb61d7
09694323-0efb-4bcf-b6ce-691ba922605b	eaa4fb16-c359-41be-93f1-37525ac18e91
09694323-0efb-4bcf-b6ce-691ba922605b	bac1a777-c8f9-46f9-98b5-dcf6b3b4e018
8613ae31-d596-4ea0-838e-f99c67defba1	af4267ad-b59c-47b6-a7b5-1e84f264aa02
8613ae31-d596-4ea0-838e-f99c67defba1	9e240d41-0ea3-4bbf-8779-7a0a128eafab
8613ae31-d596-4ea0-838e-f99c67defba1	073a88e3-863d-415b-b87d-660c9c60c206
8613ae31-d596-4ea0-838e-f99c67defba1	09e5b341-4bb6-4f74-8a34-52c3ba52e656
8613ae31-d596-4ea0-838e-f99c67defba1	1f90c5c9-2525-4ef4-a6cb-4cf9190c8900
8613ae31-d596-4ea0-838e-f99c67defba1	6f7fbb27-bdf1-4e76-a491-3a0fcacf0953
8613ae31-d596-4ea0-838e-f99c67defba1	009088aa-e4bb-48b9-8984-39a0444b712b
8613ae31-d596-4ea0-838e-f99c67defba1	71aa3a63-b552-4d4e-b080-2025c45fa9db
8613ae31-d596-4ea0-838e-f99c67defba1	4249500b-84d8-4e36-b76e-65a1ad57fe39
8613ae31-d596-4ea0-838e-f99c67defba1	96d8c311-bba7-45ed-93ef-8a41bbc75688
8613ae31-d596-4ea0-838e-f99c67defba1	e22bfaec-833c-4d39-b636-e6848bdcf029
8613ae31-d596-4ea0-838e-f99c67defba1	6af6534a-bff1-4008-91b3-278f7767552e
8613ae31-d596-4ea0-838e-f99c67defba1	e4a6bb33-8670-4ade-8dcd-7b71f0029116
8613ae31-d596-4ea0-838e-f99c67defba1	8df4a48c-5f4d-49ff-af18-49d48760d5e2
8613ae31-d596-4ea0-838e-f99c67defba1	fbc5a399-64f9-4c83-b476-ef91a20799d8
8613ae31-d596-4ea0-838e-f99c67defba1	c7a105b8-4103-4d65-9d3c-45f448db95fc
8613ae31-d596-4ea0-838e-f99c67defba1	14de2516-829b-4d2c-9bf4-3ddca87ffd9c
073a88e3-863d-415b-b87d-660c9c60c206	14de2516-829b-4d2c-9bf4-3ddca87ffd9c
073a88e3-863d-415b-b87d-660c9c60c206	8df4a48c-5f4d-49ff-af18-49d48760d5e2
09e5b341-4bb6-4f74-8a34-52c3ba52e656	fbc5a399-64f9-4c83-b476-ef91a20799d8
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	fefdbda1-11eb-4858-a42b-d6106c25503c
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	b05e845e-9c99-455d-a060-ffbe162adaac
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	e6ddedd6-a164-4a06-938f-c00dac0a51c4
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	a2868589-85e6-4915-8a95-0b7761630082
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	2f002d38-2db6-4059-b349-51df182ad393
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	9b0146ae-7010-48a2-87bf-b75e2fbbab6e
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	02247826-28fc-40ce-bc43-9a650a9147b8
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	6a3e7fa2-746f-477e-bad2-b392f6122c6e
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	3d40cab7-fc2b-48a7-9078-5594218875fa
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	40455c56-4404-4733-8a0a-80e797426dc6
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	2f7b793d-4d69-4f81-8396-54843946b1a4
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	0c3e85be-5c8f-4fc3-b2d8-a6e8da41c74c
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	cf7d722a-6f49-4b5d-971e-76d8dabb0e2a
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	fd4441bc-7ae0-4f2b-8c43-23af992e3b16
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	14b7b5ac-65e1-4844-9605-56bec1132b6f
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	430b6898-b3aa-4408-b2b3-023d7b328d8d
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	11e27fae-ce04-44fe-b7e8-455ebf2da2c0
936850eb-9be2-4c76-b572-0ab7d4f5d621	a3821c53-9200-412d-8840-c115555fe53f
a2868589-85e6-4915-8a95-0b7761630082	14b7b5ac-65e1-4844-9605-56bec1132b6f
e6ddedd6-a164-4a06-938f-c00dac0a51c4	fd4441bc-7ae0-4f2b-8c43-23af992e3b16
e6ddedd6-a164-4a06-938f-c00dac0a51c4	11e27fae-ce04-44fe-b7e8-455ebf2da2c0
936850eb-9be2-4c76-b572-0ab7d4f5d621	1b8e44dc-fa4b-49c3-88ff-cb15ca910ac3
1b8e44dc-fa4b-49c3-88ff-cb15ca910ac3	6758181d-f3fe-40e9-bf61-98c41c9010a5
c71ec187-4777-4df2-bba5-bcbf96a4487a	64ec4761-5056-4712-816a-1e25e08e8717
8613ae31-d596-4ea0-838e-f99c67defba1	260536ad-0d65-4c9c-86da-06706cb16abe
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	9a3b032d-fcdd-4f3e-bb7a-0d8f8b347e55
936850eb-9be2-4c76-b572-0ab7d4f5d621	a4291b41-533f-4fbc-b40c-9bd5c6436268
936850eb-9be2-4c76-b572-0ab7d4f5d621	540265cd-ed8a-4098-a7e1-686a022f0adb
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
20728ea9-f88e-4221-865b-c9be86ef4204	\N	password	bfc5c1ae-64e7-4c6f-bae0-61bac2dea4e7	1756230437110	\N	{"value":"Pic9lSKMzCOp8Vq84JI2hLjBcrG4AEXCFJlSPkqIAyA=","salt":"DEIDWJDgCRj5BOnvZ1ziIA==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
f5e6f814-0a51-4d17-8440-0dacdb10614a	\N	password	d85b629b-87fc-409c-a66d-d3e61be79461	1756230590396	My password	{"value":"4RQHzCLi1ukeTHK+82ENB06+nZ9q+xeoQg8gaKC67wo=","salt":"jL9uWapL1uZlW2IGYduadw==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
8af9fd09-8366-411a-a3dd-a4ae7e46bf19	\N	password	467b9742-0b00-4f9d-81ef-26e792f2d318	1756231538533	\N	{"value":"lBz0gaigXH+4Yx9k65SvjKOfh9bq0Dl/DKXbpY3ScU8=","salt":"mxQ0qALmW7yUMVCX8i0XRA==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
63319136-a1f3-4c02-8da6-0dd2349a5950	\N	password	0c5b254a-8e3e-4da8-ace9-79c17611ac42	1756327751390	\N	{"value":"a+vBaG3imxLVHwF3co2+gRxKjDgtet6QZE/yj5V77g0=","salt":"Y73UUJXrY+FPQYLORfZ9hQ==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
d8ac8887-79a7-444a-95dc-f458af21ee70	\N	password	bec1858e-304e-44c9-8f4a-3d775b958d88	1756327783908	\N	{"value":"VEOALGq7ETBtKz/SagKGYRzID2sccLwts/gFSukDHvo=","salt":"Aa0zHli6/F2lqUeapJrDIQ==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
33bf1106-34fd-40f4-99e4-28eabdc8b93a	\N	password	efa91276-b915-4904-9798-516a125b0a46	1756327827190	\N	{"value":"IokrTW1cko2nsOG3E7ijDIvMwfArz4UVtkH5nFLYwa8=","salt":"Y7k5b5llXTgiE0UdQMZJ6w==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
9316e60f-d843-418a-93b8-19afdb57cb94	\N	password	65b70101-3a6f-4755-aaf7-f588199ab417	1756328006824	\N	{"value":"CbqpvVk2c1r6bGIV6i3tppjIB1zmCU7v3Nx7IcEAHUU=","salt":"t/xs55H6mh8B7SrjtInSMw==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
5377d23c-0c03-473a-9da6-264a809a1bfb	\N	password	d1848e9f-641d-4d73-9b7c-2e11dc531ace	1756567970428	\N	{"value":"v/XDhbT9rBZhEzTdoO5TRQJCRVVUnlKZZS/+hBsDt+Q=","salt":"oBQ+4fK1TBYOj/A7nx/sfA==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2025-08-26 14:47:07.194274	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.29.1	\N	\N	6230426254
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2025-08-26 14:47:07.214794	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.29.1	\N	\N	6230426254
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2025-08-26 14:47:07.313539	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.29.1	\N	\N	6230426254
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2025-08-26 14:47:07.325168	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	6230426254
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2025-08-26 14:47:07.563517	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.29.1	\N	\N	6230426254
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2025-08-26 14:47:07.572566	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.29.1	\N	\N	6230426254
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2025-08-26 14:47:07.757084	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.29.1	\N	\N	6230426254
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2025-08-26 14:47:07.76927	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.29.1	\N	\N	6230426254
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2025-08-26 14:47:07.7902	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.29.1	\N	\N	6230426254
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2025-08-26 14:47:07.988022	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.29.1	\N	\N	6230426254
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2025-08-26 14:47:08.090902	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	6230426254
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2025-08-26 14:47:08.099299	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	6230426254
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2025-08-26 14:47:08.140523	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.29.1	\N	\N	6230426254
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-08-26 14:47:08.180244	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.29.1	\N	\N	6230426254
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-08-26 14:47:08.185194	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6230426254
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-08-26 14:47:08.190428	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.29.1	\N	\N	6230426254
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2025-08-26 14:47:08.197295	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.29.1	\N	\N	6230426254
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2025-08-26 14:47:08.294492	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.29.1	\N	\N	6230426254
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2025-08-26 14:47:08.431578	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.29.1	\N	\N	6230426254
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2025-08-26 14:47:08.440072	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.29.1	\N	\N	6230426254
26.0.0-33201-org-redirect-url	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-08-26 14:47:14.404708	144	EXECUTED	9:4d0e22b0ac68ebe9794fa9cb752ea660	addColumn tableName=ORG		\N	4.29.1	\N	\N	6230426254
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2025-08-26 14:47:08.444836	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.29.1	\N	\N	6230426254
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2025-08-26 14:47:08.450765	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.29.1	\N	\N	6230426254
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2025-08-26 14:47:08.584492	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.29.1	\N	\N	6230426254
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2025-08-26 14:47:08.595082	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.29.1	\N	\N	6230426254
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2025-08-26 14:47:08.598853	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.29.1	\N	\N	6230426254
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2025-08-26 14:47:09.232151	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.29.1	\N	\N	6230426254
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2025-08-26 14:47:09.35552	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.29.1	\N	\N	6230426254
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2025-08-26 14:47:09.361554	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.29.1	\N	\N	6230426254
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2025-08-26 14:47:09.497454	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.29.1	\N	\N	6230426254
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2025-08-26 14:47:09.525941	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.29.1	\N	\N	6230426254
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2025-08-26 14:47:09.567118	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.29.1	\N	\N	6230426254
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2025-08-26 14:47:09.575708	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.29.1	\N	\N	6230426254
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-08-26 14:47:09.587059	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6230426254
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-08-26 14:47:09.591272	34	MARK_RAN	9:3a32bace77c84d7678d035a7f5a8084e	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.29.1	\N	\N	6230426254
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-08-26 14:47:09.649746	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.29.1	\N	\N	6230426254
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2025-08-26 14:47:09.662548	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.29.1	\N	\N	6230426254
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2025-08-26 14:47:09.686764	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	6230426254
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2025-08-26 14:47:09.694565	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.29.1	\N	\N	6230426254
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2025-08-26 14:47:09.703117	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.29.1	\N	\N	6230426254
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-08-26 14:47:09.708819	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.29.1	\N	\N	6230426254
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-08-26 14:47:09.712682	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.29.1	\N	\N	6230426254
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2025-08-26 14:47:09.72368	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.29.1	\N	\N	6230426254
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2025-08-26 14:47:12.18519	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.29.1	\N	\N	6230426254
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2025-08-26 14:47:12.191829	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.29.1	\N	\N	6230426254
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-08-26 14:47:12.19657	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.29.1	\N	\N	6230426254
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-08-26 14:47:12.201516	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.29.1	\N	\N	6230426254
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-08-26 14:47:12.203924	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.29.1	\N	\N	6230426254
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-08-26 14:47:12.314769	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.29.1	\N	\N	6230426254
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2025-08-26 14:47:12.320284	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.29.1	\N	\N	6230426254
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2025-08-26 14:47:12.372568	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.29.1	\N	\N	6230426254
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2025-08-26 14:47:12.647354	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.29.1	\N	\N	6230426254
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2025-08-26 14:47:12.651778	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6230426254
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2025-08-26 14:47:12.654173	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.29.1	\N	\N	6230426254
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2025-08-26 14:47:12.656293	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.29.1	\N	\N	6230426254
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-08-26 14:47:12.662299	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.29.1	\N	\N	6230426254
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-08-26 14:47:12.668964	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.29.1	\N	\N	6230426254
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-08-26 14:47:12.708085	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.29.1	\N	\N	6230426254
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2025-08-26 14:47:12.986437	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.29.1	\N	\N	6230426254
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2025-08-26 14:47:13.009026	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.29.1	\N	\N	6230426254
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2025-08-26 14:47:13.013861	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.29.1	\N	\N	6230426254
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-08-26 14:47:13.020042	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.29.1	\N	\N	6230426254
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2025-08-26 14:47:13.025522	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.29.1	\N	\N	6230426254
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2025-08-26 14:47:13.031053	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.29.1	\N	\N	6230426254
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2025-08-26 14:47:13.034836	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.29.1	\N	\N	6230426254
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2025-08-26 14:47:13.038425	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.29.1	\N	\N	6230426254
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2025-08-26 14:47:13.073378	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.29.1	\N	\N	6230426254
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2025-08-26 14:47:13.102987	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.29.1	\N	\N	6230426254
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2025-08-26 14:47:13.107392	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.29.1	\N	\N	6230426254
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2025-08-26 14:47:13.138178	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.29.1	\N	\N	6230426254
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2025-08-26 14:47:13.143916	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.29.1	\N	\N	6230426254
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2025-08-26 14:47:13.148362	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.29.1	\N	\N	6230426254
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-08-26 14:47:13.153718	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	6230426254
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-08-26 14:47:13.16037	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	6230426254
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-08-26 14:47:13.162536	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.29.1	\N	\N	6230426254
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-08-26 14:47:13.179018	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.29.1	\N	\N	6230426254
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2025-08-26 14:47:13.218768	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.29.1	\N	\N	6230426254
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-08-26 14:47:13.224285	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.29.1	\N	\N	6230426254
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-08-26 14:47:13.226519	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.29.1	\N	\N	6230426254
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-08-26 14:47:13.246918	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.29.1	\N	\N	6230426254
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2025-08-26 14:47:13.249412	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.29.1	\N	\N	6230426254
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-08-26 14:47:13.278782	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.29.1	\N	\N	6230426254
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-08-26 14:47:13.28042	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	6230426254
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-08-26 14:47:13.284504	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	6230426254
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-08-26 14:47:13.286666	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.29.1	\N	\N	6230426254
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2025-08-26 14:47:13.322569	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	6230426254
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2025-08-26 14:47:13.327882	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.29.1	\N	\N	6230426254
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-08-26 14:47:13.33533	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.29.1	\N	\N	6230426254
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2025-08-26 14:47:13.347322	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.29.1	\N	\N	6230426254
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-08-26 14:47:13.352774	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.29.1	\N	\N	6230426254
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-08-26 14:47:13.358817	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.29.1	\N	\N	6230426254
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-08-26 14:47:13.400173	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6230426254
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-08-26 14:47:13.408415	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.29.1	\N	\N	6230426254
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-08-26 14:47:13.410582	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.29.1	\N	\N	6230426254
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-08-26 14:47:13.419113	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.29.1	\N	\N	6230426254
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-08-26 14:47:13.421108	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.29.1	\N	\N	6230426254
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2025-08-26 14:47:13.430583	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.29.1	\N	\N	6230426254
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-08-26 14:47:13.534287	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6230426254
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-08-26 14:47:13.536553	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6230426254
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-08-26 14:47:13.546391	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6230426254
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-08-26 14:47:13.592197	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6230426254
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-08-26 14:47:13.595089	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6230426254
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-08-26 14:47:13.648048	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.29.1	\N	\N	6230426254
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2025-08-26 14:47:13.655391	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.29.1	\N	\N	6230426254
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2025-08-26 14:47:13.662748	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.29.1	\N	\N	6230426254
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2025-08-26 14:47:13.704022	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.29.1	\N	\N	6230426254
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2025-08-26 14:47:13.741527	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.29.1	\N	\N	6230426254
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2025-08-26 14:47:13.787971	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.29.1	\N	\N	6230426254
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2025-08-26 14:47:13.796308	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.29.1	\N	\N	6230426254
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-08-26 14:47:13.839908	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.29.1	\N	\N	6230426254
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-08-26 14:47:13.842189	110	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.29.1	\N	\N	6230426254
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2025-08-26 14:47:13.848978	111	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6230426254
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2025-08-26 14:47:13.853445	112	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.29.1	\N	\N	6230426254
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-08-26 14:47:13.885379	113	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.29.1	\N	\N	6230426254
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2025-08-26 14:47:13.888964	114	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.29.1	\N	\N	6230426254
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-08-26 14:47:13.895806	115	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.29.1	\N	\N	6230426254
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2025-08-26 14:47:13.898563	116	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.29.1	\N	\N	6230426254
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-08-26 14:47:13.912048	117	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.29.1	\N	\N	6230426254
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2025-08-26 14:47:13.916786	118	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.29.1	\N	\N	6230426254
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-08-26 14:47:14.029589	119	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.29.1	\N	\N	6230426254
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-08-26 14:47:14.033977	120	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.29.1	\N	\N	6230426254
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-08-26 14:47:14.038609	121	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6230426254
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2025-08-26 14:47:14.067249	122	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6230426254
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-08-26 14:47:14.071335	123	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.29.1	\N	\N	6230426254
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-08-26 14:47:14.072857	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6230426254
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2025-08-26 14:47:14.074623	125	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.29.1	\N	\N	6230426254
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-08-26 14:47:14.079608	126	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	6230426254
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-08-26 14:47:14.105219	127	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6230426254
25.0.0-28265-index-cleanup	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-08-26 14:47:14.111003	128	EXECUTED	9:8c0cfa341a0474385b324f5c4b2dfcc1	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION; dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION; dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION; dropIndex ...		\N	4.29.1	\N	\N	6230426254
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-08-26 14:47:14.112855	129	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6230426254
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-08-26 14:47:14.13876	130	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.29.1	\N	\N	6230426254
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-08-26 14:47:14.160496	131	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	6230426254
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-08-26 14:47:14.173174	132	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	6230426254
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-08-26 14:47:14.174801	133	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.29.1	\N	\N	6230426254
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2025-08-26 14:47:14.22693	134	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.29.1	\N	\N	6230426254
26.0.0-org-alias	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-08-26 14:47:14.234871	135	EXECUTED	9:6ef7d63e4412b3c2d66ed179159886a4	addColumn tableName=ORG; update tableName=ORG; addNotNullConstraint columnName=ALIAS, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_ALIAS, tableName=ORG		\N	4.29.1	\N	\N	6230426254
26.0.0-org-group	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-08-26 14:47:14.241495	136	EXECUTED	9:da8e8087d80ef2ace4f89d8c5b9ca223	addColumn tableName=KEYCLOAK_GROUP; update tableName=KEYCLOAK_GROUP; addNotNullConstraint columnName=TYPE, tableName=KEYCLOAK_GROUP; customChange		\N	4.29.1	\N	\N	6230426254
26.0.0-org-indexes	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-08-26 14:47:14.289978	137	EXECUTED	9:79b05dcd610a8c7f25ec05135eec0857	createIndex indexName=IDX_ORG_DOMAIN_ORG_ID, tableName=ORG_DOMAIN		\N	4.29.1	\N	\N	6230426254
26.0.0-org-group-membership	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-08-26 14:47:14.296129	138	EXECUTED	9:a6ace2ce583a421d89b01ba2a28dc2d4	addColumn tableName=USER_GROUP_MEMBERSHIP; update tableName=USER_GROUP_MEMBERSHIP; addNotNullConstraint columnName=MEMBERSHIP_TYPE, tableName=USER_GROUP_MEMBERSHIP		\N	4.29.1	\N	\N	6230426254
31296-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-08-26 14:47:14.303889	139	EXECUTED	9:64ef94489d42a358e8304b0e245f0ed4	createTable tableName=REVOKED_TOKEN; addPrimaryKey constraintName=CONSTRAINT_RT, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	6230426254
31725-index-persist-revoked-access-tokens	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-08-26 14:47:14.332369	140	EXECUTED	9:b994246ec2bf7c94da881e1d28782c7b	createIndex indexName=IDX_REV_TOKEN_ON_EXPIRE, tableName=REVOKED_TOKEN		\N	4.29.1	\N	\N	6230426254
26.0.0-idps-for-login	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-08-26 14:47:14.386129	141	EXECUTED	9:51f5fffadf986983d4bd59582c6c1604	addColumn tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_REALM_ORG, tableName=IDENTITY_PROVIDER; createIndex indexName=IDX_IDP_FOR_LOGIN, tableName=IDENTITY_PROVIDER; customChange		\N	4.29.1	\N	\N	6230426254
26.0.0-32583-drop-redundant-index-on-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-08-26 14:47:14.389326	142	EXECUTED	9:24972d83bf27317a055d234187bb4af9	dropIndex indexName=IDX_US_SESS_ID_ON_CL_SESS, tableName=OFFLINE_CLIENT_SESSION		\N	4.29.1	\N	\N	6230426254
26.0.0.32582-remove-tables-user-session-user-session-note-and-client-session	keycloak	META-INF/jpa-changelog-26.0.0.xml	2025-08-26 14:47:14.398206	143	EXECUTED	9:febdc0f47f2ed241c59e60f58c3ceea5	dropTable tableName=CLIENT_SESSION_ROLE; dropTable tableName=CLIENT_SESSION_NOTE; dropTable tableName=CLIENT_SESSION_PROT_MAPPER; dropTable tableName=CLIENT_SESSION_AUTH_STATUS; dropTable tableName=CLIENT_USER_SESSION_NOTE; dropTable tableName=CLI...		\N	4.29.1	\N	\N	6230426254
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
d40720ce-7492-4ad3-84a5-148310a9b1c1	bcbb8e3d-4c87-4fd9-811e-20a5e92f8a74	f
d40720ce-7492-4ad3-84a5-148310a9b1c1	b956e36d-c3a5-4d3d-bc73-7fe3fbd2aa94	t
d40720ce-7492-4ad3-84a5-148310a9b1c1	cb0bd8c9-6358-4607-b85e-970309cf6569	t
d40720ce-7492-4ad3-84a5-148310a9b1c1	ca0de01c-4114-4dcf-a79d-54c719e436bb	t
d40720ce-7492-4ad3-84a5-148310a9b1c1	a1aaa576-32b8-4a19-811d-7f95bc9785f2	t
d40720ce-7492-4ad3-84a5-148310a9b1c1	3612307b-8507-42ba-b8d0-f2de49f0aaba	f
d40720ce-7492-4ad3-84a5-148310a9b1c1	fda8b94a-9da8-4266-a569-f8fa99fcd881	f
d40720ce-7492-4ad3-84a5-148310a9b1c1	fda9647d-e610-4642-b958-d2caacea8f99	t
d40720ce-7492-4ad3-84a5-148310a9b1c1	5f19e33d-5896-4eb1-9a23-5e1aea15b2cc	t
d40720ce-7492-4ad3-84a5-148310a9b1c1	02724f9e-2e88-4f35-a095-196dfe89763a	f
d40720ce-7492-4ad3-84a5-148310a9b1c1	f127b484-edd6-4d0e-84ac-bfb476827f14	t
d40720ce-7492-4ad3-84a5-148310a9b1c1	4b8ddae4-b4be-4067-96cd-024e0f99d621	t
d40720ce-7492-4ad3-84a5-148310a9b1c1	7f62e7be-a9e2-4b14-826e-da679a297e4e	f
71093b75-f667-4192-826f-bd9b1f26e9be	e777f7a5-1014-427b-bcd5-55b94f30f368	f
71093b75-f667-4192-826f-bd9b1f26e9be	7051ae3b-476b-4e26-a82f-876abf141579	t
71093b75-f667-4192-826f-bd9b1f26e9be	5f438baa-1928-4e43-8bd9-e1dd6f361ad5	t
71093b75-f667-4192-826f-bd9b1f26e9be	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a	t
71093b75-f667-4192-826f-bd9b1f26e9be	f3285eab-4a6a-4db0-bec7-8108df07e640	t
71093b75-f667-4192-826f-bd9b1f26e9be	3781dcb5-17d2-4a11-89bc-15dfcf3ea938	f
71093b75-f667-4192-826f-bd9b1f26e9be	a2cc037a-46b1-4731-9640-9d336586f984	f
71093b75-f667-4192-826f-bd9b1f26e9be	a65db840-4e0c-4cba-bc96-f26e53c1c750	t
71093b75-f667-4192-826f-bd9b1f26e9be	fc988eed-3626-4ce5-93b3-c73e75bd07e4	t
71093b75-f667-4192-826f-bd9b1f26e9be	e8b14079-c5b8-441d-8156-71b4d78d032a	f
71093b75-f667-4192-826f-bd9b1f26e9be	eae3a44f-b905-4154-bfd7-98fad0bb7c07	t
71093b75-f667-4192-826f-bd9b1f26e9be	39f4c888-537c-493f-a486-8adc4ebb9299	t
71093b75-f667-4192-826f-bd9b1f26e9be	d60c96ab-8381-4996-a39f-a3ba6718ece2	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only, organization_id, hide_on_login) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.keycloak_group (id, name, parent_group, realm_id, type) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
09694323-0efb-4bcf-b6ce-691ba922605b	d40720ce-7492-4ad3-84a5-148310a9b1c1	f	${role_default-roles}	default-roles-master	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N	\N
62a3c8e7-2950-4a28-b949-7bc82037184f	d40720ce-7492-4ad3-84a5-148310a9b1c1	f	${role_create-realm}	create-realm	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N	\N
8613ae31-d596-4ea0-838e-f99c67defba1	d40720ce-7492-4ad3-84a5-148310a9b1c1	f	${role_admin}	admin	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N	\N
eb9f3111-0cbf-49e9-b8ca-1120c4a09773	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_create-client}	create-client	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
99de1ba3-68e9-433d-a780-1313f0532db4	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_view-realm}	view-realm	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
0747e71a-40c9-4493-8692-195181549f4b	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_view-users}	view-users	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
23eeb889-04a3-426f-905e-632579b80286	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_view-clients}	view-clients	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
7259e5cc-7940-46b4-adeb-54633a47d78b	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_view-events}	view-events	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
ad65f360-32fb-4394-a475-5d5e35ca1e8a	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_view-identity-providers}	view-identity-providers	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
61d6cc83-7e70-42ad-819b-e1b985845def	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_view-authorization}	view-authorization	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
3a0229cf-563f-43ae-a82c-bd9b84187514	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_manage-realm}	manage-realm	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
8e42bb0a-11cc-484e-aa39-e12e59656eda	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_manage-users}	manage-users	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
0837f3e0-804b-4987-9518-0e48ed17ceec	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_manage-clients}	manage-clients	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
6e65d07b-1f82-459d-8d04-36d37aac7302	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_manage-events}	manage-events	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
926d4963-4f1d-4480-bc93-4df33e2975be	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_manage-identity-providers}	manage-identity-providers	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
dbcacf14-b509-4627-91ea-e1c913a530b4	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_manage-authorization}	manage-authorization	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
fd10e590-38c5-41ed-b6f6-540ce1d844b7	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_query-users}	query-users	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
fa9250e4-06db-4a7b-8903-f4e5ad15a055	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_query-clients}	query-clients	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
fc9122e6-cb5e-42cf-9ceb-5e8b0137c769	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_query-realms}	query-realms	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
7e481355-7535-40ed-b955-2fa8aed8a4c2	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_query-groups}	query-groups	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
8ca66fe0-3cdb-438f-bee9-dad9b425f8d5	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	t	${role_view-profile}	view-profile	d40720ce-7492-4ad3-84a5-148310a9b1c1	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	\N
0d6c7652-72d6-4bba-b70e-d9db79977011	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	t	${role_manage-account}	manage-account	d40720ce-7492-4ad3-84a5-148310a9b1c1	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	\N
3a142c30-91ec-4276-8c39-b3ebef59f87d	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	t	${role_manage-account-links}	manage-account-links	d40720ce-7492-4ad3-84a5-148310a9b1c1	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	\N
f15ca3a7-c019-4393-831f-b5994442f184	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	t	${role_view-applications}	view-applications	d40720ce-7492-4ad3-84a5-148310a9b1c1	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	\N
60832d89-aea5-42cc-8813-7bc4cc2b70d2	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	t	${role_view-consent}	view-consent	d40720ce-7492-4ad3-84a5-148310a9b1c1	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	\N
0ed4c9a9-a142-443d-a7d4-619a4c6906c3	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	t	${role_manage-consent}	manage-consent	d40720ce-7492-4ad3-84a5-148310a9b1c1	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	\N
8cf3791b-3c8d-4e7c-8729-00c3d7232e67	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	t	${role_view-groups}	view-groups	d40720ce-7492-4ad3-84a5-148310a9b1c1	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	\N
f4233494-b7e6-4a38-bb5d-50defb181e29	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	t	${role_delete-account}	delete-account	d40720ce-7492-4ad3-84a5-148310a9b1c1	bfda7933-3aec-4ad5-a8a5-2be68a46cb12	\N
a107b3c3-8c8f-4061-8ed3-e53fa60f7090	2978863b-accd-411e-ae79-7ddf474e3a56	t	${role_read-token}	read-token	d40720ce-7492-4ad3-84a5-148310a9b1c1	2978863b-accd-411e-ae79-7ddf474e3a56	\N
f104bc38-50b1-4c13-890c-33167cbb61d7	49690866-2d77-4fac-9963-cb59b8fcd25f	t	${role_impersonation}	impersonation	d40720ce-7492-4ad3-84a5-148310a9b1c1	49690866-2d77-4fac-9963-cb59b8fcd25f	\N
eaa4fb16-c359-41be-93f1-37525ac18e91	d40720ce-7492-4ad3-84a5-148310a9b1c1	f	${role_offline-access}	offline_access	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N	\N
bac1a777-c8f9-46f9-98b5-dcf6b3b4e018	d40720ce-7492-4ad3-84a5-148310a9b1c1	f	${role_uma_authorization}	uma_authorization	d40720ce-7492-4ad3-84a5-148310a9b1c1	\N	\N
936850eb-9be2-4c76-b572-0ab7d4f5d621	71093b75-f667-4192-826f-bd9b1f26e9be	f	${role_default-roles}	default-roles-karhub-beer	71093b75-f667-4192-826f-bd9b1f26e9be	\N	\N
af4267ad-b59c-47b6-a7b5-1e84f264aa02	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_create-client}	create-client	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
9e240d41-0ea3-4bbf-8779-7a0a128eafab	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_view-realm}	view-realm	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
073a88e3-863d-415b-b87d-660c9c60c206	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_view-users}	view-users	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
09e5b341-4bb6-4f74-8a34-52c3ba52e656	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_view-clients}	view-clients	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
1f90c5c9-2525-4ef4-a6cb-4cf9190c8900	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_view-events}	view-events	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
6f7fbb27-bdf1-4e76-a491-3a0fcacf0953	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_view-identity-providers}	view-identity-providers	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
009088aa-e4bb-48b9-8984-39a0444b712b	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_view-authorization}	view-authorization	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
71aa3a63-b552-4d4e-b080-2025c45fa9db	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_manage-realm}	manage-realm	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
4249500b-84d8-4e36-b76e-65a1ad57fe39	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_manage-users}	manage-users	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
96d8c311-bba7-45ed-93ef-8a41bbc75688	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_manage-clients}	manage-clients	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
e22bfaec-833c-4d39-b636-e6848bdcf029	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_manage-events}	manage-events	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
6af6534a-bff1-4008-91b3-278f7767552e	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_manage-identity-providers}	manage-identity-providers	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
e4a6bb33-8670-4ade-8dcd-7b71f0029116	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_manage-authorization}	manage-authorization	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
8df4a48c-5f4d-49ff-af18-49d48760d5e2	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_query-users}	query-users	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
fbc5a399-64f9-4c83-b476-ef91a20799d8	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_query-clients}	query-clients	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
c7a105b8-4103-4d65-9d3c-45f448db95fc	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_query-realms}	query-realms	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
14de2516-829b-4d2c-9bf4-3ddca87ffd9c	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_query-groups}	query-groups	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
5977c9f8-cdd1-44ae-8485-a3fb78cfbd31	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_realm-admin}	realm-admin	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
fefdbda1-11eb-4858-a42b-d6106c25503c	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_create-client}	create-client	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
b05e845e-9c99-455d-a060-ffbe162adaac	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_view-realm}	view-realm	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
e6ddedd6-a164-4a06-938f-c00dac0a51c4	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_view-users}	view-users	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
a2868589-85e6-4915-8a95-0b7761630082	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_view-clients}	view-clients	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
2f002d38-2db6-4059-b349-51df182ad393	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_view-events}	view-events	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
9b0146ae-7010-48a2-87bf-b75e2fbbab6e	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_view-identity-providers}	view-identity-providers	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
02247826-28fc-40ce-bc43-9a650a9147b8	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_view-authorization}	view-authorization	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
6a3e7fa2-746f-477e-bad2-b392f6122c6e	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_manage-realm}	manage-realm	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
3d40cab7-fc2b-48a7-9078-5594218875fa	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_manage-users}	manage-users	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
40455c56-4404-4733-8a0a-80e797426dc6	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_manage-clients}	manage-clients	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
2f7b793d-4d69-4f81-8396-54843946b1a4	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_manage-events}	manage-events	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
0c3e85be-5c8f-4fc3-b2d8-a6e8da41c74c	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_manage-identity-providers}	manage-identity-providers	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
cf7d722a-6f49-4b5d-971e-76d8dabb0e2a	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_manage-authorization}	manage-authorization	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
fd4441bc-7ae0-4f2b-8c43-23af992e3b16	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_query-users}	query-users	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
14b7b5ac-65e1-4844-9605-56bec1132b6f	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_query-clients}	query-clients	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
430b6898-b3aa-4408-b2b3-023d7b328d8d	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_query-realms}	query-realms	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
11e27fae-ce04-44fe-b7e8-455ebf2da2c0	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_query-groups}	query-groups	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
a3821c53-9200-412d-8840-c115555fe53f	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	t	${role_view-profile}	view-profile	71093b75-f667-4192-826f-bd9b1f26e9be	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	\N
1b8e44dc-fa4b-49c3-88ff-cb15ca910ac3	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	t	${role_manage-account}	manage-account	71093b75-f667-4192-826f-bd9b1f26e9be	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	\N
6758181d-f3fe-40e9-bf61-98c41c9010a5	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	t	${role_manage-account-links}	manage-account-links	71093b75-f667-4192-826f-bd9b1f26e9be	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	\N
88f3586c-b706-40a4-8d80-ff8f7686fe0b	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	t	${role_view-applications}	view-applications	71093b75-f667-4192-826f-bd9b1f26e9be	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	\N
64ec4761-5056-4712-816a-1e25e08e8717	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	t	${role_view-consent}	view-consent	71093b75-f667-4192-826f-bd9b1f26e9be	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	\N
c71ec187-4777-4df2-bba5-bcbf96a4487a	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	t	${role_manage-consent}	manage-consent	71093b75-f667-4192-826f-bd9b1f26e9be	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	\N
388940fe-31a1-4ed2-808a-6a4173ce72a6	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	t	${role_view-groups}	view-groups	71093b75-f667-4192-826f-bd9b1f26e9be	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	\N
73d3bac6-ef07-4ad1-b48b-0b6c59c77746	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	t	${role_delete-account}	delete-account	71093b75-f667-4192-826f-bd9b1f26e9be	a2881323-87fb-47fe-bf7b-99b8e8fc99ec	\N
260536ad-0d65-4c9c-86da-06706cb16abe	decc8268-c8bc-4e20-b15e-760d32d05e4f	t	${role_impersonation}	impersonation	d40720ce-7492-4ad3-84a5-148310a9b1c1	decc8268-c8bc-4e20-b15e-760d32d05e4f	\N
9a3b032d-fcdd-4f3e-bb7a-0d8f8b347e55	4a6b1732-20df-4d7a-8174-25a88c05e430	t	${role_impersonation}	impersonation	71093b75-f667-4192-826f-bd9b1f26e9be	4a6b1732-20df-4d7a-8174-25a88c05e430	\N
07559099-e087-4ef5-b87f-358b404127d6	dcc4bb07-e78c-4b16-97f0-15717787e4d8	t	${role_read-token}	read-token	71093b75-f667-4192-826f-bd9b1f26e9be	dcc4bb07-e78c-4b16-97f0-15717787e4d8	\N
a4291b41-533f-4fbc-b40c-9bd5c6436268	71093b75-f667-4192-826f-bd9b1f26e9be	f	${role_offline-access}	offline_access	71093b75-f667-4192-826f-bd9b1f26e9be	\N	\N
540265cd-ed8a-4098-a7e1-686a022f0adb	71093b75-f667-4192-826f-bd9b1f26e9be	f	${role_uma_authorization}	uma_authorization	71093b75-f667-4192-826f-bd9b1f26e9be	\N	\N
d393124d-5dac-4250-9921-7bc6007b41b4	72c394f7-ad70-432e-a0f4-715ee92e6ad2	t		user	71093b75-f667-4192-826f-bd9b1f26e9be	72c394f7-ad70-432e-a0f4-715ee92e6ad2	\N
897a897e-b42a-4ddb-a3da-9337a370016c	72c394f7-ad70-432e-a0f4-715ee92e6ad2	t		admin	71093b75-f667-4192-826f-bd9b1f26e9be	72c394f7-ad70-432e-a0f4-715ee92e6ad2	\N
ff77512b-6781-40a7-902a-725982110120	71093b75-f667-4192-826f-bd9b1f26e9be	f		admin	71093b75-f667-4192-826f-bd9b1f26e9be	\N	\N
14aadcd4-baef-49eb-847c-1ad5103813df	71093b75-f667-4192-826f-bd9b1f26e9be	f		user	71093b75-f667-4192-826f-bd9b1f26e9be	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.migration_model (id, version, update_time) FROM stdin;
ob1qe	26.0.0	1756230434
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version) FROM stdin;
1bc195e8-6bd3-4768-9fb8-0d6589da7cf5	e856bd8e-0a2c-41b0-8b72-ff1b354380ff	0	1756583746	{"authMethod":"openid-connect","redirectUri":"http://localhost:8080/admin/master/console/","notes":{"clientId":"e856bd8e-0a2c-41b0-8b72-ff1b354380ff","iss":"http://localhost:8080/realms/master","startedAt":"1756583745","response_type":"code","level-of-authentication":"-1","code_challenge_method":"S256","nonce":"78c4f6e7-ed81-44dd-bc41-a1be5c02fb13","response_mode":"query","scope":"openid","userSessionStartedAt":"1756583745","redirect_uri":"http://localhost:8080/admin/master/console/","state":"bd4b5d11-8a77-4f74-9a17-8ca3437cb754","code_challenge":"Uz0FcA8KV39DQGMNMg7r-jjW1bxdqOv9tToF50T2rF0"}}	local	local	1
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version) FROM stdin;
1bc195e8-6bd3-4768-9fb8-0d6589da7cf5	bfc5c1ae-64e7-4c6f-bae0-61bac2dea4e7	d40720ce-7492-4ad3-84a5-148310a9b1c1	1756583745	0	{"ipAddress":"172.20.0.1","authMethod":"openid-connect","rememberMe":false,"started":0,"notes":{"KC_DEVICE_NOTE":"eyJpcEFkZHJlc3MiOiIxNzIuMjAuMC4xIiwib3MiOiJXaW5kb3dzIiwib3NWZXJzaW9uIjoiMTAiLCJicm93c2VyIjoiQ2hyb21lLzEzOS4wLjAiLCJkZXZpY2UiOiJPdGhlciIsImxhc3RBY2Nlc3MiOjAsIm1vYmlsZSI6ZmFsc2V9","AUTH_TIME":"1756583745","authenticators-completed":"{\\"bb2c6256-a94f-45d9-aec0-71f124459c66\\":1756583745}"},"state":"LOGGED_IN"}	1756583746	\N	1
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.org (id, enabled, realm_id, group_id, name, description, alias, redirect_url) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
f3eed72a-ea13-4817-9180-23f9dbca49cb	audience resolve	openid-connect	oidc-audience-resolve-mapper	8a60bf99-9478-4220-a5a6-0f521fa6c5ca	\N
2c76e1fd-e5d6-4d96-8113-b737c1a8aed4	locale	openid-connect	oidc-usermodel-attribute-mapper	e856bd8e-0a2c-41b0-8b72-ff1b354380ff	\N
1228680e-ed72-4a82-9c15-1e682285ebf4	role list	saml	saml-role-list-mapper	\N	b956e36d-c3a5-4d3d-bc73-7fe3fbd2aa94
540338a3-457d-4a12-9d6f-ea842257e745	organization	saml	saml-organization-membership-mapper	\N	cb0bd8c9-6358-4607-b85e-970309cf6569
4c9cc6d8-d017-4315-aedf-e4998672350f	full name	openid-connect	oidc-full-name-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
b6dbddd7-e208-49d2-bd6d-1873fd405217	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
b5e8ecea-e421-4e0c-b8be-1e586ceaa809	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
9d1b119d-a70a-46ad-a00e-936fe3dd08ab	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
9c4aebda-35a1-4153-89dc-92a31fbc13a2	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
85a73151-48e3-4b3f-a0c3-355c64bf1a17	username	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
c6f2b281-284e-4ae9-926c-0fcb88d35530	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
f41d1516-5c84-4919-ae91-c39647658dac	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
f0718c25-b1c0-483c-860e-cfcea3c1ecc1	website	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
a74fe751-bcc4-42a8-98d9-ebc9df43d82b	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
47d58809-9d1a-4f32-9830-1e9752d9addf	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
af7d820d-e2cd-4084-b6ba-69724e26c71b	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
e00004bd-f76d-4051-b2b9-eddf9aa572bb	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
9d07eaa7-0acf-41b2-85c8-6679f4f2bf04	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	ca0de01c-4114-4dcf-a79d-54c719e436bb
79295431-33ca-4011-9020-f9e5dab8b21b	email	openid-connect	oidc-usermodel-attribute-mapper	\N	a1aaa576-32b8-4a19-811d-7f95bc9785f2
9806ec37-cfd5-4f46-9291-b72eab654ca8	email verified	openid-connect	oidc-usermodel-property-mapper	\N	a1aaa576-32b8-4a19-811d-7f95bc9785f2
71c482cd-13a5-4bb4-8cfa-63336612a471	address	openid-connect	oidc-address-mapper	\N	3612307b-8507-42ba-b8d0-f2de49f0aaba
a7efbf32-cba4-4d46-8ed3-42f82a547c54	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	fda8b94a-9da8-4266-a569-f8fa99fcd881
df4f0cea-5714-4304-8087-7cfc2859058b	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	fda8b94a-9da8-4266-a569-f8fa99fcd881
2c78476e-af97-40f2-9d5d-d976ad3c361f	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	fda9647d-e610-4642-b958-d2caacea8f99
88dfb934-0ed6-4736-9b3d-a82f43353c42	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	fda9647d-e610-4642-b958-d2caacea8f99
4112936a-8433-4222-8e38-7f25563a1268	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	fda9647d-e610-4642-b958-d2caacea8f99
09f756f0-426c-46b8-b665-eca53ac69407	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	5f19e33d-5896-4eb1-9a23-5e1aea15b2cc
7c5a9a0f-efcb-4b71-8345-dc69329cb792	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	02724f9e-2e88-4f35-a095-196dfe89763a
eac586b0-9042-40ad-9a10-f2e9a9613358	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	02724f9e-2e88-4f35-a095-196dfe89763a
54cb0f77-b625-4327-a5d3-682d86097697	acr loa level	openid-connect	oidc-acr-mapper	\N	f127b484-edd6-4d0e-84ac-bfb476827f14
16296ca3-8392-41d5-aa45-c59fbb8d761b	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	4b8ddae4-b4be-4067-96cd-024e0f99d621
867456e7-aabe-453d-8fa2-1053770dd569	sub	openid-connect	oidc-sub-mapper	\N	4b8ddae4-b4be-4067-96cd-024e0f99d621
0b9f60c7-2e8b-4841-918c-83eb2532c0cf	organization	openid-connect	oidc-organization-membership-mapper	\N	7f62e7be-a9e2-4b14-826e-da679a297e4e
64b857c5-3468-4428-af6f-a9e3e5081684	audience resolve	openid-connect	oidc-audience-resolve-mapper	df8dc7fb-12f6-4519-a7b2-884651fad866	\N
9c166360-f572-4aee-a257-f2ae6be971c7	role list	saml	saml-role-list-mapper	\N	7051ae3b-476b-4e26-a82f-876abf141579
1c48e856-209c-4cb7-b583-94499dac42a7	organization	saml	saml-organization-membership-mapper	\N	5f438baa-1928-4e43-8bd9-e1dd6f361ad5
9da79485-9750-4970-a3e7-5a8b0fc71ddb	full name	openid-connect	oidc-full-name-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
f38b2eab-6358-45cd-9fa2-d4f295c65213	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
983b88b3-76bd-407f-a7a5-7e9ac0bff9f6	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
a64692a3-de79-4240-ba7c-1ee0499c786b	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
75fec4a9-207c-46d4-8473-670ce9e39975	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
f616af44-0dd5-4fe0-8359-b139601b14fa	username	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
deff72c8-c592-4c53-8f4b-7fe20f857127	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
626c9f08-8769-49c3-922c-0ff7975c3142	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
8d0d4bc0-39b3-4133-bf34-cf6ddba310c5	website	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
77e6d42d-6c5f-408a-923d-175c4529ba2b	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
7eaa96e3-e43f-4058-8b4e-21208fbd1417	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
9fecb746-b28a-46be-ba6b-97941a27794d	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
7b7ff0f4-9f76-493c-94f0-92700ea33ee0	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
1db5fdc5-dd8b-4fd1-ab4c-2032fb501e6f	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	55aa21d1-3b61-4dab-8b15-cd7e8d4ab66a
6b031e69-2602-4db7-be87-d84c40c4f7e5	email	openid-connect	oidc-usermodel-attribute-mapper	\N	f3285eab-4a6a-4db0-bec7-8108df07e640
cb1126df-f009-4626-8f95-e967169169a6	email verified	openid-connect	oidc-usermodel-property-mapper	\N	f3285eab-4a6a-4db0-bec7-8108df07e640
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	address	openid-connect	oidc-address-mapper	\N	3781dcb5-17d2-4a11-89bc-15dfcf3ea938
c70f1055-ddc0-48e6-8e72-1e4509ea185b	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	a2cc037a-46b1-4731-9640-9d336586f984
b6bd893d-f987-4496-aae6-476ba9585508	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	a2cc037a-46b1-4731-9640-9d336586f984
788aebd7-6f49-494a-8ac9-391065f70d87	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	a65db840-4e0c-4cba-bc96-f26e53c1c750
8f48008e-63c2-4f74-a770-862d485e2d7b	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	a65db840-4e0c-4cba-bc96-f26e53c1c750
bf4421c4-d9a0-46df-96a8-a916c048ef38	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	a65db840-4e0c-4cba-bc96-f26e53c1c750
ec98978c-7394-42f3-81eb-436d0541b9d1	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	fc988eed-3626-4ce5-93b3-c73e75bd07e4
22a3776a-5fc2-4235-879e-ea71c2a8e10f	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	e8b14079-c5b8-441d-8156-71b4d78d032a
2e30398a-54d8-41a4-96bc-feb7ddff357d	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	e8b14079-c5b8-441d-8156-71b4d78d032a
fb0af181-05a3-4c6e-9d5e-0a645afd6465	acr loa level	openid-connect	oidc-acr-mapper	\N	eae3a44f-b905-4154-bfd7-98fad0bb7c07
ec28a5e8-53c1-4b4d-87d4-169043699909	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	39f4c888-537c-493f-a486-8adc4ebb9299
516e2dd1-2392-494f-91a4-80d82dca7ef5	sub	openid-connect	oidc-sub-mapper	\N	39f4c888-537c-493f-a486-8adc4ebb9299
23186559-bcc7-4b59-b1f8-722d76286286	organization	openid-connect	oidc-organization-membership-mapper	\N	d60c96ab-8381-4996-a39f-a3ba6718ece2
e014e92e-3520-4688-9480-6e6278ea6f01	locale	openid-connect	oidc-usermodel-attribute-mapper	a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	\N
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
2c76e1fd-e5d6-4d96-8113-b737c1a8aed4	true	introspection.token.claim
2c76e1fd-e5d6-4d96-8113-b737c1a8aed4	true	userinfo.token.claim
2c76e1fd-e5d6-4d96-8113-b737c1a8aed4	locale	user.attribute
2c76e1fd-e5d6-4d96-8113-b737c1a8aed4	true	id.token.claim
2c76e1fd-e5d6-4d96-8113-b737c1a8aed4	true	access.token.claim
2c76e1fd-e5d6-4d96-8113-b737c1a8aed4	locale	claim.name
2c76e1fd-e5d6-4d96-8113-b737c1a8aed4	String	jsonType.label
1228680e-ed72-4a82-9c15-1e682285ebf4	false	single
1228680e-ed72-4a82-9c15-1e682285ebf4	Basic	attribute.nameformat
1228680e-ed72-4a82-9c15-1e682285ebf4	Role	attribute.name
47d58809-9d1a-4f32-9830-1e9752d9addf	true	introspection.token.claim
47d58809-9d1a-4f32-9830-1e9752d9addf	true	userinfo.token.claim
47d58809-9d1a-4f32-9830-1e9752d9addf	birthdate	user.attribute
47d58809-9d1a-4f32-9830-1e9752d9addf	true	id.token.claim
47d58809-9d1a-4f32-9830-1e9752d9addf	true	access.token.claim
47d58809-9d1a-4f32-9830-1e9752d9addf	birthdate	claim.name
47d58809-9d1a-4f32-9830-1e9752d9addf	String	jsonType.label
4c9cc6d8-d017-4315-aedf-e4998672350f	true	introspection.token.claim
4c9cc6d8-d017-4315-aedf-e4998672350f	true	userinfo.token.claim
4c9cc6d8-d017-4315-aedf-e4998672350f	true	id.token.claim
4c9cc6d8-d017-4315-aedf-e4998672350f	true	access.token.claim
85a73151-48e3-4b3f-a0c3-355c64bf1a17	true	introspection.token.claim
85a73151-48e3-4b3f-a0c3-355c64bf1a17	true	userinfo.token.claim
85a73151-48e3-4b3f-a0c3-355c64bf1a17	username	user.attribute
85a73151-48e3-4b3f-a0c3-355c64bf1a17	true	id.token.claim
85a73151-48e3-4b3f-a0c3-355c64bf1a17	true	access.token.claim
85a73151-48e3-4b3f-a0c3-355c64bf1a17	preferred_username	claim.name
85a73151-48e3-4b3f-a0c3-355c64bf1a17	String	jsonType.label
9c4aebda-35a1-4153-89dc-92a31fbc13a2	true	introspection.token.claim
9c4aebda-35a1-4153-89dc-92a31fbc13a2	true	userinfo.token.claim
9c4aebda-35a1-4153-89dc-92a31fbc13a2	nickname	user.attribute
9c4aebda-35a1-4153-89dc-92a31fbc13a2	true	id.token.claim
9c4aebda-35a1-4153-89dc-92a31fbc13a2	true	access.token.claim
9c4aebda-35a1-4153-89dc-92a31fbc13a2	nickname	claim.name
9c4aebda-35a1-4153-89dc-92a31fbc13a2	String	jsonType.label
9d07eaa7-0acf-41b2-85c8-6679f4f2bf04	true	introspection.token.claim
9d07eaa7-0acf-41b2-85c8-6679f4f2bf04	true	userinfo.token.claim
9d07eaa7-0acf-41b2-85c8-6679f4f2bf04	updatedAt	user.attribute
9d07eaa7-0acf-41b2-85c8-6679f4f2bf04	true	id.token.claim
9d07eaa7-0acf-41b2-85c8-6679f4f2bf04	true	access.token.claim
9d07eaa7-0acf-41b2-85c8-6679f4f2bf04	updated_at	claim.name
9d07eaa7-0acf-41b2-85c8-6679f4f2bf04	long	jsonType.label
9d1b119d-a70a-46ad-a00e-936fe3dd08ab	true	introspection.token.claim
9d1b119d-a70a-46ad-a00e-936fe3dd08ab	true	userinfo.token.claim
9d1b119d-a70a-46ad-a00e-936fe3dd08ab	middleName	user.attribute
9d1b119d-a70a-46ad-a00e-936fe3dd08ab	true	id.token.claim
9d1b119d-a70a-46ad-a00e-936fe3dd08ab	true	access.token.claim
9d1b119d-a70a-46ad-a00e-936fe3dd08ab	middle_name	claim.name
9d1b119d-a70a-46ad-a00e-936fe3dd08ab	String	jsonType.label
a74fe751-bcc4-42a8-98d9-ebc9df43d82b	true	introspection.token.claim
a74fe751-bcc4-42a8-98d9-ebc9df43d82b	true	userinfo.token.claim
a74fe751-bcc4-42a8-98d9-ebc9df43d82b	gender	user.attribute
a74fe751-bcc4-42a8-98d9-ebc9df43d82b	true	id.token.claim
a74fe751-bcc4-42a8-98d9-ebc9df43d82b	true	access.token.claim
a74fe751-bcc4-42a8-98d9-ebc9df43d82b	gender	claim.name
a74fe751-bcc4-42a8-98d9-ebc9df43d82b	String	jsonType.label
af7d820d-e2cd-4084-b6ba-69724e26c71b	true	introspection.token.claim
af7d820d-e2cd-4084-b6ba-69724e26c71b	true	userinfo.token.claim
af7d820d-e2cd-4084-b6ba-69724e26c71b	zoneinfo	user.attribute
af7d820d-e2cd-4084-b6ba-69724e26c71b	true	id.token.claim
af7d820d-e2cd-4084-b6ba-69724e26c71b	true	access.token.claim
af7d820d-e2cd-4084-b6ba-69724e26c71b	zoneinfo	claim.name
af7d820d-e2cd-4084-b6ba-69724e26c71b	String	jsonType.label
b5e8ecea-e421-4e0c-b8be-1e586ceaa809	true	introspection.token.claim
b5e8ecea-e421-4e0c-b8be-1e586ceaa809	true	userinfo.token.claim
b5e8ecea-e421-4e0c-b8be-1e586ceaa809	firstName	user.attribute
b5e8ecea-e421-4e0c-b8be-1e586ceaa809	true	id.token.claim
b5e8ecea-e421-4e0c-b8be-1e586ceaa809	true	access.token.claim
b5e8ecea-e421-4e0c-b8be-1e586ceaa809	given_name	claim.name
b5e8ecea-e421-4e0c-b8be-1e586ceaa809	String	jsonType.label
b6dbddd7-e208-49d2-bd6d-1873fd405217	true	introspection.token.claim
b6dbddd7-e208-49d2-bd6d-1873fd405217	true	userinfo.token.claim
b6dbddd7-e208-49d2-bd6d-1873fd405217	lastName	user.attribute
b6dbddd7-e208-49d2-bd6d-1873fd405217	true	id.token.claim
b6dbddd7-e208-49d2-bd6d-1873fd405217	true	access.token.claim
b6dbddd7-e208-49d2-bd6d-1873fd405217	family_name	claim.name
b6dbddd7-e208-49d2-bd6d-1873fd405217	String	jsonType.label
c6f2b281-284e-4ae9-926c-0fcb88d35530	true	introspection.token.claim
c6f2b281-284e-4ae9-926c-0fcb88d35530	true	userinfo.token.claim
c6f2b281-284e-4ae9-926c-0fcb88d35530	profile	user.attribute
c6f2b281-284e-4ae9-926c-0fcb88d35530	true	id.token.claim
c6f2b281-284e-4ae9-926c-0fcb88d35530	true	access.token.claim
c6f2b281-284e-4ae9-926c-0fcb88d35530	profile	claim.name
c6f2b281-284e-4ae9-926c-0fcb88d35530	String	jsonType.label
e00004bd-f76d-4051-b2b9-eddf9aa572bb	true	introspection.token.claim
e00004bd-f76d-4051-b2b9-eddf9aa572bb	true	userinfo.token.claim
e00004bd-f76d-4051-b2b9-eddf9aa572bb	locale	user.attribute
e00004bd-f76d-4051-b2b9-eddf9aa572bb	true	id.token.claim
e00004bd-f76d-4051-b2b9-eddf9aa572bb	true	access.token.claim
e00004bd-f76d-4051-b2b9-eddf9aa572bb	locale	claim.name
e00004bd-f76d-4051-b2b9-eddf9aa572bb	String	jsonType.label
f0718c25-b1c0-483c-860e-cfcea3c1ecc1	true	introspection.token.claim
f0718c25-b1c0-483c-860e-cfcea3c1ecc1	true	userinfo.token.claim
f0718c25-b1c0-483c-860e-cfcea3c1ecc1	website	user.attribute
f0718c25-b1c0-483c-860e-cfcea3c1ecc1	true	id.token.claim
f0718c25-b1c0-483c-860e-cfcea3c1ecc1	true	access.token.claim
f0718c25-b1c0-483c-860e-cfcea3c1ecc1	website	claim.name
f0718c25-b1c0-483c-860e-cfcea3c1ecc1	String	jsonType.label
f41d1516-5c84-4919-ae91-c39647658dac	true	introspection.token.claim
f41d1516-5c84-4919-ae91-c39647658dac	true	userinfo.token.claim
f41d1516-5c84-4919-ae91-c39647658dac	picture	user.attribute
f41d1516-5c84-4919-ae91-c39647658dac	true	id.token.claim
f41d1516-5c84-4919-ae91-c39647658dac	true	access.token.claim
f41d1516-5c84-4919-ae91-c39647658dac	picture	claim.name
f41d1516-5c84-4919-ae91-c39647658dac	String	jsonType.label
79295431-33ca-4011-9020-f9e5dab8b21b	true	introspection.token.claim
79295431-33ca-4011-9020-f9e5dab8b21b	true	userinfo.token.claim
79295431-33ca-4011-9020-f9e5dab8b21b	email	user.attribute
79295431-33ca-4011-9020-f9e5dab8b21b	true	id.token.claim
79295431-33ca-4011-9020-f9e5dab8b21b	true	access.token.claim
79295431-33ca-4011-9020-f9e5dab8b21b	email	claim.name
79295431-33ca-4011-9020-f9e5dab8b21b	String	jsonType.label
9806ec37-cfd5-4f46-9291-b72eab654ca8	true	introspection.token.claim
9806ec37-cfd5-4f46-9291-b72eab654ca8	true	userinfo.token.claim
9806ec37-cfd5-4f46-9291-b72eab654ca8	emailVerified	user.attribute
9806ec37-cfd5-4f46-9291-b72eab654ca8	true	id.token.claim
9806ec37-cfd5-4f46-9291-b72eab654ca8	true	access.token.claim
9806ec37-cfd5-4f46-9291-b72eab654ca8	email_verified	claim.name
9806ec37-cfd5-4f46-9291-b72eab654ca8	boolean	jsonType.label
71c482cd-13a5-4bb4-8cfa-63336612a471	formatted	user.attribute.formatted
71c482cd-13a5-4bb4-8cfa-63336612a471	country	user.attribute.country
71c482cd-13a5-4bb4-8cfa-63336612a471	true	introspection.token.claim
71c482cd-13a5-4bb4-8cfa-63336612a471	postal_code	user.attribute.postal_code
71c482cd-13a5-4bb4-8cfa-63336612a471	true	userinfo.token.claim
71c482cd-13a5-4bb4-8cfa-63336612a471	street	user.attribute.street
71c482cd-13a5-4bb4-8cfa-63336612a471	true	id.token.claim
71c482cd-13a5-4bb4-8cfa-63336612a471	region	user.attribute.region
71c482cd-13a5-4bb4-8cfa-63336612a471	true	access.token.claim
71c482cd-13a5-4bb4-8cfa-63336612a471	locality	user.attribute.locality
a7efbf32-cba4-4d46-8ed3-42f82a547c54	true	introspection.token.claim
a7efbf32-cba4-4d46-8ed3-42f82a547c54	true	userinfo.token.claim
a7efbf32-cba4-4d46-8ed3-42f82a547c54	phoneNumber	user.attribute
a7efbf32-cba4-4d46-8ed3-42f82a547c54	true	id.token.claim
a7efbf32-cba4-4d46-8ed3-42f82a547c54	true	access.token.claim
a7efbf32-cba4-4d46-8ed3-42f82a547c54	phone_number	claim.name
a7efbf32-cba4-4d46-8ed3-42f82a547c54	String	jsonType.label
df4f0cea-5714-4304-8087-7cfc2859058b	true	introspection.token.claim
df4f0cea-5714-4304-8087-7cfc2859058b	true	userinfo.token.claim
df4f0cea-5714-4304-8087-7cfc2859058b	phoneNumberVerified	user.attribute
df4f0cea-5714-4304-8087-7cfc2859058b	true	id.token.claim
df4f0cea-5714-4304-8087-7cfc2859058b	true	access.token.claim
df4f0cea-5714-4304-8087-7cfc2859058b	phone_number_verified	claim.name
df4f0cea-5714-4304-8087-7cfc2859058b	boolean	jsonType.label
2c78476e-af97-40f2-9d5d-d976ad3c361f	true	introspection.token.claim
2c78476e-af97-40f2-9d5d-d976ad3c361f	true	multivalued
2c78476e-af97-40f2-9d5d-d976ad3c361f	foo	user.attribute
2c78476e-af97-40f2-9d5d-d976ad3c361f	true	access.token.claim
2c78476e-af97-40f2-9d5d-d976ad3c361f	realm_access.roles	claim.name
2c78476e-af97-40f2-9d5d-d976ad3c361f	String	jsonType.label
4112936a-8433-4222-8e38-7f25563a1268	true	introspection.token.claim
4112936a-8433-4222-8e38-7f25563a1268	true	access.token.claim
88dfb934-0ed6-4736-9b3d-a82f43353c42	true	introspection.token.claim
88dfb934-0ed6-4736-9b3d-a82f43353c42	true	multivalued
88dfb934-0ed6-4736-9b3d-a82f43353c42	foo	user.attribute
88dfb934-0ed6-4736-9b3d-a82f43353c42	true	access.token.claim
88dfb934-0ed6-4736-9b3d-a82f43353c42	resource_access.${client_id}.roles	claim.name
88dfb934-0ed6-4736-9b3d-a82f43353c42	String	jsonType.label
09f756f0-426c-46b8-b665-eca53ac69407	true	introspection.token.claim
09f756f0-426c-46b8-b665-eca53ac69407	true	access.token.claim
7c5a9a0f-efcb-4b71-8345-dc69329cb792	true	introspection.token.claim
7c5a9a0f-efcb-4b71-8345-dc69329cb792	true	userinfo.token.claim
7c5a9a0f-efcb-4b71-8345-dc69329cb792	username	user.attribute
7c5a9a0f-efcb-4b71-8345-dc69329cb792	true	id.token.claim
7c5a9a0f-efcb-4b71-8345-dc69329cb792	true	access.token.claim
7c5a9a0f-efcb-4b71-8345-dc69329cb792	upn	claim.name
7c5a9a0f-efcb-4b71-8345-dc69329cb792	String	jsonType.label
eac586b0-9042-40ad-9a10-f2e9a9613358	true	introspection.token.claim
eac586b0-9042-40ad-9a10-f2e9a9613358	true	multivalued
eac586b0-9042-40ad-9a10-f2e9a9613358	foo	user.attribute
eac586b0-9042-40ad-9a10-f2e9a9613358	true	id.token.claim
eac586b0-9042-40ad-9a10-f2e9a9613358	true	access.token.claim
eac586b0-9042-40ad-9a10-f2e9a9613358	groups	claim.name
eac586b0-9042-40ad-9a10-f2e9a9613358	String	jsonType.label
54cb0f77-b625-4327-a5d3-682d86097697	true	introspection.token.claim
54cb0f77-b625-4327-a5d3-682d86097697	true	id.token.claim
54cb0f77-b625-4327-a5d3-682d86097697	true	access.token.claim
16296ca3-8392-41d5-aa45-c59fbb8d761b	AUTH_TIME	user.session.note
16296ca3-8392-41d5-aa45-c59fbb8d761b	true	introspection.token.claim
16296ca3-8392-41d5-aa45-c59fbb8d761b	true	id.token.claim
16296ca3-8392-41d5-aa45-c59fbb8d761b	true	access.token.claim
16296ca3-8392-41d5-aa45-c59fbb8d761b	auth_time	claim.name
16296ca3-8392-41d5-aa45-c59fbb8d761b	long	jsonType.label
867456e7-aabe-453d-8fa2-1053770dd569	true	introspection.token.claim
867456e7-aabe-453d-8fa2-1053770dd569	true	access.token.claim
0b9f60c7-2e8b-4841-918c-83eb2532c0cf	true	introspection.token.claim
0b9f60c7-2e8b-4841-918c-83eb2532c0cf	true	multivalued
0b9f60c7-2e8b-4841-918c-83eb2532c0cf	true	id.token.claim
0b9f60c7-2e8b-4841-918c-83eb2532c0cf	true	access.token.claim
0b9f60c7-2e8b-4841-918c-83eb2532c0cf	organization	claim.name
0b9f60c7-2e8b-4841-918c-83eb2532c0cf	String	jsonType.label
9c166360-f572-4aee-a257-f2ae6be971c7	false	single
9c166360-f572-4aee-a257-f2ae6be971c7	Basic	attribute.nameformat
9c166360-f572-4aee-a257-f2ae6be971c7	Role	attribute.name
1db5fdc5-dd8b-4fd1-ab4c-2032fb501e6f	true	introspection.token.claim
1db5fdc5-dd8b-4fd1-ab4c-2032fb501e6f	true	userinfo.token.claim
1db5fdc5-dd8b-4fd1-ab4c-2032fb501e6f	updatedAt	user.attribute
1db5fdc5-dd8b-4fd1-ab4c-2032fb501e6f	true	id.token.claim
1db5fdc5-dd8b-4fd1-ab4c-2032fb501e6f	true	access.token.claim
1db5fdc5-dd8b-4fd1-ab4c-2032fb501e6f	updated_at	claim.name
1db5fdc5-dd8b-4fd1-ab4c-2032fb501e6f	long	jsonType.label
626c9f08-8769-49c3-922c-0ff7975c3142	true	introspection.token.claim
626c9f08-8769-49c3-922c-0ff7975c3142	true	userinfo.token.claim
626c9f08-8769-49c3-922c-0ff7975c3142	picture	user.attribute
626c9f08-8769-49c3-922c-0ff7975c3142	true	id.token.claim
626c9f08-8769-49c3-922c-0ff7975c3142	true	access.token.claim
626c9f08-8769-49c3-922c-0ff7975c3142	picture	claim.name
626c9f08-8769-49c3-922c-0ff7975c3142	String	jsonType.label
75fec4a9-207c-46d4-8473-670ce9e39975	true	introspection.token.claim
75fec4a9-207c-46d4-8473-670ce9e39975	true	userinfo.token.claim
75fec4a9-207c-46d4-8473-670ce9e39975	nickname	user.attribute
75fec4a9-207c-46d4-8473-670ce9e39975	true	id.token.claim
75fec4a9-207c-46d4-8473-670ce9e39975	true	access.token.claim
75fec4a9-207c-46d4-8473-670ce9e39975	nickname	claim.name
75fec4a9-207c-46d4-8473-670ce9e39975	String	jsonType.label
77e6d42d-6c5f-408a-923d-175c4529ba2b	true	introspection.token.claim
77e6d42d-6c5f-408a-923d-175c4529ba2b	true	userinfo.token.claim
77e6d42d-6c5f-408a-923d-175c4529ba2b	gender	user.attribute
77e6d42d-6c5f-408a-923d-175c4529ba2b	true	id.token.claim
77e6d42d-6c5f-408a-923d-175c4529ba2b	true	access.token.claim
77e6d42d-6c5f-408a-923d-175c4529ba2b	gender	claim.name
77e6d42d-6c5f-408a-923d-175c4529ba2b	String	jsonType.label
7b7ff0f4-9f76-493c-94f0-92700ea33ee0	true	introspection.token.claim
7b7ff0f4-9f76-493c-94f0-92700ea33ee0	true	userinfo.token.claim
7b7ff0f4-9f76-493c-94f0-92700ea33ee0	locale	user.attribute
7b7ff0f4-9f76-493c-94f0-92700ea33ee0	true	id.token.claim
7b7ff0f4-9f76-493c-94f0-92700ea33ee0	true	access.token.claim
7b7ff0f4-9f76-493c-94f0-92700ea33ee0	locale	claim.name
7b7ff0f4-9f76-493c-94f0-92700ea33ee0	String	jsonType.label
7eaa96e3-e43f-4058-8b4e-21208fbd1417	true	introspection.token.claim
7eaa96e3-e43f-4058-8b4e-21208fbd1417	true	userinfo.token.claim
7eaa96e3-e43f-4058-8b4e-21208fbd1417	birthdate	user.attribute
7eaa96e3-e43f-4058-8b4e-21208fbd1417	true	id.token.claim
7eaa96e3-e43f-4058-8b4e-21208fbd1417	true	access.token.claim
7eaa96e3-e43f-4058-8b4e-21208fbd1417	birthdate	claim.name
7eaa96e3-e43f-4058-8b4e-21208fbd1417	String	jsonType.label
8d0d4bc0-39b3-4133-bf34-cf6ddba310c5	true	introspection.token.claim
8d0d4bc0-39b3-4133-bf34-cf6ddba310c5	true	userinfo.token.claim
8d0d4bc0-39b3-4133-bf34-cf6ddba310c5	website	user.attribute
8d0d4bc0-39b3-4133-bf34-cf6ddba310c5	true	id.token.claim
8d0d4bc0-39b3-4133-bf34-cf6ddba310c5	true	access.token.claim
8d0d4bc0-39b3-4133-bf34-cf6ddba310c5	website	claim.name
8d0d4bc0-39b3-4133-bf34-cf6ddba310c5	String	jsonType.label
983b88b3-76bd-407f-a7a5-7e9ac0bff9f6	true	introspection.token.claim
983b88b3-76bd-407f-a7a5-7e9ac0bff9f6	true	userinfo.token.claim
983b88b3-76bd-407f-a7a5-7e9ac0bff9f6	firstName	user.attribute
983b88b3-76bd-407f-a7a5-7e9ac0bff9f6	true	id.token.claim
983b88b3-76bd-407f-a7a5-7e9ac0bff9f6	true	access.token.claim
983b88b3-76bd-407f-a7a5-7e9ac0bff9f6	given_name	claim.name
983b88b3-76bd-407f-a7a5-7e9ac0bff9f6	String	jsonType.label
9da79485-9750-4970-a3e7-5a8b0fc71ddb	true	introspection.token.claim
9da79485-9750-4970-a3e7-5a8b0fc71ddb	true	userinfo.token.claim
9da79485-9750-4970-a3e7-5a8b0fc71ddb	true	id.token.claim
9da79485-9750-4970-a3e7-5a8b0fc71ddb	true	access.token.claim
9fecb746-b28a-46be-ba6b-97941a27794d	true	introspection.token.claim
9fecb746-b28a-46be-ba6b-97941a27794d	true	userinfo.token.claim
9fecb746-b28a-46be-ba6b-97941a27794d	zoneinfo	user.attribute
9fecb746-b28a-46be-ba6b-97941a27794d	true	id.token.claim
9fecb746-b28a-46be-ba6b-97941a27794d	true	access.token.claim
9fecb746-b28a-46be-ba6b-97941a27794d	zoneinfo	claim.name
9fecb746-b28a-46be-ba6b-97941a27794d	String	jsonType.label
a64692a3-de79-4240-ba7c-1ee0499c786b	true	introspection.token.claim
a64692a3-de79-4240-ba7c-1ee0499c786b	true	userinfo.token.claim
a64692a3-de79-4240-ba7c-1ee0499c786b	middleName	user.attribute
a64692a3-de79-4240-ba7c-1ee0499c786b	true	id.token.claim
a64692a3-de79-4240-ba7c-1ee0499c786b	true	access.token.claim
a64692a3-de79-4240-ba7c-1ee0499c786b	middle_name	claim.name
a64692a3-de79-4240-ba7c-1ee0499c786b	String	jsonType.label
deff72c8-c592-4c53-8f4b-7fe20f857127	true	introspection.token.claim
deff72c8-c592-4c53-8f4b-7fe20f857127	true	userinfo.token.claim
deff72c8-c592-4c53-8f4b-7fe20f857127	profile	user.attribute
deff72c8-c592-4c53-8f4b-7fe20f857127	true	id.token.claim
deff72c8-c592-4c53-8f4b-7fe20f857127	true	access.token.claim
deff72c8-c592-4c53-8f4b-7fe20f857127	profile	claim.name
deff72c8-c592-4c53-8f4b-7fe20f857127	String	jsonType.label
f38b2eab-6358-45cd-9fa2-d4f295c65213	true	introspection.token.claim
f38b2eab-6358-45cd-9fa2-d4f295c65213	true	userinfo.token.claim
f38b2eab-6358-45cd-9fa2-d4f295c65213	lastName	user.attribute
f38b2eab-6358-45cd-9fa2-d4f295c65213	true	id.token.claim
f38b2eab-6358-45cd-9fa2-d4f295c65213	true	access.token.claim
f38b2eab-6358-45cd-9fa2-d4f295c65213	family_name	claim.name
f38b2eab-6358-45cd-9fa2-d4f295c65213	String	jsonType.label
f616af44-0dd5-4fe0-8359-b139601b14fa	true	introspection.token.claim
f616af44-0dd5-4fe0-8359-b139601b14fa	true	userinfo.token.claim
f616af44-0dd5-4fe0-8359-b139601b14fa	username	user.attribute
f616af44-0dd5-4fe0-8359-b139601b14fa	true	id.token.claim
f616af44-0dd5-4fe0-8359-b139601b14fa	true	access.token.claim
f616af44-0dd5-4fe0-8359-b139601b14fa	preferred_username	claim.name
f616af44-0dd5-4fe0-8359-b139601b14fa	String	jsonType.label
6b031e69-2602-4db7-be87-d84c40c4f7e5	true	introspection.token.claim
6b031e69-2602-4db7-be87-d84c40c4f7e5	true	userinfo.token.claim
6b031e69-2602-4db7-be87-d84c40c4f7e5	email	user.attribute
6b031e69-2602-4db7-be87-d84c40c4f7e5	true	id.token.claim
6b031e69-2602-4db7-be87-d84c40c4f7e5	true	access.token.claim
6b031e69-2602-4db7-be87-d84c40c4f7e5	email	claim.name
6b031e69-2602-4db7-be87-d84c40c4f7e5	String	jsonType.label
cb1126df-f009-4626-8f95-e967169169a6	true	introspection.token.claim
cb1126df-f009-4626-8f95-e967169169a6	true	userinfo.token.claim
cb1126df-f009-4626-8f95-e967169169a6	emailVerified	user.attribute
cb1126df-f009-4626-8f95-e967169169a6	true	id.token.claim
cb1126df-f009-4626-8f95-e967169169a6	true	access.token.claim
cb1126df-f009-4626-8f95-e967169169a6	email_verified	claim.name
cb1126df-f009-4626-8f95-e967169169a6	boolean	jsonType.label
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	formatted	user.attribute.formatted
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	country	user.attribute.country
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	true	introspection.token.claim
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	postal_code	user.attribute.postal_code
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	true	userinfo.token.claim
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	street	user.attribute.street
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	true	id.token.claim
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	region	user.attribute.region
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	true	access.token.claim
4c40f8c0-5bb6-4143-bca5-d3cb135d0a09	locality	user.attribute.locality
b6bd893d-f987-4496-aae6-476ba9585508	true	introspection.token.claim
b6bd893d-f987-4496-aae6-476ba9585508	true	userinfo.token.claim
b6bd893d-f987-4496-aae6-476ba9585508	phoneNumberVerified	user.attribute
b6bd893d-f987-4496-aae6-476ba9585508	true	id.token.claim
b6bd893d-f987-4496-aae6-476ba9585508	true	access.token.claim
b6bd893d-f987-4496-aae6-476ba9585508	phone_number_verified	claim.name
b6bd893d-f987-4496-aae6-476ba9585508	boolean	jsonType.label
c70f1055-ddc0-48e6-8e72-1e4509ea185b	true	introspection.token.claim
c70f1055-ddc0-48e6-8e72-1e4509ea185b	true	userinfo.token.claim
c70f1055-ddc0-48e6-8e72-1e4509ea185b	phoneNumber	user.attribute
c70f1055-ddc0-48e6-8e72-1e4509ea185b	true	id.token.claim
c70f1055-ddc0-48e6-8e72-1e4509ea185b	true	access.token.claim
c70f1055-ddc0-48e6-8e72-1e4509ea185b	phone_number	claim.name
c70f1055-ddc0-48e6-8e72-1e4509ea185b	String	jsonType.label
788aebd7-6f49-494a-8ac9-391065f70d87	true	introspection.token.claim
788aebd7-6f49-494a-8ac9-391065f70d87	true	multivalued
788aebd7-6f49-494a-8ac9-391065f70d87	foo	user.attribute
788aebd7-6f49-494a-8ac9-391065f70d87	true	access.token.claim
788aebd7-6f49-494a-8ac9-391065f70d87	realm_access.roles	claim.name
788aebd7-6f49-494a-8ac9-391065f70d87	String	jsonType.label
8f48008e-63c2-4f74-a770-862d485e2d7b	true	introspection.token.claim
8f48008e-63c2-4f74-a770-862d485e2d7b	true	multivalued
8f48008e-63c2-4f74-a770-862d485e2d7b	foo	user.attribute
8f48008e-63c2-4f74-a770-862d485e2d7b	true	access.token.claim
8f48008e-63c2-4f74-a770-862d485e2d7b	resource_access.${client_id}.roles	claim.name
8f48008e-63c2-4f74-a770-862d485e2d7b	String	jsonType.label
bf4421c4-d9a0-46df-96a8-a916c048ef38	true	introspection.token.claim
bf4421c4-d9a0-46df-96a8-a916c048ef38	true	access.token.claim
ec98978c-7394-42f3-81eb-436d0541b9d1	true	introspection.token.claim
ec98978c-7394-42f3-81eb-436d0541b9d1	true	access.token.claim
22a3776a-5fc2-4235-879e-ea71c2a8e10f	true	introspection.token.claim
22a3776a-5fc2-4235-879e-ea71c2a8e10f	true	userinfo.token.claim
22a3776a-5fc2-4235-879e-ea71c2a8e10f	username	user.attribute
22a3776a-5fc2-4235-879e-ea71c2a8e10f	true	id.token.claim
22a3776a-5fc2-4235-879e-ea71c2a8e10f	true	access.token.claim
22a3776a-5fc2-4235-879e-ea71c2a8e10f	upn	claim.name
22a3776a-5fc2-4235-879e-ea71c2a8e10f	String	jsonType.label
2e30398a-54d8-41a4-96bc-feb7ddff357d	true	introspection.token.claim
2e30398a-54d8-41a4-96bc-feb7ddff357d	true	multivalued
2e30398a-54d8-41a4-96bc-feb7ddff357d	foo	user.attribute
2e30398a-54d8-41a4-96bc-feb7ddff357d	true	id.token.claim
2e30398a-54d8-41a4-96bc-feb7ddff357d	true	access.token.claim
2e30398a-54d8-41a4-96bc-feb7ddff357d	groups	claim.name
2e30398a-54d8-41a4-96bc-feb7ddff357d	String	jsonType.label
fb0af181-05a3-4c6e-9d5e-0a645afd6465	true	introspection.token.claim
fb0af181-05a3-4c6e-9d5e-0a645afd6465	true	id.token.claim
fb0af181-05a3-4c6e-9d5e-0a645afd6465	true	access.token.claim
516e2dd1-2392-494f-91a4-80d82dca7ef5	true	introspection.token.claim
516e2dd1-2392-494f-91a4-80d82dca7ef5	true	access.token.claim
ec28a5e8-53c1-4b4d-87d4-169043699909	AUTH_TIME	user.session.note
ec28a5e8-53c1-4b4d-87d4-169043699909	true	introspection.token.claim
ec28a5e8-53c1-4b4d-87d4-169043699909	true	id.token.claim
ec28a5e8-53c1-4b4d-87d4-169043699909	true	access.token.claim
ec28a5e8-53c1-4b4d-87d4-169043699909	auth_time	claim.name
ec28a5e8-53c1-4b4d-87d4-169043699909	long	jsonType.label
23186559-bcc7-4b59-b1f8-722d76286286	true	introspection.token.claim
23186559-bcc7-4b59-b1f8-722d76286286	true	multivalued
23186559-bcc7-4b59-b1f8-722d76286286	true	id.token.claim
23186559-bcc7-4b59-b1f8-722d76286286	true	access.token.claim
23186559-bcc7-4b59-b1f8-722d76286286	organization	claim.name
23186559-bcc7-4b59-b1f8-722d76286286	String	jsonType.label
e014e92e-3520-4688-9480-6e6278ea6f01	true	introspection.token.claim
e014e92e-3520-4688-9480-6e6278ea6f01	true	userinfo.token.claim
e014e92e-3520-4688-9480-6e6278ea6f01	locale	user.attribute
e014e92e-3520-4688-9480-6e6278ea6f01	true	id.token.claim
e014e92e-3520-4688-9480-6e6278ea6f01	true	access.token.claim
e014e92e-3520-4688-9480-6e6278ea6f01	locale	claim.name
e014e92e-3520-4688-9480-6e6278ea6f01	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
71093b75-f667-4192-826f-bd9b1f26e9be	60	300	300	\N	\N	\N	t	f	0	\N	karhub-beer	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	decc8268-c8bc-4e20-b15e-760d32d05e4f	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	418074e1-b217-4d7a-95e0-8886d42cf6f1	110e023e-03c4-4808-8cea-73e1c32f8860	78da04c4-dcee-430b-9544-a526c2d14caf	4b54ca88-0b03-4c72-a229-6de4d20393ac	9ae18d00-1003-451b-a6a5-5ed776ea6679	2592000	f	900	t	f	3d6fd9ad-a5be-4cdb-b0cc-be53a8047fd0	0	f	0	0	936850eb-9be2-4c76-b572-0ab7d4f5d621
d40720ce-7492-4ad3-84a5-148310a9b1c1	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	49690866-2d77-4fac-9963-cb59b8fcd25f	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	7765d321-a7e7-4df3-b6fc-534e11d9a67c	46c74d59-3dfc-4746-9221-23875f868ecc	a9d38246-086e-4008-a738-54ece994a633	1ed0a45b-f03e-4649-b048-0adad6a3fdee	fd9dfd50-fec1-4c0e-9cb6-98a154cbc11f	2592000	f	900	t	f	c3481716-3c5b-428f-80cf-f54663122958	0	f	0	0	09694323-0efb-4bcf-b6ce-691ba922605b
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	d40720ce-7492-4ad3-84a5-148310a9b1c1	
_browser_header.xContentTypeOptions	d40720ce-7492-4ad3-84a5-148310a9b1c1	nosniff
_browser_header.referrerPolicy	d40720ce-7492-4ad3-84a5-148310a9b1c1	no-referrer
_browser_header.xRobotsTag	d40720ce-7492-4ad3-84a5-148310a9b1c1	none
_browser_header.xFrameOptions	d40720ce-7492-4ad3-84a5-148310a9b1c1	SAMEORIGIN
_browser_header.contentSecurityPolicy	d40720ce-7492-4ad3-84a5-148310a9b1c1	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	d40720ce-7492-4ad3-84a5-148310a9b1c1	1; mode=block
_browser_header.strictTransportSecurity	d40720ce-7492-4ad3-84a5-148310a9b1c1	max-age=31536000; includeSubDomains
bruteForceProtected	d40720ce-7492-4ad3-84a5-148310a9b1c1	false
permanentLockout	d40720ce-7492-4ad3-84a5-148310a9b1c1	false
maxTemporaryLockouts	d40720ce-7492-4ad3-84a5-148310a9b1c1	0
maxFailureWaitSeconds	d40720ce-7492-4ad3-84a5-148310a9b1c1	900
minimumQuickLoginWaitSeconds	d40720ce-7492-4ad3-84a5-148310a9b1c1	60
waitIncrementSeconds	d40720ce-7492-4ad3-84a5-148310a9b1c1	60
quickLoginCheckMilliSeconds	d40720ce-7492-4ad3-84a5-148310a9b1c1	1000
maxDeltaTimeSeconds	d40720ce-7492-4ad3-84a5-148310a9b1c1	43200
failureFactor	d40720ce-7492-4ad3-84a5-148310a9b1c1	30
realmReusableOtpCode	d40720ce-7492-4ad3-84a5-148310a9b1c1	false
firstBrokerLoginFlowId	d40720ce-7492-4ad3-84a5-148310a9b1c1	b50d0470-8911-4391-9619-39cba0554c8f
displayName	d40720ce-7492-4ad3-84a5-148310a9b1c1	Keycloak
displayNameHtml	d40720ce-7492-4ad3-84a5-148310a9b1c1	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	d40720ce-7492-4ad3-84a5-148310a9b1c1	RS256
offlineSessionMaxLifespanEnabled	d40720ce-7492-4ad3-84a5-148310a9b1c1	false
offlineSessionMaxLifespan	d40720ce-7492-4ad3-84a5-148310a9b1c1	5184000
_browser_header.contentSecurityPolicyReportOnly	71093b75-f667-4192-826f-bd9b1f26e9be	
_browser_header.xContentTypeOptions	71093b75-f667-4192-826f-bd9b1f26e9be	nosniff
_browser_header.referrerPolicy	71093b75-f667-4192-826f-bd9b1f26e9be	no-referrer
_browser_header.xRobotsTag	71093b75-f667-4192-826f-bd9b1f26e9be	none
_browser_header.xFrameOptions	71093b75-f667-4192-826f-bd9b1f26e9be	SAMEORIGIN
_browser_header.contentSecurityPolicy	71093b75-f667-4192-826f-bd9b1f26e9be	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	71093b75-f667-4192-826f-bd9b1f26e9be	1; mode=block
_browser_header.strictTransportSecurity	71093b75-f667-4192-826f-bd9b1f26e9be	max-age=31536000; includeSubDomains
bruteForceProtected	71093b75-f667-4192-826f-bd9b1f26e9be	false
permanentLockout	71093b75-f667-4192-826f-bd9b1f26e9be	false
maxTemporaryLockouts	71093b75-f667-4192-826f-bd9b1f26e9be	0
maxFailureWaitSeconds	71093b75-f667-4192-826f-bd9b1f26e9be	900
minimumQuickLoginWaitSeconds	71093b75-f667-4192-826f-bd9b1f26e9be	60
waitIncrementSeconds	71093b75-f667-4192-826f-bd9b1f26e9be	60
quickLoginCheckMilliSeconds	71093b75-f667-4192-826f-bd9b1f26e9be	1000
maxDeltaTimeSeconds	71093b75-f667-4192-826f-bd9b1f26e9be	43200
failureFactor	71093b75-f667-4192-826f-bd9b1f26e9be	30
realmReusableOtpCode	71093b75-f667-4192-826f-bd9b1f26e9be	false
defaultSignatureAlgorithm	71093b75-f667-4192-826f-bd9b1f26e9be	RS256
offlineSessionMaxLifespanEnabled	71093b75-f667-4192-826f-bd9b1f26e9be	false
offlineSessionMaxLifespan	71093b75-f667-4192-826f-bd9b1f26e9be	5184000
actionTokenGeneratedByAdminLifespan	71093b75-f667-4192-826f-bd9b1f26e9be	43200
actionTokenGeneratedByUserLifespan	71093b75-f667-4192-826f-bd9b1f26e9be	300
oauth2DeviceCodeLifespan	71093b75-f667-4192-826f-bd9b1f26e9be	600
oauth2DevicePollingInterval	71093b75-f667-4192-826f-bd9b1f26e9be	5
webAuthnPolicyRpEntityName	71093b75-f667-4192-826f-bd9b1f26e9be	keycloak
webAuthnPolicySignatureAlgorithms	71093b75-f667-4192-826f-bd9b1f26e9be	ES256,RS256
webAuthnPolicyRpId	71093b75-f667-4192-826f-bd9b1f26e9be	
webAuthnPolicyAttestationConveyancePreference	71093b75-f667-4192-826f-bd9b1f26e9be	not specified
webAuthnPolicyAuthenticatorAttachment	71093b75-f667-4192-826f-bd9b1f26e9be	not specified
webAuthnPolicyRequireResidentKey	71093b75-f667-4192-826f-bd9b1f26e9be	not specified
webAuthnPolicyUserVerificationRequirement	71093b75-f667-4192-826f-bd9b1f26e9be	not specified
webAuthnPolicyCreateTimeout	71093b75-f667-4192-826f-bd9b1f26e9be	0
webAuthnPolicyAvoidSameAuthenticatorRegister	71093b75-f667-4192-826f-bd9b1f26e9be	false
webAuthnPolicyRpEntityNamePasswordless	71093b75-f667-4192-826f-bd9b1f26e9be	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	71093b75-f667-4192-826f-bd9b1f26e9be	ES256,RS256
webAuthnPolicyRpIdPasswordless	71093b75-f667-4192-826f-bd9b1f26e9be	
webAuthnPolicyAttestationConveyancePreferencePasswordless	71093b75-f667-4192-826f-bd9b1f26e9be	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	71093b75-f667-4192-826f-bd9b1f26e9be	not specified
webAuthnPolicyRequireResidentKeyPasswordless	71093b75-f667-4192-826f-bd9b1f26e9be	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	71093b75-f667-4192-826f-bd9b1f26e9be	not specified
webAuthnPolicyCreateTimeoutPasswordless	71093b75-f667-4192-826f-bd9b1f26e9be	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	71093b75-f667-4192-826f-bd9b1f26e9be	false
cibaBackchannelTokenDeliveryMode	71093b75-f667-4192-826f-bd9b1f26e9be	poll
cibaExpiresIn	71093b75-f667-4192-826f-bd9b1f26e9be	120
cibaInterval	71093b75-f667-4192-826f-bd9b1f26e9be	5
cibaAuthRequestedUserHint	71093b75-f667-4192-826f-bd9b1f26e9be	login_hint
parRequestUriLifespan	71093b75-f667-4192-826f-bd9b1f26e9be	60
firstBrokerLoginFlowId	71093b75-f667-4192-826f-bd9b1f26e9be	9b058fc5-ccd5-49dc-8264-dd06790251bf
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
d40720ce-7492-4ad3-84a5-148310a9b1c1	jboss-logging
71093b75-f667-4192-826f-bd9b1f26e9be	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	d40720ce-7492-4ad3-84a5-148310a9b1c1
password	password	t	t	71093b75-f667-4192-826f-bd9b1f26e9be
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.redirect_uris (client_id, value) FROM stdin;
bfda7933-3aec-4ad5-a8a5-2be68a46cb12	/realms/master/account/*
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	/realms/master/account/*
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	/admin/master/console/*
a2881323-87fb-47fe-bf7b-99b8e8fc99ec	/realms/karhub-beer/account/*
df8dc7fb-12f6-4519-a7b2-884651fad866	/realms/karhub-beer/account/*
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	/admin/karhub-beer/console/*
72c394f7-ad70-432e-a0f4-715ee92e6ad2	/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
189d7816-187e-4989-836f-24f638e27d19	VERIFY_EMAIL	Verify Email	d40720ce-7492-4ad3-84a5-148310a9b1c1	t	f	VERIFY_EMAIL	50
cd0a2313-940f-4f6b-b262-f673344fd2b5	UPDATE_PROFILE	Update Profile	d40720ce-7492-4ad3-84a5-148310a9b1c1	t	f	UPDATE_PROFILE	40
655de2ac-496e-44f1-969e-200760c639c4	CONFIGURE_TOTP	Configure OTP	d40720ce-7492-4ad3-84a5-148310a9b1c1	t	f	CONFIGURE_TOTP	10
9b387b76-7ef0-4b45-940a-09315165bf59	UPDATE_PASSWORD	Update Password	d40720ce-7492-4ad3-84a5-148310a9b1c1	t	f	UPDATE_PASSWORD	30
805b12b3-1c9e-4602-89ed-423720b9e019	TERMS_AND_CONDITIONS	Terms and Conditions	d40720ce-7492-4ad3-84a5-148310a9b1c1	f	f	TERMS_AND_CONDITIONS	20
3f3502ef-7afa-4364-90b0-1e1e7b7c147d	delete_account	Delete Account	d40720ce-7492-4ad3-84a5-148310a9b1c1	f	f	delete_account	60
7a18e040-39d7-44d6-8cac-0508a8a5545d	delete_credential	Delete Credential	d40720ce-7492-4ad3-84a5-148310a9b1c1	t	f	delete_credential	100
a4dec1bb-3408-4c98-9b57-33d007477e36	update_user_locale	Update User Locale	d40720ce-7492-4ad3-84a5-148310a9b1c1	t	f	update_user_locale	1000
c1e0840c-5a3d-421c-8e35-49e649538650	webauthn-register	Webauthn Register	d40720ce-7492-4ad3-84a5-148310a9b1c1	t	f	webauthn-register	70
99d6e77d-b360-4fe7-9d4f-c9e7f865265f	webauthn-register-passwordless	Webauthn Register Passwordless	d40720ce-7492-4ad3-84a5-148310a9b1c1	t	f	webauthn-register-passwordless	80
e03fd090-77f4-475c-b1c0-66b5fd86fa7d	VERIFY_PROFILE	Verify Profile	d40720ce-7492-4ad3-84a5-148310a9b1c1	t	f	VERIFY_PROFILE	90
689024b6-bb66-4556-bd90-5bee1579da82	CONFIGURE_TOTP	Configure OTP	71093b75-f667-4192-826f-bd9b1f26e9be	t	f	CONFIGURE_TOTP	10
b6193dac-f9f6-4607-9636-0d40432eb0ea	TERMS_AND_CONDITIONS	Terms and Conditions	71093b75-f667-4192-826f-bd9b1f26e9be	f	f	TERMS_AND_CONDITIONS	20
6948e07a-2ab6-4cae-8b7f-c7a17867f163	delete_account	Delete Account	71093b75-f667-4192-826f-bd9b1f26e9be	f	f	delete_account	60
ca58db6e-a19e-4b6c-bc9a-c6bfde046ea7	delete_credential	Delete Credential	71093b75-f667-4192-826f-bd9b1f26e9be	t	f	delete_credential	100
5cdc40bc-caa0-4901-9c87-49d514b974dc	update_user_locale	Update User Locale	71093b75-f667-4192-826f-bd9b1f26e9be	t	f	update_user_locale	1000
808e0f63-c1c4-41cf-8cc3-15ea9d468cc4	webauthn-register	Webauthn Register	71093b75-f667-4192-826f-bd9b1f26e9be	t	f	webauthn-register	70
4c8cdde1-d382-415a-95ce-e487789f42bb	webauthn-register-passwordless	Webauthn Register Passwordless	71093b75-f667-4192-826f-bd9b1f26e9be	t	f	webauthn-register-passwordless	80
67147dbf-535c-4d5c-9e85-8175521b5121	VERIFY_PROFILE	Verify Profile	71093b75-f667-4192-826f-bd9b1f26e9be	t	f	VERIFY_PROFILE	90
7b28840e-7dcd-42ea-90c7-cbceeebf9d28	VERIFY_EMAIL	Verify Email	71093b75-f667-4192-826f-bd9b1f26e9be	f	f	VERIFY_EMAIL	50
702438b8-cd74-4f78-bbd3-8cc7330c56a7	UPDATE_PASSWORD	Update Password	71093b75-f667-4192-826f-bd9b1f26e9be	f	f	UPDATE_PASSWORD	30
45e605f7-5109-42c1-ad3a-15612886e781	UPDATE_PROFILE	Update Profile	71093b75-f667-4192-826f-bd9b1f26e9be	f	f	UPDATE_PROFILE	40
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: revoked_token; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.revoked_token (id, expire) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	8cf3791b-3c8d-4e7c-8729-00c3d7232e67
8a60bf99-9478-4220-a5a6-0f521fa6c5ca	0d6c7652-72d6-4bba-b70e-d9db79977011
df8dc7fb-12f6-4519-a7b2-884651fad866	388940fe-31a1-4ed2-808a-6a4173ce72a6
df8dc7fb-12f6-4519-a7b2-884651fad866	1b8e44dc-fa4b-49c3-88ff-cb15ca910ac3
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
is_temporary_admin	true	bfc5c1ae-64e7-4c6f-bae0-61bac2dea4e7	746a4645-7406-4e88-96a1-26408940b740	\N	\N	\N
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
467b9742-0b00-4f9d-81ef-26e792f2d318	teste@asss.com	teste@asss.com	t	t	\N	testeMal	testeMal	71093b75-f667-4192-826f-bd9b1f26e9be	testemal	1756231538493	\N	0
d85b629b-87fc-409c-a66d-d3e61be79461	logan@example.com	logan@example.com	t	t	\N	Logan	Cardoso	71093b75-f667-4192-826f-bd9b1f26e9be	logan	1756230580340	\N	0
bfc5c1ae-64e7-4c6f-bae0-61bac2dea4e7	\N	2a50c950-2b6e-4580-b09c-d7cc0c55cf75	t	t	\N	\N	\N	d40720ce-7492-4ad3-84a5-148310a9b1c1	admin	1756230436939	\N	0
0c5b254a-8e3e-4da8-ace9-79c17611ac42	testen@example.com	testen@example.com	t	t	\N	logangay	logangay	71093b75-f667-4192-826f-bd9b1f26e9be	logangay	1756327751286	\N	0
bec1858e-304e-44c9-8f4a-3d775b958d88	teste222n@example.com	teste222n@example.com	t	t	\N	logangay2	logangay2	71093b75-f667-4192-826f-bd9b1f26e9be	logangay2	1756327783857	\N	0
efa91276-b915-4904-9798-516a125b0a46	teste222n22@example.com	teste222n22@example.com	t	t	\N	logangay22	logangay22	71093b75-f667-4192-826f-bd9b1f26e9be	logangay22	1756327827135	\N	0
65b70101-3a6f-4755-aaf7-f588199ab417	zagalo@example.com	zagalo@example.com	t	t	\N	zagalo	zagalo	71093b75-f667-4192-826f-bd9b1f26e9be	zagalo	1756328006771	\N	0
d1848e9f-641d-4d73-9b7c-2e11dc531ace	testema1l@asss.com	testema1l@asss.com	t	t	\N	testeMa1l	testeMa1l	71093b75-f667-4192-826f-bd9b1f26e9be	testema1l	1756567970353	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_group_membership (group_id, user_id, membership_type) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
09694323-0efb-4bcf-b6ce-691ba922605b	bfc5c1ae-64e7-4c6f-bae0-61bac2dea4e7
8613ae31-d596-4ea0-838e-f99c67defba1	bfc5c1ae-64e7-4c6f-bae0-61bac2dea4e7
936850eb-9be2-4c76-b572-0ab7d4f5d621	d85b629b-87fc-409c-a66d-d3e61be79461
936850eb-9be2-4c76-b572-0ab7d4f5d621	467b9742-0b00-4f9d-81ef-26e792f2d318
ff77512b-6781-40a7-902a-725982110120	467b9742-0b00-4f9d-81ef-26e792f2d318
936850eb-9be2-4c76-b572-0ab7d4f5d621	0c5b254a-8e3e-4da8-ace9-79c17611ac42
936850eb-9be2-4c76-b572-0ab7d4f5d621	bec1858e-304e-44c9-8f4a-3d775b958d88
14aadcd4-baef-49eb-847c-1ad5103813df	bec1858e-304e-44c9-8f4a-3d775b958d88
936850eb-9be2-4c76-b572-0ab7d4f5d621	efa91276-b915-4904-9798-516a125b0a46
936850eb-9be2-4c76-b572-0ab7d4f5d621	65b70101-3a6f-4755-aaf7-f588199ab417
936850eb-9be2-4c76-b572-0ab7d4f5d621	d1848e9f-641d-4d73-9b7c-2e11dc531ace
ff77512b-6781-40a7-902a-725982110120	d1848e9f-641d-4d73-9b7c-2e11dc531ace
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: karhub
--

COPY public.web_origins (client_id, value) FROM stdin;
e856bd8e-0a2c-41b0-8b72-ff1b354380ff	+
a5ee41e5-ec1a-41f5-a5aa-f9c7cb55387d	+
72c394f7-ad70-432e-a0f4-715ee92e6ad2	/*
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: revoked_token constraint_rt; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.revoked_token
    ADD CONSTRAINT constraint_rt PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: org uk_org_alias; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_alias UNIQUE (realm_id, alias);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_idp_for_login; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_idp_for_login ON public.identity_provider USING btree (realm_id, enabled, link_only, hide_on_login, organization_id);


--
-- Name: idx_idp_realm_org; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_idp_realm_org ON public.identity_provider USING btree (realm_id, organization_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_last_session_refresh; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_offline_uss_by_last_session_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, last_session_refresh);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_org_domain_org_id; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_org_domain_org_id ON public.org_domain USING btree (org_id);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_rev_token_on_expire; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_rev_token_on_expire ON public.revoked_token USING btree (expire);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: karhub
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: karhub
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

