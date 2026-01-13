-- Schema for storing tender rows from tenders_rows.xlsx in PostgreSQL.
-- Lookup tables capture repeated dimensions (industry, province, tender type, etc.).
-- A staging table is included for easy loading from CSV before normalizing.

CREATE SCHEMA IF NOT EXISTS tenders;
SET search_path TO tenders, public;

-- Lookup tables
CREATE TABLE IF NOT EXISTS industries (
    industry_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS tender_types (
    tender_type_id SERIAL PRIMARY KEY,
    code TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS provinces (
    province_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS departments (
    department_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE
);

CREATE TABLE IF NOT EXISTS tender_categories (
    tender_category_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE
);

-- Main fact table
CREATE TABLE IF NOT EXISTS tenders (
    tender_id UUID PRIMARY KEY,
    tender_ref TEXT NOT NULL,
    tender_description TEXT NOT NULL,
    tender_category_id INTEGER REFERENCES tender_categories(tender_category_id),
    advertised_date DATE,
    closing_date DATE,
    industry_id INTEGER REFERENCES industries(industry_id),
    requested_by_department_id INTEGER REFERENCES departments(department_id),
    tender_type_id INTEGER REFERENCES tender_types(tender_type_id),
    province_id INTEGER REFERENCES provinces(province_id),
    service_location TEXT,
    special_conditions TEXT,
    contact_person TEXT,
    contact_email TEXT,
    contact_telephone TEXT,
    attachments JSONB DEFAULT '[]'::JSONB,
    attachment_download_url TEXT,
    created_time TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    trial_data JSONB,
    tender_review_summary TEXT
);

-- Briefing info is optional and separated to keep the main table slim.
CREATE TABLE IF NOT EXISTS tender_briefings (
    tender_id UUID PRIMARY KEY REFERENCES tenders(tender_id) ON DELETE CASCADE,
    is_scheduled BOOLEAN DEFAULT FALSE,
    is_compulsory BOOLEAN DEFAULT FALSE,
    briefing_datetime TIMESTAMPTZ,
    briefing_venue TEXT
);

-- Staging table to load the raw Excel (or CSV) output without constraints.
-- All fields are text to simplify COPY. Run the normalization below afterwards.
CREATE TABLE IF NOT EXISTS staging_tenders (
    tender_ref TEXT,
    tender_description TEXT,
    tender_category TEXT,
    advertised_date TEXT,
    closing_date TEXT,
    industry TEXT,
    tender_requested_by_dept TEXT,
    tender_type TEXT,
    province TEXT,
    service_location TEXT,
    special_conditions TEXT,
    contact_person TEXT,
    contact_email TEXT,
    contact_telephone TEXT,
    attachments TEXT,
    attachment_download_url TEXT,
    created_time TEXT,
    briefing_session TEXT,
    briefing_compulsory TEXT,
    briefing_date_time TEXT,
    briefing_venue TEXT,
    trial_data TEXT,
    tender_review_summary TEXT,
    id TEXT,
    created_at TEXT
);

-- Normalization step: insert from staging into lookups and fact tables.
-- Run these after loading staging_tenders (adjust dates as needed).
INSERT INTO industries (name)
SELECT DISTINCT TRIM(industry)
FROM staging_tenders
WHERE industry IS NOT NULL AND TRIM(industry) <> ''
ON CONFLICT DO NOTHING;

INSERT INTO tender_types (code)
SELECT DISTINCT TRIM(tender_type)
FROM staging_tenders
WHERE tender_type IS NOT NULL AND TRIM(tender_type) <> ''
ON CONFLICT DO NOTHING;

INSERT INTO provinces (name)
SELECT DISTINCT TRIM(province)
FROM staging_tenders
WHERE province IS NOT NULL AND TRIM(province) <> ''
ON CONFLICT DO NOTHING;

INSERT INTO departments (name)
SELECT DISTINCT TRIM(tender_requested_by_dept)
FROM staging_tenders
WHERE tender_requested_by_dept IS NOT NULL AND TRIM(tender_requested_by_dept) <> ''
ON CONFLICT DO NOTHING;

INSERT INTO tender_categories (name)
SELECT DISTINCT TRIM(tender_category)
FROM staging_tenders
WHERE tender_category IS NOT NULL AND TRIM(tender_category) <> ''
ON CONFLICT DO NOTHING;

-- Fact table load
INSERT INTO tenders (
    tender_id,
    tender_ref,
    tender_description,
    tender_category_id,
    advertised_date,
    closing_date,
    industry_id,
    requested_by_department_id,
    tender_type_id,
    province_id,
    service_location,
    special_conditions,
    contact_person,
    contact_email,
    contact_telephone,
    attachments,
    attachment_download_url,
    created_time,
    created_at,
    trial_data,
    tender_review_summary
)
SELECT
    CAST(NULLIF(TRIM(id), '') AS UUID),
    TRIM(tender_ref),
    TRIM(tender_description),
    (SELECT tender_category_id FROM tender_categories WHERE name = TRIM(stg.tender_category)),
    -- Excel serial dates are day counts since 1899-12-30.
    CASE
        WHEN regexp_replace(advertised_date, '[^0-9\\.]', '', 'g') ~ '^\\d+(\\.\\d+)?$'
            THEN DATE '1899-12-30' + (regexp_replace(advertised_date, '[^0-9\\.]', '', 'g')::FLOAT)::INT
        ELSE NULL
    END,
    CASE
        WHEN regexp_replace(closing_date, '[^0-9\\.]', '', 'g') ~ '^\\d+(\\.\\d+)?$'
            THEN DATE '1899-12-30' + (regexp_replace(closing_date, '[^0-9\\.]', '', 'g')::FLOAT)::INT
        ELSE NULL
    END,
    (SELECT industry_id FROM industries WHERE name = TRIM(stg.industry)),
    (SELECT department_id FROM departments WHERE name = TRIM(stg.tender_requested_by_dept)),
    (SELECT tender_type_id FROM tender_types WHERE code = TRIM(stg.tender_type)),
    (SELECT province_id FROM provinces WHERE name = TRIM(stg.province)),
    NULLIF(TRIM(service_location), ''),
    NULLIF(TRIM(special_conditions), ''),
    NULLIF(TRIM(contact_person), ''),
    NULLIF(TRIM(contact_email), ''),
    NULLIF(TRIM(contact_telephone), ''),
    COALESCE(NULLIF(TRIM(attachments), '')::JSONB, '[]'::JSONB),
    NULLIF(TRIM(attachment_download_url), ''),
    NULLIF(TRIM(created_time), '')::TIMESTAMPTZ,
    COALESCE(NULLIF(TRIM(created_at), '')::TIMESTAMPTZ, NOW()),
    CASE WHEN trial_data IS NULL OR TRIM(trial_data) = '' THEN NULL ELSE trial_data::JSONB END,
    NULLIF(TRIM(tender_review_summary), '')
FROM staging_tenders stg
WHERE NULLIF(TRIM(id), '') IS NOT NULL
  AND NULLIF(TRIM(tender_ref), '') IS NOT NULL
ON CONFLICT DO NOTHING;

-- Briefing table load
INSERT INTO tender_briefings (
    tender_id,
    is_scheduled,
    is_compulsory,
    briefing_datetime,
    briefing_venue
)
SELECT
    CAST(NULLIF(TRIM(id), '') AS UUID),
    COALESCE(NULLIF(TRIM(briefing_session), '')::BOOLEAN, FALSE),
    COALESCE(NULLIF(TRIM(briefing_compulsory), '')::BOOLEAN, FALSE),
    NULLIF(TRIM(briefing_date_time), '')::TIMESTAMPTZ,
    NULLIF(TRIM(briefing_venue), '')
FROM staging_tenders
WHERE id IS NOT NULL
ON CONFLICT DO NOTHING;

-- Helpful indexes
CREATE INDEX IF NOT EXISTS idx_tenders_advertised_date ON tenders(advertised_date);
CREATE INDEX IF NOT EXISTS idx_tenders_closing_date ON tenders(closing_date);
CREATE INDEX IF NOT EXISTS idx_tenders_industry ON tenders(industry_id);
CREATE INDEX IF NOT EXISTS idx_tenders_province ON tenders(province_id);

-- User and role management
CREATE TABLE IF NOT EXISTS roles (
    role_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS users (
    user_id BIGSERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    full_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_roles (
    user_id BIGINT REFERENCES users(user_id) ON DELETE CASCADE,
    role_id INTEGER REFERENCES roles(role_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Subscriptions and preferences
CREATE TABLE IF NOT EXISTS tender_subscriptions (
    subscription_id UUID PRIMARY KEY,
    user_id BIGINT REFERENCES users(user_id) ON DELETE CASCADE,
    company TEXT,
    phone TEXT,
    notes TEXT,
    selected_category_ids INTEGER[],
    selected_industry_ids INTEGER[],
    total_amount INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tender_subscriptions_user ON tender_subscriptions(user_id);

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS email_jobs (
    job_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tender_id UUID REFERENCES tenders(tender_id) ON DELETE CASCADE,
    recipient_email TEXT NOT NULL,
    payload JSONB NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'failed')),
    attempts INTEGER NOT NULL DEFAULT 0,
    max_attempts INTEGER NOT NULL DEFAULT 5,
    last_attempt_at TIMESTAMPTZ,
    send_after TIMESTAMPTZ,
    last_error TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION notify_subscribers_of_new_tender()
RETURNS trigger LANGUAGE plpgsql AS
$$
DECLARE
    category_name TEXT := (
        SELECT name FROM tender_categories WHERE tender_category_id = NEW.tender_category_id
    );
    industry_name TEXT := (
        SELECT name FROM industries WHERE industry_id = NEW.industry_id
    );
    province_name TEXT := (
        SELECT name FROM provinces WHERE province_id = NEW.province_id
    );
    payload JSONB := jsonb_build_object(
        'tender_ref', NEW.tender_ref,
        'tender_description', NEW.tender_description,
        'category', category_name,
        'industry', industry_name,
        'province', province_name,
        'closing_date', NEW.closing_date
    );
BEGIN
    INSERT INTO email_jobs (tender_id, recipient_email, payload)
    SELECT NEW.tender_id, recipients.email, payload
    FROM (
        SELECT DISTINCT u.email
        FROM tender_subscriptions ts
        JOIN users u ON ts.user_id = u.user_id
        WHERE NEW.tender_category_id IS NOT NULL
          AND ts.selected_category_ids IS NOT NULL
          AND ts.selected_category_ids @> ARRAY[NEW.tender_category_id]
        UNION
        SELECT DISTINCT u.email
        FROM tender_subscriptions ts
        JOIN users u ON ts.user_id = u.user_id
        WHERE NEW.industry_id IS NOT NULL
          AND ts.selected_industry_ids IS NOT NULL
          AND ts.selected_industry_ids @> ARRAY[NEW.industry_id]
    ) AS recipients;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tender_insert_notify ON tenders;

CREATE TRIGGER tender_insert_notify
AFTER INSERT ON tenders
FOR EACH ROW
EXECUTE FUNCTION notify_subscribers_of_new_tender();
