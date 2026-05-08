# API Overview

## Base Grouping

The backend groups routes under:

- `/api/auth/`
- `/api/accounts/`
- `/api/mobility/`
- `/api/payments/`

Compatibility prefixes also exist under `/api/v1/` for some flows.

## Health and Admin

- `GET /health/`
- `GET /admin/`

## Auth Endpoints

- `POST /api/auth/register/`
- `POST /api/auth/login/`
- `POST /api/auth/email-verification/request/`
- `POST /api/auth/email-verification/confirm/`
- `POST /api/auth/password/forgot/`
- `POST /api/auth/password/reset/`
- `POST /api/auth/refresh/`

## Account Endpoints

- `GET /api/accounts/me/`
- `GET /api/accounts/profile/`
- `PUT /api/accounts/profile/`
- `GET /api/accounts/kyc/`
- `PUT /api/accounts/kyc/`
- `GET /api/accounts/vehicles/`
- `POST /api/accounts/vehicles/`
- `PATCH /api/accounts/vehicles/<id>/`
- `GET /api/accounts/user/live-status`

Compatibility:

- `GET /api/v1/user/live-status`

## Mobility Endpoints

- `GET /api/mobility/dashboard/`
- `GET/POST /api/mobility/travel-plans/`
- `GET/POST /api/mobility/ride-requests/`
- `GET/POST /api/mobility/delivery-requests/`
- `GET/POST /api/mobility/matches/`
- `GET/POST /api/mobility/tracking-sessions/`
- `GET/POST /api/mobility/emergency-alerts/`

## Payment Endpoints

- `GET /api/payments/wallet/`
- `GET/POST /api/payments/wallet/funding-account`
- `GET /api/payments/wallet/balance`
- `GET /api/payments/transactions`
- `POST /api/payments/initialize`
- `POST /api/payments/verify`
- `GET /api/payments/banks`
- `GET /api/payments/bank-accounts/`
- `POST /api/payments/withdrawal/initialize`
- `POST /api/payments/withdrawal/complete`
- `GET /api/payments/checkout/<reference>/`
- `POST /api/payments/monnify/webhook`

## Legacy Compatibility Routes

- `GET /wallet/`
- `POST /toggle-is-live/<uuid:travel_plan_id>/`
- `POST /api/paystack/initialize-transaction`
- `GET /api/paystack/verify-transaction/<reference>`
- `POST /api/v1/merchant/transactions/init-transaction`
- `GET /api/v1/merchant/transactions/verify/<reference>`

## Authentication Behavior

The API defaults to authenticated access except where views explicitly allow public access.

Public examples:

- register
- login
- email verification
- forgot password
- reset password
- token refresh

## Response Notes

- The mobile client expects some compatibility payload shapes from legacy routes.
- Numeric values may sometimes arrive as strings from backend serializers or integrations, so parsers on the mobile side should be tolerant where appropriate.
- Error details are important for the mobile client and should be preserved whenever possible.

## Realtime Notes

Some task, tracking, and live-location features rely on ASGI/Channels behavior in addition to plain REST endpoints.
