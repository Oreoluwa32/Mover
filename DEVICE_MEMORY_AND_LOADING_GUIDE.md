# Device Memory & Loading Animation Implementation Guide

## Overview
This guide explains the two new features implemented in the Movr app:
1. **Device Memory** - Remember the device so user doesn't have to re-login
2. **Loading Animation** - Show Lottie animation during sign-in and registration

---

## 1. Device Memory Feature

### What It Does
- After first successful login, the device is "remembered"
- On next app launch, if the device is remembered and token is valid, user skips login and goes directly to home screen
- User can "forget" the device by logging out

### How It Works

#### Architecture
```
┌─────────────────────────────────────────┐
│       DeviceMemoryService               │
│  (Singleton Pattern)                    │
└─────────────────────────────────────────┘
         ↓              ↓              ↓
   SharedPreferences   Secure         Device
   (Device data)       Storage        State
                       (Token)
```

#### Key Files
- **`lib/services/device_memory_service.dart`** - Core service for device memory management
- **`lib/presentation/splash_screen_one/splash_screen_one.dart`** - Updated to check device memory at startup
- **`lib/presentation/sign_in_screen/sign_in_screen.dart`** - Stores device memory after successful login
- **`lib/main.dart`** - Initializes DeviceMemoryService at app startup

### API Reference

#### DeviceMemoryService Methods

**Initialize (call once at app startup)**
```dart
final deviceMemory = DeviceMemoryService();
await deviceMemory.init();
```

**Remember Device (call after successful login)**
```dart
await deviceMemory.rememberDevice(userEmail: 'user@example.com');
```

**Check if Device is Remembered**
```dart
final isRemembered = await deviceMemory.isDeviceRemembered();
if (isRemembered) {
  // Navigate to home screen
} else {
  // Navigate to login screen
}
```

**Get Remembered User Email**
```dart
final email = await deviceMemory.getRememberedUserEmail();
```

**Get Last Login Time**
```dart
final lastLogin = await deviceMemory.getLastLoginTime();
```

**Forget Device (logout)**
```dart
await deviceMemory.forgetDevice();
```

**Check Session Validity**
```dart
final isValid = await deviceMemory.isSessionValid();
```

### Implementation Details

#### What Gets Stored
1. **Device Remembered Flag** → SharedPreferences
2. **User Email** → SharedPreferences
3. **Last Login Time** → SharedPreferences
4. **Auth Token** → Flutter Secure Storage (already existed)

#### Security
- Auth tokens are stored in **Flutter Secure Storage** (encrypted)
- Device metadata stored in **SharedPreferences**
- No sensitive data is stored in SharedPreferences
- On logout, all data is cleared including secure storage

---

## 2. Loading Animation Feature

### What It Does
Shows a professional Lottie animation dialog while:
- User is signing in
- User is registering an account

### How It Works

#### LoadingDialog Widget
```
┌──────────────────────────────┐
│    LoadingDialog Widget       │
│  ┌──────────────────────────┐ │
│  │  Lottie Animation        │ │
│  │  (img_movr.json)         │ │
│  └──────────────────────────┘ │
│  Processing... (optional msg) │
└──────────────────────────────┘
```

#### Key Files
- **`lib/widgets/loading_dialog.dart`** - Reusable loading dialog with Lottie
- **`lib/presentation/sign_in_screen/sign_in_screen.dart`** - Shows during sign-in
- **`lib/presentation/create_account_screen/create_account_screen.dart`** - Shows during registration

### API Reference

#### LoadingDialog Static Methods

**Show Loading Dialog**
```dart
LoadingDialog.show(
  context,
  message: 'Signing in...',
  isCancellable: false,
);
```

**Hide Loading Dialog**
```dart
LoadingDialog.hide(context);
```

### Implementation Details

#### Usage in Sign-In Flow
```dart
Future<void> signInUser(BuildContext context, SignInNotifier notifier) async {
  // Show loading dialog
  LoadingDialog.show(context, message: 'Signing in...');
  
  try {
    // Make API call
    final response = await http.post(url, ...);
    
    // Hide loading dialog
    if (context.mounted) {
      LoadingDialog.hide(context);
    }
    
    // Handle response...
  } catch (e) {
    // Always hide on error
    if (context.mounted) {
      LoadingDialog.hide(context);
    }
  }
}
```

#### Animation File
- **Location**: `assets/lottieFiles/img_movr.json`
- **Size**: Automatically scales to 80x80 dp
- **Repeat**: Loops continuously while loading

---

## 3. Complete User Journey

### First-Time User
```
1. App Launches → SplashScreenOne
   ↓
2. Check device memory → Not remembered
   ↓
3. Navigate to SplashScreenTwo (onboarding)
   ↓
4. User signs up → CreateAccountScreen
   ↓
5. Show loading animation
   ↓
6. Account created successfully
   ↓
7. Navigate to CheckMailScreen
```

### Returning User (Device Remembered)
```
1. App Launches → SplashScreenOne
   ↓
2. Check device memory → Remembered ✓
   ↓
3. Check auth token in secure storage → Valid ✓
   ↓
4. Skip to HomeOneScreen directly
   ↓
5. User automatically logged in! 🎉
```

### Sign-In Flow with Loading
```
1. User clicks "Sign In"
   ↓
2. Validation passes → Show loading dialog
   ↓
3. API call to login endpoint
   ↓
4. Hide loading dialog
   ↓
5. If success:
   - Store token in secure storage
   - Remember device
   - Navigate to SelectPlanScreen
   ↓
6. If error:
   - Show error toast
   - User stays on sign-in screen
```

---

## 4. Implementing Logout Functionality

To add logout in your profile screen:

```dart
Future<void> onLogout(BuildContext context) async {
  // Forget device
  final deviceMemory = DeviceMemoryService();
  await deviceMemory.forgetDevice();
  
  // Show success message
  Fluttertoast.showToast(msg: 'Logged out successfully');
  
  // Navigate to login screen
  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.signInScreen,
    (route) => false,
  );
}
```

---

## 5. Testing the Features

### Test Device Memory
```dart
// Test 1: First launch (no token)
// Expected: App should show SplashScreenTwo (onboarding)

// Test 2: After sign-in
// Expected: Device marked as remembered
// Check with: DeviceMemoryService().isDeviceRemembered()

// Test 3: Subsequent launch
// Expected: App should skip to HomeOneScreen

// Test 4: Logout
// Expected: Device forgotten, next launch shows login
```

### Test Loading Animation
```dart
// Test 1: Click sign-in button
// Expected: Loading dialog appears with animation

// Test 2: Simulate slow network
// Expected: Animation continues until response

// Test 3: Sign-in succeeds
// Expected: Dialog closes, navigate to next screen

// Test 4: Sign-in fails
// Expected: Dialog closes, show error toast
```

---

## 6. Customization

### Change Loading Message
```dart
LoadingDialog.show(context, message: 'Creating your account...');
```

### Change Loading Animation
Replace the Lottie file path in `LoadingDialog`:
```dart
Lottie.asset(
  'assets/lottieFiles/your_custom_animation.json',
  height: 80.h,
  width: 80.h,
)
```

### Adjust Device Memory Timeout
Add to `DeviceMemoryService` if you want sessions to expire:
```dart
Future<bool> isSessionValid() async {
  final lastLogin = await getLastLoginTime();
  if (lastLogin == null) return false;
  
  final duration = DateTime.now().difference(lastLogin);
  const maxDuration = Duration(days: 30); // Expire after 30 days
  
  return duration < maxDuration;
}
```

---

## 7. Troubleshooting

### Issue: Loading dialog not appearing
- **Check**: Ensure `LoadingDialog.show()` is called before API request
- **Check**: Verify `context.mounted` is true before hiding

### Issue: Device not remembered after login
- **Check**: Ensure `DeviceMemoryService().rememberDevice()` is called
- **Check**: Verify SharedPreferences and SecureStorage are initialized

### Issue: User stuck on splash screen
- **Check**: Clear app data and rebuild
- **Check**: Verify `_initializeApp()` completes successfully

### Issue: Animation not showing
- **Check**: Verify `assets/lottieFiles/img_movr.json` exists
- **Check**: Verify Lottie package is added to pubspec.yaml: `lottie: ^3.3.1`

---

## 8. Performance Considerations

- **Device Memory Service**: Uses singleton pattern, minimal memory overhead
- **Loading Animation**: Lottie animations are GPU-accelerated and performant
- **Secure Storage**: Encrypted storage, minor startup delay (handled asynchronously)

---

## 9. Best Practices

✅ **DO:**
- Always use `if (context.mounted)` before navigation
- Initialize DeviceMemoryService in main.dart
- Hide loading dialog in both success and error cases
- Clear device memory on logout
- Test on slow networks to ensure animations display properly

❌ **DON'T:**
- Don't show loading dialog without hiding it (causes memory leak)
- Don't call `rememberDevice()` before successful login
- Don't store sensitive data in SharedPreferences
- Don't forget to initialize DeviceMemoryService
- Don't hardcode animation file paths

---

## 10. Dependencies

All required dependencies are already in pubspec.yaml:
- ✅ `flutter_secure_storage: ^9.2.2`
- ✅ `shared_preferences: ^2.3.0`
- ✅ `lottie: ^3.3.1`
- ✅ `fluttertoast: ^8.2.8`

No additional packages needed!

---

## Quick Reference

| Feature | File | Method | Purpose |
|---------|------|--------|---------|
| Remember Device | DeviceMemoryService | `rememberDevice()` | Store login info |
| Check Remembered | DeviceMemoryService | `isDeviceRemembered()` | Verify auto-login |
| Forget Device | DeviceMemoryService | `forgetDevice()` | Logout user |
| Show Loading | LoadingDialog | `show()` | Display animation |
| Hide Loading | LoadingDialog | `hide()` | Close animation |

---

## Next Steps

1. ✅ Test device memory on physical device (use Android emulator for testing)
2. ✅ Verify loading animation displays smoothly
3. ✅ Implement logout button in profile screen
4. ✅ Test on slow networks to verify UX
5. ✅ Monitor app performance with device memory features
