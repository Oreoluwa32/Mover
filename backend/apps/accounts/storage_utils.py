from __future__ import annotations

import json
import mimetypes
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.parse import quote, unquote, urlparse
from urllib.request import Request, urlopen


class StorageConfigurationError(Exception):
    pass


def build_storage_reference(bucket: str, object_path: str) -> str:
    return f"supabase://{bucket}/{object_path.lstrip('/')}"


def extract_storage_object_path(
    value: str | None,
    *,
    bucket: str,
    supabase_url: str,
) -> str | None:
    normalized = (value or "").strip()
    if not normalized:
        return None

    storage_prefix = f"supabase://{bucket}/"
    if normalized.startswith(storage_prefix):
        return normalized[len(storage_prefix) :].lstrip("/")

    parsed = urlparse(normalized)
    if not parsed.scheme or not parsed.netloc:
        return None

    normalized_base = supabase_url.rstrip("/")
    if not normalized_base or not normalized.startswith(normalized_base):
        return None

    public_prefix = f"/storage/v1/object/public/{bucket}/"
    sign_prefix = f"/storage/v1/object/sign/{bucket}/"
    raw_path = parsed.path
    if raw_path.startswith(public_prefix):
        return unquote(raw_path[len(public_prefix) :]).lstrip("/")
    if raw_path.startswith(sign_prefix):
        return unquote(raw_path[len(sign_prefix) :]).lstrip("/")
    return None


def upload_file_to_supabase(
    *,
    uploaded_file,
    object_path: str,
    allowed_extensions: set[str],
    max_size: int,
    allowed_content_prefixes: tuple[str, ...],
    invalid_type_message: str,
    supabase_url: str,
    service_role_key: str,
    bucket: str,
    public_access: bool,
) -> str:
    if not supabase_url or not service_role_key:
        raise StorageConfigurationError("Supabase storage is not configured.")

    extension = Path(uploaded_file.name or "").suffix.lower().lstrip(".")
    if extension not in allowed_extensions:
        raise ValueError(invalid_type_message)

    if uploaded_file.size > max_size:
        raise ValueError(f"File must be {max_size // (1024 * 1024)}MB or less.")

    content_type = (uploaded_file.content_type or "").lower()
    if not content_type or content_type == "application/octet-stream":
        guessed_content_type, _ = mimetypes.guess_type(uploaded_file.name or "")
        content_type = (guessed_content_type or content_type).lower()

    if (
        content_type
        and content_type != "application/octet-stream"
        and not any(content_type.startswith(prefix) for prefix in allowed_content_prefixes)
    ):
        raise ValueError(invalid_type_message)

    upload_url = (
        f"{supabase_url.rstrip('/')}/storage/v1/object/"
        f"{bucket}/{quote(object_path, safe='/')}"
    )

    request_headers = {
        "Authorization": f"Bearer {service_role_key}",
        "apikey": service_role_key,
        "Content-Type": content_type or "application/octet-stream",
        "x-upsert": "true",
        "cache-control": "3600",
    }

    upload_request = Request(
        upload_url,
        data=uploaded_file.read(),
        headers=request_headers,
        method="POST",
    )

    try:
        with urlopen(upload_request, timeout=30) as upload_response:
            upload_response.read()
    except HTTPError as exc:
        error_body = exc.read().decode("utf-8", errors="ignore")
        try:
            parsed = json.loads(error_body)
            detail = parsed.get("message") or parsed.get("error") or error_body
        except json.JSONDecodeError:
            detail = error_body or exc.reason
        raise ValueError(f"Upload failed: {detail}") from exc
    except URLError as exc:
        raise ValueError("Upload failed. Please try again.") from exc

    if public_access:
        return (
            f"{supabase_url.rstrip('/')}/storage/v1/object/public/"
            f"{bucket}/{quote(object_path, safe='/')}"
        )
    return build_storage_reference(bucket, object_path)


def resolve_supabase_asset_url(
    value: str | None,
    *,
    bucket: str,
    public_access: bool,
    supabase_url: str,
    service_role_key: str,
    signed_url_ttl_seconds: int,
) -> str:
    normalized = (value or "").strip()
    if not normalized:
        return ""

    object_path = extract_storage_object_path(
        normalized,
        bucket=bucket,
        supabase_url=supabase_url,
    )
    if object_path is None:
        return normalized

    if public_access:
        return (
            f"{supabase_url.rstrip('/')}/storage/v1/object/public/"
            f"{bucket}/{quote(object_path, safe='/')}"
        )

    if not supabase_url or not service_role_key:
        raise StorageConfigurationError("Supabase storage is not configured.")

    sign_url = (
        f"{supabase_url.rstrip('/')}/storage/v1/object/sign/"
        f"{bucket}/{quote(object_path, safe='/')}"
    )
    payload = json.dumps({"expiresIn": signed_url_ttl_seconds}).encode("utf-8")
    request = Request(
        sign_url,
        data=payload,
        headers={
            "Authorization": f"Bearer {service_role_key}",
            "apikey": service_role_key,
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urlopen(request, timeout=20) as response:
            body = json.loads(response.read().decode("utf-8"))
    except HTTPError as exc:
        error_body = exc.read().decode("utf-8", errors="ignore")
        try:
            parsed = json.loads(error_body)
            detail = parsed.get("message") or parsed.get("error") or error_body
        except json.JSONDecodeError:
            detail = error_body or exc.reason
        raise ValueError(f"Unable to create secure file URL: {detail}") from exc
    except URLError as exc:
        raise ValueError("Unable to create secure file URL right now.") from exc

    signed_path = body.get("signedURL") or body.get("signedUrl") or ""
    if not signed_path:
        raise ValueError("Unable to create secure file URL right now.")

    if signed_path.startswith("http://") or signed_path.startswith("https://"):
        return signed_path
    return f"{supabase_url.rstrip('/')}{signed_path}"
