# Backend Password Reset Implementation Guide

## 📋 Overview

Password reset endpoints have been implemented in the backend with the following features:
- ✅ Forgot password endpoint - generates secure reset tokens
- ✅ Reset password endpoint - validates tokens and updates passwords
- ✅ Token expiration (1 hour)
- ✅ One-time use tokens (security)
- ✅ Bearer token authentication

## 🔧 Setup Steps

### Step 1: Run Database Migration

Run the Alembic migration to add password reset fields to the users table:

```bash
# Navigate to backend directory
cd backend

# Activate virtual environment (if not already activated)
# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate

# Run migrations
alembic upgrade head
```

This will add the following fields to the users table:
- `reset_token` (String, unique, indexed)
- `reset_token_created_at` (DateTime)
- `reset_token_used` (Boolean)

### Step 2: Restart Backend Server

```bash
# If running with uvicorn
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Or if using the setup script
# Follow your normal backend startup procedure
```

## 📡 API Endpoints

### 1. Forgot Password Endpoint
**POST** `/api/v1/auth/forgot-password`

**Request Body:**
```json
{
    "email": "user@example.com"
}
```

**Success Response (200):**
```json
{
    "message": "If an account exists with that email, you will receive password reset instructions.",
    "email": "user@example.com"
}
```

**Security Note:** The endpoint returns the same message whether or not the email exists, preventing email enumeration attacks.

---

### 2. Reset Password Endpoint
**POST** `/api/v1/auth/reset-password`

**Headers:**
```
Authorization: Bearer <reset_token_from_deep_link>
Content-Type: application/json
```

**Request Body:**
```json
{
    "new_password": "NewPassword123!",
    "confirm_password": "NewPassword123!"
}
```

**Success Response (200):**
```json
{
    "message": "Password has been reset successfully. Please login with your new password.",
    "email": "user@example.com"
}
```

**Error Responses:**

- **Missing Authorization Header (401):**
```json
{
    "detail": "Missing or invalid authorization header"
}
```

- **Passwords Don't Match (400):**
```json
{
    "detail": "Passwords do not match"
}
```

- **Invalid/Expired Token (401):**
```json
{
    "detail": "Invalid or expired reset token"
}
```

- **Token Already Used (401):**
```json
{
    "detail": "Reset token has already been used"
}
```

- **Token Expired (401):**
```json
{
    "detail": "Reset token has expired. Please request a new one."
}
```

## 🔐 Security Features

### Token Generation
- Uses `secrets.token_urlsafe(32)` for cryptographically secure token generation
- Tokens are unique and indexed in the database

### Token Expiration
- Reset tokens expire after **1 hour**
- Expired tokens cannot be used to reset passwords

### One-Time Use Tokens
- Once a token is used, it cannot be reused
- `reset_token_used` flag prevents replay attacks

### Email Enumeration Protection
- `/forgot-password` endpoint returns the same response for existing and non-existing emails
- Prevents attackers from determining which emails are registered

### Password Requirements
- Minimum 8 characters
- Maximum 72 characters (bcrypt limitation)

## 📧 Email Integration

Currently, the endpoints are implemented but email sending is not automatically triggered. To enable email sending:

### Option 1: Use Existing Email Service
If you already have email sending utility set up, modify the `/forgot-password` endpoint in `auth.py`:

```python
# In /forgot-password endpoint, around line 457
from app.utils.email import send_password_reset_email  # Import your email function

# After storing the reset token
reset_link = f"movr://reset-password?token={reset_token}"
email_sent = send_password_reset_email(user.email, reset_link, user.first_name)

if not email_sent:
    logger.warning(f"Failed to send password reset email to {user.email}")
```

### Option 2: Integrate with Email Service
The reset token and link are ready to be sent. You can integrate with:
- SendGrid
- AWS SES
- Gmail SMTP
- Any email service

**Email Template Example:**
```
Subject: Reset Your Movr Password

Hi [User First Name],

Click the link below to reset your password:
movr://reset-password?token=[RESET_TOKEN]

This link expires in 1 hour.

If you didn't request this, you can safely ignore this email.

Best regards,
Movr Team
```

## 🧪 Testing

### Test with Postman/Insomnia

**Step 1: Request Password Reset**
```
POST http://localhost:8000/api/v1/auth/forgot-password
Content-Type: application/json

{
    "email": "test@example.com"
}
```

**Step 2: Get Reset Token**
- Check your backend logs for the token
- Or check the database directly:
```sql
SELECT reset_token FROM users WHERE email = 'test@example.com';
```

**Step 3: Reset Password**
```
POST http://localhost:8000/api/v1/auth/reset-password
Authorization: Bearer <RESET_TOKEN_FROM_PREVIOUS_STEP>
Content-Type: application/json

{
    "new_password": "NewPassword123!",
    "confirm_password": "NewPassword123!"
}
```

**Step 4: Verify Password Changed**
- Try logging in with the new password

### Test with Flutter App

1. The forgot password screen will call `/api/v1/auth/forgot-password`
2. If email sending is set up, user receives reset link
3. Clicking link opens deep link: `movr://reset-password?token=xyz`
4. App parses token and shows reset password screen
5. User enters new password and confirms
6. App sends request to `/api/v1/auth/reset-password` with token in Authorization header
7. On success, user is redirected to login screen

## 🔍 Debugging

### Check Migration Status
```bash
alembic current
alembic history
```

### View Logs
Check the backend console for logs like:
```
INFO:__main__:Password reset requested for: user@example.com
INFO:__main__:Password reset successful for: user@example.com
```

### Database Inspection
```sql
-- Check if fields exist
PRAGMA table_info(users);

-- Find reset tokens
SELECT id, email, reset_token, reset_token_created_at, reset_token_used 
FROM users 
WHERE reset_token IS NOT NULL;
```

## 🐛 Common Issues

### Issue: 404 Not Found on /forgot-password
**Solution:** Make sure you've run `alembic upgrade head` and restarted the backend server.

### Issue: Token Doesn't Work After 1 Hour
**Expected Behavior:** Tokens expire after 1 hour. User must request a new one.

### Issue: Can Reuse Same Token Multiple Times
**Solution:** Check that migration ran successfully and `reset_token_used` column exists and is set correctly.

### Issue: Email Sending Not Working
**Solution:** Email sending is not yet integrated. Follow the "Email Integration" section above.

## 📦 Files Modified/Created

**Backend:**
- ✅ `app/models/user.py` - Added reset token fields
- ✅ `app/schemas/user.py` - Updated ResetPasswordRequest schema
- ✅ `app/api/routes/auth.py` - Added /forgot-password and /reset-password endpoints
- ✅ `alembic/versions/add_password_reset_fields.py` - Database migration

**Frontend (Already implemented):**
- ✅ `lib/presentation/forgot_password_screen/forgot_password_screen.dart`
- ✅ `lib/presentation/password_check_mail_screen/password_check_mail_screen.dart`
- ✅ `lib/presentation/reset_password_screen/reset_password_screen.dart`
- ✅ `lib/routes/app_routes.dart`
- ✅ `lib/services/deep_link_service.dart`
- ✅ `lib/main.dart`

## 🚀 Next Steps

1. **Run migrations:** `alembic upgrade head`
2. **Restart backend:** Start your backend server
3. **Test endpoints:** Use Postman/Insomnia to test the endpoints
4. **Set up email sending:** Integrate with your email service
5. **Test full flow:** Try the complete password reset flow in the Flutter app

## 📞 Support

For questions or issues:
1. Check the logs on both frontend and backend
2. Verify migration ran successfully
3. Confirm reset tokens are being stored in the database
4. Ensure tokens are being passed correctly in the Authorization header