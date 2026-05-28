from __future__ import annotations

import os
from datetime import timedelta
from pathlib import Path
from urllib.parse import parse_qs, urlparse

import dj_database_url
from django.core.exceptions import ImproperlyConfigured

BASE_DIR = Path(__file__).resolve().parent.parent


def _bool_env(name: str, default: bool = False) -> bool:
    raw = os.getenv(name)
    if raw is None:
        return default
    return raw.strip().lower() in {"1", "true", "yes", "on"}


def _split_env(name: str, default: str = "") -> list[str]:
    raw = os.getenv(name, default)
    return [item.strip() for item in raw.split(",") if item.strip()]


def _int_env(name: str, default: int) -> int:
    raw = os.getenv(name)
    if raw is None:
        return default
    try:
        return int(raw.strip())
    except ValueError as exc:
        raise ImproperlyConfigured(f"{name} must be an integer.") from exc


DEV_SECRET_KEY = "movr-dev-secret-key"
SECRET_KEY = os.getenv("DJANGO_SECRET_KEY", DEV_SECRET_KEY)
DEBUG = _bool_env("DJANGO_DEBUG", default=False)
MOVR_ENV = os.getenv("MOVR_ENV", "development")
IS_CLOUD_RUNTIME = _bool_env("RENDER") or _bool_env("KOYEB")
IS_PRODUCTION_LIKE = IS_CLOUD_RUNTIME or MOVR_ENV.lower() not in {
    "development",
    "dev",
    "local",
    "test",
}

LOCAL_ALLOWED_HOSTS = "127.0.0.1,localhost,0.0.0.0,10.0.2.2"
LOCAL_FRONTEND_ORIGINS = "http://localhost:3000,http://localhost:8080"

ALLOWED_HOSTS = _split_env(
    "DJANGO_ALLOWED_HOSTS",
    "" if IS_PRODUCTION_LIKE else LOCAL_ALLOWED_HOSTS,
)
RENDER_EXTERNAL_HOSTNAME = os.getenv("RENDER_EXTERNAL_HOSTNAME")
if RENDER_EXTERNAL_HOSTNAME and RENDER_EXTERNAL_HOSTNAME not in ALLOWED_HOSTS:
    ALLOWED_HOSTS.append(RENDER_EXTERNAL_HOSTNAME)

CORS_ALLOWED_ORIGINS = _split_env(
    "CORS_ALLOWED_ORIGINS",
    "" if IS_PRODUCTION_LIKE else LOCAL_FRONTEND_ORIGINS,
)
CSRF_TRUSTED_ORIGINS = _split_env(
    "CSRF_TRUSTED_ORIGINS",
    "" if IS_PRODUCTION_LIKE else LOCAL_FRONTEND_ORIGINS,
)

if DEBUG and "*" not in ALLOWED_HOSTS:
    ALLOWED_HOSTS.append("*")

if IS_PRODUCTION_LIKE:
    if DEBUG:
        raise ImproperlyConfigured(
            "DJANGO_DEBUG must be false outside local development."
        )
    if SECRET_KEY in {
        "",
        DEV_SECRET_KEY,
        "change-this-to-a-random-string-in-production",
    }:
        raise ImproperlyConfigured(
            "Set a unique DJANGO_SECRET_KEY before deploying Movr."
        )
    if not ALLOWED_HOSTS:
        raise ImproperlyConfigured(
            "DJANGO_ALLOWED_HOSTS is required outside local development."
        )
    if "*" in ALLOWED_HOSTS:
        raise ImproperlyConfigured(
            "DJANGO_ALLOWED_HOSTS must not contain '*' outside local development."
        )
    if "*" in CORS_ALLOWED_ORIGINS:
        raise ImproperlyConfigured(
            "CORS_ALLOWED_ORIGINS must list exact origins outside local development."
        )
    if "*" in CSRF_TRUSTED_ORIGINS:
        raise ImproperlyConfigured(
            "CSRF_TRUSTED_ORIGINS must list exact origins outside local development."
        )

INSTALLED_APPS = [
    "daphne",
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "django.contrib.humanize",
    "corsheaders",
    "rest_framework",
    "rest_framework.authtoken",
    "rest_framework_simplejwt.token_blacklist",
    "channels",
    "apps.accounts",
    "apps.mobility",
    "apps.payments",
    "apps.dashboard",
]

MIDDLEWARE = [
    "config.health.HealthCheckMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "config.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "config.wsgi.application"
ASGI_APPLICATION = "config.asgi.application"

DATABASE_URL = os.getenv("DATABASE_URL", "")
DATABASE_SSL_REQUIRE = IS_PRODUCTION_LIKE and bool(DATABASE_URL)
DATABASE_CONN_MAX_AGE = _int_env(
    "DATABASE_CONN_MAX_AGE",
    0 if IS_PRODUCTION_LIKE else 600,
)

if IS_PRODUCTION_LIKE and not DATABASE_URL:
    raise ImproperlyConfigured("DATABASE_URL is required outside local development.")

if DATABASE_URL:
    parsed_database_url = urlparse(DATABASE_URL)
    if parsed_database_url.scheme.startswith("postgres"):
        sslmode = parse_qs(parsed_database_url.query).get("sslmode", [""])[0].lower()
        if sslmode in {"disable", "allow", "prefer"}:
            raise ImproperlyConfigured(
                "DATABASE_URL must require SSL. Use sslmode=require, verify-ca, or verify-full."
            )

DATABASES = {
    "default": dj_database_url.config(
        default=f"sqlite:///{BASE_DIR / 'db.sqlite3'}",
        conn_max_age=DATABASE_CONN_MAX_AGE,
        ssl_require=DATABASE_SSL_REQUIRE,
    )
}
DATABASES["default"]["CONN_HEALTH_CHECKS"] = DATABASE_CONN_MAX_AGE > 0

AUTH_USER_MODEL = "accounts.User"

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"
    },
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

LANGUAGE_CODE = "en-us"
TIME_ZONE = os.getenv("DJANGO_TIME_ZONE", "Africa/Lagos")
USE_I18N = True
USE_TZ = True

STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "staticfiles"
STATICFILES_DIRS = [BASE_DIR / "static"]
MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "media"
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
    "DEFAULT_PERMISSION_CLASSES": ("rest_framework.permissions.IsAuthenticated",),
    "DEFAULT_PARSER_CLASSES": (
        "config.api_security.SanitizedJSONParser",
        "config.api_security.SanitizedFormParser",
        "config.api_security.SanitizedMultiPartParser",
    ),
    "DEFAULT_RENDERER_CLASSES": ("config.api_security.SanitizedJSONRenderer",),
    "DEFAULT_THROTTLE_CLASSES": (
        "config.api_security.MovrAnonRateThrottle",
        "config.api_security.MovrUserRateThrottle",
        "config.api_security.MovrScopedRateThrottle",
    ),
    "DEFAULT_THROTTLE_RATES": {
        "anon": os.getenv("API_THROTTLE_ANON_RATE", "30/minute"),
        "user": os.getenv("API_THROTTLE_USER_RATE", "120/minute"),
        "auth": os.getenv("API_THROTTLE_AUTH_RATE", "10/minute"),
        "email_verification": os.getenv(
            "API_THROTTLE_EMAIL_VERIFICATION_RATE",
            "6/hour",
        ),
        "password_reset": os.getenv(
            "API_THROTTLE_PASSWORD_RESET_RATE",
            "5/hour",
        ),
        "payments": os.getenv("API_THROTTLE_PAYMENTS_RATE", "30/minute"),
    },
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 20,
}

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(
        minutes=int(os.getenv("JWT_ACCESS_LIFETIME_MIN", "30"))
    ),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=14),
    "ROTATE_REFRESH_TOKENS": True,
    "BLACKLIST_AFTER_ROTATION": True,
    "AUTH_HEADER_TYPES": ("Bearer",),
}

REDIS_URL = os.getenv("REDIS_URL", "")
if REDIS_URL:
    CHANNEL_LAYERS = {
        "default": {
            "BACKEND": "channels_redis.core.RedisChannelLayer",
            "CONFIG": {
                "hosts": [REDIS_URL],
            },
        }
    }
else:
    CHANNEL_LAYERS = {
        "default": {
            "BACKEND": "channels.layers.InMemoryChannelLayer",
        }
    }

SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")
SESSION_COOKIE_SECURE = not DEBUG
CSRF_COOKIE_SECURE = not DEBUG
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = "DENY"

if IS_PRODUCTION_LIKE:
    SECURE_SSL_REDIRECT = True
    # Start with a short HSTS window when first enabling, then ratchet up.
    SECURE_HSTS_SECONDS = int(os.getenv("DJANGO_SECURE_HSTS_SECONDS", "31536000"))
    SECURE_HSTS_INCLUDE_SUBDOMAINS = True
    SECURE_HSTS_PRELOAD = True

MOVR_FRONTEND_BASE_URL = os.getenv("MOVR_FRONTEND_BASE_URL", "https://movr.app")
MOVR_DEFAULT_CURRENCY = os.getenv("MOVR_DEFAULT_CURRENCY", "NGN")
MOVR_PASSWORD_RESET_DEEP_LINK_BASE = os.getenv(
    "MOVR_PASSWORD_RESET_DEEP_LINK_BASE",
    "movr://reset-password",
)
MOVR_EMAIL_VERIFICATION_CODE_TTL_MINUTES = _int_env(
    "MOVR_EMAIL_VERIFICATION_CODE_TTL_MINUTES",
    15,
)
RESEND_API_KEY = os.getenv("RESEND_API_KEY", "")
RESEND_FROM_EMAIL = os.getenv("RESEND_FROM_EMAIL", "")
MONNIFY_API_KEY = os.getenv("MONNIFY_API_KEY", "")
MONNIFY_SECRET_KEY = os.getenv("MONNIFY_SECRET_KEY", "")
MONNIFY_CONTRACT_CODE = os.getenv("MONNIFY_CONTRACT_CODE", "")
MONNIFY_BASE_URL = os.getenv(
    "MONNIFY_BASE_URL",
    "https://api.monnify.com" if IS_PRODUCTION_LIKE else "https://sandbox.monnify.com",
)
# Browser-restricted Google Maps JS key used by the admin Live Tracking map.
# If empty, Live Tracking degrades gracefully to a list-only view.
GOOGLE_MAPS_BROWSER_KEY = os.getenv("GOOGLE_MAPS_BROWSER_KEY", "")
SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_SERVICE_ROLE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "")
SUPABASE_STORAGE_BUCKET = os.getenv("SUPABASE_STORAGE_BUCKET", "avatars")
SUPABASE_AVATAR_BUCKET = os.getenv(
    "SUPABASE_AVATAR_BUCKET",
    SUPABASE_STORAGE_BUCKET,
)
SUPABASE_STORAGE_AVATAR_PREFIX = os.getenv(
    "SUPABASE_STORAGE_AVATAR_PREFIX",
    "profile-avatars",
)
SUPABASE_STORAGE_AVATAR_PUBLIC = _bool_env(
    "SUPABASE_STORAGE_AVATAR_PUBLIC",
    True,
)
SUPABASE_STORAGE_VEHICLE_PREFIX = os.getenv(
    "SUPABASE_STORAGE_VEHICLE_PREFIX",
    "vehicle-documents",
)
SUPABASE_VEHICLE_BUCKET = os.getenv(
    "SUPABASE_VEHICLE_BUCKET",
    SUPABASE_STORAGE_BUCKET,
)
SUPABASE_STORAGE_VEHICLE_PUBLIC = _bool_env(
    "SUPABASE_STORAGE_VEHICLE_PUBLIC",
    False,
)
SUPABASE_STORAGE_SIGNED_URL_TTL_SECONDS = _int_env(
    "SUPABASE_STORAGE_SIGNED_URL_TTL_SECONDS",
    3600,
)

if IS_PRODUCTION_LIKE and SUPABASE_STORAGE_VEHICLE_PUBLIC:
    raise ImproperlyConfigured(
        "SUPABASE_STORAGE_VEHICLE_PUBLIC must be false outside local development."
    )

if (
    IS_PRODUCTION_LIKE
    and SUPABASE_STORAGE_AVATAR_PUBLIC
    and SUPABASE_VEHICLE_BUCKET == SUPABASE_AVATAR_BUCKET
):
    raise ImproperlyConfigured(
        "Vehicle documents must not share the public avatar bucket outside local development."
    )
