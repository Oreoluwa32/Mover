# Password Reset - Quick Reference

## 🚀 Quick Setup (5 minutes)

### 1. Add Dependency
```bash
flutter pub add app_links
```

Or add to `pubspec.yaml`:
```yaml
dependencies:
  app_links: ^4.0.1
```

### 2. Android Setup
Edit `android/app/src/main/AndroidManifest.xml` - add inside `<activity>`:
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="movr" android:host="reset-password" />
</intent-filter>
```

### 3. iOS Setup
Edit `ios/Runner/Info.plist` - add inside `<dict>`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>movr</string>
        </array>
    </dict>
</array>
```

### 4. Test
```bash
flutter run
```

## 📋 Flow Overview

```
Forgot Password Screen
       ↓
   Enter Email
       ↓
   Check Mail Screen (shows email)
       ↓
   User clicks link in email: movr://reset-password?token=abc123
       ↓
   App opens → Reset Password Screen loads (token auto-filled)
       ↓
   Enter new password
       ↓
   API call: POST /reset-password with Authorization: Bearer abc123
       ↓
   Login Screen (ready to sign in)
```

## 🔑 Key Changes Made

| File | What Changed |
|------|--------------|
| `reset_password_screen.dart` | Now accepts token, includes it in API call |
| `reset_password_notifier.dart` | Uses `.family` to accept token parameter |
| `password_check_mail_screen.dart` | Shows actual email address |
| `forgot_password_screen.dart` | Passes email when navigating |
| `app_routes.dart` | Handles deep links with `onDeepLinkRoute()` |
| `deep_link_service.dart` | NEW - Manages deep link routing |
| `main.dart` | Initializes deep link service |

## 🧪 Testing Deep Links

### Android (via ADB)
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "movr://reset-password?token=test123" \
  com.example.movr
```

### iOS (via Simulator)
```bash
xcrun simctl openurl booted "movr://reset-password?token=test123"
```

## ⚙️ Backend Requirements

Your backend should:

1. **Generate reset tokens** on forgot-password endpoint
2. **Send in email** with format: `movr://reset-password?token=<TOKEN>`
3. **Validate tokens** on reset-password endpoint
4. **Accept** Authorization header: `Authorization: Bearer <token>`
5. **Update password** in database
6. **Invalidate token** after use

### API Endpoints

#### POST /api/v1/auth/forgot-password
```json
Request:  { "email": "user@example.com" }
Response: { "message": "Reset link sent", "status": 200 }
```

#### POST /api/v1/auth/reset-password
```json
Request Header:  Authorization: Bearer <reset_token>
Request Body:    {
  "new_password": "NewPass123!",
  "confirm_password": "NewPass123!"
}
Response:        { "message": "Password reset successful", "status": 200 }
```

## 🔒 Security Checklist

- [ ] Token is time-limited (e.g., 1 hour expiration)
- [ ] Token is one-time use only
- [ ] Token is validated server-side
- [ ] HTTPS is used in production
- [ ] Strong password requirements enforced
- [ ] Rate limiting on reset endpoints
- [ ] Token not visible in logs

## 📱 Frontend Files Location

```
lib/
├── presentation/
│   ├── forgot_password_screen/
│   │   ├── forgot_password_screen.dart ✨
│   │   └── notifier/
│   ├── password_check_mail_screen/
│   │   └── password_check_mail_screen.dart ✨
│   └── reset_password_screen/
│       ├── reset_password_screen.dart ✨
│       └── notifier/
│           ├── reset_password_notifier.dart ✨
│           └── reset_password_state.dart ✨
├── services/
│   └── deep_link_service.dart ✨ (NEW)
├── routes/
│   └── app_routes.dart ✨
└── main.dart ✨
```

✨ = Modified or created in this update

## 🛠️ Troubleshooting

| Issue | Solution |
|-------|----------|
| Deep links not working | Check manifest/info.plist, rebuild app |
| Token not passed | Verify link format: `movr://reset-password?token=VALUE` |
| 401 error from API | Token might be expired or invalid on backend |
| Blank reset screen | Check token is extracted in `onDeepLinkRoute()` |

## 📚 Full Guides

- **Setup Guide**: `PASSWORD_RESET_DEEP_LINKING_SETUP.md`
- **Implementation Details**: `PASSWORD_RESET_IMPLEMENTATION_SUMMARY.md`
- **This File**: `PASSWORD_RESET_QUICK_REFERENCE.md`

## 🎯 Next Steps

1. ✅ Run `flutter pub get`
2. ✅ Update Android manifest
3. ✅ Update iOS Info.plist
4. ✅ Ask backend team to update email template with deep link
5. ✅ Test on real device or emulator
6. ✅ Verify full flow end-to-end

## 📞 Common Questions

**Q: Can I use a different deep link format?**
A: Yes! Edit `app_routes.dart` → `onDeepLinkRoute()` method to change the format.

**Q: What if backend doesn't send a token in link?**
A: You can modify the flow to use a code that user enters manually. Edit `reset_password_screen.dart` to add a code input field.

**Q: How long should tokens be valid?**
A: Typically 1-24 hours depending on security requirements.

**Q: Can I customize the success screen?**
A: Yes! In `reset_password_screen.dart` line 70, change `AppRoutes.signInScreen` to another route.

**Q: Do I need HTTPS for deep links?**
A: For custom schemes like `movr://`, no. But HTTPS-based deep links (universal links) require configuration on backend.