# Email OTP Verification Setup Guide

## Overview
This guide explains the new email verification system with OTP (One-Time Password) that was implemented in the Movr backend.

## What Changed

### 1. **User Registration Flow**
Previously, users could register and immediately access the app. Now:
- Users register with email and password
- An OTP is automatically sent to their email
- Users must verify their email with the OTP before they can login
- Once verified, they receive access and refresh tokens

### 2. **New Database Fields**
Four new fields added to the `users` table:
- `email_verified_at` (DateTime): When the email was verified
- `verification_otp` (String): The 6-digit OTP code
- `otp_created_at` (DateTime): When the OTP was created (used for expiration)
- `otp_attempts` (Integer): Track failed OTP attempts (max 5)

### 3. **Updated `is_verified` Behavior**
- Previously: Set to `False` by default
- Now: Set to `False` on registration, `True` after OTP verification
- Google Sign-In: Automatically set to `True` (Google already verified email)

## New API Endpoints

### 1. POST `/api/v1/auth/register`
**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123",
  "phone": "+1234567890",  // optional
  "first_name": "John",    // optional
  "last_name": "Doe",      // optional
  "role": "customer"       // optional, defaults to "customer"
}
```

**Response (201 Created):**
```json
{
  "message": "Registration successful. An OTP has been sent to your email. Please verify your email within 10 minutes.",
  "email": "user@example.com",
  "otp_expires_in": 600
}
```

**Notes:**
- OTP expires in 10 minutes
- User cannot login without verifying email
- User receives a beautiful HTML email with the OTP

---

### 2. POST `/api/v1/auth/verify-otp`
**Request:**
```json
{
  "email": "user@example.com",
  "otp": "123456"
}
```

**Response (200 OK):**
```json
{
  "access_token": "eyJhbGc...",
  "refresh_token": "eyJhbGc...",
  "token_type": "bearer",
  "expires_in": 1800
}
```

**Error Responses:**
- `404 Not Found`: User not found
- `400 Bad Request`: Email already verified
- `400 Bad Request`: OTP has expired
- `429 Too Many Requests`: More than 5 failed attempts
- `401 Unauthorized`: Invalid OTP with remaining attempts shown

**Notes:**
- Maximum 5 failed attempts before lockout
- OTP is 6 digits
- Upon successful verification, confirmation email is sent

---

### 3. POST `/api/v1/auth/send-otp`
**Request:**
```json
{
  "email": "user@example.com"
}
```

**Response (200 OK):**
```json
{
  "message": "OTP has been sent to your email. Please verify within 10 minutes.",
  "email": "user@example.com",
  "otp_expires_in": 600
}
```

**Use Cases:**
- User didn't receive the first OTP
- User's OTP expired (10 minutes)
- User wants to reverify
- Resetting OTP clears all previous attempts

---

### 4. POST `/api/v1/auth/login` (Updated)
**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123"
}
```

**Response (200 OK):**
```json
{
  "access_token": "eyJhbGc...",
  "refresh_token": "eyJhbGc...",
  "token_type": "bearer",
  "expires_in": 1800
}
```

**Error Responses:**
- `403 Forbidden`: Please verify your email first. Check your email for the OTP.
- `401 Unauthorized`: Invalid email or password
- `403 Forbidden`: User account is inactive
- `403 Forbidden`: User account has been banned

**Notes:**
- Users cannot login until their email is verified
- If unverified, users should use `/send-otp` and `/verify-otp` endpoints

---

### 5. POST `/api/v1/auth/google-signin` (Updated)
No changes to API, but internally:
- Google users are automatically marked as verified
- No OTP required for Google Sign-In
- Email is verified at creation time

---

## Required Environment Variables

Ensure these are set in your `.env` file:

```env
# SendGrid Configuration
SENDGRID_API_KEY=your_sendgrid_api_key_here
SENDGRID_FROM_EMAIL=noreply@movr.app
```

### Getting SendGrid API Key
1. Sign up at [SendGrid](https://sendgrid.com)
2. Navigate to Settings → API Keys
3. Create a new API key with "Mail Send" permission
4. Copy and paste it into your `.env` file

---

## Database Migration

Run the migration to add new columns:

```bash
# From the backend directory
alembic upgrade head
```

This will add:
- `email_verified_at`
- `verification_otp`
- `otp_created_at`
- `otp_attempts`

---

## Installation

Update your dependencies:

```bash
pip install -r requirements.txt
```

The `sendgrid==6.11.0` package has been added to `requirements.txt`.

---

## Security Features

1. **OTP Expiration**: OTPs expire after 10 minutes
2. **Rate Limiting**: Maximum 5 failed attempts before lockout
3. **Email Validation**: Uses Pydantic's EmailStr validator
4. **Password Security**: Passwords are hashed with bcrypt
5. **Attempt Tracking**: Failed attempts are tracked and cleared on resend
6. **Secure Emails**: Uses SendGrid's enterprise email service

---

## Flutter Integration

### 1. Update Registration Flow

**Before:**
```dart
// Register and get tokens immediately
final response = await http.post(
  Uri.parse('$baseUrl/api/v1/auth/register'),
  body: jsonEncode(userRegisterData),
);
final tokens = TokenResponse.fromJson(jsonDecode(response.body));
```

**After:**
```dart
// Step 1: Register and get OTP message
final registerResponse = await http.post(
  Uri.parse('$baseUrl/api/v1/auth/register'),
  body: jsonEncode(userRegisterData),
);

// Step 2: Show OTP input screen
// User enters OTP from their email

// Step 3: Verify OTP and get tokens
final verifyResponse = await http.post(
  Uri.parse('$baseUrl/api/v1/auth/verify-otp'),
  body: jsonEncode({
    'email': userEmail,
    'otp': userEnteredOtp,
  }),
);
final tokens = TokenResponse.fromJson(jsonDecode(verifyResponse.body));
```

### 2. New Screens to Create

1. **OTP Input Screen** (`OTPVerificationScreen`)
   - Show email where OTP was sent
   - Input field for 6-digit OTP
   - Resend button (after 10 seconds)
   - Error messages for failed attempts

2. **Resend OTP Dialog**
   - Show when user clicks "Resend OTP"
   - Call `/send-otp` endpoint
   - Show success/error message

### 3. Example Flutter Code

```dart
// OTP Verification Screen
class OTPVerificationScreen extends StatefulWidget {
  final String email;
  const OTPVerificationScreen({required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  int _remainingTime = 600; // 10 minutes

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
        if (_remainingTime <= 0) {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      setState(() => _errorMessage = 'OTP must be 6 digits');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp': _otpController.text,
        }),
      );

      if (response.statusCode == 200) {
        final tokens = TokenResponse.fromJson(jsonDecode(response.body));
        // Save tokens and navigate to home
        await _saveTokens(tokens);
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (response.statusCode == 429) {
        setState(() => _errorMessage = 'Too many failed attempts. Please request a new OTP.');
      } else {
        final error = jsonDecode(response.body);
        setState(() => _errorMessage = error['detail'] ?? 'Verification failed');
      }
    } catch (e) {
      setState(() => _errorMessage = 'An error occurred: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOTP() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _remainingTime = 600;
          _errorMessage = 'New OTP sent to your email';
          _otpController.clear();
        });
        _startTimer();
      }
    } catch (e) {
      setState(() => _errorMessage = 'Failed to resend OTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;

    return Scaffold(
      appBar: AppBar(title: Text('Verify Email')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Verification code sent to\n${widget.email}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            CustomPinCodeTextField(
              controller: _otpController,
              onChanged: (value) => setState(() => _errorMessage = null),
            ),
            if (_errorMessage != null)
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              ),
            SizedBox(height: 24),
            Text('Expires in: ${minutes}m ${seconds}s',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            CustomElevatedButton(
              text: _isLoading ? 'Verifying...' : 'Verify OTP',
              onPressed: _isLoading ? null : _verifyOTP,
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _resendOTP,
              child: Text('Didn\'t receive code? Resend',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Testing

### Using cURL

1. **Register:**
```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123"}'
```

2. **Verify OTP (replace with actual OTP):**
```bash
curl -X POST http://localhost:8000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","otp":"123456"}'
```

3. **Resend OTP:**
```bash
curl -X POST http://localhost:8000/api/v1/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'
```

4. **Login (after verification):**
```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123"}'
```

### Using Postman
Import the endpoints in Postman:
1. `/api/v1/auth/register` - POST
2. `/api/v1/auth/verify-otp` - POST
3. `/api/v1/auth/send-otp` - POST
4. `/api/v1/auth/login` - POST

---

## Troubleshooting

### "SENDGRID_API_KEY not configured"
- Add `SENDGRID_API_KEY` to your `.env` file
- Restart the backend server

### OTP not received
- Check spam/junk folder in email
- Verify SendGrid API key is correct
- Check email logs in SendGrid dashboard

### "Too many failed attempts"
- Wait a moment or call `/send-otp` to get a new OTP
- This resets the attempt counter

### Database migration fails
- Ensure Alembic is properly configured
- Check PostgreSQL connection
- Run `alembic current` to see current revision

---

## Next Steps

1. ✅ Install dependencies: `pip install -r requirements.txt`
2. ✅ Run database migration: `alembic upgrade head`
3. ✅ Restart backend server
4. ✅ Update Flutter registration flow
5. ✅ Add OTP verification screen
6. ✅ Test the complete registration → verification → login flow

---

## Support

For issues or questions:
1. Check the error response message
2. Review logs in CloudWatch or local console
3. Test with cURL/Postman first
4. Verify all environment variables are set
