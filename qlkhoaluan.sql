--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2025-06-17 13:30:26

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
-- TOC entry 215 (class 1259 OID 16399)
-- Name: academy_year; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.academy_year (
    id uuid NOT NULL,
    name character varying NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public.academy_year OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16418)
-- Name: batch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.batch (
    id uuid NOT NULL,
    semester_id uuid NOT NULL,
    name character varying NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    create_datetime timestamp without time zone,
    status integer,
    update_datetime timestamp without time zone
);


ALTER TABLE public.batch OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16602)
-- Name: committee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.committee (
    id uuid NOT NULL,
    name character varying NOT NULL,
    chairman_id uuid,
    meeting_time timestamp without time zone,
    note character varying,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public.committee OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16471)
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    id integer NOT NULL,
    name character varying NOT NULL,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public.department OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16470)
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.department_id_seq OWNER TO postgres;

--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 222
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_id_seq OWNED BY public.department.id;


--
-- TOC entry 239 (class 1259 OID 16567)
-- Name: group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."group" (
    id uuid NOT NULL,
    name character varying,
    leader_id uuid NOT NULL,
    quantity integer NOT NULL,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public."group" OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16576)
-- Name: group_member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.group_member (
    id uuid NOT NULL,
    group_id uuid,
    student_id uuid,
    is_leader boolean,
    join_date timestamp without time zone
);


ALTER TABLE public.group_member OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16440)
-- Name: information; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.information (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    date_of_birth timestamp without time zone NOT NULL,
    gender integer NOT NULL,
    address character varying NOT NULL,
    tel_phone character varying NOT NULL
);


ALTER TABLE public.information OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16587)
-- Name: invite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invite (
    id uuid NOT NULL,
    sender_id uuid NOT NULL,
    receiver_id uuid NOT NULL,
    group_id uuid NOT NULL,
    status integer,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public.invite OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16461)
-- Name: lecturer_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lecturer_info (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    lecturer_code character varying NOT NULL,
    department integer,
    title character varying NOT NULL,
    email character varying NOT NULL,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public.lecturer_info OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16493)
-- Name: major; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.major (
    id uuid NOT NULL,
    name character varying
);


ALTER TABLE public.major OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16609)
-- Name: mission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mission (
    id uuid NOT NULL,
    thesis_id uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    status integer,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public.mission OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16482)
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    token character varying NOT NULL,
    access_token character varying,
    expires_at timestamp without time zone NOT NULL,
    access_expires_at timestamp without time zone,
    is_revoked boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16481)
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.refresh_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.refresh_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 224
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.refresh_tokens_id_seq OWNED BY public.refresh_tokens.id;


--
-- TOC entry 238 (class 1259 OID 16559)
-- Name: score_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.score_type (
    id integer NOT NULL,
    name character varying NOT NULL,
    description character varying
);


ALTER TABLE public.score_type OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16558)
-- Name: score_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.score_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.score_type_id_seq OWNER TO postgres;

--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 237
-- Name: score_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.score_type_id_seq OWNED BY public.score_type.id;


--
-- TOC entry 216 (class 1259 OID 16408)
-- Name: semester; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semester (
    id uuid NOT NULL,
    academy_year_id uuid NOT NULL,
    name character varying NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public.semester OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16451)
-- Name: student_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_info (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    student_code character varying NOT NULL,
    class_name character varying,
    major_id uuid NOT NULL,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public.student_info OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16514)
-- Name: sys_function; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_function (
    id integer NOT NULL,
    name character varying NOT NULL,
    path character varying,
    type character varying NOT NULL,
    parent_id integer,
    description character varying,
    status integer,
    create_datetime timestamp without time zone,
    created_by uuid,
    update_datetime timestamp without time zone
);


ALTER TABLE public.sys_function OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16513)
-- Name: sys_function_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sys_function_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sys_function_id_seq OWNER TO postgres;

--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 229
-- Name: sys_function_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sys_function_id_seq OWNED BY public.sys_function.id;


--
-- TOC entry 228 (class 1259 OID 16503)
-- Name: sys_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_role (
    id integer NOT NULL,
    role_code character varying NOT NULL,
    role_name character varying NOT NULL,
    description character varying,
    status integer,
    create_datetime timestamp without time zone,
    created_by uuid,
    update_datetime timestamp without time zone
);


ALTER TABLE public.sys_role OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16533)
-- Name: sys_role_function; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_role_function (
    id integer NOT NULL,
    role_id integer NOT NULL,
    function_id integer NOT NULL,
    status integer,
    created_by uuid,
    create_datetime timestamp without time zone
);


ALTER TABLE public.sys_role_function OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16532)
-- Name: sys_role_function_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sys_role_function_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sys_role_function_id_seq OWNER TO postgres;

--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 233
-- Name: sys_role_function_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sys_role_function_id_seq OWNED BY public.sys_role_function.id;


--
-- TOC entry 227 (class 1259 OID 16502)
-- Name: sys_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sys_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sys_role_id_seq OWNER TO postgres;

--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 227
-- Name: sys_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sys_role_id_seq OWNED BY public.sys_role.id;


--
-- TOC entry 218 (class 1259 OID 16428)
-- Name: sys_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_user (
    id uuid NOT NULL,
    user_name character varying,
    password character varying,
    is_active boolean,
    user_type integer,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public.sys_user OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16525)
-- Name: sys_user_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sys_user_role (
    id integer NOT NULL,
    user_id uuid NOT NULL,
    role_id integer NOT NULL,
    created_by uuid,
    create_datetime timestamp without time zone
);


ALTER TABLE public.sys_user_role OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16524)
-- Name: sys_user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sys_user_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sys_user_role_id_seq OWNER TO postgres;

--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 231
-- Name: sys_user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sys_user_role_id_seq OWNED BY public.sys_user_role.id;


--
-- TOC entry 247 (class 1259 OID 16617)
-- Name: task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task (
    id uuid NOT NULL,
    mission_id uuid NOT NULL,
    title character varying NOT NULL,
    description character varying,
    due_date timestamp without time zone,
    status integer,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone
);


ALTER TABLE public.task OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16625)
-- Name: task_comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_comment (
    id uuid NOT NULL,
    task_id uuid NOT NULL,
    commenter_id uuid NOT NULL,
    comment_text character varying,
    image_base64 text,
    create_datetime timestamp without time zone
);


ALTER TABLE public.task_comment OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16540)
-- Name: thesis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.thesis (
    id uuid NOT NULL,
    title character varying,
    description character varying,
    thesis_type integer NOT NULL,
    create_by uuid NOT NULL,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    create_datetime timestamp without time zone,
    update_datetime timestamp without time zone,
    status integer,
    batch_id uuid NOT NULL,
    major_id uuid NOT NULL,
    reason character varying
);


ALTER TABLE public.thesis OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16592)
-- Name: thesis_committee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.thesis_committee (
    id uuid NOT NULL,
    thesis_id uuid NOT NULL,
    member_id uuid NOT NULL,
    committee_id uuid NOT NULL,
    role integer NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.thesis_committee OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16582)
-- Name: thesis_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.thesis_group (
    id uuid NOT NULL,
    thesis_id uuid NOT NULL,
    group_id uuid NOT NULL
);


ALTER TABLE public.thesis_group OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16553)
-- Name: thesis_lecturer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.thesis_lecturer (
    id uuid NOT NULL,
    lecturer_id uuid NOT NULL,
    thesis_id uuid NOT NULL,
    role integer,
    create_datetime timestamp without time zone
);


ALTER TABLE public.thesis_lecturer OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16597)
-- Name: thesis_member_score; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.thesis_member_score (
    id uuid NOT NULL,
    thesis_id uuid,
    student_id uuid,
    evaluator_id uuid,
    score double precision NOT NULL,
    score_type integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.thesis_member_score OWNER TO postgres;

--
-- TOC entry 4798 (class 2604 OID 16474)
-- Name: department id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- TOC entry 4799 (class 2604 OID 16485)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('public.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4804 (class 2604 OID 16562)
-- Name: score_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.score_type ALTER COLUMN id SET DEFAULT nextval('public.score_type_id_seq'::regclass);


--
-- TOC entry 4801 (class 2604 OID 16517)
-- Name: sys_function id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_function ALTER COLUMN id SET DEFAULT nextval('public.sys_function_id_seq'::regclass);


--
-- TOC entry 4800 (class 2604 OID 16506)
-- Name: sys_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_role ALTER COLUMN id SET DEFAULT nextval('public.sys_role_id_seq'::regclass);


--
-- TOC entry 4803 (class 2604 OID 16536)
-- Name: sys_role_function id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_role_function ALTER COLUMN id SET DEFAULT nextval('public.sys_role_function_id_seq'::regclass);


--
-- TOC entry 4802 (class 2604 OID 16528)
-- Name: sys_user_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_user_role ALTER COLUMN id SET DEFAULT nextval('public.sys_user_role_id_seq'::regclass);


--
-- TOC entry 5049 (class 0 OID 16399)
-- Dependencies: 215
-- Data for Name: academy_year; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.academy_year (id, name, start_date, end_date, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5051 (class 0 OID 16418)
-- Dependencies: 217
-- Data for Name: batch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.batch (id, semester_id, name, start_date, end_date, create_datetime, status, update_datetime) FROM stdin;
\.


--
-- TOC entry 5079 (class 0 OID 16602)
-- Dependencies: 245
-- Data for Name: committee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.committee (id, name, chairman_id, meeting_time, note, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5057 (class 0 OID 16471)
-- Dependencies: 223
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.department (id, name, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5073 (class 0 OID 16567)
-- Dependencies: 239
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."group" (id, name, leader_id, quantity, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5074 (class 0 OID 16576)
-- Dependencies: 240
-- Data for Name: group_member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_member (id, group_id, student_id, is_leader, join_date) FROM stdin;
\.


--
-- TOC entry 5053 (class 0 OID 16440)
-- Dependencies: 219
-- Data for Name: information; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.information (id, user_id, first_name, last_name, date_of_birth, gender, address, tel_phone) FROM stdin;
\.


--
-- TOC entry 5076 (class 0 OID 16587)
-- Dependencies: 242
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invite (id, sender_id, receiver_id, group_id, status, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5055 (class 0 OID 16461)
-- Dependencies: 221
-- Data for Name: lecturer_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lecturer_info (id, user_id, lecturer_code, department, title, email, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5060 (class 0 OID 16493)
-- Dependencies: 226
-- Data for Name: major; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.major (id, name) FROM stdin;
\.


--
-- TOC entry 5080 (class 0 OID 16609)
-- Dependencies: 246
-- Data for Name: mission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mission (id, thesis_id, title, description, start_date, end_date, status, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5059 (class 0 OID 16482)
-- Dependencies: 225
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (id, user_id, token, access_token, expires_at, access_expires_at, is_revoked, created_at) FROM stdin;
\.


--
-- TOC entry 5072 (class 0 OID 16559)
-- Dependencies: 238
-- Data for Name: score_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.score_type (id, name, description) FROM stdin;
\.


--
-- TOC entry 5050 (class 0 OID 16408)
-- Dependencies: 216
-- Data for Name: semester; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semester (id, academy_year_id, name, start_date, end_date, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5054 (class 0 OID 16451)
-- Dependencies: 220
-- Data for Name: student_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_info (id, user_id, student_code, class_name, major_id, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5064 (class 0 OID 16514)
-- Dependencies: 230
-- Data for Name: sys_function; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_function (id, name, path, type, parent_id, description, status, create_datetime, created_by, update_datetime) FROM stdin;
\.


--
-- TOC entry 5062 (class 0 OID 16503)
-- Dependencies: 228
-- Data for Name: sys_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_role (id, role_code, role_name, description, status, create_datetime, created_by, update_datetime) FROM stdin;
\.


--
-- TOC entry 5068 (class 0 OID 16533)
-- Dependencies: 234
-- Data for Name: sys_role_function; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_role_function (id, role_id, function_id, status, created_by, create_datetime) FROM stdin;
\.


--
-- TOC entry 5052 (class 0 OID 16428)
-- Dependencies: 218
-- Data for Name: sys_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_user (id, user_name, password, is_active, user_type, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5066 (class 0 OID 16525)
-- Dependencies: 232
-- Data for Name: sys_user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sys_user_role (id, user_id, role_id, created_by, create_datetime) FROM stdin;
\.


--
-- TOC entry 5081 (class 0 OID 16617)
-- Dependencies: 247
-- Data for Name: task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task (id, mission_id, title, description, due_date, status, create_datetime, update_datetime) FROM stdin;
\.


--
-- TOC entry 5082 (class 0 OID 16625)
-- Dependencies: 248
-- Data for Name: task_comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_comment (id, task_id, commenter_id, comment_text, image_base64, create_datetime) FROM stdin;
\.


--
-- TOC entry 5069 (class 0 OID 16540)
-- Dependencies: 235
-- Data for Name: thesis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.thesis (id, title, description, thesis_type, create_by, start_date, end_date, create_datetime, update_datetime, status, batch_id, major_id, reason) FROM stdin;
\.


--
-- TOC entry 5077 (class 0 OID 16592)
-- Dependencies: 243
-- Data for Name: thesis_committee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.thesis_committee (id, thesis_id, member_id, committee_id, role, created_at) FROM stdin;
\.


--
-- TOC entry 5075 (class 0 OID 16582)
-- Dependencies: 241
-- Data for Name: thesis_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.thesis_group (id, thesis_id, group_id) FROM stdin;
\.


--
-- TOC entry 5070 (class 0 OID 16553)
-- Dependencies: 236
-- Data for Name: thesis_lecturer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.thesis_lecturer (id, lecturer_id, thesis_id, role, create_datetime) FROM stdin;
\.


--
-- TOC entry 5078 (class 0 OID 16597)
-- Dependencies: 244
-- Data for Name: thesis_member_score; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.thesis_member_score (id, thesis_id, student_id, evaluator_id, score, score_type, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 222
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_seq', 1, false);


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 224
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.refresh_tokens_id_seq', 1, false);


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 237
-- Name: score_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.score_type_id_seq', 1, false);


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 229
-- Name: sys_function_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sys_function_id_seq', 1, false);


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 233
-- Name: sys_role_function_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sys_role_function_id_seq', 1, false);


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 227
-- Name: sys_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sys_role_id_seq', 1, false);


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 231
-- Name: sys_user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sys_user_role_id_seq', 1, false);


--
-- TOC entry 4806 (class 2606 OID 16405)
-- Name: academy_year academy_year_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academy_year
    ADD CONSTRAINT academy_year_pkey PRIMARY KEY (id);


--
-- TOC entry 4815 (class 2606 OID 16424)
-- Name: batch batch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.batch
    ADD CONSTRAINT batch_pkey PRIMARY KEY (id);


--
-- TOC entry 4896 (class 2606 OID 16608)
-- Name: committee committee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.committee
    ADD CONSTRAINT committee_pkey PRIMARY KEY (id);


--
-- TOC entry 4842 (class 2606 OID 16480)
-- Name: department department_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_name_key UNIQUE (name);


--
-- TOC entry 4844 (class 2606 OID 16478)
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- TOC entry 4885 (class 2606 OID 16580)
-- Name: group_member group_member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.group_member
    ADD CONSTRAINT group_member_pkey PRIMARY KEY (id);


--
-- TOC entry 4881 (class 2606 OID 16573)
-- Name: group group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 16446)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 4890 (class 2606 OID 16591)
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- TOC entry 4840 (class 2606 OID 16467)
-- Name: lecturer_info lecturer_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturer_info
    ADD CONSTRAINT lecturer_info_pkey PRIMARY KEY (id);


--
-- TOC entry 4853 (class 2606 OID 16499)
-- Name: major major_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.major
    ADD CONSTRAINT major_pkey PRIMARY KEY (id);


--
-- TOC entry 4899 (class 2606 OID 16615)
-- Name: mission mission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mission
    ADD CONSTRAINT mission_pkey PRIMARY KEY (id);


--
-- TOC entry 4849 (class 2606 OID 16489)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4879 (class 2606 OID 16566)
-- Name: score_type score_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.score_type
    ADD CONSTRAINT score_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4813 (class 2606 OID 16414)
-- Name: semester semester_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semester
    ADD CONSTRAINT semester_pkey PRIMARY KEY (id);


--
-- TOC entry 4836 (class 2606 OID 16457)
-- Name: student_info student_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_info
    ADD CONSTRAINT student_info_pkey PRIMARY KEY (id);


--
-- TOC entry 4861 (class 2606 OID 16521)
-- Name: sys_function sys_function_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_function
    ADD CONSTRAINT sys_function_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 16538)
-- Name: sys_role_function sys_role_function_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_role_function
    ADD CONSTRAINT sys_role_function_pkey PRIMARY KEY (id);


--
-- TOC entry 4857 (class 2606 OID 16510)
-- Name: sys_role sys_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_role
    ADD CONSTRAINT sys_role_pkey PRIMARY KEY (id);


--
-- TOC entry 4825 (class 2606 OID 16434)
-- Name: sys_user sys_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_user
    ADD CONSTRAINT sys_user_pkey PRIMARY KEY (id);


--
-- TOC entry 4864 (class 2606 OID 16530)
-- Name: sys_user_role sys_user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sys_user_role
    ADD CONSTRAINT sys_user_role_pkey PRIMARY KEY (id);


--
-- TOC entry 4905 (class 2606 OID 16631)
-- Name: task_comment task_comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_comment
    ADD CONSTRAINT task_comment_pkey PRIMARY KEY (id);


--
-- TOC entry 4902 (class 2606 OID 16623)
-- Name: task task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- TOC entry 4892 (class 2606 OID 16596)
-- Name: thesis_committee thesis_committee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thesis_committee
    ADD CONSTRAINT thesis_committee_pkey PRIMARY KEY (id);


--
-- TOC entry 4888 (class 2606 OID 16586)
-- Name: thesis_group thesis_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thesis_group
    ADD CONSTRAINT thesis_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4877 (class 2606 OID 16557)
-- Name: thesis_lecturer thesis_lecturer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thesis_lecturer
    ADD CONSTRAINT thesis_lecturer_pkey PRIMARY KEY (id);


--
-- TOC entry 4894 (class 2606 OID 16601)
-- Name: thesis_member_score thesis_member_score_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thesis_member_score
    ADD CONSTRAINT thesis_member_score_pkey PRIMARY KEY (id);


--
-- TOC entry 4875 (class 2606 OID 16546)
-- Name: thesis thesis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thesis
    ADD CONSTRAINT thesis_pkey PRIMARY KEY (id);


--
-- TOC entry 4807 (class 1259 OID 16407)
-- Name: ix_academy_year_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_academy_year_id ON public.academy_year USING btree (id);


--
-- TOC entry 4808 (class 1259 OID 16406)
-- Name: ix_academy_year_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_academy_year_name ON public.academy_year USING btree (name);


--
-- TOC entry 4816 (class 1259 OID 16426)
-- Name: ix_batch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_batch_id ON public.batch USING btree (id);


--
-- TOC entry 4817 (class 1259 OID 16427)
-- Name: ix_batch_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_batch_name ON public.batch USING btree (name);


--
-- TOC entry 4818 (class 1259 OID 16425)
-- Name: ix_batch_semester_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_batch_semester_id ON public.batch USING btree (semester_id);


--
-- TOC entry 4882 (class 1259 OID 16574)
-- Name: ix_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_group_id ON public."group" USING btree (id);


--
-- TOC entry 4886 (class 1259 OID 16581)
-- Name: ix_group_member_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_group_member_id ON public.group_member USING btree (id);


--
-- TOC entry 4883 (class 1259 OID 16575)
-- Name: ix_group_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_group_name ON public."group" USING btree (name);


--
-- TOC entry 4828 (class 1259 OID 16449)
-- Name: ix_information_first_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_information_first_name ON public.information USING btree (first_name);


--
-- TOC entry 4829 (class 1259 OID 16448)
-- Name: ix_information_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_information_id ON public.information USING btree (id);


--
-- TOC entry 4830 (class 1259 OID 16447)
-- Name: ix_information_last_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_information_last_name ON public.information USING btree (last_name);


--
-- TOC entry 4831 (class 1259 OID 16450)
-- Name: ix_information_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_information_user_id ON public.information USING btree (user_id);


--
-- TOC entry 4837 (class 1259 OID 16469)
-- Name: ix_lecturer_info_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_lecturer_info_id ON public.lecturer_info USING btree (id);


--
-- TOC entry 4838 (class 1259 OID 16468)
-- Name: ix_lecturer_info_lecturer_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_lecturer_info_lecturer_code ON public.lecturer_info USING btree (lecturer_code);


--
-- TOC entry 4850 (class 1259 OID 16500)
-- Name: ix_major_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_major_id ON public.major USING btree (id);


--
-- TOC entry 4851 (class 1259 OID 16501)
-- Name: ix_major_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_major_name ON public.major USING btree (name);


--
-- TOC entry 4897 (class 1259 OID 16616)
-- Name: ix_mission_thesis_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_mission_thesis_id ON public.mission USING btree (thesis_id);


--
-- TOC entry 4845 (class 1259 OID 16490)
-- Name: ix_refresh_tokens_access_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_refresh_tokens_access_token ON public.refresh_tokens USING btree (access_token);


--
-- TOC entry 4846 (class 1259 OID 16491)
-- Name: ix_refresh_tokens_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_refresh_tokens_id ON public.refresh_tokens USING btree (id);


--
-- TOC entry 4847 (class 1259 OID 16492)
-- Name: ix_refresh_tokens_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_refresh_tokens_token ON public.refresh_tokens USING btree (token);


--
-- TOC entry 4809 (class 1259 OID 16415)
-- Name: ix_semester_academy_year_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_semester_academy_year_id ON public.semester USING btree (academy_year_id);


--
-- TOC entry 4810 (class 1259 OID 16416)
-- Name: ix_semester_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_semester_id ON public.semester USING btree (id);


--
-- TOC entry 4811 (class 1259 OID 16417)
-- Name: ix_semester_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_semester_name ON public.semester USING btree (name);


--
-- TOC entry 4832 (class 1259 OID 16460)
-- Name: ix_student_info_class_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_student_info_class_name ON public.student_info USING btree (class_name);


--
-- TOC entry 4833 (class 1259 OID 16458)
-- Name: ix_student_info_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_student_info_id ON public.student_info USING btree (id);


--
-- TOC entry 4834 (class 1259 OID 16459)
-- Name: ix_student_info_student_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_student_info_student_code ON public.student_info USING btree (student_code);


--
-- TOC entry 4858 (class 1259 OID 16523)
-- Name: ix_sys_function_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sys_function_id ON public.sys_function USING btree (id);


--
-- TOC entry 4859 (class 1259 OID 16522)
-- Name: ix_sys_function_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_sys_function_name ON public.sys_function USING btree (name);


--
-- TOC entry 4865 (class 1259 OID 16539)
-- Name: ix_sys_role_function_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sys_role_function_id ON public.sys_role_function USING btree (id);


--
-- TOC entry 4854 (class 1259 OID 16511)
-- Name: ix_sys_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sys_role_id ON public.sys_role USING btree (id);


--
-- TOC entry 4855 (class 1259 OID 16512)
-- Name: ix_sys_role_role_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_sys_role_role_code ON public.sys_role USING btree (role_code);


--
-- TOC entry 4819 (class 1259 OID 16439)
-- Name: ix_sys_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sys_user_id ON public.sys_user USING btree (id);


--
-- TOC entry 4820 (class 1259 OID 16436)
-- Name: ix_sys_user_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sys_user_is_active ON public.sys_user USING btree (is_active);


--
-- TOC entry 4821 (class 1259 OID 16435)
-- Name: ix_sys_user_password; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sys_user_password ON public.sys_user USING btree (password);


--
-- TOC entry 4862 (class 1259 OID 16531)
-- Name: ix_sys_user_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sys_user_role_id ON public.sys_user_role USING btree (id);


--
-- TOC entry 4822 (class 1259 OID 16438)
-- Name: ix_sys_user_user_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sys_user_user_name ON public.sys_user USING btree (user_name);


--
-- TOC entry 4823 (class 1259 OID 16437)
-- Name: ix_sys_user_user_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sys_user_user_type ON public.sys_user USING btree (user_type);


--
-- TOC entry 4903 (class 1259 OID 16632)
-- Name: ix_task_comment_task_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_comment_task_id ON public.task_comment USING btree (task_id);


--
-- TOC entry 4900 (class 1259 OID 16624)
-- Name: ix_task_mission_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_task_mission_id ON public.task USING btree (mission_id);


--
-- TOC entry 4868 (class 1259 OID 16548)
-- Name: ix_thesis_batch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_thesis_batch_id ON public.thesis USING btree (batch_id);


--
-- TOC entry 4869 (class 1259 OID 16547)
-- Name: ix_thesis_description; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_thesis_description ON public.thesis USING btree (description);


--
-- TOC entry 4870 (class 1259 OID 16550)
-- Name: ix_thesis_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_thesis_id ON public.thesis USING btree (id);


--
-- TOC entry 4871 (class 1259 OID 16549)
-- Name: ix_thesis_major_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_thesis_major_id ON public.thesis USING btree (major_id);


--
-- TOC entry 4872 (class 1259 OID 16552)
-- Name: ix_thesis_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_thesis_status ON public.thesis USING btree (status);


--
-- TOC entry 4873 (class 1259 OID 16551)
-- Name: ix_thesis_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_thesis_title ON public.thesis USING btree (title);


-- Completed on 2025-06-17 13:30:26

--
-- PostgreSQL database dump complete
--

