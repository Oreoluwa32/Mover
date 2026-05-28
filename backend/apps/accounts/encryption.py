"""Transparent encryption helpers for PII columns (BVN, NIN).

The KycRecord.bvn / KycRecord.nin columns store ciphertext at rest. The
``EncryptedCharField`` defined here transparently encrypts on save and
decrypts on read, so all calling code (Monnify payments, verification
checks, admin masking) keeps using the field exactly like a CharField.

Ciphertext is prefixed with ``PII_PREFIX`` so legacy plaintext rows are
recognisable, and a re-encryption sweep is idempotent.
"""

from __future__ import annotations

from typing import Iterable

from cryptography.fernet import Fernet, InvalidToken
from django.conf import settings
from django.core.exceptions import ImproperlyConfigured
from django.db import models

PII_PREFIX = "enc::"


def _resolve_keys() -> Iterable[bytes]:
    raw = getattr(settings, "MOVR_PII_ENCRYPTION_KEY", "") or ""
    if not raw:
        raise ImproperlyConfigured(
            "MOVR_PII_ENCRYPTION_KEY is required to read or write encrypted PII."
        )
    # Allow comma-separated keys so the first entry is the active encryption
    # key and later entries decrypt legacy ciphertext during key rotation.
    return [k.strip().encode("utf-8") for k in raw.split(",") if k.strip()]


def _primary_fernet() -> Fernet:
    return Fernet(next(iter(_resolve_keys())))


def encrypt_pii(value: str) -> str:
    if not value:
        return value
    if value.startswith(PII_PREFIX):
        return value
    token = _primary_fernet().encrypt(value.encode("utf-8")).decode("utf-8")
    return f"{PII_PREFIX}{token}"


def decrypt_pii(value: str) -> str:
    if not value:
        return value
    if not value.startswith(PII_PREFIX):
        # Legacy plaintext row that has not been migrated yet.
        return value
    payload = value[len(PII_PREFIX) :].encode("utf-8")
    for key in _resolve_keys():
        try:
            return Fernet(key).decrypt(payload).decode("utf-8")
        except InvalidToken:
            continue
    # No key could decrypt; surface the ciphertext so the failure is visible.
    return value


class EncryptedCharField(models.CharField):
    """CharField that transparently encrypts / decrypts its value.

    The column stores ciphertext (much longer than plaintext); size the
    ``max_length`` generously when adding the field.
    """

    def from_db_value(self, value, expression, connection):
        if value is None:
            return value
        return decrypt_pii(value)

    def to_python(self, value):
        if value is None or value == "":
            return value
        if isinstance(value, str) and value.startswith(PII_PREFIX):
            return decrypt_pii(value)
        return value

    def get_prep_value(self, value):
        if value is None or value == "":
            return value
        return encrypt_pii(value)
