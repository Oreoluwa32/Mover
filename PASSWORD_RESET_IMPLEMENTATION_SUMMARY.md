# Password Reset Implementation Summary

## What Has Been Implemented

A complete password reset flow with deep linking support has been added to the Movr app.

### Core Features

✅ **Password Reset Request Flow**
- User enters email on forgot password screen
- API call to `/api/v1/auth/forgot-password` sends reset link to email
- User navigated to "Check your email" screen showing the email address

✅ **Deep Linking Support**
- Email contains a link in format: `movr://reset-password?token=<TOKEN>`
- When user clicks link, app automatically opens and navigates to reset password screen
- Token is automatically extracted and passed to the reset screen

✅ **Password Reset Screen**
- Accepts reset token from deep link
- User enters new password and confirmation
- API call includes token in `Authorization: Bearer <token>` header
- After successful reset, user is navigated to login screen

✅ **Error Handling**
- Invalid/expired tokens show appropriate error message
- API errors are displayed to user
- Network errors are handled gracefully

## Files Changed

### Presentation Layer
1. `lib/presentation/forgot_password_screen/forgot_password_screen.dart`
   - ✨ Now passes email to password check mail screen

2. `lib/presentation/password_check_mail_screen/password_check_mail_screen.dart`
   - ✨ Accepts email parameter and displays it
   - ✨ Resend link navigates back to forgot password screen

3. `lib/presentation/reset_password_screen/reset_password_screen.dart`
   - ✨ Accepts resetToken parameter
   - ✨ Includes token in Authorization header
   - ✨ Updated form field bindings to use family notifier
   - ✨ Final navigation is to login screen

### State Management
4. `lib/presentation/reset_password_screen/notifier/reset_password_state.dart`
   - ✨ Added resetToken field

5. `lib/presentation/reset_password_screen/notifier/reset_password_notifier.dart`
   - ✨ Updated to use `.family` provider for token parameter

### Routing & Deep Linking
6. `lib/routes/app_routes.dart`
   - ✨ Updated route builders to accept parameters
   - ✨ Added `onDeepLinkRoute()` method for deep link handling
   - ✨ Updated `onGenerateRoute()` to handle reset password with token

### Services
7. `lib/services/deep_link_service.dart` (NEW)
   - ✨ Handles incoming deep links
   - ✨ Routes to appropriate screens based on deep link format

### Main App
8. `lib/main.dart`
   - ✨ Imports and initializes deep link service
   - ✨ Sets up context for deep link handling

## Next Steps Required

### Step 1: Add Dependency
Update `pubspec.yaml`:
```yaml
dependencies:
  app_links: ^4.0.1
```

Then run: `flutter pub get`

### Step 2: Configure Android
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="movr"
        android:host="reset-password" />
</intent-filter>
```

### Step 3: Configure iOS
Edit `ios/Runner/Info.plist`:
```xml
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
```

### Step 4: Backend Configuration
Update your backend email template to include reset link:
```
Click here to reset your password:
movr://reset-password?token=<GENERATED_TOKEN>
```

## How It Works: User Perspective

1. **User clicks "Forgot password?"** on login screen
   - Navigated to forgot password screen

2. **User enters email and clicks "Reset password"**
   - Email is sent with reset link
   - Navigated to "Check your email" screen

3. **User opens email and clicks link**
   - App opens automatically (due to deep linking)
   - Token is extracted from URL
   - Reset password screen loads with token pre-filled

4. **User enters new password twice and clicks "Reset password"**
   - Password is sent with Bearer token in header
   - If successful, user is navigated to login screen
   - User can now login with new password

## Testing Checklist

- [ ] `app_links` dependency added to pubspec.yaml
- [ ] Android manifest updated with intent filter
- [ ] iOS Info.plist updated with URL scheme
- [ ] App builds and runs without errors
- [ ] Can navigate to forgot password screen
- [ ] Can enter email and click reset password button
- [ ] API call is made to forget-password endpoint
- [ ] Navigation to "Check your email" screen works
- [ ] Deep link URL format is correct in backend email template
- [ ] Clicking deep link navigates to reset password screen
- [ ] Token is correctly passed to reset screen
- [ ] Can enter new password and confirmation
- [ ] API call includes Authorization Bearer header with token
- [ ] Successful reset navigates to login screen
- [ ] Login works with new password

## API Requirements

The backend `/api/v1/auth/reset-password` endpoint should:

**Accept:**
```json
POST /api/v1/auth/reset-password
Authorization: Bearer <reset_token>
Content-Type: application/json

{
  "new_password": "NewPassword123!",
  "confirm_password": "NewPassword123!"
}
```

**Return on Success (200):**
```json
{
  "message": "Password reset successful",
  "status": 200
}
```

**Return on Error:**
```json
{
  "error": "Invalid or expired token",
  "status": 400
}
```

## Security Features

✅ Token is validated server-side only
✅ Token is time-limited (set on backend)
✅ Token is one-time use only (implement on backend)
✅ Token is sent via Authorization header (not in body)
✅ HTTPS recommended for production
✅ No token is logged or persisted locally

## Customization Options

If you want to customize the flow:

1. **Change final destination after reset**
   - Edit: `reset_password_screen.dart` line 70
   - Change: `AppRoutes.signInScreen` to `AppRoutes.passwordSuccessScreen`

2. **Add custom token validation**
   - Edit: `deep_link_service.dart`
   - Add validation logic in `_handleDeepLink()` method

3. **Change deep link format**
   - Edit: `app_routes.dart` in `onDeepLinkRoute()` method
   - Change: `uri.host == 'reset-password'` condition

4. **Add different token parameters**
   - Edit: `app_routes.dart` in `onDeepLinkRoute()` method
   - Update: `uri.queryParameters['token']` key name

## Troubleshooting

### Deep links not working
1. Verify `app_links` is imported in deep_link_service.dart
2. Check AndroidManifest.xml intent-filter is correct
3. Check Info.plist CFBundleURLSchemes is set
4. Rebuild the app: `flutter clean && flutter run`

### Token not being passed
1. Check deep link format: `movr://reset-password?token=VALUE`
2. Add debug logging in `_handleDeepLink()` to see what's received

### Password reset API failing
1. Check backend expects Bearer token in Authorization header
2. Verify token format is correct (no extra "Bearer " prefix)
3. Check token hasn't expired on backend

## References

- Full setup guide: `PASSWORD_RESET_DEEP_LINKING_SETUP.md`
- App links package: https://pub.dev/packages/app_links
- Flutter deep linking: https://flutter.dev/docs/cookbook/navigation/set-up-universal-links