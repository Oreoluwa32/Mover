# Operations Guide

## Health Checks

The backend exposes:

- `GET /health/`

Expected response:

```json
{"status":"ok","service":"movr-backend"}
```

On Render and similar hosts, this endpoint will appear repeatedly in logs. That is expected platform behavior.

## Admin

Django admin is exposed at:

- `/admin/`

Branding:

- site header: `Movr Control Center`
- site title: `Movr Admin`
- index title: `Operations dashboard`

Use admin for:

- account inspection
- profile/KYC review
- general backend data verification

## Common Operational Areas

### Authentication

Watch for:

- invalid/expired tokens
- unverified-email login loops
- password reset delivery issues

### Storage

Watch for:

- avatar upload failures
- missing Supabase env vars
- bucket misconfiguration
- MIME/content-type validation mismatches

### Payments

Watch for:

- funding account provisioning failures
- webhook delivery failures
- wallet balance reconciliation mismatches

### Realtime

Watch for:

- live toggle errors
- tracking session drift
- Redis absence in production-like workloads

## Common Troubleshooting

### Admin page is unstyled

Likely cause:

- static files were not collected or served properly

### `Invalid HTTP_HOST header`

Likely cause:

- deployment hostname or internal host IP not allowed in `DJANGO_ALLOWED_HOSTS`

### Repeated `/health/` log entries

Likely cause:

- host health checks

This is normal unless paired with non-200 responses.

### Supabase pooled DB connection exhaustion

Likely cause:

- too many persistent DB connections for session pool limits

Mitigations:

- reduce concurrency
- reduce DB connection max age
- avoid overlapping services consuming the same pool unnecessarily

### Resend email failures

Likely cause:

- missing API key
- unverified sender/domain
- using placeholder `yourdomain.com`

### Profile image upload 400/503

Likely cause:

- invalid image validation
- Supabase storage not configured
- bucket missing or inaccessible

## Suggested Runbook

When a user-facing feature breaks:

1. reproduce the error in the app
2. inspect backend logs around the timestamp
3. check env configuration for the affected integration
4. verify the API response payload shape
5. confirm the mobile client parser still matches it

## Maintenance Suggestions

- keep `.env.example` updated whenever new runtime variables are added
- add migration notes when schema changes affect deployment
- expand API docs when endpoint behavior changes
- document gateway-specific sandbox behaviors early to reduce confusion
