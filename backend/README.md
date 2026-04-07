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
