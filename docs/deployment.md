# Deployment Guide

## Recommended Services

Current project integrations are well suited to a stack like:

- Render for backend hosting
- Supabase for PostgreSQL and Storage
- Upstash Redis for Channels in production
- Resend for email delivery
- Monnify for wallet funding flows

## Runtime Type

The Django backend treats these as production-like:

- Render
- Koyeb
- any non-local `MOVR_ENV`

This means stricter startup validation is enforced automatically.

## Required Backend Environment Variables

### Core

- `DJANGO_SECRET_KEY`
- `DJANGO_DEBUG=false`
- `DJANGO_ALLOWED_HOSTS`
- `MOVR_ENV`
- `DATABASE_URL`
- `CORS_ALLOWED_ORIGINS`
- `CSRF_TRUSTED_ORIGINS`

### Database and Realtime

- `DATABASE_CONN_MAX_AGE`
- `REDIS_URL`

### Email

- `RESEND_API_KEY`
- `RESEND_FROM_EMAIL`
- `MOVR_PASSWORD_RESET_DEEP_LINK_BASE`

### Storage

- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `SUPABASE_STORAGE_BUCKET`
- `SUPABASE_STORAGE_AVATAR_PREFIX`

### Payments

- `MONNIFY_API_KEY`
- `MONNIFY_SECRET_KEY`
- `MONNIFY_CONTRACT_CODE`
- `MONNIFY_BASE_URL`

## Render Notes

### Start command

Example:

```bash
python manage.py migrate && daphne -b 0.0.0.0 -p $PORT config.asgi:application
```

### Build command

Example:

```bash
pip install -r backend/requirements.txt && cd backend && python manage.py collectstatic --noinput
```

Adjust for the actual Render root directory layout you choose.

### Health check

- path: `/health/`

Render will continuously probe this route, so seeing it in logs is normal.

### Connection pooling

If using Supabase pooler URLs, keep DB connection retention conservative:

- `WEB_CONCURRENCY=1`
- `DATABASE_CONN_MAX_AGE=0`

This helps avoid hitting pooled connection limits.

## Supabase Notes

### Database

- use the pooled PostgreSQL URL
- require SSL
- avoid unsafe `sslmode` values

### Storage

For avatar uploads:

- create the bucket configured in `SUPABASE_STORAGE_BUCKET`
- ensure the bucket/public URL approach matches how avatars are consumed

## Resend Notes

- `RESEND_FROM_EMAIL` must belong to a verified sender/domain in Resend
- for test-only flows, Resend's restricted onboarding sender may work with limitations

## Monnify Notes

- configure your webhook to point to `/api/payments/monnify/webhook`
- test reserved-account flows with sandbox-compatible methods

## Flutter Deployment Inputs

The mobile app uses `dart-define` values for runtime configuration.

Examples:

- `MOVR_API_BASE_URL`
- `MOVR_WS_BASE_URL`
- `MOVR_ENVIRONMENT`
- `GOOGLE_MAPS_API_KEY`
- `GOOGLE_PLACES_API_KEY`
- `PAYSTACK_PUBLIC_KEY`

## Security Checklist

- do not commit real secrets
- keep `DJANGO_DEBUG=false` outside local development
- do not use wildcard hosts/origins in production
- use TLS-backed database and Redis URLs
- verify email sender domains before production auth rollout
