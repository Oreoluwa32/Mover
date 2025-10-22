# Paystack Integration - Quick Start Guide

## TL;DR - 5 Minute Overview

You're migrating from **Monnify** to **Paystack** for payment processing. Here's what you need to know:

### What Changed?

| Component | Before (Monnify) | After (Paystack) |
|-----------|------------------|-----------------|
| Backend Config | `MONNIFY_API_KEY`, `MONNIFY_SECRET_KEY`, `MONNIFY_CONTRACT_CODE` | `PAYSTACK_PUBLIC_KEY`, `PAYSTACK_SECRET_KEY` |
| Payment Service | `app/utils/payments.py` | `app/utils/paystack.py` ✅ NEW |
| Payment Routes | None | `app/api/routes/payments.py` ✅ NEW |
| Webhooks | None | `app/api/routes/webhooks.py` ✅ NEW |
| Flutter | Partial Paystack | Full implementation ready |
| Model | `monnify_reference`, `monnify_payment_reference` | `paystack_reference`, `paystack_access_code` |

---

## Implementation Status

### ✅ Backend (Completed)

- [x] Update `config.py` - Paystack credentials
- [x] Create `app/utils/paystack.py` - Full payment service
- [x] Create `app/api/routes/payments.py` - Payment API endpoints
- [x] Create `app/api/routes/webhooks.py` - Webhook handlers
- [x] Update `Payment` model - Paystack fields
- [x] Update `.env` files - New credentials
- [x] Update `main.py` - Register new routes
- [x] Update documentation files

### ⏳ Flutter (Ready for Implementation)

- [x] Plan & Architecture
- [x] Implementation guide created
- [ ] Add flutter_paystack package
- [ ] Create Paystack constants
- [ ] Create API service
- [ ] Create Riverpod notifiers
- [ ] Update Deposit screen
- [ ] Update Select Plan screen
- [ ] Add Wallet display screens
- [ ] Test end-to-end

---

## Backend API Endpoints

### Wallet Operations

```
GET  /api/v1/payments/wallet/balance
     → Get current wallet balance
     
GET  /api/v1/payments/transactions
     → Get transaction history
     
GET  /api/v1/payments/banks
     → Get list of supported banks
```

### Payment Operations

```
POST /api/v1/payments/initialize
     → Initialize payment
     Request: {amount, description, related_type}
     Response: {authorization_url, reference, access_code}
     
POST /api/v1/payments/verify
     → Verify payment after completion
     Request: {reference}
     Response: {status, new_balance}
```

### Withdrawal Operations

```
POST /api/v1/payments/withdrawal/initialize
     → Start withdrawal process
     Request: {amount, account_number, bank_code, account_name}
     Response: {withdrawal_id, reference}
     
POST /api/v1/payments/withdrawal/complete
     → Complete withdrawal transfer
     Request: {reference}
     Response: {status, new_balance}
```

### Webhooks

```
POST /api/v1/webhooks/paystack
     → Paystack payment notifications
     Events: charge.success, charge.failed, transfer.success, transfer.failed
```

---

## Environment Variables

### Backend (.env)

```bash
# Remove these:
# MONNIFY_API_KEY=...
# MONNIFY_SECRET_KEY=...
# MONNIFY_CONTRACT_CODE=...

# Add these:
PAYSTACK_PUBLIC_KEY=pk_test_xxxxx  # or pk_live_xxxxx in production
PAYSTACK_SECRET_KEY=sk_test_xxxxx  # or sk_live_xxxxx in production
```

### Flutter

```dart
const String PAYSTACK_PUBLIC_KEY = 'pk_test_xxxxx';
const String API_BASE_URL = 'https://your-backend-url/api/v1';
```

---

## Next Steps

### Phase 1: Verify Backend (NOW)

1. ✅ Code has been updated
2. Add Paystack credentials to `.env`
3. Start backend: `python manage.py runserver`
4. Test endpoints using Postman/Insomnia

### Phase 2: Implement Flutter (NEXT)

1. Add `flutter_paystack` package
2. Follow `PAYSTACK_FLUTTER_IMPLEMENTATION.md`
3. Create API service & state management
4. Update deposit and plan screens
5. Test payment flow

### Phase 3: Deploy to Production

1. Update to LIVE Paystack keys
2. Configure webhook URL in Paystack dashboard
3. Test in staging environment
4. Deploy to production
5. Monitor transactions

---

## Testing Paystack Payments

### Test Card Details

```
Card Number: 4111111111111111
Expiry: 12/25
CVV: 123
OTP: 123456
```

### Test Payment Flow

1. Initialize payment through API
2. User clicks payment link
3. Enter test card details
4. Complete OTP verification
5. Webhook confirms payment
6. Wallet balance updates

---

## Key Features Implemented

### 1. Wallet Management
- View balance
- Deposit funds via card
- Withdraw to bank account
- Transaction history

### 2. Payment Processing
- Initialize transactions
- Secure payment verification
- Automatic wallet credit
- Webhook validation

### 3. Subscription Plans
- Basic (₦500/month)
- Rover (₦2,500/month)
- Courier (₦5,000/month)
- Courier Plus (₦10,000/month)

### 4. Security Features
- HMAC webhook signature validation
- Bearer token authentication
- Secure storage of secrets
- Error logging and tracking

---

## Useful Links

### Paystack Resources
- **Dashboard**: https://dashboard.paystack.com
- **API Documentation**: https://paystack.com/docs/api/
- **Test Cards**: https://paystack.com/docs/payments/test-transactions/
- **Webhook Guide**: https://paystack.com/docs/webhooks/

### Flutter Resources
- **Flutter Paystack**: https://pub.dev/packages/flutter_paystack
- **Dio HTTP Client**: https://pub.dev/packages/dio
- **Riverpod State Management**: https://riverpod.dev

---

## Troubleshooting

### Issue: "PAYSTACK_SECRET_KEY not configured"

**Solution**: Add to `.env`:
```bash
PAYSTACK_SECRET_KEY=sk_test_your_key_here
```

### Issue: "Authorization header invalid"

**Solution**: Ensure Bearer token format:
```
Authorization: Bearer sk_test_xxxxx
```

### Issue: Payment verification fails

**Solution**: 
1. Check webhook configuration in Paystack dashboard
2. Verify backend URL is accessible
3. Check payment reference is correct

---

## File Structure

```
backend/
├── app/
│   ├── config.py (✅ Updated)
│   ├── main.py (✅ Updated)
│   ├── models/
│   │   └── payment.py (✅ Updated)
│   ├── utils/
│   │   ├── paystack.py (✅ NEW)
│   │   └── payments.py (Old - can remove)
│   └── api/
│       └── routes/
│           ├── payments.py (✅ NEW)
│           └── webhooks.py (✅ NEW)
├── .env (✅ Updated)
└── .env.example (✅ Updated)

lib/
├── services/
│   └── paystack_services.dart (✅ Enhanced)
├── core/
│   └── constants/
│       └── paystack_constants.dart (NEW)
├── data/
│   └── services/
│       └── paystack_api_service.dart (NEW)
└── presentation/
    ├── wallet/ (NEW)
    │   └── notifier/
    │       ├── wallet_notifier.dart (NEW)
    │       └── payment_notifier.dart (NEW)
    ├── deposit_screen/ (✅ Update)
    └── select_plan_screen/ (✅ Update)
```

---

## Questions?

Refer to:
- 📄 `PAYSTACK_INTEGRATION_PLAN.md` - Complete plan
- 📄 `PAYSTACK_FLUTTER_IMPLEMENTATION.md` - Flutter guide
- 📄 `BACKEND_SETUP_GUIDE.md` - Backend guide (updated)
- 🔗 Paystack API docs: https://paystack.com/docs/api/

---

**Status**: Backend implementation complete ✅
**Next**: Flutter implementation & testing
**Timeline**: 1-2 weeks for full integration