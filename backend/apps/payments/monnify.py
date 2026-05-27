from __future__ import annotations

import base64
import json
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.parse import urljoin
from urllib.request import Request, urlopen

from django.conf import settings
from rest_framework.exceptions import APIException, ValidationError


class MonnifyConfigurationError(APIException):
    status_code = 503
    default_detail = "Monnify is not configured yet."


class MonnifyServiceError(APIException):
    status_code = 502
    default_detail = "Monnify is temporarily unavailable."


def _json_headers() -> dict[str, str]:
    return {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "User-Agent": "movr-backend/1.0",
    }


def get_monnify_base_url() -> str:
    base_url = settings.MONNIFY_BASE_URL.strip()
    if not base_url:
        raise MonnifyConfigurationError("Set MONNIFY_BASE_URL before using Monnify.")
    return base_url.rstrip("/") + "/"


def ensure_monnify_config() -> None:
    missing = [
        name
        for name, value in {
            "MONNIFY_API_KEY": settings.MONNIFY_API_KEY,
            "MONNIFY_SECRET_KEY": settings.MONNIFY_SECRET_KEY,
            "MONNIFY_CONTRACT_CODE": settings.MONNIFY_CONTRACT_CODE,
            "MONNIFY_BASE_URL": settings.MONNIFY_BASE_URL,
        }.items()
        if not str(value).strip()
    ]
    if missing:
        raise MonnifyConfigurationError(
            f"Monnify is not configured completely. Missing: {', '.join(missing)}."
        )


def _load_response_body(response) -> dict[str, Any]:
    raw_body = response.read().decode("utf-8")
    if not raw_body.strip():
        return {}
    return json.loads(raw_body)


def _monnify_request(
    method: str,
    path: str,
    *,
    token: str | None = None,
    payload: dict[str, Any] | None = None,
):
    ensure_monnify_config()
    url = urljoin(get_monnify_base_url(), path.lstrip("/"))
    headers = _json_headers()
    if token:
        headers["Authorization"] = f"Bearer {token}"
    data = None
    if payload is not None:
        data = json.dumps(payload).encode("utf-8")

    request = Request(url, data=data, method=method.upper(), headers=headers)
    try:
        with urlopen(request, timeout=30) as response:
            return _load_response_body(response)
    except HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        try:
            payload = json.loads(body)
        except json.JSONDecodeError:
            payload = {"responseMessage": body or exc.reason}

        message = (
            payload.get("responseMessage") or payload.get("message") or str(exc.reason)
        )
        if exc.code < 500:
            raise ValidationError(message)
        raise MonnifyServiceError(message) from exc
    except URLError as exc:
        raise MonnifyServiceError(f"Could not reach Monnify: {exc.reason}") from exc


def get_access_token() -> str:
    ensure_monnify_config()
    auth_pair = f"{settings.MONNIFY_API_KEY}:{settings.MONNIFY_SECRET_KEY}".encode(
        "utf-8"
    )
    authorization = base64.b64encode(auth_pair).decode("utf-8")
    url = urljoin(get_monnify_base_url(), "api/v1/auth/login")
    request = Request(
        url,
        data=b"{}",
        method="POST",
        headers={
            **_json_headers(),
            "Authorization": f"Basic {authorization}",
        },
    )
    try:
        with urlopen(request, timeout=30) as response:
            payload = _load_response_body(response)
    except HTTPError as exc:
        body = exc.read().decode("utf-8", errors="replace")
        raise MonnifyServiceError(
            f"Monnify login failed: {body or exc.reason}"
        ) from exc
    except URLError as exc:
        raise MonnifyServiceError(f"Could not reach Monnify: {exc.reason}") from exc

    token = payload.get("responseBody", {}).get("accessToken")
    if not token:
        raise MonnifyServiceError("Monnify did not return an access token.")
    return token


def reserve_account(payload: dict[str, Any]) -> dict[str, Any]:
    token = get_access_token()
    return _monnify_request(
        "POST",
        "api/v2/bank-transfer/reserved-accounts",
        token=token,
        payload=payload,
    )


def get_reserved_account(account_reference: str) -> dict[str, Any]:
    token = get_access_token()
    return _monnify_request(
        "GET",
        f"api/v2/bank-transfer/reserved-accounts/{account_reference}",
        token=token,
    )


def get_reserved_account_transactions(
    account_reference: str,
    *,
    page: int = 0,
    size: int = 20,
) -> dict[str, Any]:
    token = get_access_token()
    return _monnify_request(
        "GET",
        (
            "api/v1/bank-transfer/reserved-accounts/transactions"
            f"?accountReference={account_reference}&page={page}&size={size}"
        ),
        token=token,
    )
