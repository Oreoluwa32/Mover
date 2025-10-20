# 📱 Flutter App - Update API URLs to Production Backend

**Goal**: Change all hardcoded API URLs from demo system to your production Railway backend.

---

## 🔍 What Needs to Change

Your Flutter app currently has hardcoded URLs pointing to:
```
https://demosystem.pythonanywhere.com
```

These need to be updated to your Railway backend:
```
https://your-railway-url.up.railway.app
```

---

## 📝 Files That Need Updating

Found **8 files** with hardcoded API URLs. Here's the complete list:

### 1. **add_route_screen_three.dart**
**Location**: `lib/presentation/add_route_screen_three/add_route_screen_three.dart`

**Find:**
```dart
final url = Uri.parse(
    'https://demosystem.pythonanywhere.com/create-scheduled-route/');
```

**Replace with:**
```dart
final url = Uri.parse(
    'https://your-railway-url.up.railway.app/api/v1/routes/scheduled');
```

---

### 2. **check_mail_screen.dart**
**Location**: `lib/presentation/check_mail_screen/check_mail_screen.dart`

**Find:**
```dart
final url = Uri.parse('https://demosystem.pythonanywhere.com/verify-otp/');
```

**Replace with:**
```dart
final url = Uri.parse('https://your-railway-url.up.railway.app/api/v1/auth/verify-otp');
```

---

### 3. **create_account_screen.dart**
**Location**: `lib/presentation/create_account_screen/create_account_screen.dart`

**Find:**
```dart
final url = Uri.parse('https://demosystem.pythonanywhere.com/register/');
```

**Replace with:**
```dart
final url = Uri.parse('https://your-railway-url.up.railway.app/api/v1/auth/register');
```

---

### 4. **instant_add_route_screen_one.dart** (add_route_screen_one.dart)
**Location**: `lib/presentation/instant_add_route_screen_one/add_route_screen_one.dart`

**Find:**
```dart
final url =
    Uri.parse('https://demosystem.pythonanywhere.com/create-route/');
```

**Replace with:**
```dart
final url =
    Uri.parse('https://your-railway-url.up.railway.app/api/v1/routes/instant');
```

---

### 5. **sign_in_screen.dart**
**Location**: `lib/presentation/sign_in_screen/sign_in_screen.dart`

**Find:**
```dart
final url = Uri.parse('https://demosystem.pythonanywhere.com/login/');
```

**Replace with:**
```dart
final url = Uri.parse('https://your-railway-url.up.railway.app/api/v1/auth/login');
```

---

### 6. **personal_information_screen.dart**
**Location**: `lib/presentation/personal_information_screen/personal_information_screen.dart`

**Find:**
```dart
final url = Uri.parse('https://demosystem.pythonanywhere.com/update-personal-info/');
```

**Replace with:**
```dart
final url = Uri.parse('https://your-railway-url.up.railway.app/api/v1/users/profile');
```

---

### 7. **select_plan_screen.dart**
**Location**: `lib/presentation/select_plan_screen/select_plan_screen.dart`

**Find:**
```dart
final url = Uri.parse('https://demosystem.pythonanywhere.com/update-subscription/');
```

**Replace with:**
```dart
final url = Uri.parse('https://your-railway-url.up.railway.app/api/v1/subscription');
```

---

### 8. **reset_password_screen.dart**
**Location**: `lib/presentation/reset_password_screen/reset_password_screen.dart`

**Find:**
```dart
final url = Uri.parse('https://demosystem.pythonanywhere.com/reset-password/');
```

**Replace with:**
```dart
final url = Uri.parse('https://your-railway-url.up.railway.app/api/v1/auth/reset-password');
```

---

### 9. **vehicle_information_screen.dart**
**Location**: `lib/presentation/vehicle_information_screen/vehicle_information_screen.dart`

**Find:**
```dart
final url = Uri.parse('https://demosystem.pythonanywhere.com/update-vehicle/');
```

**Replace with:**
```dart
final url = Uri.parse('https://your-railway-url.up.railway.app/api/v1/users/vehicle');
```

---

### 10. **forgot_password_screen.dart**
**Location**: `lib/presentation/forgot_password_screen/forgot_password_screen.dart`

**Find:**
```dart
final url = Uri.parse('https://demosystem.pythonanywhere.com/forgot-password/');
```

**Replace with:**
```dart
final url = Uri.parse('https://your-railway-url.up.railway.app/api/v1/auth/forgot-password');
```

---

### 11. **delivery_details_screen.dart**
**Location**: `lib/presentation/delivery_details_screen/delivery_details_screen.dart`

**Find:**
```dart
final url =
    Uri.parse('https://demosystem.pythonanywhere.com/submit-package');
```

**Replace with:**
```dart
final url =
    Uri.parse('https://your-railway-url.up.railway.app/api/v1/deliveries');
```

---

### 12. **schedule_add_route_screen_one.dart** (add_route_screen_one.dart)
**Location**: `lib/presentation/schedule_add_route_screen_one/add_route_screen_one.dart`

**Find:**
```dart
final url = Uri.parse('https://demosystem.pythonanywhere.com/create-route/');
```

**Replace with:**
```dart
final url = Uri.parse('https://your-railway-url.up.railway.app/api/v1/routes/schedule');
```

---

## 🚀 How to Update (Choose One Method)

### Method 1: Manual Find & Replace (Safest)

1. Open each file listed above
2. Use Ctrl+H (Find & Replace) in VS Code
3. Find: `https://demosystem.pythonanywhere.com`
4. Replace: `https://your-railway-url.up.railway.app`
5. Review each change before replacing

### Method 2: Global Replace (Fastest)

1. Press **Ctrl+Shift+H** in VS Code
2. In "Find" field, enter:
   ```
   https://demosystem\.pythonanywhere\.com
   ```
3. In "Replace" field, enter:
   ```
   https://your-railway-url.up.railway.app
   ```
4. Click "Replace All"
5. Verify changes look correct

---

## 📌 Important Notes

1. **Replace `your-railway-url`** with your actual Railway URL:
   - Example: `https://movr-backend-prod.up.railway.app`
   - Get this from Railway dashboard → Backend service → Deployments

2. **API Endpoints** should match your backend routes:
   - The endpoints shown above are suggestions
   - If your backend has different endpoint names, adjust accordingly
   - Check your backend's Swagger docs: `https://your-url.up.railway.app/docs`

3. **After Update:**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Run `flutter run`

---

## ✅ Verification Steps

After updating all URLs:

1. **Check for remaining old URLs:**
   ```
   Ctrl+Shift+F (Find in Files)
   Search for: "demosystem"
   Should return: 0 results
   ```

2. **Test in Flutter app:**
   - Open app
   - Try to register → should work
   - Try to login → should work
   - Check backend logs in Railway for requests

3. **Check Network Requests:**
   - Open Flutter DevTools (if using)
   - Verify requests go to production URL
   - Not to demo system

---

## 🔧 Backend API Endpoints Reference

If your backend endpoints are different, update accordingly:

| Action | Suggested Endpoint |
|--------|-------------------|
| Register | `/api/v1/auth/register` |
| Login | `/api/v1/auth/login` |
| Verify OTP | `/api/v1/auth/verify-otp` |
| Forgot Password | `/api/v1/auth/forgot-password` |
| Reset Password | `/api/v1/auth/reset-password` |
| Get Profile | `/api/v1/users/profile` |
| Update Profile | `/api/v1/users/profile` |
| Update Vehicle | `/api/v1/users/vehicle` |
| Create Route (Instant) | `/api/v1/routes/instant` |
| Create Route (Scheduled) | `/api/v1/routes/scheduled` |
| Schedule Route | `/api/v1/routes/schedule` |
| Create Delivery | `/api/v1/deliveries` |
| Update Subscription | `/api/v1/subscription` |

Check your backend Swagger at: `https://your-railway-url.up.railway.app/docs`

---

## 🎯 Done!

Once you've updated all URLs and tested:

1. Your Flutter app connects to production backend ✅
2. Data flows to production database ✅
3. Ready to show supervisor ✅

**Next:** Follow the main production deployment checklist!