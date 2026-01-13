--
-- PostgreSQL database dump
--

\restrict imceF29BJogSNV8r7E2j1UlbVaeiU6rGsrr7fEMUDE4FI4zMKYUgC0mvbbDud1G

-- Dumped from database version 18.1 (Postgres.app)
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tenders; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tenders;


ALTER SCHEMA tenders OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: departments; Type: TABLE; Schema: tenders; Owner: postgres
--

CREATE TABLE tenders.departments (
    department_id integer NOT NULL,
    name text
);


ALTER TABLE tenders.departments OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: tenders; Owner: postgres
--

CREATE SEQUENCE tenders.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tenders.departments_department_id_seq OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: tenders; Owner: postgres
--

ALTER SEQUENCE tenders.departments_department_id_seq OWNED BY tenders.departments.department_id;


--
-- Name: industries; Type: TABLE; Schema: tenders; Owner: postgres
--

CREATE TABLE tenders.industries (
    industry_id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE tenders.industries OWNER TO postgres;

--
-- Name: industries_industry_id_seq; Type: SEQUENCE; Schema: tenders; Owner: postgres
--

CREATE SEQUENCE tenders.industries_industry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tenders.industries_industry_id_seq OWNER TO postgres;

--
-- Name: industries_industry_id_seq; Type: SEQUENCE OWNED BY; Schema: tenders; Owner: postgres
--

ALTER SEQUENCE tenders.industries_industry_id_seq OWNED BY tenders.industries.industry_id;


--
-- Name: provinces; Type: TABLE; Schema: tenders; Owner: postgres
--

CREATE TABLE tenders.provinces (
    province_id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE tenders.provinces OWNER TO postgres;

--
-- Name: provinces_province_id_seq; Type: SEQUENCE; Schema: tenders; Owner: postgres
--

CREATE SEQUENCE tenders.provinces_province_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tenders.provinces_province_id_seq OWNER TO postgres;

--
-- Name: provinces_province_id_seq; Type: SEQUENCE OWNED BY; Schema: tenders; Owner: postgres
--

ALTER SEQUENCE tenders.provinces_province_id_seq OWNED BY tenders.provinces.province_id;


--
-- Name: staging_tenders; Type: TABLE; Schema: tenders; Owner: postgres
--

CREATE TABLE tenders.staging_tenders (
    tender_ref text,
    tender_description text,
    tender_category text,
    advertised_date text,
    closing_date text,
    industry text,
    tender_requested_by_dept text,
    tender_type text,
    province text,
    service_location text,
    special_conditions text,
    contact_person text,
    contact_email text,
    contact_telephone text,
    attachments text,
    attachment_download_url text,
    created_time text,
    briefing_session text,
    briefing_compulsory text,
    briefing_date_time text,
    briefing_venue text,
    trial_data text,
    tender_review_summary text,
    id text,
    created_at text
);


ALTER TABLE tenders.staging_tenders OWNER TO postgres;

--
-- Name: tender_briefings; Type: TABLE; Schema: tenders; Owner: postgres
--

CREATE TABLE tenders.tender_briefings (
    tender_id uuid NOT NULL,
    is_scheduled boolean DEFAULT false,
    is_compulsory boolean DEFAULT false,
    briefing_datetime timestamp with time zone,
    briefing_venue text
);


ALTER TABLE tenders.tender_briefings OWNER TO postgres;

--
-- Name: tender_categories; Type: TABLE; Schema: tenders; Owner: postgres
--

CREATE TABLE tenders.tender_categories (
    tender_category_id integer NOT NULL,
    name text
);


ALTER TABLE tenders.tender_categories OWNER TO postgres;

--
-- Name: tender_categories_tender_category_id_seq; Type: SEQUENCE; Schema: tenders; Owner: postgres
--

CREATE SEQUENCE tenders.tender_categories_tender_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tenders.tender_categories_tender_category_id_seq OWNER TO postgres;

--
-- Name: tender_categories_tender_category_id_seq; Type: SEQUENCE OWNED BY; Schema: tenders; Owner: postgres
--

ALTER SEQUENCE tenders.tender_categories_tender_category_id_seq OWNED BY tenders.tender_categories.tender_category_id;


--
-- Name: tender_types; Type: TABLE; Schema: tenders; Owner: postgres
--

CREATE TABLE tenders.tender_types (
    tender_type_id integer NOT NULL,
    code text NOT NULL
);


ALTER TABLE tenders.tender_types OWNER TO postgres;

--
-- Name: tender_types_tender_type_id_seq; Type: SEQUENCE; Schema: tenders; Owner: postgres
--

CREATE SEQUENCE tenders.tender_types_tender_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tenders.tender_types_tender_type_id_seq OWNER TO postgres;

--
-- Name: tender_types_tender_type_id_seq; Type: SEQUENCE OWNED BY; Schema: tenders; Owner: postgres
--

ALTER SEQUENCE tenders.tender_types_tender_type_id_seq OWNED BY tenders.tender_types.tender_type_id;


--
-- Name: tenders; Type: TABLE; Schema: tenders; Owner: postgres
--

CREATE TABLE tenders.tenders (
    tender_id uuid NOT NULL,
    tender_ref text NOT NULL,
    tender_description text NOT NULL,
    tender_category_id integer,
    advertised_date date,
    closing_date date,
    industry_id integer,
    requested_by_department_id integer,
    tender_type_id integer,
    province_id integer,
    service_location text,
    special_conditions text,
    contact_person text,
    contact_email text,
    contact_telephone text,
    attachments jsonb DEFAULT '[]'::jsonb,
    attachment_download_url text,
    created_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    trial_data jsonb,
    tender_review_summary text
);


ALTER TABLE tenders.tenders OWNER TO postgres;

--
-- Name: departments department_id; Type: DEFAULT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.departments ALTER COLUMN department_id SET DEFAULT nextval('tenders.departments_department_id_seq'::regclass);


--
-- Name: industries industry_id; Type: DEFAULT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.industries ALTER COLUMN industry_id SET DEFAULT nextval('tenders.industries_industry_id_seq'::regclass);


--
-- Name: provinces province_id; Type: DEFAULT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.provinces ALTER COLUMN province_id SET DEFAULT nextval('tenders.provinces_province_id_seq'::regclass);


--
-- Name: tender_categories tender_category_id; Type: DEFAULT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tender_categories ALTER COLUMN tender_category_id SET DEFAULT nextval('tenders.tender_categories_tender_category_id_seq'::regclass);


--
-- Name: tender_types tender_type_id; Type: DEFAULT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tender_types ALTER COLUMN tender_type_id SET DEFAULT nextval('tenders.tender_types_tender_type_id_seq'::regclass);


--
-- Data for Name: departments; Type: TABLE DATA; Schema: tenders; Owner: postgres
--

COPY tenders.departments (department_id, name) FROM stdin;
\.


--
-- Data for Name: industries; Type: TABLE DATA; Schema: tenders; Owner: postgres
--

COPY tenders.industries (industry_id, name) FROM stdin;
1	SECURITY
2	CLEANING
3	CONSTRUCTION
\.


--
-- Data for Name: provinces; Type: TABLE DATA; Schema: tenders; Owner: postgres
--

COPY tenders.provinces (province_id, name) FROM stdin;
1	Gauteng
2	Western Cape
3	Mpumalanga
4	North West
5	Eastern Cape
6	Northern Cape
7	Limpopo
8	KwaZulu-Natal
\.


--
-- Data for Name: staging_tenders; Type: TABLE DATA; Schema: tenders; Owner: postgres
--

COPY tenders.staging_tenders (tender_ref, tender_description, tender_category, advertised_date, closing_date, industry, tender_requested_by_dept, tender_type, province, service_location, special_conditions, contact_person, contact_email, contact_telephone, attachments, attachment_download_url, created_time, briefing_session, briefing_compulsory, briefing_date_time, briefing_venue, trial_data, tender_review_summary, id, created_at) FROM stdin;
DFFEQ 255 CLEANING MATERIAL 2025	SUPPLY AND DELIVER CLEANING MATERIAL	\N	45960	45968	CLEANING	\N	RFQ	Western Cape	24 East Pier Road, Victoria & Alfred Waterfront, Cape Town , 8001 - V & A WATERFRONT - Cape Town - 8001	\N	Andiswa Euphimia Charlie	acharlie@dffe.gov.za	021-493-7149	\N	\N	2025-10-30 12:16:00.657+00	0	0	\N	\N	\N	\N	007857b7-db1f-41aa-b3a0-5cb5cf76d0b2	2025-10-30 12:16:01.820305+00
74312	Re-advertisement: Appointment of a multi-disciplinary team (Architect as Principal Agent, Quantity Surveyor, Civil / Structural Engineer, Electrical Engineer, Mechanical and Fire Engineer) to provide Professional Services for the Refurbishment, Repairs and Alterations to Nurses‚Äô Accommodation at RK Khan Hospital.	\N	45936	45964	CONSTRUCTION	\N	RFQ	KwaZulu-Natal	R K Khan Hospital - Durban - Durban - 4001	Compulsory Briefing session Date : 16 October 2025 Time : 11h00 Venue : MS Teams (online) Meeting ID : 365 818 402 252 5 Passcode : fe6zx9kp Meeting link : https://teams.microsoft.com/l/meetup-join/19%3ameeting_MDM1MTU5M2UtZmE2OS00NTZjLWFjMGMtYjQzMWViNDQ0MzJl%40thread.v2/0?context=%7b%22Tid%22%3a%229a833c6f-eba4-468f-be72-dcf3d89967e8%22%2c%22Oid%22%3a%22d74f21f3-4645-4cb9-9458-dd1d511f3c0e%22%7d All attendees to submit (1) Tenderer‚Äôs Business Name, (2) the Representatives Name, (3) a Contact number and (4) Email address, via the MS Teams chat upon entry as confirmation of attendance. Online register to serve as proof of attendance.	Ms S Mahabeer	shehana.mahabeer@kznworks.gov.za	072-261-4210	\N	\N	2025-10-06 12:22:14.589+00	1	1	2025-10-16 11:00:00+00	Teams-365 818 402 252 5 Passcode : fe6zx9kp	\N	\N	00b9d4e2-95fe-4beb-8230-3e41c2e93391	2025-10-06 12:22:15.444739+00
RFT84/10/2025/26	APPOINTMENT OF A SERVICE PROVIDER TO SUPPLY, INSTALL, MONITOR AND MAINTAIN CCTV CAMERAS AND BIOMETRIC ACCESS CONTROL SYSTEM AT MADIBENG LOCAL MUNICIPALITY FOR A PERIOD OF 36 MONTHS.	\N	45947	45978	SECURITY	\N	RFQ	North West	53 Van Velden - Brits - Brits - 0250	Tender documents are obtainable at Municipal Offices (Brits) at a cost of R3000.00 per document on a non-refundable deposit in cash. EFT; Cheques will not be accepted. Payment is made at the Ground floor, Main Municipal Building, 53 van Velden Street, Brits	Mr. Johannes Magoro	johannesmagoro@madibeng.gov.za	012-493-7777	\N	\N	2025-10-17 13:16:54.592+00	0	0	\N	\N	\N	\N	00ee982f-f978-4f83-87ff-0e462fba7bcb	2025-10-17 13:16:55.833709+00
781/08/25	SUPPLY, DELIVERY, AND ERECTION OF MUNICIPAL GRAVEYARD FENCING	\N	45980	45994	CONSTRUCTION	\N	RFQ	KwaZulu-Natal	61 MARTIN STREET uPHONGOLO LOCAL MUNICIPALITY - PONGOLA - PONGOLA - 3170	SEE DOCUMENT	MR MS MTSHALI	musawenkosim@uphongolo.gov.za	034-413-1223	\N	\N	2025-11-19 13:53:11.54+00	1	1	2025-11-25 10:00:00+00	uPhongolo Local Municipality, Office in Pongola, 61 Martin Street, 3170	\N	\N	01544ee3-d154-44ff-ae41-a1b2c76eb079	2025-11-19 13:53:12.252102+00
RFQ 4083/24	Request for service provider to do an assessment and quoting in Earthing refurbishment, testing and Concrete slab refurbishment, leveling at Lightning Detection Network (LDN) sites.	\N	45916	45933	CONSTRUCTION	\N	RFQ	Gauteng	Irene Weather Office which is situated on the premises of the Agricultural Research Council (ARC), I - Irene - Pretoria - 0157	\N	Zandile Sebotsane	RFQsubmissions@weathersa.co.za	012-367-6000	\N	\N	2025-09-16 13:21:48.66+00	1	1	2025-09-25 11:21:00+00	South African Weather Service Irene Weather Office Situated on the grounds of the Agricultural Resea	\N	\N	01dabc94-36b4-42fc-9c30-231b5fd30ffe	2025-09-16 13:21:49.079744+00
KZNL 08/2025	APPOINTMENT OF A SERVICE PROVIDER FOR RENDERING OF SECURITY OPERATIONS CENTRE (SOC) AND MANAGED SECURITY INFORMATION AND EVENTS MANAGEMENT (SIEM) SERVICE FOR 36 MONTHS	\N	45922	45952	SECURITY	\N	RFQ	KwaZulu-Natal	244 LANGALIBALELE STREET - PIETERMARITZBURG - PIETERMARITZBURG - 3201	Tender Briefing session will be held on 06 OCTOBER 2025 at 13h00 via Microsoft teams. Interested bidders are requested to forward their email addresses and name of the company to tenders@kznleg.gov.za before or on the 03 OCTOBER 2025 at 16h30.	Mr G.N. Ngcamu	tenders@kznleg.gov.za	033-355-7548	\N	\N	2025-09-22 12:42:34.72+00	1	1	2025-10-06 13:00:00+00	MICROSOFT TEAMS	\N	\N	0279fbfb-b1d6-4653-95a6-f4794123e509	2025-09-22 12:42:35.402471+00
SRVM-EOI-01/2026	NOTICE FOR INVITING EXPRESSION OF INTEREST TO OPERATE, MANAGE AND COORDINATING EVENTS AT THE KIRKWOOD PUBLIC SWIMMING POOL FOR MEDIUM-TERM PERIOD ENDING 30 JUNE 2026	\N	45953	45966	CONSTRUCTION	\N	EOI	Eastern Cape	23 MIDDLE STREET - Kirkwood - Kirkwood - 6120	\N	SIBONILE SIBACA	siboniles@srvm.gov.za	042-230-7775	\N	\N	2025-10-23 13:50:20.146+00	0	0	\N	\N	\N	\N	02a25190-dd97-4936-a657-e8184c72394c	2025-10-23 13:50:20.396436+00
BID 08/25	RE-ADVERT FOR PROVISION OF SECURITY SERVICES AT FRANCES BAARD OFFICES FOR A PERIOD OF THREE (3) YEARS	\N	45931	45950	SECURITY	\N	RFQ	Northern Cape	51 Drakensberg Avenue - Carters Glen - Kimberley - 8300	NB: A compulsory briefing / clarification meeting will be held on 07 October 2025 at 10:00 at the offices of FBDM: 51 Drakensberg Avenue, Carters Glen, Kimberley. For all compulsory site/briefing sessions, all bidders must assemble at the reception area at the stated time from where they will be escorted to the relevant room where the compulsory briefing meeting will be held. Late service providers who are not at the reception area at the stated time will not be allowed into the compulsory briefing meeting and will be prohibited from submitting proposals.	Mr. C. Jones	eric.tlhageng@fbdm.co.za	053-838-0925	\N	\N	2025-10-01 12:36:49.892+00	1	1	2025-10-07 10:00:00+00	Frances Baard District Municipal Offices, 51 Drakensberg Avenue, Carters Glen, Kimberley	\N	\N	02cd46ea-6877-4cc5-8abe-45651babde3a	2025-10-01 12:36:50.415366+00
WTE-0400 CS	SUPPLY AND DELIVERY ELECTRICAL HIGH-FREQUENCY INTERNAL CONCRETE VIBRATORS FOR CLANWILLIAM DAM IN THE WESTERN CAPE FOR DWS CONSTRUCTION SOUTH.	\N	45910	45932	CONSTRUCTION	\N	RFQ	Western Cape	CLANWILLIAM - CLANWILLIAM - CLANWILLIAM -	DATE: 17 SEPTEMBER 2025 VENUE: MASKAMSIG HALL IN VAN RHYNSDORP CO-ORDINATES: 18¬∞35‚Äô48.4‚Äô‚ÄôS and 18¬∞45‚Äô06.5‚Äô‚ÄôE TIME: 09:00 TILL 10:00 DATE: 17 SEPTEMBER 2025 VENUE: VREDENDAL NORTH COMMUNITY HALL CO-ORDINATES: LATITUDE. -31.64456¬∞ and LONGTITUDE. 185255¬∞ TIME: 12:00 TILL 13:00 DATE: 18 SEPTEMBER 2025 VENUE: CEDERBERG MUNICIPAL CHAMBERS CITRUSDAL CO-ORDINATES: 32¬∞35‚Äô22.2‚Äô‚ÄôS and 19¬∞00‚Äô53‚Äô‚ÄôE TIME: 09:00 TILL 10:00 DATE: 18 SEPTEMBER 2025 VENUE: DWS CONSTRUCTION SOUTH CLANWILLIAM DAM TRAINING CENTRE CO-ORDINATES: 32¬∞11‚Äô5‚Äô‚ÄôS and 18¬∞52‚Äô1‚Äô‚ÄôE TIME: 12:00 TILL 13:00	B CROUS	crousb@dws.gov.za	021-872-0591	\N	\N	2025-09-10 12:58:25.046+00	1	1	\N	see in special conditions below	\N	\N	04b3bb23-153e-4f62-aba7-c435ecf6f64c	2025-09-10 12:58:25.346744+00
KZNB02/DSD/2025/26	ESTABLISHMENT OF A PANEL OF SERVICE PROVIDERS TO PROVIDE CLEANING SERVICE FOR THE DEPARTMENT OF SOCIAL DEVELOPMENT KWAZULU - NATAL FOR A PERIOD OF SIXTY (60) MONTHS	\N	45973	46003	CLEANING	\N	RFQ	KwaZulu-Natal	208 Hoosen Haffejee - Pietermaritzburg - Pietermaritzburg - 3201	\N	Ms. L.T Dandile	thandeka.dandile@kzndsd.gov.za	033-897-9908	\N	\N	2025-11-12 12:04:44.715+00	1	1	2025-11-26 10:00:00+00	https://teams.microsoft.com/l/meetup-join/19%3ameeting_NDg0MGMyNDMtYzA0Ni00YjdiLTkwYTctOWZiMGNkYTQwN	\N	\N	05828357-4e80-491f-ab66-906cd082ee36	2025-11-12 12:04:46.708662+00
SAST/RFQ/2025/281	Supply and installation of roof floors	\N	45978	45966	CONSTRUCTION	\N	RFQ	Gauteng	320 Pretorius street - Pretoria - Pretoria - 0025	Kindly attach: ‚Ä¢ Fully completed SBD1,SBD 4 and 6.1( Score page 5 of 7 on SBD 6.1) ‚Ä¢ Completed POPIA -Consent form ‚Ä¢ Signed GCC (all pages must be signed) ‚Ä¢ CSD Report ‚ÄÇ ‚Ä¢ Valid B-BBEE certificate or Affidavit in case of EME or QSE ‚Ä¢ Valid SARS Tax pin certificate ‚Ä¢ Certified Share certificate ‚Ä¢ CIPC -Company registration ‚Ä¢ Directors IDs (all directors listed in the CIPC)	Phindile Mabasa	RFQ@statetheatre.co.za	012-392-4000	\N	\N	2025-11-17 12:58:25.876+00	1	1	2025-11-25 11:00:00+00	The South African state theatre	\N	\N	06a5c3b7-7f62-432f-908e-60c0c8bd89de	2025-11-17 12:58:26.923213+00
ITVETC-001/10/2025	APPOINTMENT OF A CONTRACTOR FOR THE SUPPLY AND INSTALLATION OF BLOCK B & WORKSHOP ELEVATOR AT IKHALA TVET COLLEGE ALIWAL NORTH CAMPUS (4GB PE OR 4 ME PE OR HIGHER)	\N	45954	45978	CONSTRUCTION	\N	RFQ	Eastern Cape	ZONE D, 2020 GWADANA DRIVE, EZIBELENI - QUEENSTOWN - QUEENSTOWN - 5326	Documents can be purchased from Supply Chain Management Unit, Ikhala TVET College, Administration Centre, OR can be downloaded from National Treasury Portal at a Non refundable fee of R150 each. Suppliers should send the proof of payment to SCM and attached PoP on the tender document upon the return of the submission.	MR NKOSINATHI FUTSHANE	nkosinathi.futshane@ikhala.edu.za	071-898-3042	\N	\N	2025-10-24 12:37:13.027+00	1	1	2025-10-30 10:00:00+00	ONLINE COMPULSORY INFORMATION SESSION	\N	\N	06f649dc-1156-4de2-9081-e69a17e2f2d5	2025-10-24 12:37:13.259836+00
10111514	The Road Accident Fund (RAF) wishes to appoint a suitable service provider to Maintain, Service and Repair Security Systems at Durban Office on a month-to-month basis for a period not exceeding six (6) months).	\N	45918	45925	SECURITY	\N	RFQ	KwaZulu-Natal	\N	\N	Phakamani Zulu	phakamaniz@raf.co.za	031-365-2979	\N	\N	2025-09-18 12:40:39.557+00	1	1	2025-09-22 11:00:00+00	12th Floor Embassy Building, RAF Durban Offices	\N	\N	07b2cb76-9050-4877-93e7-b737c7806fb5	2025-09-18 12:40:40.525723+00
EEC/T04/2025	Stormwater reticulation and installation of carports at Benoni campus	\N	45911	45919	CONSTRUCTION	\N	RFQ	Gauteng	O`Reilly Merry Street in Benoni - Northmead - Benoni - 1501	1. Compulsory briefing session 2. CIDB Grading : 6CE 3. Tender amount: 1000	Ms Azwihangwisi Tshitema	azwihangwisit@eec.edu.za	011-730-6600	\N	\N	2025-09-11 12:57:56.413+00	1	1	2025-09-18 10:00:00+00	Ekurhuleni East TVET College, Benoni Campus Staff Room, O`Reilly Merry Street Benoni,	\N	\N	08630b62-ec4b-4be0-885a-283bffed1254	2025-09-11 12:57:57.866591+00
PWRT/2602/25/MP	RENOVATION AND CONSTRUCTION OF LUGEBHUTA SECONDARY SCHOOL, IN SCHOEMANSDAL, SHONGWE MISSION, NKOMAZI LOCAL MUNICIPALITY, MPUMALANGA PROVINCE - PHASE 03	\N	45909	45932	CONSTRUCTION	\N	RFQ	Mpumalanga	Riversisde Government Complex, Building no: 9, Government Boulevard - Riverside - Mbombela - 1200	\N	Mr L Buasi	LBuasi@mpg.gov.za	013-766-8920	\N	\N	2025-09-09 10:02:28.361+00	1	1	2025-09-17 10:00:00+00	Lugebhuta Secondary School, Schoemansdal, Nkomazi Local Municipality	\N	\N	08d9c64b-79ee-4483-87e1-87e496b320ae	2025-09-09 10:02:29.032983+00
TMT-DBE-25/26-SAFE6-KZNCL2	TENDER DOCUMENT FOR CONSTRUCTION OF SANITATION FACILITIES AT LUNDINI PRIMARY SCHOOL IN KWAZULU NATAL PROVINCE	\N	45931	45945	CONSTRUCTION	\N	RFQ	KwaZulu-Natal	69 Devereux Avenue - Vincent - East London - 5201	\N	Anele Nqambi	anele@themvulatrust.org.za	043-726-2255	\N	\N	2025-10-01 12:12:16.699+00	0	0	\N	\N	\N	\N	097bb570-b823-4fde-a137-8db14eea425c	2025-10-01 12:12:17.331135+00
GMQ073/25-26	GMQ073/25-26 ‚Äì Appointment of a Service Provider for CCTV Surveillance Training and Body Language Course for CCTV Operators	\N	45937	45947	SECURITY	\N	RFQ	Western Cape	71 York Street - George - George - 6530	\N	Claudette Rondganger	crondganger@george.gov.za	044-801-9304	\N	\N	2025-10-07 12:27:22.955+00	0	0	\N	\N	\N	\N	0a9e1f41-11e3-4b98-a296-be4a3e2be645	2025-10-07 12:27:22.945474+00
WTE136CE..	The Removal of Bees from Construction East - Grootdraai Dam ,Vlakfontein Canal and Standerton WTW close to Standerton in the Mpumalanga Province	\N	45909	45926	CONSTRUCTION	\N	RFQ	Mpumalanga	Vlakfontein Canal Project - standerton - standerton - 2430	SUBMIT COMPLETED AND SIGNED BID DOCUMENTS TO: POSTAL ADDRESS: OR TO BE DEPOSITED IN: Department of Water and Sanitation The bid box at the entrance of Supply Chain Management Office Construction East Office Building Private Bag X2023 Grootdraai Dam STANDERTON STANDERTON 2430 2430 Physical Address: Ermelo R 39 Road, Grootdraai Dam close to Standerton Construction East Office 2430 Compulsory Briefing Session Date: 18 September 2025 Time: 10am Venue: Grootdraai Dam, Vlakfontein Canal and Standerton WTW in the Mpumalanga Province.	Rejoice Kubheka	kubhekan@dws.gov.za	017-720-1616	\N	\N	2025-09-09 09:52:44.586+00	1	1	2025-09-18 10:00:00+00	Vlakfontein Canal Project near Standerton	\N	\N	0adc0350-eb26-40cf-bc87-e236c620b919	2025-09-09 09:52:44.809119+00
E1709DXEC	EXECUTION AND CONSTRUCTION OF MIDDELBURG/BULHOEK 22KV STRENGTHENING PHASE 2	\N	45884	45925	CONSTRUCTION	\N	RFQ	Eastern Cape	Corner Querera Drive and Bonza Bay Road - Beacon Bay - East London - 5205	N/A	Lonwabo Mavukwana	mavukwlm@eskom.co.za	043-703-2023	\N	\N	2025-08-15 11:13:46.45+00	1	1	\N	Eskom Middelburg Substation	\N	\N	0b3a69bc-ee25-4312-b8d8-ec4f2644ab6d	2025-08-15 11:13:47.287847+00
E1729NTCSAWG	E1729NTCSAWG - Cleaning services and general labour services for the various sites in the Western Grid (Western and Northern Cape) for 36 months	\N	45890	45926	CLEANING	\N	RFQ	Western Cape	60 Voortrekker Road - Bellville - Bellville - 7535	PLEASE DOWN ALL TENDER DOCUMENTS FROM NTCSA TENDERBULLETIN OR NT WEBSITE	Sandi Bokveldt-Lize	LizeSN@ntcsa.co.za	021-980-3003	\N	\N	2025-08-21 10:56:34.853+00	1	0	2025-08-28 10:00:00+00	MS Teams	\N	\N	0b47f249-b21e-4cf1-aa99-5199c1ff2114	2025-08-21 10:56:35.817645+00
DLRRD (CRD-09) 2025/26	THE APPOINTMENT OF A SERVICE PROVIDER TO RENDER CLEANING AND HYGIENE SERVICES FOR THE DEPARTMENT OF LAND REFORM AND RURAL DEVELOPMENT- EASTERN CAPE DEEDS REGISTRY: MTHATHA FOR A PERIOD OF 36 MONTHS.	\N	45968	45992	CLEANING	\N	RFQ	Eastern Cape	Eastern Cape Deeds Registry: Corner Owen and Leeds Street, Botha Sigcau Building - Mthatha - East London - 5200	\N	BUTI MATJILA	Buti.Matjila@deeds.gov.za	082-385-4570	\N	\N	2025-11-07 12:23:08.608+00	1	1	2025-11-29 12:30:00+00	Eastern Cape Deeds Registry: Corner Owen and Leeds Street, Botha Sigcau Building	\N	\N	0bb9cb38-632b-4941-920c-92750cfdb3b7	2025-11-07 12:23:09.672534+00
ZNQSRO25/2025-2026	DEPARTMENT OF PUBLIC WORKS: THE APPOINTMENT OF A SUITABLE SERVICE PROVIDER TO RENDER THE SAFEGUARDING AND SECURITY SERVICES FOR A PERIOD OF FOUR (4) MONTHS AT SOUTHERN REGION OFFICE: 10 -18 PRINCE ALFRED STREET EXTENSION, PIETERMARITZBURG.	\N	45967	45975	SECURITY	\N	RFQ	KwaZulu-Natal	10-18 Prince Alfred Street - Campsdrifts - Town - 3201	Only Bidders registered within the applicable Central Suppliers Database, PSIRA, a letter of Good Standing with PSIRA, ICASA AND COIDA will be eligible to submit bids. The Preference points system is applicable for this bid 80/20, where 20 Points of specific goals per project allocated ‚Ä¢ Ownership by People who are Youth: 10 points. ‚Ä¢ 51% Ownership by People who are Military Veterans: 10 points	Ms J. Ngidi	janet.ngidi@kznworks.gov.za	033-897-1300	\N	\N	2025-11-06 13:09:59.03+00	0	0	\N	\N	\N	\N	0c416b21-cebe-4421-a35a-05994733505b	2025-11-06 13:09:59.617221+00
LDPWRI-B20564	Appointment of a Turkey Contractor for the Refurbishment of the Parliamentary Club House at the Parliamentary Village - Once Off	\N	45923	45944	CONSTRUCTION	\N	RFQ	Limpopo	43 CHURCH STREET - POLOKWANE - POLOKWANE - 0699	Supplier should be 6 GB or Higher Tender should be dropped at Corner River & Blaauwberg Street Ladanna	NJ Motsopye	motsopyenj@dpw.limpopo.gov.za	015-284-7126	\N	\N	2025-09-23 13:30:50.637+00	1	1	2025-10-01 11:00:00+00	Parliamentary Village Club House at Parliamentary Village	\N	\N	0c52ca80-6ce3-41d3-8bc5-1688731bd439	2025-09-23 13:30:51.100222+00
EMLM 06/2026	PROVISION OF VIP PROTECTION AND STATIC SECURITY SERVICES IN ELIAS MOTSOALEDI LOCAL MUNICIPALITY FOR A PERIOD OF THREE (3) YEARS (RE-ADVERT)	\N	45975	46006	SECURITY	\N	RFQ	Limpopo	2nd Grober Avenue - Groblersdal - Groblersdal - 0470	\N	V Masilela	vmasilela@emlm.gov.za	013-262-3056	\N	\N	2025-11-14 13:05:28.943+00	1	1	2025-12-03 11:00:00+00	Municipal Chamber (2nd Grobler Avenue, Groblersdal 0470)	\N	\N	0c77a262-7dc4-426d-8487-a3d1febea595	2025-11-14 13:05:30.07249+00
IZIKO-RFQ ‚Äì SLIDING DOOR - RFQ-2025/10/08	The Iziko South African Museum is looking to procure supply and installation of glass sliding door for ISAM200 commemorative garden	\N	45943	45952	CONSTRUCTION	\N	RFQ	Western Cape	\N	Quotes / Proposals, and accompanying documentation, must be emailed to (SCM) 021 481 3917 Sikelwa Madlavu smadlavu@iziko.org.za and scm@iziko.org.za	Gabriel Lukoji	glukoji@iziko.org.za	021-481-7240	\N	\N	2025-10-14 07:27:52.026+00	1	1	2025-10-15 10:00:00+00	Iziko South African Museum, 25 Queen Victoria Street, Gardens, Cape Town 8001	\N	\N	0ce8e5c8-631a-47b2-a514-408aa4e58d0b	2025-10-14 07:27:51.687304+00
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: tender_briefings; Type: TABLE DATA; Schema: tenders; Owner: postgres
--

COPY tenders.tender_briefings (tender_id, is_scheduled, is_compulsory, briefing_datetime, briefing_venue) FROM stdin;
007857b7-db1f-41aa-b3a0-5cb5cf76d0b2	f	f	\N	\N
00b9d4e2-95fe-4beb-8230-3e41c2e93391	t	t	2025-10-16 13:00:00+02	Teams-365 818 402 252 5 Passcode : fe6zx9kp
00ee982f-f978-4f83-87ff-0e462fba7bcb	f	f	\N	\N
01544ee3-d154-44ff-ae41-a1b2c76eb079	t	t	2025-11-25 12:00:00+02	uPhongolo Local Municipality, Office in Pongola, 61 Martin Street, 3170
01dabc94-36b4-42fc-9c30-231b5fd30ffe	t	t	2025-09-25 13:21:00+02	South African Weather Service Irene Weather Office Situated on the grounds of the Agricultural Resea
0279fbfb-b1d6-4653-95a6-f4794123e509	t	t	2025-10-06 15:00:00+02	MICROSOFT TEAMS
02a25190-dd97-4936-a657-e8184c72394c	f	f	\N	\N
02cd46ea-6877-4cc5-8abe-45651babde3a	t	t	2025-10-07 12:00:00+02	Frances Baard District Municipal Offices, 51 Drakensberg Avenue, Carters Glen, Kimberley
04b3bb23-153e-4f62-aba7-c435ecf6f64c	t	t	\N	see in special conditions below
05828357-4e80-491f-ab66-906cd082ee36	t	t	2025-11-26 12:00:00+02	https://teams.microsoft.com/l/meetup-join/19%3ameeting_NDg0MGMyNDMtYzA0Ni00YjdiLTkwYTctOWZiMGNkYTQwN
06a5c3b7-7f62-432f-908e-60c0c8bd89de	t	t	2025-11-25 13:00:00+02	The South African state theatre
06f649dc-1156-4de2-9081-e69a17e2f2d5	t	t	2025-10-30 12:00:00+02	ONLINE COMPULSORY INFORMATION SESSION
07b2cb76-9050-4877-93e7-b737c7806fb5	t	t	2025-09-22 13:00:00+02	12th Floor Embassy Building, RAF Durban Offices
08630b62-ec4b-4be0-885a-283bffed1254	t	t	2025-09-18 12:00:00+02	Ekurhuleni East TVET College, Benoni Campus Staff Room, O`Reilly Merry Street Benoni,
08d9c64b-79ee-4483-87e1-87e496b320ae	t	t	2025-09-17 12:00:00+02	Lugebhuta Secondary School, Schoemansdal, Nkomazi Local Municipality
097bb570-b823-4fde-a137-8db14eea425c	f	f	\N	\N
0a9e1f41-11e3-4b98-a296-be4a3e2be645	f	f	\N	\N
0adc0350-eb26-40cf-bc87-e236c620b919	t	t	2025-09-18 12:00:00+02	Vlakfontein Canal Project near Standerton
0b3a69bc-ee25-4312-b8d8-ec4f2644ab6d	t	t	\N	Eskom Middelburg Substation
0b47f249-b21e-4cf1-aa99-5199c1ff2114	t	f	2025-08-28 12:00:00+02	MS Teams
0bb9cb38-632b-4941-920c-92750cfdb3b7	t	t	2025-11-29 14:30:00+02	Eastern Cape Deeds Registry: Corner Owen and Leeds Street, Botha Sigcau Building
0c416b21-cebe-4421-a35a-05994733505b	f	f	\N	\N
0c52ca80-6ce3-41d3-8bc5-1688731bd439	t	t	2025-10-01 13:00:00+02	Parliamentary Village Club House at Parliamentary Village
0c77a262-7dc4-426d-8487-a3d1febea595	t	t	2025-12-03 13:00:00+02	Municipal Chamber (2nd Grobler Avenue, Groblersdal 0470)
0ce8e5c8-631a-47b2-a514-408aa4e58d0b	t	t	2025-10-15 12:00:00+02	Iziko South African Museum, 25 Queen Victoria Street, Gardens, Cape Town 8001
\.


--
-- Data for Name: tender_categories; Type: TABLE DATA; Schema: tenders; Owner: postgres
--

COPY tenders.tender_categories (tender_category_id, name) FROM stdin;
\.


--
-- Data for Name: tender_types; Type: TABLE DATA; Schema: tenders; Owner: postgres
--

COPY tenders.tender_types (tender_type_id, code) FROM stdin;
1	EOI
2	RFQ
\.


--
-- Data for Name: tenders; Type: TABLE DATA; Schema: tenders; Owner: postgres
--

COPY tenders.tenders (tender_id, tender_ref, tender_description, tender_category_id, advertised_date, closing_date, industry_id, requested_by_department_id, tender_type_id, province_id, service_location, special_conditions, contact_person, contact_email, contact_telephone, attachments, attachment_download_url, created_time, created_at, trial_data, tender_review_summary) FROM stdin;
007857b7-db1f-41aa-b3a0-5cb5cf76d0b2	DFFEQ 255 CLEANING MATERIAL 2025	SUPPLY AND DELIVER CLEANING MATERIAL	\N	\N	\N	2	\N	2	2	24 East Pier Road, Victoria & Alfred Waterfront, Cape Town , 8001 - V & A WATERFRONT - Cape Town - 8001	\N	Andiswa Euphimia Charlie	acharlie@dffe.gov.za	021-493-7149	[]	\N	2025-10-30 14:16:00.657+02	2025-10-30 14:16:01.820305+02	\N	\N
00b9d4e2-95fe-4beb-8230-3e41c2e93391	74312	Re-advertisement: Appointment of a multi-disciplinary team (Architect as Principal Agent, Quantity Surveyor, Civil / Structural Engineer, Electrical Engineer, Mechanical and Fire Engineer) to provide Professional Services for the Refurbishment, Repairs and Alterations to Nurses‚Äô Accommodation at RK Khan Hospital.	\N	\N	\N	3	\N	2	8	R K Khan Hospital - Durban - Durban - 4001	Compulsory Briefing session Date : 16 October 2025 Time : 11h00 Venue : MS Teams (online) Meeting ID : 365 818 402 252 5 Passcode : fe6zx9kp Meeting link : https://teams.microsoft.com/l/meetup-join/19%3ameeting_MDM1MTU5M2UtZmE2OS00NTZjLWFjMGMtYjQzMWViNDQ0MzJl%40thread.v2/0?context=%7b%22Tid%22%3a%229a833c6f-eba4-468f-be72-dcf3d89967e8%22%2c%22Oid%22%3a%22d74f21f3-4645-4cb9-9458-dd1d511f3c0e%22%7d All attendees to submit (1) Tenderer‚Äôs Business Name, (2) the Representatives Name, (3) a Contact number and (4) Email address, via the MS Teams chat upon entry as confirmation of attendance. Online register to serve as proof of attendance.	Ms S Mahabeer	shehana.mahabeer@kznworks.gov.za	072-261-4210	[]	\N	2025-10-06 14:22:14.589+02	2025-10-06 14:22:15.444739+02	\N	\N
00ee982f-f978-4f83-87ff-0e462fba7bcb	RFT84/10/2025/26	APPOINTMENT OF A SERVICE PROVIDER TO SUPPLY, INSTALL, MONITOR AND MAINTAIN CCTV CAMERAS AND BIOMETRIC ACCESS CONTROL SYSTEM AT MADIBENG LOCAL MUNICIPALITY FOR A PERIOD OF 36 MONTHS.	\N	\N	\N	1	\N	2	4	53 Van Velden - Brits - Brits - 0250	Tender documents are obtainable at Municipal Offices (Brits) at a cost of R3000.00 per document on a non-refundable deposit in cash. EFT; Cheques will not be accepted. Payment is made at the Ground floor, Main Municipal Building, 53 van Velden Street, Brits	Mr. Johannes Magoro	johannesmagoro@madibeng.gov.za	012-493-7777	[]	\N	2025-10-17 15:16:54.592+02	2025-10-17 15:16:55.833709+02	\N	\N
01544ee3-d154-44ff-ae41-a1b2c76eb079	781/08/25	SUPPLY, DELIVERY, AND ERECTION OF MUNICIPAL GRAVEYARD FENCING	\N	\N	\N	3	\N	2	8	61 MARTIN STREET uPHONGOLO LOCAL MUNICIPALITY - PONGOLA - PONGOLA - 3170	SEE DOCUMENT	MR MS MTSHALI	musawenkosim@uphongolo.gov.za	034-413-1223	[]	\N	2025-11-19 15:53:11.54+02	2025-11-19 15:53:12.252102+02	\N	\N
01dabc94-36b4-42fc-9c30-231b5fd30ffe	RFQ 4083/24	Request for service provider to do an assessment and quoting in Earthing refurbishment, testing and Concrete slab refurbishment, leveling at Lightning Detection Network (LDN) sites.	\N	\N	\N	3	\N	2	1	Irene Weather Office which is situated on the premises of the Agricultural Research Council (ARC), I - Irene - Pretoria - 0157	\N	Zandile Sebotsane	RFQsubmissions@weathersa.co.za	012-367-6000	[]	\N	2025-09-16 15:21:48.66+02	2025-09-16 15:21:49.079744+02	\N	\N
0279fbfb-b1d6-4653-95a6-f4794123e509	KZNL 08/2025	APPOINTMENT OF A SERVICE PROVIDER FOR RENDERING OF SECURITY OPERATIONS CENTRE (SOC) AND MANAGED SECURITY INFORMATION AND EVENTS MANAGEMENT (SIEM) SERVICE FOR 36 MONTHS	\N	\N	\N	1	\N	2	8	244 LANGALIBALELE STREET - PIETERMARITZBURG - PIETERMARITZBURG - 3201	Tender Briefing session will be held on 06 OCTOBER 2025 at 13h00 via Microsoft teams. Interested bidders are requested to forward their email addresses and name of the company to tenders@kznleg.gov.za before or on the 03 OCTOBER 2025 at 16h30.	Mr G.N. Ngcamu	tenders@kznleg.gov.za	033-355-7548	[]	\N	2025-09-22 14:42:34.72+02	2025-09-22 14:42:35.402471+02	\N	\N
02a25190-dd97-4936-a657-e8184c72394c	SRVM-EOI-01/2026	NOTICE FOR INVITING EXPRESSION OF INTEREST TO OPERATE, MANAGE AND COORDINATING EVENTS AT THE KIRKWOOD PUBLIC SWIMMING POOL FOR MEDIUM-TERM PERIOD ENDING 30 JUNE 2026	\N	\N	\N	3	\N	1	5	23 MIDDLE STREET - Kirkwood - Kirkwood - 6120	\N	SIBONILE SIBACA	siboniles@srvm.gov.za	042-230-7775	[]	\N	2025-10-23 15:50:20.146+02	2025-10-23 15:50:20.396436+02	\N	\N
02cd46ea-6877-4cc5-8abe-45651babde3a	BID 08/25	RE-ADVERT FOR PROVISION OF SECURITY SERVICES AT FRANCES BAARD OFFICES FOR A PERIOD OF THREE (3) YEARS	\N	\N	\N	1	\N	2	6	51 Drakensberg Avenue - Carters Glen - Kimberley - 8300	NB: A compulsory briefing / clarification meeting will be held on 07 October 2025 at 10:00 at the offices of FBDM: 51 Drakensberg Avenue, Carters Glen, Kimberley. For all compulsory site/briefing sessions, all bidders must assemble at the reception area at the stated time from where they will be escorted to the relevant room where the compulsory briefing meeting will be held. Late service providers who are not at the reception area at the stated time will not be allowed into the compulsory briefing meeting and will be prohibited from submitting proposals.	Mr. C. Jones	eric.tlhageng@fbdm.co.za	053-838-0925	[]	\N	2025-10-01 14:36:49.892+02	2025-10-01 14:36:50.415366+02	\N	\N
04b3bb23-153e-4f62-aba7-c435ecf6f64c	WTE-0400 CS	SUPPLY AND DELIVERY ELECTRICAL HIGH-FREQUENCY INTERNAL CONCRETE VIBRATORS FOR CLANWILLIAM DAM IN THE WESTERN CAPE FOR DWS CONSTRUCTION SOUTH.	\N	\N	\N	3	\N	2	2	CLANWILLIAM - CLANWILLIAM - CLANWILLIAM -	DATE: 17 SEPTEMBER 2025 VENUE: MASKAMSIG HALL IN VAN RHYNSDORP CO-ORDINATES: 18¬∞35‚Äô48.4‚Äô‚ÄôS and 18¬∞45‚Äô06.5‚Äô‚ÄôE TIME: 09:00 TILL 10:00 DATE: 17 SEPTEMBER 2025 VENUE: VREDENDAL NORTH COMMUNITY HALL CO-ORDINATES: LATITUDE. -31.64456¬∞ and LONGTITUDE. 185255¬∞ TIME: 12:00 TILL 13:00 DATE: 18 SEPTEMBER 2025 VENUE: CEDERBERG MUNICIPAL CHAMBERS CITRUSDAL CO-ORDINATES: 32¬∞35‚Äô22.2‚Äô‚ÄôS and 19¬∞00‚Äô53‚Äô‚ÄôE TIME: 09:00 TILL 10:00 DATE: 18 SEPTEMBER 2025 VENUE: DWS CONSTRUCTION SOUTH CLANWILLIAM DAM TRAINING CENTRE CO-ORDINATES: 32¬∞11‚Äô5‚Äô‚ÄôS and 18¬∞52‚Äô1‚Äô‚ÄôE TIME: 12:00 TILL 13:00	B CROUS	crousb@dws.gov.za	021-872-0591	[]	\N	2025-09-10 14:58:25.046+02	2025-09-10 14:58:25.346744+02	\N	\N
05828357-4e80-491f-ab66-906cd082ee36	KZNB02/DSD/2025/26	ESTABLISHMENT OF A PANEL OF SERVICE PROVIDERS TO PROVIDE CLEANING SERVICE FOR THE DEPARTMENT OF SOCIAL DEVELOPMENT KWAZULU - NATAL FOR A PERIOD OF SIXTY (60) MONTHS	\N	\N	\N	2	\N	2	8	208 Hoosen Haffejee - Pietermaritzburg - Pietermaritzburg - 3201	\N	Ms. L.T Dandile	thandeka.dandile@kzndsd.gov.za	033-897-9908	[]	\N	2025-11-12 14:04:44.715+02	2025-11-12 14:04:46.708662+02	\N	\N
06a5c3b7-7f62-432f-908e-60c0c8bd89de	SAST/RFQ/2025/281	Supply and installation of roof floors	\N	\N	\N	3	\N	2	1	320 Pretorius street - Pretoria - Pretoria - 0025	Kindly attach: ‚Ä¢ Fully completed SBD1,SBD 4 and 6.1( Score page 5 of 7 on SBD 6.1) ‚Ä¢ Completed POPIA -Consent form ‚Ä¢ Signed GCC (all pages must be signed) ‚Ä¢ CSD Report ‚ÄÇ ‚Ä¢ Valid B-BBEE certificate or Affidavit in case of EME or QSE ‚Ä¢ Valid SARS Tax pin certificate ‚Ä¢ Certified Share certificate ‚Ä¢ CIPC -Company registration ‚Ä¢ Directors IDs (all directors listed in the CIPC)	Phindile Mabasa	RFQ@statetheatre.co.za	012-392-4000	[]	\N	2025-11-17 14:58:25.876+02	2025-11-17 14:58:26.923213+02	\N	\N
06f649dc-1156-4de2-9081-e69a17e2f2d5	ITVETC-001/10/2025	APPOINTMENT OF A CONTRACTOR FOR THE SUPPLY AND INSTALLATION OF BLOCK B & WORKSHOP ELEVATOR AT IKHALA TVET COLLEGE ALIWAL NORTH CAMPUS (4GB PE OR 4 ME PE OR HIGHER)	\N	\N	\N	3	\N	2	5	ZONE D, 2020 GWADANA DRIVE, EZIBELENI - QUEENSTOWN - QUEENSTOWN - 5326	Documents can be purchased from Supply Chain Management Unit, Ikhala TVET College, Administration Centre, OR can be downloaded from National Treasury Portal at a Non refundable fee of R150 each. Suppliers should send the proof of payment to SCM and attached PoP on the tender document upon the return of the submission.	MR NKOSINATHI FUTSHANE	nkosinathi.futshane@ikhala.edu.za	071-898-3042	[]	\N	2025-10-24 14:37:13.027+02	2025-10-24 14:37:13.259836+02	\N	\N
07b2cb76-9050-4877-93e7-b737c7806fb5	10111514	The Road Accident Fund (RAF) wishes to appoint a suitable service provider to Maintain, Service and Repair Security Systems at Durban Office on a month-to-month basis for a period not exceeding six (6) months).	\N	\N	\N	1	\N	2	8	\N	\N	Phakamani Zulu	phakamaniz@raf.co.za	031-365-2979	[]	\N	2025-09-18 14:40:39.557+02	2025-09-18 14:40:40.525723+02	\N	\N
08630b62-ec4b-4be0-885a-283bffed1254	EEC/T04/2025	Stormwater reticulation and installation of carports at Benoni campus	\N	\N	\N	3	\N	2	1	O`Reilly Merry Street in Benoni - Northmead - Benoni - 1501	1. Compulsory briefing session 2. CIDB Grading : 6CE 3. Tender amount: 1000	Ms Azwihangwisi Tshitema	azwihangwisit@eec.edu.za	011-730-6600	[]	\N	2025-09-11 14:57:56.413+02	2025-09-11 14:57:57.866591+02	\N	\N
08d9c64b-79ee-4483-87e1-87e496b320ae	PWRT/2602/25/MP	RENOVATION AND CONSTRUCTION OF LUGEBHUTA SECONDARY SCHOOL, IN SCHOEMANSDAL, SHONGWE MISSION, NKOMAZI LOCAL MUNICIPALITY, MPUMALANGA PROVINCE - PHASE 03	\N	\N	\N	3	\N	2	3	Riversisde Government Complex, Building no: 9, Government Boulevard - Riverside - Mbombela - 1200	\N	Mr L Buasi	LBuasi@mpg.gov.za	013-766-8920	[]	\N	2025-09-09 12:02:28.361+02	2025-09-09 12:02:29.032983+02	\N	\N
097bb570-b823-4fde-a137-8db14eea425c	TMT-DBE-25/26-SAFE6-KZNCL2	TENDER DOCUMENT FOR CONSTRUCTION OF SANITATION FACILITIES AT LUNDINI PRIMARY SCHOOL IN KWAZULU NATAL PROVINCE	\N	\N	\N	3	\N	2	8	69 Devereux Avenue - Vincent - East London - 5201	\N	Anele Nqambi	anele@themvulatrust.org.za	043-726-2255	[]	\N	2025-10-01 14:12:16.699+02	2025-10-01 14:12:17.331135+02	\N	\N
0a9e1f41-11e3-4b98-a296-be4a3e2be645	GMQ073/25-26	GMQ073/25-26 ‚Äì Appointment of a Service Provider for CCTV Surveillance Training and Body Language Course for CCTV Operators	\N	\N	\N	1	\N	2	2	71 York Street - George - George - 6530	\N	Claudette Rondganger	crondganger@george.gov.za	044-801-9304	[]	\N	2025-10-07 14:27:22.955+02	2025-10-07 14:27:22.945474+02	\N	\N
0adc0350-eb26-40cf-bc87-e236c620b919	WTE136CE..	The Removal of Bees from Construction East - Grootdraai Dam ,Vlakfontein Canal and Standerton WTW close to Standerton in the Mpumalanga Province	\N	\N	\N	3	\N	2	3	Vlakfontein Canal Project - standerton - standerton - 2430	SUBMIT COMPLETED AND SIGNED BID DOCUMENTS TO: POSTAL ADDRESS: OR TO BE DEPOSITED IN: Department of Water and Sanitation The bid box at the entrance of Supply Chain Management Office Construction East Office Building Private Bag X2023 Grootdraai Dam STANDERTON STANDERTON 2430 2430 Physical Address: Ermelo R 39 Road, Grootdraai Dam close to Standerton Construction East Office 2430 Compulsory Briefing Session Date: 18 September 2025 Time: 10am Venue: Grootdraai Dam, Vlakfontein Canal and Standerton WTW in the Mpumalanga Province.	Rejoice Kubheka	kubhekan@dws.gov.za	017-720-1616	[]	\N	2025-09-09 11:52:44.586+02	2025-09-09 11:52:44.809119+02	\N	\N
0b3a69bc-ee25-4312-b8d8-ec4f2644ab6d	E1709DXEC	EXECUTION AND CONSTRUCTION OF MIDDELBURG/BULHOEK 22KV STRENGTHENING PHASE 2	\N	\N	\N	3	\N	2	5	Corner Querera Drive and Bonza Bay Road - Beacon Bay - East London - 5205	N/A	Lonwabo Mavukwana	mavukwlm@eskom.co.za	043-703-2023	[]	\N	2025-08-15 13:13:46.45+02	2025-08-15 13:13:47.287847+02	\N	\N
0b47f249-b21e-4cf1-aa99-5199c1ff2114	E1729NTCSAWG	E1729NTCSAWG - Cleaning services and general labour services for the various sites in the Western Grid (Western and Northern Cape) for 36 months	\N	\N	\N	2	\N	2	2	60 Voortrekker Road - Bellville - Bellville - 7535	PLEASE DOWN ALL TENDER DOCUMENTS FROM NTCSA TENDERBULLETIN OR NT WEBSITE	Sandi Bokveldt-Lize	LizeSN@ntcsa.co.za	021-980-3003	[]	\N	2025-08-21 12:56:34.853+02	2025-08-21 12:56:35.817645+02	\N	\N
0bb9cb38-632b-4941-920c-92750cfdb3b7	DLRRD (CRD-09) 2025/26	THE APPOINTMENT OF A SERVICE PROVIDER TO RENDER CLEANING AND HYGIENE SERVICES FOR THE DEPARTMENT OF LAND REFORM AND RURAL DEVELOPMENT- EASTERN CAPE DEEDS REGISTRY: MTHATHA FOR A PERIOD OF 36 MONTHS.	\N	\N	\N	2	\N	2	5	Eastern Cape Deeds Registry: Corner Owen and Leeds Street, Botha Sigcau Building - Mthatha - East London - 5200	\N	BUTI MATJILA	Buti.Matjila@deeds.gov.za	082-385-4570	[]	\N	2025-11-07 14:23:08.608+02	2025-11-07 14:23:09.672534+02	\N	\N
0c416b21-cebe-4421-a35a-05994733505b	ZNQSRO25/2025-2026	DEPARTMENT OF PUBLIC WORKS: THE APPOINTMENT OF A SUITABLE SERVICE PROVIDER TO RENDER THE SAFEGUARDING AND SECURITY SERVICES FOR A PERIOD OF FOUR (4) MONTHS AT SOUTHERN REGION OFFICE: 10 -18 PRINCE ALFRED STREET EXTENSION, PIETERMARITZBURG.	\N	\N	\N	1	\N	2	8	10-18 Prince Alfred Street - Campsdrifts - Town - 3201	Only Bidders registered within the applicable Central Suppliers Database, PSIRA, a letter of Good Standing with PSIRA, ICASA AND COIDA will be eligible to submit bids. The Preference points system is applicable for this bid 80/20, where 20 Points of specific goals per project allocated ‚Ä¢ Ownership by People who are Youth: 10 points. ‚Ä¢ 51% Ownership by People who are Military Veterans: 10 points	Ms J. Ngidi	janet.ngidi@kznworks.gov.za	033-897-1300	[]	\N	2025-11-06 15:09:59.03+02	2025-11-06 15:09:59.617221+02	\N	\N
0c52ca80-6ce3-41d3-8bc5-1688731bd439	LDPWRI-B20564	Appointment of a Turkey Contractor for the Refurbishment of the Parliamentary Club House at the Parliamentary Village - Once Off	\N	\N	\N	3	\N	2	7	43 CHURCH STREET - POLOKWANE - POLOKWANE - 0699	Supplier should be 6 GB or Higher Tender should be dropped at Corner River & Blaauwberg Street Ladanna	NJ Motsopye	motsopyenj@dpw.limpopo.gov.za	015-284-7126	[]	\N	2025-09-23 15:30:50.637+02	2025-09-23 15:30:51.100222+02	\N	\N
0c77a262-7dc4-426d-8487-a3d1febea595	EMLM 06/2026	PROVISION OF VIP PROTECTION AND STATIC SECURITY SERVICES IN ELIAS MOTSOALEDI LOCAL MUNICIPALITY FOR A PERIOD OF THREE (3) YEARS (RE-ADVERT)	\N	\N	\N	1	\N	2	7	2nd Grober Avenue - Groblersdal - Groblersdal - 0470	\N	V Masilela	vmasilela@emlm.gov.za	013-262-3056	[]	\N	2025-11-14 15:05:28.943+02	2025-11-14 15:05:30.07249+02	\N	\N
0ce8e5c8-631a-47b2-a514-408aa4e58d0b	IZIKO-RFQ ‚Äì SLIDING DOOR - RFQ-2025/10/08	The Iziko South African Museum is looking to procure supply and installation of glass sliding door for ISAM200 commemorative garden	\N	\N	\N	3	\N	2	2	\N	Quotes / Proposals, and accompanying documentation, must be emailed to (SCM) 021 481 3917 Sikelwa Madlavu smadlavu@iziko.org.za and scm@iziko.org.za	Gabriel Lukoji	glukoji@iziko.org.za	021-481-7240	[]	\N	2025-10-14 09:27:52.026+02	2025-10-14 09:27:51.687304+02	\N	\N
e88f2c57-890b-4d92-bbc0-b272a4229e24	test	test	\N	2025-12-04	2025-12-26	2	\N	1	1	\N	\N	\N	\N	\N	[]	\N	2025-12-02 20:26:35.670447+02	2025-12-02 20:26:35.670458+02	\N	\N
\.


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: tenders; Owner: postgres
--

SELECT pg_catalog.setval('tenders.departments_department_id_seq', 1, false);


--
-- Name: industries_industry_id_seq; Type: SEQUENCE SET; Schema: tenders; Owner: postgres
--

SELECT pg_catalog.setval('tenders.industries_industry_id_seq', 15, true);


--
-- Name: provinces_province_id_seq; Type: SEQUENCE SET; Schema: tenders; Owner: postgres
--

SELECT pg_catalog.setval('tenders.provinces_province_id_seq', 40, true);


--
-- Name: tender_categories_tender_category_id_seq; Type: SEQUENCE SET; Schema: tenders; Owner: postgres
--

SELECT pg_catalog.setval('tenders.tender_categories_tender_category_id_seq', 1, false);


--
-- Name: tender_types_tender_type_id_seq; Type: SEQUENCE SET; Schema: tenders; Owner: postgres
--

SELECT pg_catalog.setval('tenders.tender_types_tender_type_id_seq', 10, true);


--
-- Name: departments departments_name_key; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.departments
    ADD CONSTRAINT departments_name_key UNIQUE (name);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: industries industries_name_key; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.industries
    ADD CONSTRAINT industries_name_key UNIQUE (name);


--
-- Name: industries industries_pkey; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (industry_id);


--
-- Name: provinces provinces_name_key; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.provinces
    ADD CONSTRAINT provinces_name_key UNIQUE (name);


--
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (province_id);


--
-- Name: tender_briefings tender_briefings_pkey; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tender_briefings
    ADD CONSTRAINT tender_briefings_pkey PRIMARY KEY (tender_id);


--
-- Name: tender_categories tender_categories_name_key; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tender_categories
    ADD CONSTRAINT tender_categories_name_key UNIQUE (name);


--
-- Name: tender_categories tender_categories_pkey; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tender_categories
    ADD CONSTRAINT tender_categories_pkey PRIMARY KEY (tender_category_id);


--
-- Name: tender_types tender_types_code_key; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tender_types
    ADD CONSTRAINT tender_types_code_key UNIQUE (code);


--
-- Name: tender_types tender_types_pkey; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tender_types
    ADD CONSTRAINT tender_types_pkey PRIMARY KEY (tender_type_id);


--
-- Name: tenders tenders_pkey; Type: CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tenders
    ADD CONSTRAINT tenders_pkey PRIMARY KEY (tender_id);


--
-- Name: idx_tenders_advertised_date; Type: INDEX; Schema: tenders; Owner: postgres
--

CREATE INDEX idx_tenders_advertised_date ON tenders.tenders USING btree (advertised_date);


--
-- Name: idx_tenders_closing_date; Type: INDEX; Schema: tenders; Owner: postgres
--

CREATE INDEX idx_tenders_closing_date ON tenders.tenders USING btree (closing_date);


--
-- Name: idx_tenders_industry; Type: INDEX; Schema: tenders; Owner: postgres
--

CREATE INDEX idx_tenders_industry ON tenders.tenders USING btree (industry_id);


--
-- Name: idx_tenders_province; Type: INDEX; Schema: tenders; Owner: postgres
--

CREATE INDEX idx_tenders_province ON tenders.tenders USING btree (province_id);


--
-- Name: tender_briefings tender_briefings_tender_id_fkey; Type: FK CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tender_briefings
    ADD CONSTRAINT tender_briefings_tender_id_fkey FOREIGN KEY (tender_id) REFERENCES tenders.tenders(tender_id) ON DELETE CASCADE;


--
-- Name: tenders tenders_industry_id_fkey; Type: FK CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tenders
    ADD CONSTRAINT tenders_industry_id_fkey FOREIGN KEY (industry_id) REFERENCES tenders.industries(industry_id);


--
-- Name: tenders tenders_province_id_fkey; Type: FK CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tenders
    ADD CONSTRAINT tenders_province_id_fkey FOREIGN KEY (province_id) REFERENCES tenders.provinces(province_id);


--
-- Name: tenders tenders_requested_by_department_id_fkey; Type: FK CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tenders
    ADD CONSTRAINT tenders_requested_by_department_id_fkey FOREIGN KEY (requested_by_department_id) REFERENCES tenders.departments(department_id);


--
-- Name: tenders tenders_tender_category_id_fkey; Type: FK CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tenders
    ADD CONSTRAINT tenders_tender_category_id_fkey FOREIGN KEY (tender_category_id) REFERENCES tenders.tender_categories(tender_category_id);


--
-- Name: tenders tenders_tender_type_id_fkey; Type: FK CONSTRAINT; Schema: tenders; Owner: postgres
--

ALTER TABLE ONLY tenders.tenders
    ADD CONSTRAINT tenders_tender_type_id_fkey FOREIGN KEY (tender_type_id) REFERENCES tenders.tender_types(tender_type_id);


--
-- PostgreSQL database dump complete
--

\unrestrict imceF29BJogSNV8r7E2j1UlbVaeiU6rGsrr7fEMUDE4FI4zMKYUgC0mvbbDud1G

