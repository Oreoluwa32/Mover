# Backend Guide

## Stack

- Django 5.1
- Django REST Framework
- djangorestframework-simplejwt
- Channels
- WhiteNoise
- psycopg 3
- dj-database-url

## Backend Folder Layout

```text
backend/
  apps/
    accounts/
    mobility/
    payments/
  config/
  static/
  templates/
  manage.py
  requirements.txt
```

## Django Apps

### `apps.accounts`

Responsible for:

- registration
- login
- token refresh
- email verification
- password reset
- account overview
- profile updates
- KYC
- vehicles
- live status helper endpoints

Key routes:

- `/api/auth/register/`
- `/api/auth/login/`
- `/api/auth/email-verification/request/`
- `/api/auth/email-verification/confirm/`
- `/api/auth/password/forgot/`
- `/api/auth/password/reset/`
- `/api/auth/refresh/`
- `/api/accounts/me/`
- `/api/accounts/profile/`
- `/api/accounts/kyc/`
- `/api/accounts/vehicles/`

### `apps.mobility`

Responsible for:

- travel plans
- ride requests
- delivery requests
- matches
- tracking sessions
- emergency alerts
- dashboard endpoints

Key routes:

- `/api/mobility/dashboard/`
- `/api/mobility/travel-plans/`
- `/api/mobility/ride-requests/`
- `/api/mobility/delivery-requests/`
- `/api/mobility/matches/`
- `/api/mobility/tracking-sessions/`
- `/api/mobility/emergency-alerts/`

### `apps.payments`

Responsible for:

- wallet access
- transactions
- funding account provisioning
- Monnify webhook integration
- bank lookup and withdrawal flows
- legacy compatibility routes

Key routes:

- `/api/payments/wallet/`
- `/api/payments/wallet/funding-account`
- `/api/payments/wallet/balance`
- `/api/payments/transactions`
- `/api/payments/initialize`
- `/api/payments/verify`
- `/api/payments/banks`
- `/api/payments/bank-accounts/`
- `/api/payments/withdrawal/initialize`
- `/api/payments/withdrawal/complete`
- `/api/payments/monnify/webhook`

## URL Composition

Top-level URL wiring:

- [config/urls.py](C:/Users/oreol/Documents/Projects/Movr/backend/config/urls.py)
- [config/api_urls.py](C:/Users/oreol/Documents/Projects/Movr/backend/config/api_urls.py)

The backend exposes both:

- `/api/...`
- `/api/v1/...`

There are also compatibility routes such as:

- `/wallet/`
- `/toggle-is-live/<uuid>/`
- `/api/v1/user/live-status`

## Settings and Runtime Behavior

The backend is intentionally stricter in production-like environments.

Production-like mode is triggered by:

- `RENDER`
- `KOYEB`
- or any `MOVR_ENV` not equal to `development`, `dev`, `local`, or `test`

In those environments the backend enforces:

- non-default secret key
- explicit allowed hosts
- exact CORS origins
- exact CSRF trusted origins
- SSL-safe database configuration

## Authentication

Authentication uses JWT with:

- access token lifetime: 8 hours
- refresh token lifetime: 14 days
- rotating refresh tokens enabled

Default auth class:

- `rest_framework_simplejwt.authentication.JWTAuthentication`

## Realtime

ASGI app:

- `config.asgi.application`

Channel layers:

- Redis-backed if `REDIS_URL` is provided
- in-memory fallback otherwise

## Static and Media

- `STATIC_ROOT = backend/staticfiles`
- `STATICFILES_DIRS = backend/static`
- `MEDIA_ROOT = backend/media`

Profile avatars are intended to use Supabase Storage rather than persistent local media in deployed environments.

## Email Delivery

Resend is used for:

- email verification
- password reset

Important settings:

- `RESEND_API_KEY`
- `RESEND_FROM_EMAIL`

## Storage

Supabase Storage is used for avatar uploads when configured.

Important settings:

- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `SUPABASE_STORAGE_BUCKET`
- `SUPABASE_STORAGE_AVATAR_PREFIX`

## Payments

Monnify is used for wallet funding account flows.

Important settings:

- `MONNIFY_API_KEY`
- `MONNIFY_SECRET_KEY`
- `MONNIFY_CONTRACT_CODE`
- `MONNIFY_BASE_URL`

Paystack-compatible routes also exist for payment checkout support.

## Local Backend Commands

```bash
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
python manage.py collectstatic --noinput
```
