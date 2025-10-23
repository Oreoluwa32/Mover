# Login Email Verification Flow - Implementation Guide

## Overview
When a user tries to login with an unverified email address, the system will automatically send a fresh OTP to their email and redirect them to the check mail screen.

## Backend Changes

### Login Endpoint (`POST /api/v1/auth/login`)

**Behavior:**
- When user attempts to login with an unverified email address:
  1. ✅ Fresh OTP is automatically generated and sent to their email
  2. ✅ OTP attempt counter is reset to 0
  3. ✅ Returns **403 Forbidden** with error code `"email_not_verified"`
  4. ✅ User should be directed to check mail screen

**Response:**
```json
{
  "detail": "email_not_verified"
}
```

## Frontend (Flutter) Implementation

### Step 1: Handle Login Error in SignIn Screen

Modify your login handler to detect the `email_not_verified` error:

```dart
Future<void> handleLogin(String email, String password) async {
  try {
    final response = await authService.login(email, password);
    // Success - navigate to home
    Navigator.pushReplacementNamed(context, '/home');
  } catch (e) {
    if (e is DioException) {
      final errorDetail = e.response?.data['detail'] ?? 'Unknown error';
      
      // Check if email is not verified
      if (errorDetail == 'email_not_verified') {
        // ✅ Fresh OTP was sent - navigate to check mail screen
        Navigator.pushReplacementNamed(
          context,
          '/check-mail',
          arguments: {'email': email, 'isResend': true},
        );
        
        // Show toast
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fresh OTP sent to $email. Please verify your email.'),
            backgroundColor: Colors.blue,
          ),
        );
        return;
      }
      
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorDetail)),
      );
    }
  }
}
```

### Step 2: Update CheckMail Screen

Update your check mail verification screen to handle the `isResend` flag:

```dart
class CheckMailScreen extends StatefulWidget {
  final String email;
  final bool isResend;

  const CheckMailScreen({
    required this.email,
    this.isResend = false,
  });

  @override
  _CheckMailScreenState createState() => _CheckMailScreenState();
}

class _CheckMailScreenState extends State<CheckMailScreen> {
  @override
  void initState() {
    super.initState();
    
    // If coming from login with unverified email
    if (widget.isResend) {
      _showMessage('Fresh OTP has been sent to your email');
    } else {
      _showMessage('OTP sent to your email');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Check Your Email',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'We sent a 4-digit code to\n${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),
              // OTP Input Field
              OTPInputField(
                onComplete: (otp) async {
                  await _verifyOTP(otp);
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await _resendOTP();
                },
                child: Text('Didn\'t receive the code? Resend'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOTP(String otp) async {
    try {
      final tokens = await authService.verifyOTP(widget.email, otp);
      
      // Save tokens
      await saveAuthTokens(tokens);
      
      // Navigate to home
      Navigator.pushReplacementNamed(context, '/home');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email verified successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resendOTP() async {
    try {
      await authService.sendOTP(widget.email);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New OTP sent to ${widget.email}'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend OTP'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

### Step 3: Update Routes

Add the check mail screen route:

```dart
// In your app routes
'/check-mail': (context) {
  final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  return CheckMailScreen(
    email: args?['email'] ?? '',
    isResend: args?['isResend'] ?? false,
  );
},
```

## User Flow Diagram

```
┌─────────────────────────────┐
│   User on SignIn Screen     │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│ Enters email & password     │
│ Clicks Sign In              │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│ POST /api/v1/auth/login     │
└──────────────┬──────────────┘
               │
        ┌──────┴──────┐
        │             │
        ▼             ▼
    ✅ VERIFIED    ❌ NOT VERIFIED
        │             │
        │             ▼
        │    ┌──────────────────────┐
        │    │ Fresh OTP generated  │
        │    │ Email sent           │
        │    │ Return 403           │
        │    │ detail: "email_not_  │
        │    │         verified"    │
        │    └──────────┬───────────┘
        │               │
        ▼               ▼
    LOGIN           NAVIGATE TO
    SUCCESS         CHECK MAIL
        │           SCREEN
        │           (Show Toast:
        ▼           Fresh OTP sent)
    Home Screen      │
                     ▼
                OTP Entry
                Screen
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
    VALID OTP              INVALID OTP
        │                     │
        ▼                     ▼
    GET TOKENS           SHOW ERROR
        │              + Retry Option
        ▼
    HOME SCREEN
```

## Test Scenarios

### Scenario 1: Forgot OTP (Left Check Mail Screen)
1. User registers with email
2. Gets OTP in email
3. User accidentally closes app before verifying
4. User reopens app and tries to login
5. ✅ Fresh OTP sent automatically
6. ✅ Directed to check mail screen
7. ✅ Verification completes successfully

### Scenario 2: OTP Expired
1. User received OTP
2. Waited more than 10 minutes
3. Tries to enter expired OTP
4. Gets error "OTP has expired"
5. User clicks "Resend OTP"
6. ✅ New OTP sent

### Scenario 3: Wrong OTP Multiple Times
1. User enters wrong OTP 5 times
2. Gets error "Too many failed attempts"
3. User must click "Resend OTP"
4. ✅ Fresh OTP sent, counter reset

## Error Codes & Messages

| Error | Status | Meaning | Action |
|-------|--------|---------|--------|
| `email_not_verified` | 403 | Email not verified, fresh OTP sent | Navigate to check mail screen |
| `Invalid OTP` | 401 | Wrong OTP code entered | Show error, retry |
| `OTP has expired` | 400 | OTP older than 10 minutes | Click resend OTP |
| `Too many failed attempts` | 429 | 5 wrong attempts made | Click resend OTP to get fresh code |
| `Invalid email or password` | 401 | Wrong credentials | Show error, retry |

## Backend Endpoints Reference

### Login
```
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Password123"
}
```

**Response (Email Not Verified):**
```json
Status: 403 Forbidden
{
  "detail": "email_not_verified"
}
```

**Response (Success):**
```json
Status: 200 OK
{
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "token_type": "bearer",
  "expires_in": 1800
}
```

### Verify OTP
```
POST /api/v1/auth/verify-otp
Content-Type: application/json

{
  "email": "user@example.com",
  "otp": "1234"
}
```

**Response (Success):**
```json
Status: 200 OK
{
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "token_type": "bearer",
  "expires_in": 1800
}
```

### Send OTP (Resend)
```
POST /api/v1/auth/send-otp
Content-Type: application/json

{
  "email": "user@example.com"
}
```

**Response:**
```json
Status: 200 OK
{
  "message": "OTP has been sent to your email. Please verify within 10 minutes.",
  "email": "user@example.com",
  "otp_expires_in": 600
}
```

## Summary

✅ **Backend:** Automatically sends fresh OTP when user tries to login with unverified email  
✅ **Backend:** Returns specific error code `"email_not_verified"` for easy detection  
✅ **Frontend:** Catches this error and navigates to check mail screen  
✅ **Frontend:** Shows toast message informing user fresh OTP was sent  
✅ **User Experience:** Seamless recovery when accidentally leaving verification screen