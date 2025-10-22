# Paystack Backend Testing Guide

## Prerequisites
- Backend running on `http://localhost:8000`
- You have a valid auth token (from login)
- Paystack credentials configured in `.env`

---

## 1. Get Your Auth Token

First, sign in to get a token:

```powershell
$response = curl.exe -X POST http://localhost:8000/api/v1/auth/login `
  -H "Content-Type: application/json" `
  -d '{
    "email": "your-email@example.com",
    "password": "your-password"
  }' | ConvertFrom-Json

$token = $response.data.access_token
$token  # Print to verify
```

Store this token - you'll need it for all requests:
```powershell
$authHeader = "Authorization: Bearer $token"
```

---

## 2. Test Wallet Balance Endpoint

```powershell
curl.exe -X GET http://localhost:8000/api/v1/payments/wallet/balance `
  -H $authHeader `
  -H "Content-Type: application/json"
```

**Expected Response:**
```json
{
  "status": true,
  "message": "Wallet balance retrieved successfully",
  "data": {
    "balance": 0.0,
    "currency": "NGN"
  }
}
```

---

## 3. Test Get Banks Endpoint

```powershell
curl.exe -X GET http://localhost:8000/api/v1/payments/banks `
  -H $authHeader `
  -H "Content-Type: application/json"
```

**Expected Response:**
```json
{
  "status": true,
  "message": "Banks retrieved successfully",
  "data": [
    {
      "id": 1,
      "code": "033",
      "name": "United Bank for Africa"
    },
    ...
  ]
}
```

---

## 4. Test Initialize Payment Endpoint

```powershell
curl.exe -X POST http://localhost:8000/api/v1/payments/initialize `
  -H $authHeader `
  -H "Content-Type: application/json" `
  -d '{
    "amount": 500.0,
    "description": "Test subscription",
    "related_type": "subscription"
  }'
```

**Expected Response:**
```json
{
  "status": true,
  "message": "Payment initialized successfully",
  "data": {
    "reference": "movr_xyz123",
    "access_code": "flw_xyz",
    "authorization_url": "https://checkout.paystack.com/..."
  }
}
```

---

## 5. Test Verify Payment Endpoint

After initializing, use the reference to verify:

```powershell
curl.exe -X POST http://localhost:8000/api/v1/payments/verify `
  -H $authHeader `
  -H "Content-Type: application/json" `
  -d '{
    "reference": "movr_xyz123"
  }'
```

**Expected Response:**
```json
{
  "status": true,
  "message": "Payment verified successfully",
  "data": {
    "status": "success",
    "new_balance": 500.0
  }
}
```

---

## 6. Test Get Transaction History

```powershell
curl.exe -X GET "http://localhost:8000/api/v1/payments/transactions?limit=10&offset=0" `
  -H $authHeader `
  -H "Content-Type: application/json"
```

**Expected Response:**
```json
{
  "status": true,
  "message": "Transactions retrieved successfully",
  "data": {
    "transactions": [...],
    "total": 0
  }
}
```

---

## 7. Using Postman (Alternative)

If you prefer Postman, here's the setup:

1. Import this collection or create requests:
   - **Base URL**: `http://localhost:8000/api/v1`
   - **Auth Header**: `Authorization: Bearer <your_token>`

2. **Requests**:
   - `GET /payments/wallet/balance`
   - `GET /payments/banks`
   - `POST /payments/initialize` (with body)
   - `POST /payments/verify` (with reference)
   - `GET /payments/transactions`

---

## Troubleshooting

### 401 Unauthorized
- Token may have expired
- Get a new token from login endpoint
- Check Bearer token format

### 400 Bad Request
- Check JSON format
- Verify amount is a float
- Check enum values (related_type)

### 500 Server Error
- Check backend logs
- Verify Paystack credentials in `.env`
- Ensure database is properly set up

---

## Next Steps
1. ✅ Test all endpoints work
2. ✅ Verify payment initialization
3. → Proceed with Flutter implementation