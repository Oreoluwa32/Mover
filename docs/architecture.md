# Architecture

## High-Level Architecture

Movr consists of:

- a Flutter mobile client
- a Django backend with REST APIs
- realtime support via Channels
- external integrations for payments, storage, maps, and email

```text
Flutter App
  -> REST API (Django / DRF)
  -> Realtime / tracking flows (Channels)
  -> Third-party services through backend

Django Backend
  -> PostgreSQL / SQLite
  -> Redis / InMemory channel layer
  -> Supabase Storage
  -> Resend
  -> Monnify
  -> Paystack compatibility flows
```

## Repository Layout

### Mobile

- `lib/core/`: theme, routing helpers, shared utilities, config
- `lib/data/`: models and services
- `lib/presentation/`: screens, notifiers, UI flows
- `lib/widgets/`: shared widgets
- `assets/`: static UI assets, icons, images, animation resources

### Backend

- `backend/apps/accounts/`: authentication, profiles, KYC, vehicles
- `backend/apps/mobility/`: travel plans, matches, requests, tracking
- `backend/apps/payments/`: wallets, transactions, funding, gateways
- `backend/config/`: settings, URL composition, ASGI/WSGI, health middleware

## Main Domains

### Accounts

- registration
- login
- refresh token
- email verification
- forgot/reset password
- profile management
- avatar upload
- KYC record
- vehicle management

### Mobility

- travel plan creation
- ride and delivery request handling
- matching between routes and requests
- tracking sessions
- emergency alerts
- dashboard and derived task state

### Payments

- wallet balance and transactions
- funding account provisioning
- Monnify reserved account flow
- Monnify webhook handling
- Paystack compatibility endpoints
- withdrawal-related endpoints

## Mobile State Management

The app primarily uses Riverpod for screen-level and flow-level state.

Patterns in use:

- `StateNotifierProvider` for mutable screen state
- service classes in `lib/data/services/`
- route argument passing for cross-screen workflow transitions
- `PrefUtils` and secure storage for persistence

## Authentication Model

The backend uses JWT authentication with:

- access token
- refresh token
- token refresh endpoint

The mobile app persists session state and uses a route guard for protected navigation.

## Realtime and Background Sync

Realtime is supported through Django Channels. In production-like environments, Redis is the preferred channel layer backend. Local development can fall back to an in-memory layer.

The app also uses periodic refresh/polling in some screens to keep task and wallet state updated.

## UI Architecture

The presentation layer is organized by screen folder. Each major screen often contains:

- `models/`
- `notifier/`
- screen widget
- local reusable screen widgets

This gives the app a screen-oriented modular structure rather than a feature-package monolith.

## Integration Dependencies

- Google Maps and Places for map display and search
- Resend for email delivery
- Supabase Storage for avatar uploads
- Monnify for wallet funding account flows
- Paystack-compatible flows for payment checkout support

## Operational Design Notes

- `/health/` is used for platform health checks
- cloud deployments are validated more strictly than local dev
- database SSL enforcement is required in production-like environments
- connection retention is reduced in cloud runtime to avoid pooled DB exhaustion
