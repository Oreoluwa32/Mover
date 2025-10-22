# Quick Start: Authentication Fix for Production

## What Was Fixed? 🔧

Your 422 errors were caused by **missing required fields** in registration:
- ❌ Old: Only sending `email` + `password`
- ✅ New: Now sending `email` + `password` + `first_name` + `last_name` + `phone` + `role`

## Immediate Next Steps 📋

### 1. Test Registration Locally (5 min)
```bash
cd c:\Users\oreol\Documents\Projects\Movr
flutter pub get
flutter run  # Run on Android emulator or physical device
```

Then:
1. Navigate to Create Account screen
2. Fill in ALL fields: email, first name, last name, phone, password
3. Click "Get Started"
4. Should see success message (no more 422 errors!)

### 2. Test Login (5 min)
1. Go to Sign In screen
2. Use the email & password you just registered with
3. Should see "Sign-in successful" and navigate to Select Plan
4. Tokens are automatically stored securely

### 3. Test Google Sign-In (Optional locally)
1. Click "Sign up with Google" or "Sign in with Google"
2. Select your Google account
3. Should complete successfully if Google credentials are configured

---

## For Production Deployment 🚀

### Backend (Already Done ✅)
- New endpoint: `POST /api/v1/auth/google-signin`
- All endpoints properly return JWT tokens
- Database ready

### Frontend - Before Deploying

#### Step 1: Get Google Credentials

**For Android:**
```bash
# Generate SHA-1 of your release key
keytool -list -v -keystore YOUR_KEYSTORE.jks -alias YOUR_ALIAS
```
- Copy the SHA-1 fingerprint
- Go to [Google Cloud Console](https://console.cloud.google.com/)
- Create Android OAuth Credential
- Add your SHA-1 fingerprint
- Download `google-services.json`
- Place in `android/app/google-services.json`

**For iOS:**
- Go to Google Cloud Console
- Create iOS OAuth Credential
- Add your Bundle ID (likely `com.example.new-project`)
- Download `GoogleService-Info.plist`
- Add to Xcode: Runner > Build Phases > Copy Bundle Resources

#### Step 2: Build Release

**Android:**
```bash
flutter build apk --release
# or for Google Play Store
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
# Then open ios/Runner.xcworkspace in Xcode and archive
```

#### Step 3: Update Backend (if custom domain)

If you have a custom domain, update these files:
- `lib/presentation/create_account_screen/create_account_screen.dart` (line 59)
- `lib/presentation/sign_in_screen/sign_in_screen.dart` (line 26)
- `lib/domain/googleauth/google_auth_helper.dart` (line 32)

Change:
```dart
Uri.parse('https://movr-api.onrender.com/api/v1/auth/...')
```
to your domain

#### Step 4: Test Everything

- ✅ Register new user
- ✅ Login with credentials
- ✅ Google Sign-In
- ✅ Check app logs for errors

---

## Important Production Configuration ⚠️

### Update Backend Environment Variables on Render

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Select your service
3. Go to Settings > Environment
4. Add/Update:
   ```
   DATABASE_URL=postgresql://...
   JWT_SECRET_KEY=long-random-string-at-least-32-chars
   JWT_ALGORITHM=HS256
   ENVIRONMENT=production
   ALLOWED_ORIGINS=https://yourdomain.com
   ```

### Update CORS if Needed

Your backend at `backend/app/main.py` already has CORS configured for:
- All origins (during development)
- Allow credentials, cookies, custom headers

For strict production, update line 69 in `backend/app/main.py`:
```python
allow_origins=["https://yourdomain.com"],  # Your domain only
```

---

## Verification Checklist ✅

Before deploying to production, verify:

- [ ] Registration screen shows 4 input fields: email, first name, last name, phone
- [ ] Registration accepts and sends all fields
- [ ] Login works with registered credentials
- [ ] Tokens are stored in secure storage
- [ ] Google Sign-In credentials configured
- [ ] Google-services.json in android/app/ (Android)
- [ ] GoogleService-Info.plist in iOS/Runner (iOS)
- [ ] Backend environment variables set on Render
- [ ] API endpoints in frontend point to correct backend URL
- [ ] Database connection verified on Render

---

## Troubleshooting 🔍

### Still Getting 422?
```bash
# Check backend logs on Render
# Look for: "Failed to create database tables"
# If found, run: python -m alembic upgrade head
```

### Google Sign-In Shows Error?
- Android: SHA-1 fingerprint mismatch → regenerate and update Google Cloud
- iOS: Bundle ID mismatch → verify in Google Cloud Console
- All: Check network request in browser dev tools

### App Crashes on Login?
```bash
flutter run --verbose
# Look for error messages in console
# Check: flutter_secure_storage permissions
```

---

## New Files to Review

1. **`PRODUCTION_AUTH_SETUP.md`** - Detailed setup guide (read before deploying)
2. **`BACKEND_FRONTEND_INTEGRATION_SUMMARY.md`** - Technical details of all changes
3. **`QUICK_START_AUTH_FIX.md`** - This file

---

## API Changes Summary

| What | Before | After |
|------|--------|-------|
| Register fields | email, password | email, password, first_name, last_name, phone, role |
| Login response | token.key | access_token, refresh_token, expires_in |
| Google endpoint | None | /api/v1/auth/google-signin |
| Token storage | Custom | Secure storage (flutter_secure_storage) |

---

## What's Next? 🎯

1. ✅ Test locally with these changes
2. ✅ Get Google OAuth credentials
3. ✅ Update Android/iOS configs
4. ✅ Build release versions
5. ✅ Deploy to app stores
6. ✅ Monitor backend logs for errors

---

**Questions?** Check the detailed guides in this repo or review the backend logs at:
```
https://dashboard.render.com/ → Your Service → Logs
```

Good luck! 🚀