# Password Reset with Deep Linking - Setup Guide

This guide explains the complete password reset flow implementation with deep linking support that has been added to the Movr app.

## Overview

The password reset flow now works as follows:

1. **User initiates password reset**: Enters email in forgot password screen
2. **Email sent**: Backend sends password reset link via email with format: `movr://reset-password?token=<TOKEN>`
3. **User clicks link**: Email link opens the app with the reset token
4. **Reset screen loads**: App automatically navigates to the reset password screen with the token
5. **User sets new password**: Enters and confirms new password
6. **Password updated**: New password is sent to backend with Bearer token in Authorization header
7. **Navigation**: After successful reset, user is redirected to login screen

## Files Modified

### 1. **Reset Password Notifier State**
- **File**: `lib/presentation/reset_password_screen/notifier/reset_password_state.dart`
- **Changes**: Added `resetToken` field to store the password reset token

### 2. **Reset Password Notifier**
- **File**: `lib/presentation/reset_password_screen/notifier/reset_password_notifier.dart`
- **Changes**: Updated to use `.family` provider to accept `resetToken` parameter

### 3. **Reset Password Screen**
- **File**: `lib/presentation/reset_password_screen/reset_password_screen.dart`
- **Changes**:
  - Added `resetToken` parameter to constructor
  - Updated API call to include `Authorization: Bearer <token>` header
  - Changed final navigation to login screen (sign in)
  - Updated all Consumer calls to use the family notifier

### 4. **Password Check Mail Screen**
- **File**: `lib/presentation/password_check_mail_screen/password_check_mail_screen.dart`
- **Changes**: Added `email` parameter to display actual email address

### 5. **Forgot Password Screen**
- **File**: `lib/presentation/forgot_password_screen/forgot_password_screen.dart`
- **Changes**: Pass email to password check mail screen when navigating

### 6. **App Routes**
- **File**: `lib/routes/app_routes.dart`
- **Changes**:
  - Updated `resetPasswordScreen` route to accept `resetToken` parameter
  - Updated `passwordCheckMailScreen` route to accept `email` parameter
  - Added `onDeepLinkRoute()` method to handle deep links with `movr://reset-password?token=xyz` format
  - Updated `onGenerateRoute()` to handle reset password screen with parameters

### 7. **Deep Link Service**
- **File**: `lib/services/deep_link_service.dart` (NEW)
- **Purpose**: Handles incoming deep links and routes them appropriately

### 8. **Main App**
- **File**: `lib/main.dart`
- **Changes**: Initialized deep link service in the app builder

## Required Setup Steps

### Step 1: Add Dependencies to pubspec.yaml

Add the `app_links` package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # ... other dependencies ...
  app_links: ^4.0.1  # or latest version
  fluttertoast: # should already exist
  http: # should already exist
```

Run `flutter pub get` after adding the dependency.

### Step 2: Android Configuration

#### AndroidManifest.xml
Update `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.movr">

    <uses-permission android:name="android.permission.INTERNET" />
    <!-- other permissions -->

    <application
        android:label="Movr"
        android:icon="@mipmap/ic_launcher">
        
        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <!-- Add Intent Filters for Deep Linking -->
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <!-- Password Reset Deep Link -->
                <data
                    android:scheme="movr"
                    android:host="reset-password" />
            </intent-filter>

            <!-- Keep existing intent filters -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- If you have a FirebaseMessagingService, add it here -->
        <service
            android:name=".MyFirebaseMessagingService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>
    </application>
</manifest>
```

#### (Optional) Domain Verification
For secure deep linking with domain verification, you can also add HTTP/HTTPS scheme:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <!-- App scheme for custom deep links -->
    <data
        android:scheme="movr"
        android:host="reset-password" />
    <!-- Optional: HTTPS for web links -->
    <data
        android:scheme="https"
        android:host="app.movr.com"
        android:pathPrefix="/reset-password" />
</intent-filter>
```

### Step 3: iOS Configuration

#### Info.plist
Update `ios/Runner/Info.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- existing configuration -->
    
    <!-- Add URL Scheme Configuration -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLName</key>
            <string>com.movr.app</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>movr</string>
            </array>
        </dict>
    </array>
    
    <!-- other keys -->
</dict>
</plist>
```

#### Podfile Configuration
Update `ios/Podfile` to ensure proper linking:

```ruby
# Uncomment this line if you're using multiple targets
# target 'Runner' do
#   inherit! :search_paths
#   ...
# end
```

### Step 4: Backend Configuration

Your backend email template should send password reset links in the format:

```
https://app.movr.com/reset-password?token=YOUR_TOKEN_HERE
```

Or for app deep linking:

```
movr://reset-password?token=YOUR_TOKEN_HERE
```

The backend should:
1. Generate a unique, time-limited reset token
2. Include this token in the email link
3. Validate the token when the password reset API is called
4. Expect the token in the `Authorization: Bearer <token>` header

### Step 5: Password Reset API Expectations

The `/api/v1/auth/reset-password` endpoint should:

**Request:**
```json
{
  "new_password": "NewPassword123!",
  "confirm_password": "NewPassword123!"
}
```

**Headers:**
```
Authorization: Bearer <reset_token>
Content-Type: application/json
```

**Response:**
```json
{
  "message": "Password reset successful",
  "status": 200
}
```

**Error Response:**
```json
{
  "error": "Invalid or expired token",
  "status": 400
}
```

## Testing the Flow

### Manual Testing on Android/iOS

1. **Start the app**: `flutter run`
2. **Navigate to forgot password**: Click "Forgot password?" on login screen
3. **Enter email**: Use a test email account
4. **Check console**: You should see the password reset screen appear automatically when clicking the deep link

### Testing with Adb (Android)

```bash
# Test the deep link
adb shell am start -W -a android.intent.action.VIEW -d "movr://reset-password?token=test_token_123" com.example.movr

# Check logcat for errors
adb logcat | grep -i movr
```

### Testing with Deep Link Tester Tools

You can use online deep link testers or create test links:

```
movr://reset-password?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│ User starts on Sign In Screen                                   │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ Tap "Forgot password?" → Forgot Password Screen                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ Enter email → POST /forgot-password                             │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ Password Check Mail Screen (displays email)                     │
│ - "Check your email" message                                    │
│ - "Open email app" button                                       │
│ - "Resend" link                                                 │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
        ┌────────────────────────────────┐
        │ User opens email client        │
        │ Clicks reset link:             │
        │ movr://reset-password?...      │
        └────────────────────┬───────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ Deep Link Service intercepts URI                                │
│ - Extracts token from query parameter                           │
│ - Routes to Reset Password Screen with token                   │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ Reset Password Screen                                           │
│ - Displays "Set new password" form                              │
│ - Token stored in state (user doesn't see it)                  │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│ User enters new password and confirmation                       │
│ → POST /reset-password with Authorization header               │
└────────────────────────┬────────────────────────────────────────┘
                         │
                    ┌────┴────┐
                    ▼         ▼
              ✓ Success   ✗ Error
                    │         │
                    ▼         ▼
        ┌──────────────┐  ┌────────────┐
        │ Sign In      │  │ Show Error │
        │ Screen       │  │ Toast      │
        └──────────────┘  └────────────┘
```

## Troubleshooting

### Deep Links Not Working

1. **Check AndroidManifest.xml**: Ensure intent-filter is properly configured
2. **Check Info.plist**: Verify CFBundleURLTypes are set correctly
3. **Check app_links package**: Run `flutter pub get` and ensure it's imported
4. **Check logs**: 
   - Android: `adb logcat | grep -i "deep link\|app_links"`
   - iOS: Check Console in Xcode

### Token Not Being Passed

1. **Verify deep link format**: Should be `movr://reset-password?token=<value>`
2. **Check URI parsing**: Add debug prints in `onDeepLinkRoute()` method
3. **Verify token extraction**: Ensure `uri.queryParameters['token']` is working

### Password Reset API Errors

1. **401 Unauthorized**: Token might be expired or invalid
2. **400 Bad Request**: Check request body format
3. **Enable logging**: Add http request/response logging to debug

## Security Considerations

1. **Token Expiration**: Ensure backend sets short expiration times (e.g., 1 hour)
2. **Token Validation**: Backend should validate token before accepting new password
3. **HTTPS Only**: In production, use HTTPS for web-based deep links
4. **No Token in URL**: Consider using POST with Authorization header instead
5. **Rate Limiting**: Implement rate limiting on password reset endpoints
6. **Password Validation**: Enforce strong password requirements on backend

## API Response Changes

After successful password reset, the app navigates to **Sign In Screen** instead of Password Success Screen. This allows users to immediately log in with their new credentials.

You can modify this behavior in `reset_password_screen.dart`:
```dart
Navigator.pushNamedAndRemoveUntil(
  context, 
  AppRoutes.signInScreen,  // Change to passwordSuccessScreen if preferred
  (route) => false
);
```

## Additional Notes

- The reset token is validated server-side, not client-side
- Token is not persisted or logged anywhere
- After page navigation, the token is still available in the state if user goes back
- Each reset token should only be valid for one use