# Paystack Integration Setup Guide - Backend & Frontend

This guide walks you through setting up the complete Paystack payment integration between Flutter frontend and Python FastAPI backend.

## Quick Summary

**What was changed:**
1. ✅ Backend endpoints created at `/api/paystack/`
2. ✅ Secret key stored securely in `.env` (NOT exposed)
3. ✅ Flutter app calls backend instead of Paystack directly
4. ✅ Webhook handler ready for payment notifications

---

## 🔧 Backend Setup

Your backend is already configured! Just make sure:

### 1. Check Your .env File

Your `.env` file should have:

```bash
# .env
PAYSTACK_SECRET_KEY=sk_test_9589d42fc73907f36768aed2f96d4e4ef95b6dcc
PAYSTACK_PUBLIC_KEY=pk_test_66ad6e65718f66ad859ccb4155fb499eb07f3c36
```

✅ **Your .env is already set up with both keys!**

### 2. Backend Endpoints are Ready

Your backend now has two new endpoints:

```
POST   /api/paystack/initialize-transaction
GET    /api/paystack/verify-transaction/{reference}
```

**These are auto-registered in `app/main.py`**

---

## 📱 Flutter Frontend Setup

### 1. Update Backend URL

Edit `lib/core/utils/keys.dart`:

```dart
class Keys {
  // Paystack public key (safe to expose)
  static const String paystackPublicKey = 'pk_test_66ad6e65718f66ad859ccb4155fb499eb07f3c36';
  
  // Backend URL - UPDATE THIS to your backend server
  static const String backendBaseUrl = 'http://localhost:3000';  // LOCAL DEV
  // static const String backendBaseUrl = 'https://your-production-api.com';  // PRODUCTION
}
```

**Important:** 
- For local development: Use `http://localhost:3000` (if backend runs on port 3000)
- For production: Use your actual production URL (must be HTTPS)

### 2. Ensure CORS is Configured

Your backend `.env` has CORS enabled:

```bash
ALLOWED_ORIGINS=["http://localhost:3000","http://localhost:8000","http://localhost:8081"]
```

If needed, add your Flutter app's backend URL here.

---

## 🧪 Testing the Integration

### Test 1: Check Backend is Running

```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "environment": "development"
}
```

### Test 2: Check Paystack Payment Endpoint

```bash
curl http://localhost:3000/api/paystack/health
```

Expected response:
```json
{
  "status": "healthy",
  "message": "Paystack payment endpoints ready",
  "endpoints": [...]
}
```

### Test 3: Initialize a Transaction (cURL)

```bash
curl -X POST http://localhost:3000/api/paystack/initialize-transaction \
  -H "Content-Type: application/json" \
  -d '{
    "amount": "5000",
    "email": "test@example.com",
    "reference": "TXN-1705570000000",
    "currency": "NGN",
    "channels": ["card", "bank", "bank_transfer"]
  }'
```

Expected response:
```json
{
  "status": true,
  "message": "Authorization URL created",
  "data": {
    "authorizationUrl": "https://checkout.paystack.com/...",
    "accessCode": "...",
    "reference": "TXN-1705570000000"
  }
}
```

### Test 4: Verify a Transaction

After you get a transaction reference, verify it:

```bash
curl http://localhost:3000/api/paystack/verify-transaction/TXN-1705570000000
```

---

## 🎯 Flutter App - Manual Testing

### Test Flow:

1. **Start Backend**
   ```bash
   cd backend
   python -m uvicorn app.main:app --reload
   ```
   Should show: `Uvicorn running on http://0.0.0.0:3000`

2. **Update Backend URL in Flutter**
   ```dart
   // lib/core/utils/keys.dart
   static const String backendBaseUrl = 'http://localhost:3000';
   ```

3. **Run Flutter App**
   ```bash
   flutter run
   ```

4. **Test Payment Flow**
   - Navigate to Wallet screen
   - Click "Deposit" button
   - Quick Deposit Bottom Sheet appears
   - Enter amount: `5000`
   - Enter email: `test@example.com`
   - Click "Pay Now"
   - PaystackPaymentScreen opens with WebView
   - Test card: `4111 1111 1111 1111`
   - Expiry: Any future date (e.g., `12/25`)
   - CVV: Any 3 digits (e.g., `123`)
   - Click "Pay"
   - OTP field appears, enter: `123456`
   - Success message appears
   - Wallet updates (or webhook updates it in background)

---

## 🔒 Security Checklist

- ✅ **Secret Key Protection**: Stored in `.env` on backend only
- ✅ **Frontend Safety**: Only public key in Flutter code
- ✅ **API Chain**: Flutter → Backend → Paystack
- ✅ **Webhook Validation**: Signature verified with secret key
- ✅ **Database**: Transactions logged with status
- ✅ **Errors**: No sensitive data in error messages

---

## ⚙️ Backend Environment

### Start Backend Server

```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# Create database (if needed)
alembic upgrade head

# Start server
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 3000
```

### If Using Docker

```bash
cd backend

# Build image
docker build -t movr-backend .

# Run container
docker run -p 3000:8000 \
  -e DATABASE_URL=postgresql+psycopg://... \
  -e PAYSTACK_SECRET_KEY=sk_test_... \
  movr-backend
```

---

## 🪝 Webhook Configuration

### 1. Get Your Backend Public URL

For webhooks to work, Paystack must reach your backend. If you're on localhost, use a tunnel:

```bash
# Install ngrok
# https://ngrok.com

# Start tunnel
ngrok http 3000

# You'll get a URL like: https://abc123.ngrok.io
```

### 2. Add Webhook to Paystack Dashboard

1. Go to https://dashboard.paystack.com/settings/webhooks
2. Set webhook URL:
   ```
   https://your-backend.com/api/v1/webhooks/paystack
   ```
   or for local testing:
   ```
   https://abc123.ngrok.io/api/v1/webhooks/paystack
   ```
3. Whitelist events:
   - `charge.success`
   - `charge.failed`
   - `transfer.success`
   - `transfer.failed`

### 3. Webhook Verification

The webhook handler in `app/api/routes/webhooks.py`:
- ✅ Validates Paystack signature
- ✅ Updates payment status
- ✅ Updates user wallet on successful payment
- ✅ Handles failed payments
- ✅ Logs all transactions

---

## 🧩 What Happens Behind the Scenes

### Payment Flow:

```
┌─────────────────┐
│   Flutter App   │
│  (Quick Deposit)│
└────────┬────────┘
         │
         │ 1. Click "Pay Now"
         ↓
┌──────────────────────────────────┐
│ Validation & Reference Generation │
│ - Amount: valid number           │
│ - Email: valid format            │
│ - Reference: TXN-{timestamp}     │
└────────┬─────────────────────────┘
         │
         │ 2. POST /api/paystack/initialize-transaction
         │    {amount, email, reference}
         ↓
┌────────────────────────────┐
│    FastAPI Backend         │
│    (app/main.py)           │
│                            │
│  - Validates input         │
│  - Reads PAYSTACK_SECRET   │
│    KEY from .env           │
│  - Calls Paystack API      │
│  - Saves to database       │
│  - Returns auth URL        │
└────────┬───────────────────┘
         │
         │ 3. POST https://api.paystack.co/transaction/initialize
         │    (Authorization: Bearer SECRET_KEY)
         ↓
┌─────────────────────┐
│   Paystack API      │
│                     │
│ - Initializes txn   │
│ - Returns URL       │
└────────┬────────────┘
         │
         │ 4. Returns authorization URL
         ↓
┌────────────────────────────┐
│    FastAPI Backend         │
│                            │
│  Returns:                  │
│  {                         │
│    authorizationUrl: "..." │
│    accessCode: "..."       │
│    reference: "..."        │
│  }                         │
└────────┬───────────────────┘
         │
         │ 5. Returns authorization URL
         ↓
┌──────────────────────────┐
│     Flutter WebView      │
│                          │
│ - Loads authorization URL│
│ - Shows Paystack UI      │
│ - User enters card/OTP   │
└────────┬─────────────────┘
         │
         │ 6. User completes payment
         ↓
┌─────────────────────┐
│   Paystack Server   │
│                     │
│ - Processes payment │
│ - Sends webhook     │
└────────┬────────────┘
         │
         │ 7. charge.success webhook
         │    POST /api/v1/webhooks/paystack
         ↓
┌────────────────────────────┐
│    FastAPI Webhook Handler │
│                            │
│  - Validates signature     │
│  - Updates payment status  │
│  - Updates wallet balance  │
│  - Logs transaction        │
└────────────────────────────┘
```

---

## 📊 Testing Paystack Test Credentials

These credentials are for **test mode only**:

- **Card Number**: `4111 1111 1111 1111`
- **Expiry Date**: Any future date (e.g., `12/25`)
- **CVV**: Any 3 digits (e.g., `123`)
- **OTP**: `123456`
- **Amount**: Any amount (e.g., `5000` = 5000 NGN)

---

## 🔧 Troubleshooting

### Issue: "Failed to initialize transaction"

**Cause**: Backend cannot reach Paystack API

**Solution**:
1. Check internet connection
2. Check Paystack keys in `.env`
3. Check if backend is running: `curl http://localhost:3000/health`
4. Check backend logs for error details

### Issue: "Backend URL not reachable"

**Cause**: Flutter cannot reach backend

**Solution**:
1. Check `backendBaseUrl` in `lib/core/utils/keys.dart`
2. Check if backend is running on the right port
3. Check device network (emulator vs real device)
4. For emulator: Use `http://10.0.2.2:3000` instead of localhost

### Issue: Wallet not updating after payment

**Cause**: Webhook not configured or signature validation failed

**Solution**:
1. Configure webhook in Paystack dashboard
2. Check backend logs: Look for webhook signature errors
3. Check if ngrok tunnel is still active (if local testing)
4. Verify database transaction: Check `payments` table status

### Issue: "Invalid webhook signature"

**Cause**: Webhook validation failed

**Solution**:
1. Ensure `PAYSTACK_SECRET_KEY` in `.env` matches Paystack dashboard
2. Check ngrok/tunnel URL is correct in Paystack dashboard
3. Restart backend after changing keys

---

## 📈 Monitoring & Debugging

### Check Backend Logs

```bash
# Watch logs while testing
python -m uvicorn app.main:app --reload --log-level debug
```

Look for:
- ✅ "Payment initialized"
- ✅ "Payment verified"
- ✅ "Charge successful"

### Check Database

```bash
# Connect to PostgreSQL
psql -U postgres -d movr

# View payments table
SELECT * FROM payments ORDER BY created_at DESC;

# Check user wallet
SELECT id, email, wallet_balance FROM users;
```

### Test Webhook Locally

Use RequestBin or Webhook.cool to capture webhook calls:

```bash
# Set RequestBin URL in Paystack dashboard
https://webhook.cool/your-unique-id

# Complete a test payment and check if webhook arrives
```

---

## 🚀 Production Deployment

### 1. Update Backend URL

```dart
// lib/core/utils/keys.dart
static const String backendBaseUrl = 'https://your-production-api.com';
```

### 2. Use Live Paystack Keys

```bash
# .env
PAYSTACK_SECRET_KEY=sk_live_xxxxxxxxxxxxx
PAYSTACK_PUBLIC_KEY=pk_live_xxxxxxxxxxxxx
```

### 3. Enable HTTPS

- Ensure backend uses HTTPS only
- Update webhook URL to HTTPS
- Consider using Let's Encrypt for free SSL

### 4. Environment Configuration

```bash
# .env production
DEBUG=False
ENVIRONMENT=production
ALLOWED_ORIGINS=["https://your-domain.com"]
PAYSTACK_SECRET_KEY=sk_live_...
```

### 5. Deploy Backend

Options:
- **Render.com**: `git push` → auto-deploys
- **Heroku**: `git push heroku main`
- **AWS/DigitalOcean**: Docker + Docker Compose
- **Railway**: Import from GitHub

---

## ✅ Final Checklist

- [ ] Backend `.env` has Paystack keys
- [ ] Backend endpoints registered in `app/main.py`
- [ ] Flutter `backendBaseUrl` updated
- [ ] Backend running on accessible URL
- [ ] CORS configured correctly
- [ ] Database migrations run (`alembic upgrade head`)
- [ ] Webhook configured in Paystack dashboard
- [ ] Tested with test credentials
- [ ] Error handling works
- [ ] Wallet updates on successful payment

---

## 📞 Support

If you encounter issues:

1. Check backend logs for error details
2. Check Flutter DevTools console
3. Test endpoints with cURL
4. Check Paystack dashboard for transaction details
5. Verify webhook signature in backend logs

**All endpoints are documented in the code with comments!**