# 🚀 Password Reset - Quick Fix Guide

## 🔴 The Issue

You were getting **404 - Not Found** when trying to use the forgot password feature. This is because the backend API endpoints didn't exist yet.

## ✅ The Solution

Backend password reset endpoints have now been created. Here's what to do:

### 1. Database Migration (1 minute)

Navigate to the backend directory and run:

```bash
cd backend
alembic upgrade head
```

This creates the necessary database tables for password reset tokens.

### 2. Restart Backend Server (30 seconds)

Stop your backend server and restart it:

```bash
# If using uvicorn:
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 3. Test Again (2 minutes)

Go back to the Flutter app:
1. Click "Forgot password?"
2. Enter your email
3. Click "Reset password"
4. You should see: **"Reset instructions sent to your email."**

## 📝 What Was Added

Two new backend endpoints:

### ✅ POST `/api/v1/auth/forgot-password`
- Takes user email
- Generates secure reset token (expires in 1 hour)
- Returns success message
- **Currently not sending emails** (to be integrated)

### ✅ POST `/api/v1/auth/reset-password`
- Takes new password in request body
- Takes reset token in Authorization header
- Validates token hasn't expired
- Validates token hasn't been used
- Updates user password in database
- Returns success

## 🔐 Security Features

✅ Cryptographically secure token generation  
✅ Token expires after 1 hour  
✅ One-time use tokens  
✅ Email enumeration protection  
✅ Bearer token authentication  

## 📧 Email Sending (Optional Next Step)

The endpoints are ready, but email sending isn't automatically triggered yet. To enable it:

1. Create a function to send password reset emails
2. Modify the `/forgot-password` endpoint to call it
3. Users will receive the deep link in their email

See `BACKEND_PASSWORD_RESET_SETUP.md` for detailed email integration instructions.

## 🧪 Test Endpoints Directly

You can test the endpoints using curl or Postman:

```bash
# Test 1: Request password reset
curl -X POST http://localhost:8000/api/v1/auth/forgot-password \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'

# Response:
# {"message": "If an account exists...", "email": "test@example.com"}
```

## ✨ What's Next

1. **Immediate:** Run `alembic upgrade head` and restart backend
2. **Soon:** Set up email sending so users receive reset links
3. **Later:** Monitor password reset attempts in logs

## 📱 Full Flow (After Email Setup)

```
User enters email
    ↓
Backend generates token & sends email with deep link
    ↓
User clicks link in email
    ↓
App opens automatically to reset password screen
    ↓
User enters new password
    ↓
Backend updates password
    ↓
User redirected to login with new password
```

## 🆘 Still Getting 404?

1. Did you run `alembic upgrade head`? ✓
2. Did you restart the backend server? ✓
3. Is the backend running on the right URL? ✓ (Should be https://movr-api.onrender.com)

If yes to all, the endpoints should work now!

---

**Files Modified:**
- ✅ `backend/app/models/user.py`
- ✅ `backend/app/schemas/user.py`
- ✅ `backend/app/api/routes/auth.py`
- ✅ `backend/alembic/versions/add_password_reset_fields.py`

**Backend Migration Status:** READY TO DEPLOY ✅
**Frontend Implementation:** ALREADY DONE ✅
**Email Integration:** TODO (optional)