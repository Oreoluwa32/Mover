from __future__ import annotations

from urllib.parse import parse_qs

from channels.db import database_sync_to_async
from django.contrib.auth.models import AnonymousUser
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
from rest_framework_simplejwt.tokens import AccessToken

from apps.accounts.models import User


@database_sync_to_async
def _get_user(user_id: int):
    try:
        return User.objects.get(id=user_id)
    except User.DoesNotExist:
        return AnonymousUser()


class QueryStringJWTAuthMiddleware:
    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        scope["user"] = AnonymousUser()
        raw_query = scope.get("query_string", b"").decode()
        query_params = parse_qs(raw_query)
        token = query_params.get("token", [None])[0]

        if token:
            try:
                validated = AccessToken(token)
                scope["user"] = await _get_user(validated["user_id"])
            except (InvalidToken, TokenError, KeyError):
                scope["user"] = AnonymousUser()

        return await self.app(scope, receive, send)
