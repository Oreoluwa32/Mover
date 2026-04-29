from __future__ import annotations

import json
import logging
import random
from urllib.error import HTTPError, URLError
from urllib.parse import parse_qsl, urlencode, urlparse, urlunparse
from urllib.request import Request, urlopen

from django.conf import settings

logger = logging.getLogger(__name__)


class PasswordResetEmailError(RuntimeError):
    """Raised when Movr cannot send a password reset email."""


class EmailVerificationError(RuntimeError):
    """Raised when Movr cannot send an email verification code."""


def build_password_reset_url(*, uid: str, token: str) -> str:
    base_url = settings.MOVR_PASSWORD_RESET_DEEP_LINK_BASE
    parsed = urlparse(base_url)
    query = dict(parse_qsl(parsed.query, keep_blank_values=True))
    query.update(
        {
            "uid": uid,
            "token": token,
        }
    )
    return urlunparse(parsed._replace(query=urlencode(query)))


def generate_email_verification_code() -> str:
    return f"{random.randint(0, 999999):06d}"


def _send_resend_email(
    *,
    to_email: str,
    subject: str,
    html: str,
    text: str,
    category: str,
    error_cls: type[RuntimeError],
    generic_failure_message: str,
) -> None:
    if not settings.RESEND_API_KEY or not settings.RESEND_FROM_EMAIL:
        raise error_cls(
            "Resend is not configured. Set RESEND_API_KEY and RESEND_FROM_EMAIL."
        )

    payload = json.dumps(
        {
            "from": settings.RESEND_FROM_EMAIL,
            "to": [to_email],
            "subject": subject,
            "html": html,
            "text": text,
            "tags": [
                {"name": "category", "value": category},
            ],
        }
    ).encode("utf-8")

    request = Request(
        "https://api.resend.com/emails",
        data=payload,
        headers={
            "Authorization": f"Bearer {settings.RESEND_API_KEY}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urlopen(request, timeout=20) as response:
            if response.status >= 400:
                raise error_cls(
                    f"Resend rejected the email with status {response.status}."
                )
    except HTTPError as exc:
        error_body = exc.read().decode("utf-8", errors="ignore")
        logger.exception("Resend email failed: %s", error_body)
        raise error_cls(generic_failure_message) from exc
    except URLError as exc:
        logger.exception("Resend email network error.")
        raise error_cls("Unable to reach the email service right now.") from exc


def send_password_reset_email(
    *,
    to_email: str,
    recipient_name: str,
    reset_url: str,
) -> None:
    greeting_name = recipient_name.strip() or "there"
    subject = "Reset your Movr password"
    html = f"""
    <div style="font-family:Arial,sans-serif;line-height:1.6;color:#1f2937;">
      <h2 style="margin-bottom:8px;">Reset your password</h2>
      <p>Hello {greeting_name},</p>
      <p>We received a request to reset your Movr password.</p>
      <p>
        <a
          href="{reset_url}"
          style="display:inline-block;padding:12px 20px;background:#6D28D9;color:#ffffff;text-decoration:none;border-radius:999px;font-weight:600;"
        >
          Reset Password
        </a>
      </p>
      <p>If the button does not open the app, copy and paste this link into your browser:</p>
      <p><a href="{reset_url}">{reset_url}</a></p>
      <p>If you did not request this, you can safely ignore this email.</p>
      <p>Movr Team</p>
    </div>
    """
    text = (
        f"Hello {greeting_name},\n\n"
        "We received a request to reset your Movr password.\n\n"
        f"Open this link to reset it:\n{reset_url}\n\n"
        "If you did not request this, you can ignore this email.\n\n"
        "Movr Team"
    )
    _send_resend_email(
        to_email=to_email,
        subject=subject,
        html=html,
        text=text,
        category="password_reset",
        error_cls=PasswordResetEmailError,
        generic_failure_message="Unable to send password reset email right now.",
    )


def send_email_verification_email(
    *,
    to_email: str,
    recipient_name: str,
    verification_code: str,
) -> None:
    greeting_name = recipient_name.strip() or "there"
    subject = "Verify your Movr email"
    html = f"""
    <div style="font-family:Arial,sans-serif;line-height:1.6;color:#1f2937;">
      <h2 style="margin-bottom:8px;">Verify your email</h2>
      <p>Hello {greeting_name},</p>
      <p>Use the code below to verify your Movr account:</p>
      <p style="font-size:32px;font-weight:700;letter-spacing:8px;color:#6D28D9;margin:24px 0;">
        {verification_code}
      </p>
      <p>This code will expire in a few minutes.</p>
      <p>If you did not create a Movr account, you can safely ignore this email.</p>
      <p>Movr Team</p>
    </div>
    """
    text = (
        f"Hello {greeting_name},\n\n"
        "Use this code to verify your Movr account:\n\n"
        f"{verification_code}\n\n"
        "This code will expire in a few minutes.\n\n"
        "If you did not create a Movr account, you can ignore this email.\n\n"
        "Movr Team"
    )
    _send_resend_email(
        to_email=to_email,
        subject=subject,
        html=html,
        text=text,
        category="email_verification",
        error_cls=EmailVerificationError,
        generic_failure_message="Unable to send verification email right now.",
    )
