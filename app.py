import datetime
import hashlib
import json
import logging
import os
import threading
import urllib.error
import urllib.parse
import urllib.request
import uuid
from functools import wraps
from typing import Any, Dict, Iterable, List, Optional

from datetime import timedelta, timezone

from flask import Flask, abort, render_template, request, session, url_for, redirect
from sqlalchemy import (
    ARRAY,
    Boolean,
    Column,
    Date,
    DateTime,
    ForeignKey,
    Integer,
    BigInteger,
    String,
    Text,
    func,
    select,
    or_,
    create_engine,
    event,
    MetaData,
)
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.engine import URL
from sqlalchemy.orm import Session, declarative_base, relationship, selectinload, sessionmaker
from werkzeug.security import check_password_hash, generate_password_hash


app = Flask(__name__)
app.secret_key = os.environ.get("FLASK_SECRET_KEY", "change-this-secret")

logger = logging.getLogger(__name__)


DEFAULT_ADMIN_EMAIL = os.environ.get("DEFAULT_ADMIN_EMAIL", "admin@admin.com")
DEFAULT_ADMIN_PASSWORD = os.environ.get("DEFAULT_ADMIN_PASSWORD", "B3kinAdmin!2024")
DEFAULT_ADMIN_NAME = os.environ.get("DEFAULT_ADMIN_NAME", "Administrator")

SERVICE_OPTIONS = [
    {
        "slug": "tender-review",
        "label": "Tender Review",
        "price": 250,
        "description": "We review your tender and provide a detailed summary with guidance.",
        "step": 1,
    },
    {
        "slug": "one-off",
        "label": "One-Off Tender Application",
        "price": 990,
        "description": "We handle your tender from start to finish — complete, compliant, and submitted on time.",
        "step": 2,
    },
    {
        "slug": "training",
        "label": "Full Tender Training",
        "price": 690,
        "description": "Learn how to apply for tenders with step-by-step, practical training — perfect for new businesses.",
        "step": 3,
    },
]

PAYFAST_MERCHANT_ID = os.environ.get("PAYFAST_MERCHANT_ID", "27480019")
PAYFAST_MERCHANT_KEY = os.environ.get("PAYFAST_MERCHANT_KEY", "6wb97bgknskbs")
PAYFAST_PASSPHRASE = os.environ.get("PAYFAST_PASSPHRASE")
PAYFAST_URL = os.environ.get("PAYFAST_URL", "https://www.payfast.co.za/eng/process")
PAYFAST_API_BASE_URL = os.environ.get("PAYFAST_API_BASE_URL", "https://api.payfast.co.za")
PAYFAST_API_VERSION = os.environ.get("PAYFAST_API_VERSION", "v1")

EMAIL_WORKER_INTERVAL = float(os.environ.get("EMAIL_WORKER_INTERVAL", "2"))
EMAIL_WORKER_BATCH_SIZE = int(os.environ.get("EMAIL_WORKER_BATCH_SIZE", "12"))
EMAIL_RETRY_DELAY_SECONDS = int(os.environ.get("EMAIL_RETRY_DELAY_SECONDS", "30"))
EMAIL_RETRY_MAX_MULTIPLIER = int(os.environ.get("EMAIL_RETRY_MAX_MULTIPLIER", "5"))


def make_engine():
    database_url = os.environ.get("DATABASE_URL")
    if database_url:
        return create_engine(
            database_url,
            connect_args={"options": "-c search_path=tenders,public", "sslmode": "require"},
            pool_pre_ping=True,
            future=True,
        )

    host = os.environ.get("DB_HOST", "localhost")
    port = os.environ.get("DB_PORT", "5432")
    dbname = os.environ.get("DB_NAME", "BekinTenders")
    user = os.environ.get("DB_USER", "postgres")
    password = os.environ.get("DB_PASSWORD", "")
    if password == "":
        password = None
    url = URL.create(
        drivername="postgresql+psycopg",
        username=user,
        password=password,
        host=host,
        port=port,
        database=dbname,
    )
    return create_engine(
        url,
        connect_args={"options": "-c search_path=tenders,public", "sslmode": "require"},
        pool_pre_ping=True,
        future=True,
    )


engine = make_engine()


@event.listens_for(engine, "connect")
def _set_search_path(dbapi_connection, connection_record):
    cursor = dbapi_connection.cursor()
    cursor.execute("SET search_path TO tenders,public")
    cursor.close()


@event.listens_for(Session, "after_begin")
def _set_search_path_per_transaction(session, transaction, connection):
    connection.exec_driver_sql("SET search_path TO tenders,public")

SessionLocal = sessionmaker(bind=engine, autoflush=False, future=True)
Base = declarative_base(metadata=MetaData(schema="tenders"))


class Industry(Base):
    __tablename__ = "industries"
    industry_id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False, unique=True)


class TenderType(Base):
    __tablename__ = "tender_types"
    tender_type_id = Column(Integer, primary_key=True)
    code = Column(Text, nullable=False, unique=True)


class Province(Base):
    __tablename__ = "provinces"
    province_id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False, unique=True)


class Department(Base):
    __tablename__ = "departments"
    department_id = Column(Integer, primary_key=True)
    name = Column(Text, unique=True)


class TenderCategory(Base):
    __tablename__ = "tender_categories"
    tender_category_id = Column(Integer, primary_key=True)
    name = Column(Text, unique=True)


class Tender(Base):
    __tablename__ = "tenders"
    tender_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    tender_ref = Column(Text, nullable=False)
    tender_description = Column(Text, nullable=False)
    tender_category_id = Column(Integer, ForeignKey("tender_categories.tender_category_id"))
    advertised_date = Column(Date)
    closing_date = Column(Date)
    industry_id = Column(Integer, ForeignKey("industries.industry_id"))
    requested_by_department_id = Column(Integer, ForeignKey("departments.department_id"))
    tender_type_id = Column(Integer, ForeignKey("tender_types.tender_type_id"))
    province_id = Column(Integer, ForeignKey("provinces.province_id"))
    service_location = Column(Text)
    special_conditions = Column(Text)
    contact_person = Column(Text)
    contact_email = Column(Text)
    contact_telephone = Column(Text)
    attachments = Column(JSONB, nullable=False, server_default="[]::jsonb")
    attachment_download_url = Column(Text)
    created_time = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    trial_data = Column(JSONB)
    tender_review_summary = Column(Text)

    industry = relationship("Industry", lazy="joined")
    tender_type = relationship("TenderType", lazy="joined")
    province = relationship("Province", lazy="joined")
    category = relationship("TenderCategory", lazy="joined")
    briefing = relationship("TenderBriefing", uselist=False, back_populates="tender")


class TenderBriefing(Base):
    __tablename__ = "tender_briefings"
    tender_id = Column(UUID(as_uuid=True), ForeignKey("tenders.tender_id"), primary_key=True)
    is_scheduled = Column(Boolean, default=False)
    is_compulsory = Column(Boolean, default=False)
    briefing_datetime = Column(DateTime(timezone=True))
    briefing_venue = Column(Text)

    tender = relationship("Tender", back_populates="briefing")


class Role(Base):
    __tablename__ = "roles"
    role_id = Column(Integer, primary_key=True)
    name = Column(Text, nullable=False, unique=True)
    description = Column(Text)


class User(Base):
    __tablename__ = "users"
    user_id = Column(BigInteger, primary_key=True)
    email = Column(Text, nullable=False, unique=True)
    password_hash = Column(Text, nullable=False)
    full_name = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    roles = relationship("UserRole", back_populates="user")


class UserRole(Base):
    __tablename__ = "user_roles"
    user_id = Column(BigInteger, ForeignKey("users.user_id", ondelete="CASCADE"), primary_key=True)
    role_id = Column(Integer, ForeignKey("roles.role_id", ondelete="CASCADE"), primary_key=True)

    user = relationship("User", back_populates="roles")
    role = relationship("Role")


class TenderSubscription(Base):
    __tablename__ = "tender_subscriptions"
    subscription_id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(BigInteger, ForeignKey("users.user_id", ondelete="CASCADE"))
    company = Column(Text)
    phone = Column(Text)
    notes = Column(Text)
    selected_category_ids = Column(ARRAY(Integer))
    selected_industry_ids = Column(ARRAY(Integer))
    total_amount = Column(Integer, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    user = relationship("User")


class EmailJob(Base):
    __tablename__ = "email_jobs"
    job_id = Column(UUID(as_uuid=True), primary_key=True, server_default=func.gen_random_uuid())
    tender_id = Column(UUID(as_uuid=True), ForeignKey("tenders.tender_id", ondelete="CASCADE"))
    recipient_email = Column(Text, nullable=False)
    payload = Column(JSONB, nullable=False)
    status = Column(Text, nullable=False, server_default="pending")
    attempts = Column(Integer, nullable=False, default=0, server_default="0")
    max_attempts = Column(Integer, nullable=False, default=5, server_default="5")
    last_attempt_at = Column(DateTime(timezone=True))
    send_after = Column(DateTime(timezone=True))
    last_error = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())


if os.environ.get("AUTO_CREATE_SCHEMA") == "1":
    Base.metadata.create_all(bind=engine)


def load_filter_options(db: Session) -> Dict[str, List[Dict[str, Any]]]:
    """Fetch lookup values for dropdowns."""
    options = {
        "industries": [
            {"id": item.industry_id, "name": item.name}
            for item in db.scalars(select(Industry).order_by(Industry.name)).all()
        ],
        "tender_types": [
            {"id": item.tender_type_id, "name": item.code}
            for item in db.scalars(select(TenderType).order_by(TenderType.code)).all()
        ],
        "provinces": [
            {"id": item.province_id, "name": item.name}
            for item in db.scalars(select(Province).order_by(Province.name)).all()
        ],
        "categories": [
            {"id": item.tender_category_id, "name": item.name}
            for item in db.scalars(
                select(TenderCategory)
                .where(TenderCategory.name.isnot(None))
                .order_by(TenderCategory.name)
            ).all()
        ],
    }
    return options


def ensure_role(db: Session, name: str) -> int:
    """Ensure a role exists and return its id."""
    role = db.scalars(select(Role).filter_by(name=name)).one_or_none()
    if not role:
        role = Role(name=name)
        db.add(role)
        db.flush()
    return role.role_id


def get_or_create_user(
    db: Session, email: str, full_name: Optional[str], password_hash: Optional[str] = None
) -> int:
    """Insert or update a user, returning the user_id."""
    stmt = select(User).filter(func.lower(User.email) == email.lower())
    user = db.scalars(stmt).one_or_none()
    if user:
        user.full_name = full_name
        if password_hash:
            user.password_hash = password_hash
        db.flush()
        return user.user_id
    hashed = password_hash or generate_password_hash(uuid.uuid4().hex)
    created_user = User(email=email.lower(), full_name=full_name, password_hash=hashed)
    db.add(created_user)
    db.flush()
    return created_user.user_id


def assign_role(db: Session, user_id: int, role_id: int):
    """Assign a role to a user if not already assigned."""
    existing = db.get(UserRole, (user_id, role_id))
    if not existing:
        db.add(UserRole(user_id=user_id, role_id=role_id))
        db.flush()


def persist_subscription(
    db: Session,
    user_id: int,
    company: Optional[str],
    phone: Optional[str],
    notes: Optional[str],
    category_ids: List[int],
    industry_ids: List[int],
    total_amount: int,
) -> TenderSubscription:
    subscription = TenderSubscription(
        subscription_id=uuid.uuid4(),
        user_id=user_id,
        company=company,
        phone=phone,
        notes=notes,
        selected_category_ids=category_ids,
        selected_industry_ids=industry_ids,
        total_amount=total_amount,
    )
    db.add(subscription)
    db.flush()
    return subscription


def normalize_ids(values: Iterable[str]) -> List[int]:
    result: List[int] = []
    for value in values:
        try:
            result.append(int(value))
        except (TypeError, ValueError):
            continue
    return result


def parse_int(value: Optional[str]) -> Optional[int]:
    if value is None:
        return None
    try:
        return int(value)
    except (TypeError, ValueError):
        return None


def _build_email_payload(payload: Dict[str, Any]) -> str:
    closing_date = payload.get("closing_date") or "—"
    category = payload.get("category") or "—"
    industry = payload.get("industry") or "—"
    province = payload.get("province") or "—"
    return f"""
    <p>Hi there,</p>
    <p>We found a new tender that matches your preferences:</p>
    <ul>
      <li><strong>Reference:</strong> {payload.get("tender_ref", "Tender update")}</li>
      <li><strong>Description:</strong> {payload.get("tender_description", "Details available in the portal.")}</li>
      <li><strong>Category:</strong> {category}</li>
      <li><strong>Industry:</strong> {industry}</li>
      <li><strong>Province:</strong> {province}</li>
      <li><strong>Closing Date:</strong> {closing_date}</li>
    </ul>
    <p>
      More information is available in the BekinTenders dashboard.
    </p>
    """


def _current_iso_timestamp() -> str:
    return datetime.datetime.now(datetime.timezone.utc).astimezone().isoformat(timespec="seconds")


def _build_payfast_api_signature(headers: Dict[str, Any], body: Dict[str, Any]) -> str:
    combined: Dict[str, str] = {}
    combined.update({k: str(v) for k, v in headers.items() if v not in (None, "")})
    combined.update({k: str(v) for k, v in body.items() if v not in (None, "")})
    if PAYFAST_PASSPHRASE:
        combined["passphrase"] = PAYFAST_PASSPHRASE
    normalized = urllib.parse.urlencode(
        sorted(combined.items()),
        quote_via=urllib.parse.quote_plus,
    )
    return hashlib.md5(normalized.encode("utf-8")).hexdigest()


def _payfast_api_request(method: str, path: str, body: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    url = f"{PAYFAST_API_BASE_URL.rstrip('/')}{path}"
    timestamp = _current_iso_timestamp()
    headers_map = {
        "merchant-id": PAYFAST_MERCHANT_ID,
        "version": PAYFAST_API_VERSION,
        "timestamp": timestamp,
    }
    signature = _build_payfast_api_signature(headers_map, body or {})
    headers_map["signature"] = signature
    request_headers = {
        "Content-Type": "application/json",
        **headers_map,
    }
    data = json.dumps(body or {}).encode("utf-8") if body is not None else None
    req = urllib.request.Request(url, data=data, headers=request_headers, method=method.upper())
    with urllib.request.urlopen(req, timeout=15) as resp:
        raw = resp.read().decode("utf-8")
        if not raw:
            return {}
        try:
            return json.loads(raw)
        except json.JSONDecodeError:
            return {}


def _prepare_payfast_payment(
    total_amount: int,
    subscription_id: uuid.UUID,
    payer_email: str,
    payer_name: str,
    url_root: str,
) -> Dict[str, Any]:
    if total_amount <= 0:
        raise ValueError("Payment amount must be greater than zero")
    if not PAYFAST_MERCHANT_ID or not PAYFAST_MERCHANT_KEY:
        raise RuntimeError("PayFast credentials are not configured")
    base = (url_root or "").rstrip("/")
    if not base:
        base = "http://127.0.0.1:5000"
    try:
        _payfast_api_request("GET", "/ping")
    except Exception as exc:  # pragma: no cover - depends on network
        logger.warning("PayFast ping failed: %s", exc)
    amount_value = f"{total_amount:.2f}"
    params = {
        "merchant_id": PAYFAST_MERCHANT_ID,
        "merchant_key": PAYFAST_MERCHANT_KEY,
        "return_url": f"{base}/payfast/return",
        "cancel_url": f"{base}/payfast/cancel",
        "notify_url": f"{base}/payfast/notify",
        "email_address": payer_email,
        "m_payment_id": str(subscription_id),
        "amount": amount_value,
        "item_name": f"Tender alerts ({payer_email})",
        "item_description": payer_name or "Tender subscription",
        "custom_str1": "tender_subscription",
        "email_confirmation": "1",
    }
    params["timestamp"] = _current_iso_timestamp()
    params["version"] = PAYFAST_API_VERSION
    signature_headers = {
        "merchant-id": PAYFAST_MERCHANT_ID,
        "version": PAYFAST_API_VERSION,
        "timestamp": params["timestamp"],
    }
    params["signature"] = _build_payfast_api_signature(signature_headers, params)
    return {
        "form_action": PAYFAST_URL,
        "display_amount": f"{total_amount:,.2f}",
        "fields": params,
    }


def _sendgrid_email(recipient_email: str, payload: Dict[str, Any]) -> None:
    api_key = os.environ.get("SENDGRID_API_KEY")
    if not api_key:
        raise RuntimeError("SENDGRID_API_KEY environment variable is not set")

    sender_email = os.environ.get("SENDGRID_FROM_EMAIL", "tenders@bekinconsulting.co.za")
    subject = f"New tender available: {payload.get('tender_ref', 'Tender update')}"
    apply_url = f"{os.environ.get('APP_BASE_URL', 'http://127.0.0.1:5000').rstrip('/')}/apply?service=one-off"
    html_content = f"""
    {_build_email_payload(payload)}
    <p>
      <a href="{apply_url}" style="display:inline-block;padding:12px 24px;border-radius:8px;background:#8b0000;color:#fff;font-weight:700;text-decoration:none;">Apply now</a>
    </p>
    <p>Best regards,<br>BekinTenders Team</p>
    """

    mail_payload = {
        "personalizations": [{"to": [{"email": recipient_email}]}],
        "from": {"email": sender_email},
        "subject": subject,
        "content": [{"type": "text/html", "value": html_content}],
    }

    request = urllib.request.Request(
        "https://api.sendgrid.com/v3/mail/send",
        data=json.dumps(mail_payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
    )

    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            if getattr(response, "status", 0) >= 400:
                raise RuntimeError(f"SendGrid returned status {response.status}")
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="ignore")
        raise RuntimeError(f"SendGrid HTTP error {exc.code}: {detail}") from exc
    except urllib.error.URLError as exc:
        raise RuntimeError(f"SendGrid request failed: {exc}") from exc


_email_worker_thread: Optional[threading.Thread] = None
_email_worker_stop_event = threading.Event()


def _fetch_pending_email_jobs(db: Session) -> List[EmailJob]:
    now = datetime.datetime.now(timezone.utc)
    stmt = (
        select(EmailJob)
        .where(
            EmailJob.status == "pending",
            EmailJob.attempts < EmailJob.max_attempts,
            or_(
                EmailJob.send_after.is_(None),
                EmailJob.send_after <= now,
            ),
        )
        .order_by(EmailJob.created_at)
        .limit(EMAIL_WORKER_BATCH_SIZE)
        .with_for_update(skip_locked=True)
    )
    return db.scalars(stmt).all()


def _process_email_job(db: Session, job: EmailJob) -> None:
    now = datetime.datetime.now(timezone.utc)
    job.attempts += 1
    job.last_attempt_at = now
    job.updated_at = now
    try:
        _sendgrid_email(job.recipient_email, job.payload or {})
    except Exception as exc:  # noqa: BLE001
        job.last_error = str(exc)
        if job.attempts >= job.max_attempts:
            job.status = "failed"
        else:
            job.status = "pending"
            multiplier = min(job.attempts, EMAIL_RETRY_MAX_MULTIPLIER)
            job.send_after = now + timedelta(seconds=EMAIL_RETRY_DELAY_SECONDS * multiplier)
        db.add(job)
        db.commit()
        logger.warning("Email job %s failed (%s)", job.job_id, job.last_error)
        return

    job.status = "sent"
    job.last_error = None
    job.send_after = None
    db.add(job)
    db.commit()


def _run_email_worker_cycle() -> None:
    with SessionLocal() as db:
        jobs = _fetch_pending_email_jobs(db)
        for job in jobs:
            _process_email_job(db, job)


def _email_worker_loop() -> None:
    while not _email_worker_stop_event.is_set():
        try:
            _run_email_worker_cycle()
        except Exception:
            logger.exception("Email worker cycle failed")
        _email_worker_stop_event.wait(EMAIL_WORKER_INTERVAL)


def _ensure_email_worker_running() -> None:
    global _email_worker_thread
    if _email_worker_thread is None:
        _email_worker_thread = threading.Thread(target=_email_worker_loop, daemon=True)
        _email_worker_thread.start()


if hasattr(app, "before_first_request"):
    @app.before_first_request
    def _start_email_worker() -> None:
        _ensure_email_worker_running()
else:
    _ensure_email_worker_running()


def ensure_admin_user(db: Session):
    """Ensure the default admin user exists with the Admin role."""
    role_id = ensure_role(db, "Admin")
    password_hash = generate_password_hash(DEFAULT_ADMIN_PASSWORD)
    user_id = get_or_create_user(db, DEFAULT_ADMIN_EMAIL, DEFAULT_ADMIN_NAME, password_hash=password_hash)
    assign_role(db, user_id, role_id)
    db.flush()
    return user_id


def fetch_user_by_email(db: Session, email: str) -> Optional[User]:
    stmt = select(User).filter(func.lower(User.email) == email.lower())
    return db.scalars(stmt).one_or_none()


def fetch_user_roles(db: Session, user_id: int) -> List[str]:
    stmt = select(Role.name).join(UserRole).filter(UserRole.user_id == user_id)
    return [row[0] for row in db.execute(stmt).all()]


def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get("is_admin"):
            return redirect(url_for("admin_login", next=request.path))
        return f(*args, **kwargs)

    return decorated_function


def fetch_tenders(
    db: Session,
    q: Optional[str],
    category_id: Optional[str],
    industry_id: Optional[str],
    province_id: Optional[str],
    tender_type_id: Optional[str],
) -> List[Dict[str, Any]]:
    """Query tenders with optional filters."""
    stmt = select(Tender).options(
        selectinload(Tender.industry),
        selectinload(Tender.tender_type),
        selectinload(Tender.province),
        selectinload(Tender.category),
    )
    if q:
        like = f"%{q}%"
        stmt = stmt.filter(
            or_(
                Tender.tender_ref.ilike(like),
                Tender.tender_description.ilike(like),
                Tender.service_location.ilike(like),
            )
        )
    category_id_int = parse_int(category_id)
    industry_id_int = parse_int(industry_id)
    province_id_int = parse_int(province_id)
    tender_type_id_int = parse_int(tender_type_id)

    if category_id_int is not None:
        stmt = stmt.filter(Tender.tender_category_id == category_id_int)
    if industry_id_int is not None:
        stmt = stmt.filter(Tender.industry_id == industry_id_int)
    if province_id_int is not None:
        stmt = stmt.filter(Tender.province_id == province_id_int)
    if tender_type_id_int is not None:
        stmt = stmt.filter(Tender.tender_type_id == tender_type_id_int)

    stmt = stmt.order_by(
        func.coalesce(Tender.closing_date, Tender.created_time).asc(),
        Tender.tender_ref,
    )

    tenders = db.scalars(stmt).all()
    return [
        {
            "tender_id": str(t.tender_id),
            "tender_ref": t.tender_ref,
            "tender_description": t.tender_description,
            "advertised_date": t.advertised_date,
            "closing_date": t.closing_date,
            "tender_type": t.tender_type.code if t.tender_type else None,
            "province": t.province.name if t.province else None,
            "industry": t.industry.name if t.industry else None,
            "category": t.category.name if t.category else None,
        }
        for t in tenders
    ]


def fetch_tender_detail(db: Session, tender_id: str) -> Optional[Tender]:
    """Return a single tender with briefing info."""
    try:
        tender_uuid = uuid.UUID(tender_id)
    except ValueError:
        return None
    stmt = (
        select(Tender)
        .where(Tender.tender_id == tender_uuid)
        .options(
            selectinload(Tender.industry),
            selectinload(Tender.tender_type),
            selectinload(Tender.province),
            selectinload(Tender.category),
            selectinload(Tender.briefing),
        )
    )
    return db.scalars(stmt).one_or_none()


@app.route("/")
def search():
    q = request.args.get("q") or ""
    category_id = request.args.get("category") or None
    industry_id = request.args.get("industry") or None
    province_id = request.args.get("province") or None
    tender_type_id = request.args.get("tender_type") or None
    run = request.args.get("run") == "1"

    with SessionLocal() as db:
        options = load_filter_options(db)
        tenders = (
            fetch_tenders(
                db,
                q=q.strip() or None,
                category_id=category_id,
                industry_id=industry_id,
                province_id=province_id,
                tender_type_id=tender_type_id,
            )
            if run
            else []
        )

    return render_template(
        "search.html",
        q=q,
        category_id=category_id,
        industry_id=industry_id,
        province_id=province_id,
        tender_type_id=tender_type_id,
        options=options,
        tenders=tenders,
        show_results=run,
    )


@app.route("/apply", methods=["GET", "POST"])
def apply():
    submitted = False
    form_values = {
        "full_name": "",
        "email": "",
        "phone": "",
        "company": "",
        "tender_ref": "",
        "tender_description": "",
    }
    selected_slug = request.args.get("service") or SERVICE_OPTIONS[0]["slug"]
    if request.method == "POST":
        submitted = True
        selected_slug = request.form.get("service") or selected_slug
        form_values = {
            "full_name": request.form.get("full_name", "").strip(),
            "email": request.form.get("email", "").strip(),
            "phone": request.form.get("phone", "").strip(),
            "company": request.form.get("company", "").strip(),
            "tender_ref": request.form.get("tender_ref", "").strip(),
            "tender_description": request.form.get("tender_description", "").strip(),
        }
        app.logger.info(
            "Application submitted for %s (service=%s, tender_ref=%s)",
            form_values["email"] or form_values["full_name"],
            selected_slug,
            form_values["tender_ref"],
        )

    selected_service = next((s for s in SERVICE_OPTIONS if s["slug"] == selected_slug), SERVICE_OPTIONS[0])
    return render_template(
        "apply.html",
        services=SERVICE_OPTIONS,
        selected_slug=selected_slug,
        selected_service=selected_service,
        submitted=submitted,
        form_values=form_values,
    )


@app.route("/admin/login", methods=["GET", "POST"])
def admin_login():
    error = None
    next_url = request.args.get("next") or request.form.get("next") or url_for("admin_index")
    with SessionLocal() as db:
        ensure_admin_user(db)
        db.commit()
        if request.method == "POST":
            email = request.form.get("email", "").strip()
            password = request.form.get("password", "")
            user = fetch_user_by_email(db, email)
            if not user or not check_password_hash(user.password_hash, password):
                error = "Invalid credentials."
            else:
                roles = fetch_user_roles(db, user.user_id)
                if "Admin" not in roles:
                    error = "Access restricted to users with Admin role."
                else:
                    session["user_id"] = user.user_id
                    session["user_email"] = user.email
                    session["is_admin"] = True
                    return redirect(next_url)

    return render_template("admin_login.html", error=error, next_url=next_url)


@app.route("/admin/logout")
def admin_logout():
    session.clear()
    return redirect(url_for("admin_login"))


@app.route("/subscribe", methods=["GET", "POST"])
def subscribe():
    submitted = False
    form_values = {
        "full_name": "",
        "company": "",
        "email": "",
        "phone": "",
        "notes": "",
    }
    selected_categories: List[str] = []
    selected_industries: List[str] = []
    total_amount = 0
    payment_data: Optional[Dict[str, Any]] = None
    payment_error: Optional[str] = None

    if request.method == "POST":
        submitted = True
        form_values = {
            "full_name": request.form.get("full_name", "").strip(),
            "company": request.form.get("company", "").strip(),
            "email": request.form.get("email", "").strip(),
            "phone": request.form.get("phone", "").strip(),
            "notes": request.form.get("notes", "").strip(),
        }
        selected_categories = [value for value in request.form.getlist("categories") if value]
        selected_industries = [value for value in request.form.getlist("industries") if value]
        app.logger.info(
            "Subscription request from %s for categories %s and industries %s",
            form_values["email"] or form_values["full_name"],
            selected_categories,
            selected_industries,
        )

    options: Dict[str, List[Dict[str, Any]]] = {}
    selected_category_ids: List[int] = normalize_ids(selected_categories)
    selected_industry_ids: List[int] = normalize_ids(selected_industries)
    total_amount = 100 * (len(selected_category_ids) + len(selected_industry_ids))

    with SessionLocal() as db:
        options = load_filter_options(db)
        if request.method == "POST" and form_values["email"]:
            role_id = ensure_role(db, "Tender User")
            user_id = get_or_create_user(db, form_values["email"], form_values["full_name"])
            assign_role(db, user_id, role_id)
            subscription = persist_subscription(
                db,
                user_id,
                form_values["company"] or None,
                form_values["phone"] or None,
                form_values["notes"] or None,
                selected_category_ids,
                selected_industry_ids,
                total_amount,
            )
            db.commit()
            if total_amount > 0:
                try:
                    payment_data = _prepare_payfast_payment(
                        total_amount,
                        subscription.subscription_id,
                        form_values["email"],
                        form_values["full_name"],
                        request.url_root,
                    )
                    return render_template("payfast_redirect.html", payment_data=payment_data)
                except Exception as exc:  # pragma: no cover - integration
                    payment_error = str(exc)
                    submitted = True
            else:
                submitted = True

    category_map = {str(item["id"]): item["name"] for item in options.get("categories", [])}
    industry_map = {str(item["id"]): item["name"] for item in options.get("industries", [])}
    selected_category_names = [category_map[id_] for id_ in selected_categories if id_ in category_map]
    selected_industry_names = [industry_map[id_] for id_ in selected_industries if id_ in industry_map]

    return render_template(
        "subscribe.html",
        options=options,
        submitted=submitted,
        form_values=form_values,
        selected_categories=selected_categories,
        selected_industries=selected_industries,
        selected_category_names=selected_category_names,
        selected_industry_names=selected_industry_names,
        payment_error=payment_error,
    )


@app.route("/payfast/return")
def payfast_return():
    return render_template("payfast_return.html")


@app.route("/payfast/cancel")
def payfast_cancel():
    return render_template("payfast_cancel.html")


@app.route("/payfast/notify", methods=["POST"])
def payfast_notify():
    payload = request.form.to_dict()
    app.logger.info("PayFast notification received: %s", payload)
    return "", 200


@app.route("/tenders/<tender_id>")
def tender_detail(tender_id: str):
    with SessionLocal() as db:
        tender = fetch_tender_detail(db, tender_id)
    if not tender:
        abort(404)
    return render_template("detail.html", tender=tender)


# -------- Admin helpers --------

def parse_date(value: Optional[str]):
    if not value or not value.strip():
        return None
    try:
        return datetime.date.fromisoformat(value.strip())
    except ValueError:
        return None


def upsert_tender(db: Session, tender_id: Optional[str], form: Dict[str, Any]) -> str:
    """Insert or update a tender based on tender_id."""
    payload = {
        "tender_ref": form.get("tender_ref", "").strip(),
        "tender_description": form.get("tender_description", "").strip(),
        "tender_category_id": parse_int(form.get("category")),
        "industry_id": parse_int(form.get("industry")),
        "province_id": parse_int(form.get("province")),
        "tender_type_id": parse_int(form.get("tender_type")),
        "advertised_date": parse_date(form.get("advertised_date")),
        "closing_date": parse_date(form.get("closing_date")),
        "service_location": form.get("service_location") or None,
        "special_conditions": form.get("special_conditions") or None,
        "contact_person": form.get("contact_person") or None,
        "contact_email": form.get("contact_email") or None,
        "contact_telephone": form.get("contact_telephone") or None,
        "attachment_download_url": form.get("attachment_download_url") or None,
        "tender_review_summary": form.get("tender_review_summary") or None,
    }

    if tender_id:
        try:
            tender_uuid = uuid.UUID(tender_id)
        except ValueError:
            raise ValueError("Invalid tender ID")
        tender = db.get(Tender, tender_uuid)
        if not tender:
            raise ValueError("Tender not found")
        for key, value in payload.items():
            setattr(tender, key, value)
        db.flush()
        return tender_id

    new_tender = Tender(
        tender_id=uuid.uuid4(),
        **payload,
        attachments=[],
        created_time=datetime.datetime.now(datetime.timezone.utc),
        created_at=datetime.datetime.now(datetime.timezone.utc),
    )
    db.add(new_tender)
    db.flush()
    return str(new_tender.tender_id)


def delete_tender(db: Session, tender_id: str):
    try:
        tender_uuid = uuid.UUID(tender_id)
    except ValueError:
        return
    tender = db.get(Tender, tender_uuid)
    if tender:
        db.delete(tender)
        db.flush()


@app.route("/admin")
@admin_required
def admin_index():
    q = request.args.get("q") or ""
    category_id = request.args.get("category") or None
    industry_id = request.args.get("industry") or None
    province_id = request.args.get("province") or None
    tender_type_id = request.args.get("tender_type") or None
    run = request.args.get("run") == "1"

    with SessionLocal() as db:
        options = load_filter_options(db)
        tenders = (
            fetch_tenders(
                db,
                q=q.strip() or None,
                category_id=category_id,
                industry_id=industry_id,
                province_id=province_id,
                tender_type_id=tender_type_id,
            )
            if run
            else []
        )

    return render_template(
        "admin_list.html",
        q=q,
        category_id=category_id,
        industry_id=industry_id,
        province_id=province_id,
        tender_type_id=tender_type_id,
        options=options,
        tenders=tenders,
        show_results=run,
    )


@app.route("/admin/tenders/new", methods=["GET", "POST"])
@admin_required
def admin_new_tender():
    if request.method == "POST":
        form = request.form
        with SessionLocal() as db:
            tid = upsert_tender(db, None, form)
            db.commit()
        return redirect(url_for("admin_index", run=1))

    with SessionLocal() as db:
        options = load_filter_options(db)
    return render_template("admin_form.html", tender=None, options=options, action="New")


@app.route("/admin/tenders/<tender_id>/edit", methods=["GET", "POST"])
@admin_required
def admin_edit_tender(tender_id: str):
    with SessionLocal() as db:
        if request.method == "POST":
            form = request.form
            upsert_tender(db, tender_id, form)
            db.commit()
            return redirect(url_for("admin_index", run=1))
        tender = fetch_tender_detail(db, tender_id)
        options = load_filter_options(db)
    if not tender:
        abort(404)
    return render_template("admin_form.html", tender=tender, options=options, action="Edit")


@app.route("/admin/tenders/<tender_id>/delete", methods=["POST"])
@admin_required
def admin_delete_tender(tender_id: str):
    with SessionLocal() as db:
        delete_tender(db, tender_id)
        db.commit()
    return redirect(url_for("admin_index", run=1))


@app.template_filter("date_fmt")
def date_fmt(value):
    if value is None:
        return "—"
    return value.strftime("%Y-%m-%d")


@app.template_filter("datetime_fmt")
def datetime_fmt(value):
    if value is None:
        return "—"
    return value.strftime("%Y-%m-%d %H:%M")


if __name__ == "__main__":
    app.run(debug=True)
