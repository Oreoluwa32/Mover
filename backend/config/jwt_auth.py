from __future__ import annotations

from urllib.parse import parse_qs

from channels.db import database_sync_to_async
from django.contrib.auth.models import AnonymousUser
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
from rest_framework_simplejwt.tokens import AccessToken

from apps.accounts.models import User

# Subprotocol the Flutter client offers alongside the raw JWT:
#   Sec-WebSocket-Protocol: movr.jwt, <token>
JWT_SUBPROTOCOL = "movr.jwt"


@database_sync_to_async
def _get_user(user_id: int):
    try:
        return User.objects.get(id=user_id)
    except User.DoesNotExist:
        return AnonymousUser()


def _token_from_subprotocols(scope) -> str | None:
    subprotocols = scope.get("subprotocols") or []
    if len(subprotocols) >= 2 and subprotocols[0] == JWT_SUBPROTOCOL:
        return subprotocols[1] or None
    return None


def _token_from_query_string(scope) -> str | None:
    raw_query = scope.get("query_string", b"").decode()
    return parse_qs(raw_query).get("token", [None])[0]


class QueryStringJWTAuthMiddleware:
    """Authenticates WebSocket connections via JWT.

    Tokens are read from the ``Sec-WebSocket-Protocol`` subprotocol
    header (preferred) and fall back to the ``?token=`` query string for
    backward compatibility with older clients. The query-string path is
    deprecated; remove it once all clients ship the subprotocol-based
    connection.
    """

    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        scope["user"] = AnonymousUser()
        token = _token_from_subprotocols(scope) or _token_from_query_string(scope)

        if token:
            try:
                validated = AccessToken(token)
                scope["user"] = await _get_user(validated["user_id"])
            except (InvalidToken, TokenError, KeyError):
                scope["user"] = AnonymousUser()

        return await self.app(scope, receive, send)
