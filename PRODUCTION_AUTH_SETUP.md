# Production Authentication Setup Guide

This guide covers setting up authentication for the Movr application in production, including email/password login, Google Sign-In, and backend configuration.

## 1. Backend Setup

### API Endpoints Available

- `POST /api/v1/auth/register` - Register with email, password, phone, first_name, last_name
- `POST /api/v1/auth/login` - Login with email and password
- `POST /api/v1/auth/google-signin` - Google Sign-In authentication
- `POST /api/v1/auth/refresh` - Refresh access token

### Database Configuration

Ensure the following environment variables are set in your backend (Render):

```env
DATABASE_URL=postgresql://user:password@host/dbname
JWT_SECRET_KEY=your-long-random-secret-key
JWT_ALGORITHM=HS256
JWT_EXPIRATION_MINUTES=30
REFRESH_TOKEN_EXPIRATION_DAYS=7
```

### Production Deployment (Render)

1. **Set Environment Variables in Render:**
   - Go to your Render dashboard
   - Select your service
   - Go to Settings > Environment
   - Add all required variables from `.env.example`

2. **Database Setup:**
   ```bash
   # Run migrations on Render PostgreSQL
   alembic upgrade head
   ```

## 2. Google Sign-In Production Setup

### For Android

1. **Get SHA-1 Fingerprint of Your Release Key:**
   ```bash
   keytool -list -v -keystore path/to/your/keystore.jks -alias your_alias
   ```

2. **In Google Cloud Console:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create or select your project
   - Enable Google+ API
   - Go to Credentials
   - Create OAuth 2.0 Client ID (Android)
   - Add your package name: `com.example.new_project`
   - Add SHA-1 fingerprint from step 1
   - Download the JSON config

3. **Update Android App:**
   - Place the `google-services.json` in `android/app/`
   - The Flutter Google Sign-In package will automatically detect this

### For iOS

1. **In Google Cloud Console:**
   - Go to Credentials
   - Create OAuth 2.0 Client ID (iOS)
   - Add your Bundle ID: `com.example.new-project`
   - Download the JSON config

2. **Update iOS App:**
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`
   - Add to Xcode: Target > Build Phases > Copy Bundle Resources

3. **Update Info.plist:**
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   ```

### For Web

1. **In Google Cloud Console:**
   - Create OAuth 2.0 Client ID (Web application)
   - Add authorized JavaScript origins:
     - `https://yourdomain.com`
     - `https://www.yourdomain.com`
   - Add authorized redirect URIs
   - Copy the Client ID

2. **In Flutter Web (index.html):**
   ```html
   <meta name="google-signin-client_id" content="YOUR_WEB_CLIENT_ID.apps.googleusercontent.com">
   <script src="https://accounts.google.com/gsi/client" async defer></script>
   ```

## 3. Frontend Configuration

### Update API Endpoints (if using a custom domain)

If you have a custom domain, update the API endpoints in:

1. **create_account_screen.dart:**
   ```dart
   final url = Uri.parse('https://your-api-domain.com/api/v1/auth/register');
   ```

2. **sign_in_screen.dart:**
   ```dart
   final url = Uri.parse('https://your-api-domain.com/api/v1/auth/login');
   ```

3. **google_auth_helper.dart:**
   ```dart
   final response = await http.post(
     Uri.parse('https://your-api-domain.com/api/v1/auth/google-signin'),
     ...
   );
   ```

### Build for Production

#### Android Release Build:
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

#### iOS Release Build:
```bash
flutter build ios --release
```

#### Web Release Build:
```bash
flutter build web --release
```

## 4. Testing in Production

### Test Registration:
1. Open the Create Account screen
2. Enter: email, first name, last name, phone number, password
3. Click "Get Started"
4. Verify success toast appears
5. Check backend logs for confirmation

### Test Email/Password Login:
1. Open the Sign In screen
2. Enter registered email and password
3. Click "Sign in"
4. Verify tokens are stored securely
5. Should navigate to Select Plan screen

### Test Google Sign-In:
1. On Create Account screen: Click "Sign up with Google"
2. Select your Google account
3. Verify authentication with backend succeeds
4. Tokens stored and user navigates to Select Plan screen

## 5. Troubleshooting

### 422 Unprocessable Entity Error
- **Cause:** Request body doesn't match backend schema
- **Fix:** Ensure all required fields are sent: email, phone, password, first_name, last_name, role

### Google Sign-In Not Working
- **Android:** Verify SHA-1 fingerprint matches in Google Cloud Console
- **iOS:** Verify Bundle ID and Info.plist configuration
- **All:** Check that GoogleService config file is properly included

### Token Not Stored
- Verify `flutter_secure_storage` permissions are set correctly
- Check device settings to ensure app has permission to store data

### Backend Errors
- Check Render logs: `Settings > Logs`
- Verify database connection: `SELECT 1;`
- Check environment variables are set correctly

## 6. Security Considerations

✅ **Implemented:**
- Passwords hashed with bcrypt
- JWT tokens for authentication
- Secure token storage with flutter_secure_storage
- HTTPS for all API calls
- CORS properly configured

⚠️ **Production Checklist:**
- [ ] Change default JWT secret to a long random string
- [ ] Enable HTTPS only (set `ENVIRONMENT=production`)
- [ ] Set up rate limiting for auth endpoints
- [ ] Configure email verification for email accounts
- [ ] Set up monitoring and alerts for auth failures
- [ ] Implement device fingerprinting for suspicious logins
- [ ] Set up audit logging for authentication events

## 7. Firebase Integration (Optional)

If you want to add Firebase for crash reporting and analytics:

1. **Create Firebase Project:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project
   - Add Android and iOS apps

2. **Configure Flutter:**
   ```bash
   flutter pub add firebase_core firebase_crashlytics firebase_analytics
   ```

3. **Update main.dart:**
   ```dart
   import 'package:firebase_core/firebase_core.dart';
   
   void main() async {
     await Firebase.initializeApp();
     runApp(MyApp());
   }
   ```

## 8. Monitoring & Logging

### Key Metrics to Monitor:
- Registration success/failure rate
- Login success/failure rate
- Google Sign-In success rate
- Token refresh success rate
- Failed authentication attempts per IP
- Average response time for auth endpoints

### Logging Setup:
The backend logs to:
- Standard output (visible in Render logs)
- Format: `timestamp - module - level - message`

Access logs in Render:
1. Go to your service
2. Click on "Logs" tab
3. Filter by level (INFO, ERROR, WARNING)

## 9. Next Steps

1. ✅ Set up Google Cloud project and get credentials
2. ✅ Update Android/iOS configs with credentials
3. ✅ Deploy backend to Render with environment variables
4. ✅ Build and deploy frontend to app stores
5. ✅ Test all authentication flows
6. ✅ Set up monitoring and alerts
7. ✅ Create user feedback/support channel