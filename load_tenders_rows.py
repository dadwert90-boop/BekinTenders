import datetime
import json
import os
from typing import Any, Dict, Optional

import pandas as pd
import psycopg


LOOKUP_QUERIES = {
    "industries": (
        "industry_id",
        "name",
        "INSERT INTO tenders.industries (name) VALUES (%s) ON CONFLICT (name) DO NOTHING RETURNING industry_id",
        "SELECT industry_id FROM tenders.industries WHERE name = %s",
    ),
    "tender_types": (
        "tender_type_id",
        "code",
        "INSERT INTO tenders.tender_types (code) VALUES (%s) ON CONFLICT (code) DO NOTHING RETURNING tender_type_id",
        "SELECT tender_type_id FROM tenders.tender_types WHERE code = %s",
    ),
    "provinces": (
        "province_id",
        "name",
        "INSERT INTO tenders.provinces (name) VALUES (%s) ON CONFLICT (name) DO NOTHING RETURNING province_id",
        "SELECT province_id FROM tenders.provinces WHERE name = %s",
    ),
    "departments": (
        "department_id",
        "name",
        "INSERT INTO tenders.departments (name) VALUES (%s) ON CONFLICT (name) DO NOTHING RETURNING department_id",
        "SELECT department_id FROM tenders.departments WHERE name = %s",
    ),
    "tender_categories": (
        "tender_category_id",
        "name",
        "INSERT INTO tenders.tender_categories (name) VALUES (%s) ON CONFLICT (name) DO NOTHING RETURNING tender_category_id",
        "SELECT tender_category_id FROM tenders.tender_categories WHERE name = %s",
    ),
}


def _env(name: str) -> Optional[str]:
    value = os.environ.get(name)
    if value is None or value == "":
        return None
    return value


def _build_conninfo() -> str:
    database_url = _env("DATABASE_URL")
    if database_url:
        return database_url
    host = _env("DB_HOST")
    port = _env("DB_PORT")
    dbname = _env("DB_NAME")
    user = _env("DB_USER")
    password = os.environ.get("DB_PASSWORD")
    if not host or not port or not dbname or not user or password is None:
        raise RuntimeError("DB_HOST, DB_PORT, DB_NAME, DB_USER, and DB_PASSWORD must be set")
    return f"postgresql://{user}:{password}@{host}:{port}/{dbname}?sslmode=require"


def _clean_text(value: Any) -> Optional[str]:
    if value is None:
        return None
    if isinstance(value, float) and pd.isna(value):
        return None
    text = str(value).strip()
    return text if text else None


def _clean_datetime(value: Any) -> Optional[datetime.datetime]:
    if value is None:
        return None
    if isinstance(value, float) and pd.isna(value):
        return None
    if isinstance(value, datetime.datetime):
        return value
    if isinstance(value, datetime.date):
        return datetime.datetime.combine(value, datetime.time.min)
    try:
        return pd.to_datetime(value).to_pydatetime()
    except Exception:
        return None


def _clean_date(value: Any) -> Optional[datetime.date]:
    dt = _clean_datetime(value)
    return dt.date() if dt else None


def _clean_bool(value: Any) -> bool:
    if value is None:
        return False
    if isinstance(value, float) and pd.isna(value):
        return False
    if isinstance(value, bool):
        return value
    text = str(value).strip().lower()
    return text in {"true", "yes", "1", "y"}


def _clean_json(value: Any):
    if value is None:
        return None
    if isinstance(value, float) and pd.isna(value):
        return None
    if isinstance(value, (dict, list)):
        return value
    text = str(value).strip()
    if not text:
        return None
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        return None


def _get_or_create_id(cur, table: str, value: str) -> Optional[int]:
    if not value:
        return None
    _, _, insert_sql, select_sql = LOOKUP_QUERIES[table]
    cur.execute(insert_sql, (value,))
    row = cur.fetchone()
    if row:
        return row[0]
    cur.execute(select_sql, (value,))
    row = cur.fetchone()
    return row[0] if row else None


def main() -> None:
    df = pd.read_excel("tenders_rows.xlsx")

    conninfo = _build_conninfo()
    with psycopg.connect(conninfo) as conn:
        conn.execute("SET search_path TO tenders,public")
        with conn.cursor() as cur:
            inserted = 0
            briefing_upserts = 0
            for _, row in df.iterrows():
                tender_id = _clean_text(row.get("id"))
                if not tender_id:
                    continue

                category_id = _get_or_create_id(cur, "tender_categories", _clean_text(row.get("tender_category")) or "")
                industry_id = _get_or_create_id(cur, "industries", _clean_text(row.get("industry")) or "")
                province_id = _get_or_create_id(cur, "provinces", _clean_text(row.get("province")) or "")
                tender_type_id = _get_or_create_id(cur, "tender_types", _clean_text(row.get("tender_type")) or "")
                dept_id = _get_or_create_id(cur, "departments", _clean_text(row.get("tender_requested_by_dept")) or "")

                attachments = _clean_json(row.get("attachments"))
                if attachments is None:
                    attachments = []

                payload: Dict[str, Any] = {
                    "tender_id": tender_id,
                    "tender_ref": _clean_text(row.get("tender_ref")),
                    "tender_description": _clean_text(row.get("tender_description")),
                    "tender_category_id": category_id,
                    "advertised_date": _clean_date(row.get("advertised_date")),
                    "closing_date": _clean_date(row.get("closing_date")),
                    "industry_id": industry_id,
                    "requested_by_department_id": dept_id,
                    "tender_type_id": tender_type_id,
                    "province_id": province_id,
                    "service_location": _clean_text(row.get("service_location")),
                    "special_conditions": _clean_text(row.get("special_conditions")),
                    "contact_person": _clean_text(row.get("contact_person")),
                    "contact_email": _clean_text(row.get("contact_email")),
                    "contact_telephone": _clean_text(row.get("contact_telephone")),
                    "attachments": attachments,
                    "attachment_download_url": _clean_text(row.get("attachment_download_url")),
                    "created_time": _clean_datetime(row.get("created_time")),
                    "created_at": _clean_datetime(row.get("created_at")),
                    "trial_data": _clean_json(row.get("trial_data")),
                    "tender_review_summary": _clean_text(row.get("tender_review_summary")),
                }

                cur.execute(
                    """
                    INSERT INTO tenders.tenders (
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
                    VALUES (
                        %(tender_id)s,
                        %(tender_ref)s,
                        %(tender_description)s,
                        %(tender_category_id)s,
                        %(advertised_date)s,
                        %(closing_date)s,
                        %(industry_id)s,
                        %(requested_by_department_id)s,
                        %(tender_type_id)s,
                        %(province_id)s,
                        %(service_location)s,
                        %(special_conditions)s,
                        %(contact_person)s,
                        %(contact_email)s,
                        %(contact_telephone)s,
                        %(attachments)s,
                        %(attachment_download_url)s,
                        %(created_time)s,
                        %(created_at)s,
                        %(trial_data)s,
                        %(tender_review_summary)s
                    )
                    ON CONFLICT (tender_id) DO UPDATE SET
                        tender_ref = EXCLUDED.tender_ref,
                        tender_description = EXCLUDED.tender_description,
                        tender_category_id = EXCLUDED.tender_category_id,
                        advertised_date = EXCLUDED.advertised_date,
                        closing_date = EXCLUDED.closing_date,
                        industry_id = EXCLUDED.industry_id,
                        requested_by_department_id = EXCLUDED.requested_by_department_id,
                        tender_type_id = EXCLUDED.tender_type_id,
                        province_id = EXCLUDED.province_id,
                        service_location = EXCLUDED.service_location,
                        special_conditions = EXCLUDED.special_conditions,
                        contact_person = EXCLUDED.contact_person,
                        contact_email = EXCLUDED.contact_email,
                        contact_telephone = EXCLUDED.contact_telephone,
                        attachments = EXCLUDED.attachments,
                        attachment_download_url = EXCLUDED.attachment_download_url,
                        created_time = EXCLUDED.created_time,
                        created_at = EXCLUDED.created_at,
                        trial_data = EXCLUDED.trial_data,
                        tender_review_summary = EXCLUDED.tender_review_summary
                    """,
                    payload,
                )
                inserted += 1

                briefing_session = _clean_bool(row.get("briefing_session"))
                briefing_compulsory = _clean_bool(row.get("briefing_compulsory"))
                briefing_datetime = _clean_datetime(row.get("briefing_date_time"))
                briefing_venue = _clean_text(row.get("briefing_venue"))
                if briefing_session or briefing_compulsory or briefing_datetime or briefing_venue:
                    cur.execute(
                        """
                        INSERT INTO tenders.tender_briefings (
                            tender_id,
                            is_scheduled,
                            is_compulsory,
                            briefing_datetime,
                            briefing_venue
                        )
                        VALUES (%s, %s, %s, %s, %s)
                        ON CONFLICT (tender_id) DO UPDATE SET
                            is_scheduled = EXCLUDED.is_scheduled,
                            is_compulsory = EXCLUDED.is_compulsory,
                            briefing_datetime = EXCLUDED.briefing_datetime,
                            briefing_venue = EXCLUDED.briefing_venue
                        """,
                        (
                            tender_id,
                            briefing_session,
                            briefing_compulsory,
                            briefing_datetime,
                            briefing_venue,
                        ),
                    )
                    briefing_upserts += 1

            conn.commit()

    print(f"Loaded {inserted} tenders")
    print(f"Upserted {briefing_upserts} tender briefings")


if __name__ == "__main__":
    main()
