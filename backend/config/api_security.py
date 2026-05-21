from __future__ import annotations

import re
import unicodedata
from collections.abc import Mapping

from django.http import QueryDict
from rest_framework.parsers import DataAndFiles, FormParser, JSONParser, MultiPartParser
from rest_framework.renderers import JSONRenderer
from rest_framework.throttling import AnonRateThrottle, ScopedRateThrottle, UserRateThrottle


_DISALLOWED_CONTROL_CHARS = re.compile(r"[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]")


def sanitize_string(value: str, *, trim: bool = True) -> str:
    normalized = unicodedata.normalize("NFKC", value)
    normalized = _DISALLOWED_CONTROL_CHARS.sub("", normalized)
    return normalized.strip() if trim else normalized


def sanitize_payload(value):
    if isinstance(value, str):
        return sanitize_string(value)
    if isinstance(value, QueryDict):
        sanitized = QueryDict("", mutable=True)
        for key, values in value.lists():
            sanitized.setlist(
                sanitize_string(key),
                [
                    sanitize_string(item) if isinstance(item, str) else item
                    for item in values
                ],
            )
        sanitized._mutable = False
        return sanitized
    if isinstance(value, Mapping):
        return {
            sanitize_string(str(key)): sanitize_payload(item)
            for key, item in value.items()
        }
    if isinstance(value, list):
        return [sanitize_payload(item) for item in value]
    if isinstance(value, tuple):
        return tuple(sanitize_payload(item) for item in value)
    return value


class SanitizedJSONParser(JSONParser):
    def parse(self, stream, media_type=None, parser_context=None):
        parsed = super().parse(stream, media_type=media_type, parser_context=parser_context)
        return sanitize_payload(parsed)


class SanitizedFormParser(FormParser):
    def parse(self, stream, media_type=None, parser_context=None):
        parsed = super().parse(stream, media_type=media_type, parser_context=parser_context)
        return sanitize_payload(parsed)


class SanitizedMultiPartParser(MultiPartParser):
    def parse(self, stream, media_type=None, parser_context=None):
        parsed = super().parse(stream, media_type=media_type, parser_context=parser_context)
        return DataAndFiles(
            sanitize_payload(parsed.data),
            parsed.files,
        )


class SanitizedJSONRenderer(JSONRenderer):
    def render(self, data, accepted_media_type=None, renderer_context=None):
        return super().render(
            sanitize_payload(data),
            accepted_media_type=accepted_media_type,
            renderer_context=renderer_context,
        )


class MovrAnonRateThrottle(AnonRateThrottle):
    scope = "anon"


class MovrUserRateThrottle(UserRateThrottle):
    scope = "user"


class MovrScopedRateThrottle(ScopedRateThrottle):
    pass
