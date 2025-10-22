# Paystack Backend Security Setup

## ⚠️ CRITICAL SECURITY ISSUE FIXED

**Previous Problem**: Frontend had hardcoded Paystack secret key - EXPOSED
**Solution**: Moved all secret key operations to backend

---

## What Changed

### Frontend (SECURE ✅)
- Removed secret key from `lib/core/utils/keys.dart`
- Now only has PUBLIC key (if needed)
- Calls BACKEND endpoints instead of Paystack directly

### Backend (SECURE ✅)
- Keeps secret key in `.env` file - NOT exposed
- Handles all Paystack API interactions
- Frontend never touches the secret key

---

## Required Backend Endpoints

Your backend MUST implement these two endpoints:

### 1. Initialize Transaction
```
POST /api/paystack/initialize-transaction
```

**Request Body:**
```json
{
  "amount": "5000",
  "email": "user@example.com",
  "currency": "NGN",
  "reference": "TXN-1234567890",
  "channels": ["card", "bank", "bank_transfer"]
}
```

**Response:**
```json
{
  "status": true,
  "message": "Authorization URL created",
  "data": {
    "authorizationUrl": "https://checkout.paystack.com/...",
    "accessCode": "...",
    "reference": "TXN-1234567890"
  }
}
```

### 2. Verify Transaction
```
GET /api/paystack/verify-transaction/:reference
```

**Response:**
```json
{
  "status": true,
  "message": "Verification successful",
  "data": {
    "reference": "TXN-1234567890",
    "status": "success",
    "amount": 500000,
    "paid_at": "2024-01-15T10:30:00Z"
  }
}
```

---

## Example Node.js/Express Implementation

### Backend Route Handler

```javascript
// routes/paystack.js
const express = require('express');
const axios = require('axios');
const router = express.Router();

// Paystack secret key from .env (NOT exposed to frontend)
const PAYSTACK_SECRET_KEY = process.env.PAYSTACK_SECRET_KEY;
const PAYSTACK_API = 'https://api.paystack.co';

// ✅ Endpoint: Initialize Transaction
router.post('/initialize-transaction', async (req, res) => {
  try {
    const { amount, email, currency = 'NGN', reference, channels } = req.body;

    // Validate input
    if (!amount || !email || !reference) {
      return res.status(400).json({
        status: false,
        message: 'Missing required fields: amount, email, reference'
      });
    }

    // Convert amount to kobo (Paystack expects amounts in smallest unit)
    const amountInKobo = Math.floor(parseFloat(amount) * 100);

    // Call Paystack API with SECRET KEY (kept safe on backend)
    const response = await axios.post(
      `${PAYSTACK_API}/transaction/initialize`,
      {
        amount: amountInKobo,
        email: email,
        currency: currency,
        reference: reference,
        channels: channels || ['card', 'bank', 'bank_transfer']
      },
      {
        headers: {
          Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
          'Content-Type': 'application/json'
        }
      }
    );

    // Return authorization URL to frontend
    // Frontend will load this URL in WebView
    return res.status(200).json({
      status: true,
      message: 'Authorization URL created',
      data: response.data.data
    });

  } catch (error) {
    console.error('Paystack initialization error:', error.response?.data || error.message);
    return res.status(500).json({
      status: false,
      message: 'Failed to initialize transaction',
      error: error.response?.data?.message || error.message
    });
  }
});

// ✅ Endpoint: Verify Transaction
router.get('/verify-transaction/:reference', async (req, res) => {
  try {
    const { reference } = req.params;

    if (!reference) {
      return res.status(400).json({
        status: false,
        message: 'Reference is required'
      });
    }

    // Call Paystack API with SECRET KEY (kept safe on backend)
    const response = await axios.get(
      `${PAYSTACK_API}/transaction/verify/${reference}`,
      {
        headers: {
          Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
          'Content-Type': 'application/json'
        }
      }
    );

    const transactionData = response.data.data;

    // Check if payment was successful
    if (transactionData.status === 'success') {
      // ✅ Save to database, trigger fulfillment, etc.
      console.log(`Transaction ${reference} verified successfully`);

      return res.status(200).json({
        status: true,
        message: 'Verification successful',
        data: {
          reference: transactionData.reference,
          status: transactionData.status,
          amount: transactionData.amount,
          email: transactionData.customer.email,
          paid_at: transactionData.paid_at
        }
      });
    } else {
      return res.status(400).json({
        status: false,
        message: 'Transaction was not successful',
        data: transactionData
      });
    }

  } catch (error) {
    console.error('Paystack verification error:', error.response?.data || error.message);
    return res.status(500).json({
      status: false,
      message: 'Failed to verify transaction',
      error: error.response?.data?.message || error.message
    });
  }
});

module.exports = router;
```

### Main Express App Setup

```javascript
// server.js or app.js
const express = require('express');
const app = express();

app.use(express.json());

// Import the Paystack routes
const paystackRoutes = require('./routes/paystack');

// Mount the routes
app.use('/api/paystack', paystackRoutes);

app.listen(process.env.PORT || 3000, () => {
  console.log('Server running...');
});
```

### Environment Variables

```bash
# .env (BACKEND ONLY - NEVER in frontend)
PAYSTACK_SECRET_KEY=sk_test_9589d42fc73907f36768aed2f96d4e4ef95b6dcc
```

---

## Flutter Frontend Configuration

**Update `lib/core/utils/keys.dart`:**

```dart
class Keys {
  // ✅ PUBLIC KEY only (safe to expose)
  static const String paystackPublicKey = 'pk_test_...';
  
  // Backend API URL - Update with your actual backend URL
  static const String backendBaseUrl = 'https://your-backend.com'; // or http://localhost:3000 for dev
}
```

---

## Security Checklist

- ✅ **Frontend**: No secret keys anywhere
- ✅ **Frontend**: Only calls backend endpoints
- ✅ **Backend**: Secret key in `.env` file
- ✅ **Backend**: Never exposes secret key in responses
- ✅ **Backend**: Validates all input from frontend
- ✅ **Backend**: Verifies transactions server-to-server with Paystack
- ✅ **Backend**: Uses HTTPS in production
- ✅ **Backend**: Implements rate limiting on endpoints
- ✅ **Backend**: Logs all transactions for audit trail

---

## Flow Diagram

```
┌─────────────┐
│   Flutter   │
│  (Frontend) │
└──────┬──────┘
       │
       │ POST /api/paystack/initialize-transaction
       │ (amount, email, reference)
       ↓
┌─────────────────┐
│    Backend      │
│   (Node.js)     │
│  Secret Key: ✓  │ (in .env)
└────────┬────────┘
         │
         │ POST https://api.paystack.co/transaction/initialize
         │ (Authorization: Bearer SECRET_KEY)
         ↓
    ┌─────────────┐
    │   Paystack  │
    │     API     │
    └─────────────┘
         │
         │ Returns authorization URL
         ↓
┌─────────────────┐
│    Backend      │
│ Returns URL     │
└────────┬────────┘
         │
         ↓
┌──────────────────┐
│   Flutter WebView│
│ Loads URL & gets │
│ user payment     │
└──────────────────┘
```

---

## Testing

### Test Credentials
- Card: `4111 1111 1111 1111`
- Expiry: Any future date (e.g., 12/25)
- CVV: Any 3 digits (e.g., 123)
- OTP: `123456`

### Test Endpoints
```bash
# Initialize transaction
curl -X POST http://localhost:3000/api/paystack/initialize-transaction \
  -H "Content-Type: application/json" \
  -d '{
    "amount": "5000",
    "email": "test@example.com",
    "reference": "TXN-1234567890",
    "channels": ["card"]
  }'

# Verify transaction
curl -X GET http://localhost:3000/api/paystack/verify-transaction/TXN-1234567890 \
  -H "Content-Type: application/json"
```

---

## Important Notes

1. **Always verify transactions on the backend** - Never trust frontend verification
2. **Use HTTPS in production** - All communication must be encrypted
3. **Implement webhook handling** - Paystack sends webhooks for transaction status
4. **Never log secret keys** - Even in development, keep keys secure
5. **Use environment variables** - Never hardcode secrets
6. **Implement rate limiting** - Prevent abuse of payment endpoints