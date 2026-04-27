# Movr Backend

This directory contains the new Django backend for Movr. It is designed for:

- PostgreSQL-backed cloud deployment
- environment separation for testing and production
- REST APIs for mobile clients
- WebSocket support for live trip tracking and status updates

## Recommended MVP cloud stack

- App hosting: Koyeb web service
- PostgreSQL: Supabase project
- Redis for production WebSockets: Upstash Redis

This combination is practical for an MVP because Supabase currently offers a free PostgreSQL project tier and Koyeb currently offers a free web-service tier. For true always-on staging and production at the same time, current free tiers are tight, so the codebase supports both environments cleanly even if you start by keeping only one environment live.

## Required environment variables

Set these on your cloud host:

- `DJANGO_SECRET_KEY`
- `DJANGO_DEBUG`
- `DJANGO_ALLOWED_HOSTS`
- `DATABASE_URL`
- `CORS_ALLOWED_ORIGINS`
- `CSRF_TRUSTED_ORIGINS`
- `MOVR_ENV`
- `MOVR_FRONTEND_BASE_URL`
- `REDIS_URL` optional, recommended in production for Channels

Production-like environments include Render, Koyeb, and any `MOVR_ENV` value
other than `development`, `dev`, `local`, or `test`. In those environments the
backend intentionally fails to start if security-critical settings are missing
or unsafe.

## Render and Supabase security

Use Render environment variables for all secrets. Do not commit real values to
the repository or paste them into build commands.

Recommended Render values for a test backend:

```text
DJANGO_DEBUG=false
DJANGO_SECRET_KEY=<unique random key>
DJANGO_ALLOWED_HOSTS=<your-service>.onrender.com
MOVR_ENV=render-test
DATABASE_URL=<supabase session pooler url with sslmode=require>
REDIS_URL=<upstash rediss:// url>
MOVR_FRONTEND_BASE_URL=https://<your-service>.onrender.com
CORS_ALLOWED_ORIGINS=http://localhost:3000,https://<your-frontend-domain>
CSRF_TRUSTED_ORIGINS=http://localhost:3000,https://<your-frontend-domain>
```

For Supabase, prefer the Session Pooler connection string for Render because it
supports IPv4 and IPv6. The URL should use TLS, for example:

```text
postgresql://postgres.<project-ref>:<password>@aws-0-<region>.pooler.supabase.com:5432/postgres?sslmode=require
```

For stronger certificate verification, enable SSL enforcement in Supabase and
use `sslmode=verify-full` with the Supabase CA certificate. For quick Render
testing, `sslmode=require` plus Supabase SSL enforcement is a practical baseline.

Do not use these in deployed environments:

- SQLite fallback
- `DJANGO_DEBUG=true`
- `DJANGO_ALLOWED_HOSTS=*`
- `CORS_ALLOWED_ORIGINS=*`
- `CSRF_TRUSTED_ORIGINS=*`
- `sslmode=disable`, `sslmode=allow`, or `sslmode=prefer`

## Main API groups

- `/api/auth/*`
- `/api/accounts/*`
- `/api/mobility/*`
- `/api/payments/*`

Compatibility routes for the current Flutter app are also exposed:

- `/wallet/`
- `/toggle-is-live/<uuid>/`
- `/api/v1/user/live-status`
- `/api/paystack/initialize-transaction`
- `/api/paystack/verify-transaction/<reference>`
- `/api/v1/merchant/transactions/init-transaction`
- `/api/v1/merchant/transactions/verify/<reference>`

## Local run

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
daphne -b 0.0.0.0 -p 8000 config.asgi:application
```

## Notes

- Wallet and payment flows are gateway-ready, but the current implementation uses a safe mock checkout flow so the mobile app can work before real Paystack or Monnify credentials are wired in.
- Switch to real gateways by replacing the service methods in `apps/payments/views.py`.
