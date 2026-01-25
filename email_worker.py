import datetime
import json
import logging
import os
import sys
import time
import urllib.error
import urllib.request
from typing import Any, Dict, List

from sqlalchemy import or_, select

from app import EmailJob, get_session

logger = logging.getLogger(__name__)

EMAIL_WORKER_INTERVAL = float(os.environ.get("EMAIL_WORKER_INTERVAL", "2"))
EMAIL_WORKER_BATCH_SIZE = int(os.environ.get("EMAIL_WORKER_BATCH_SIZE", "12"))
EMAIL_RETRY_DELAY_SECONDS = int(os.environ.get("EMAIL_RETRY_DELAY_SECONDS", "30"))
EMAIL_RETRY_MAX_MULTIPLIER = int(os.environ.get("EMAIL_RETRY_MAX_MULTIPLIER", "5"))


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
        "reply_to": {"email": sender_email},
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


def _fetch_pending_email_jobs(db) -> List[EmailJob]:
    now = datetime.datetime.now(datetime.timezone.utc)
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


def _process_email_job(db, job: EmailJob) -> None:
    now = datetime.datetime.now(datetime.timezone.utc)
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
            job.send_after = now + datetime.timedelta(seconds=EMAIL_RETRY_DELAY_SECONDS * multiplier)
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
    with get_session() as db:
        jobs = _fetch_pending_email_jobs(db)
        for job in jobs:
            _process_email_job(db, job)


def _email_worker_loop() -> None:
    while True:
        try:
            _run_email_worker_cycle()
        except Exception:
            logger.exception("Email worker cycle failed")
        time_to_wait = EMAIL_WORKER_INTERVAL
        if time_to_wait <= 0:
            time_to_wait = 2
        time.sleep(time_to_wait)


if __name__ == "__main__":
    if os.getenv("ENABLE_WORKER") != "true":
        print("ENABLE_WORKER is not set to 'true'; exiting.")
        sys.exit(0)

    _email_worker_loop()
