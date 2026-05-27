# Getting Started

## Overview

Movr is split into two main runtime pieces:

- Flutter mobile app in `lib/`
- Django backend in `backend/`

The mobile app talks to the backend over HTTP and WebSocket-style realtime flows. Several features also depend on third-party integrations such as Google Maps, Resend, Monnify, Paystack, Supabase Storage, and Redis.

## Prerequisites

### Mobile

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android emulator or physical device
- Google Maps API key
- Google Places API key

### Backend

- Python 3.12
- PostgreSQL for production-like environments
- SQLite for quick local fallback
- Redis optional locally, recommended for production

## Repository Structure

```text
Movr/
  assets/
  backend/
  lib/
  test/
  docs/
  pubspec.yaml
  .env.example
```

## Environment Variables

The project keeps a shared example config at:

- [`.env.example`](../.env.example)

Important variables include:

### Django/backend

- `DJANGO_DEBUG`
- `DJANGO_SECRET_KEY`
- `DJANGO_ALLOWED_HOSTS`
- `MOVR_ENV`
- `DATABASE_URL`
- `DATABASE_CONN_MAX_AGE`
- `CORS_ALLOWED_ORIGINS`
- `CSRF_TRUSTED_ORIGINS`
- `REDIS_URL`

### Email and auth

- `RESEND_API_KEY`
- `RESEND_FROM_EMAIL`
- `MOVR_PASSWORD_RESET_DEEP_LINK_BASE`
- `MOVR_EMAIL_VERIFICATION_CODE_TTL_MINUTES`

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
- `PAYSTACK_PUBLIC_KEY`

### Flutter build-time config

- `MOVR_API_BASE_URL`
- `MOVR_WS_BASE_URL`
- `MOVR_ENVIRONMENT`
- `GOOGLE_MAPS_API_KEY`
- `GOOGLE_PLACES_API_KEY`

## Backend Local Setup

From the project root:

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

Alternative ASGI run:

```bash
daphne -b 0.0.0.0 -p 8000 config.asgi:application
```

## Flutter Local Setup

From the project root:

```bash
flutter pub get
```

Run with build-time config:

```bash
flutter run --dart-define=MOVR_API_BASE_URL=http://10.0.2.2:8000 --dart-define=MOVR_WS_BASE_URL=ws://10.0.2.2:8000 --dart-define=MOVR_ENVIRONMENT=development --dart-define=GOOGLE_MAPS_API_KEY=your_key --dart-define=GOOGLE_PLACES_API_KEY=your_key
```

If using a physical device, replace `10.0.2.2` with the host machine IP reachable by the phone.

## Common Commands

### Flutter

```bash
flutter analyze
flutter test
dart format lib test
```

### Django

```bash
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py collectstatic --noinput
```

## Local Workflow Suggestion

1. Start backend
2. Start Flutter app with correct `dart-define` values
3. Sign in or create an account
4. Verify email flows locally if Resend is configured
5. Test routing, wallet, notifications, and profile updates

## Notes

- Free-tier cloud platforms may cold start and make the app feel slow on first request.
- Profile picture upload depends on Supabase Storage when configured in deployed environments.
- Wallet funding uses Monnify integration paths and should be tested with sandbox-compatible flows.
