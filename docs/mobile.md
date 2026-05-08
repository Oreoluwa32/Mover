# Mobile App Guide

## Stack

- Flutter
- Riverpod
- Dio
- flutter_secure_storage
- shared_preferences
- google_maps_flutter
- google_navigation_flutter
- flutter_svg
- image_picker
- webview_flutter

## App Structure

Primary folders:

- `lib/core/`: app config, utilities, theme, routing helpers
- `lib/data/`: models and services
- `lib/presentation/`: screens and feature-specific UI modules
- `lib/widgets/`: shared reusable widgets

## Important Service Classes

Examples include:

- account APIs
- auth APIs
- auth session refresh handling
- mobility APIs
- wallet APIs
- realtime/tracking helpers

These services are used by screen notifiers and UI flows to keep business logic out of widgets.

## Presentation Structure

The app is organized by screen folders under `lib/presentation/`.

Examples:

- `sign_in_screen`
- `create_account_screen`
- `home_one_screen`
- `instant_add_route_screen_one`
- `schedule_add_route_screen_one`
- `notification_screen`
- `transaction_history_screen`
- `profile_screen`

Many of these contain:

- `models/`
- `notifier/`
- widgets local to that screen

## Navigation

The app uses named routes and route arguments for flow transitions.

Important navigation behavior includes:

- auth route guarding for protected screens
- onboarding/auth/public screen separation
- route/task screen transitions using passed request and match payloads

## State Management

The app heavily uses Riverpod with `StateNotifierProvider`.

Common responsibilities handled in state:

- loading status
- validation
- fetched models
- user-selected route values
- profile image state
- activity/task state

## Key User Flows

### Authentication

- sign in
- create account
- email verification
- forgot password
- reset password

### Mobility

- instant route creation
- scheduled route creation
- nearby mover search
- mover offer selection
- ride and delivery task progression

### Wallet

- wallet view
- transaction history
- Monnify funding account display
- payment screens

### Profile

- profile details
- profile picture upload
- personal information
- KYC and supporting identity screens

## Assets and Visual System

Assets live in:

- `assets/images/`
- `assets/fonts/`
- `assets/lottieFiles/`

The app now also uses a custom Movr SVG breathing loader via shared widgets instead of default stock spinners in the main flows.

## Local Mobile Run

```bash
flutter pub get
flutter run --dart-define=MOVR_API_BASE_URL=http://10.0.2.2:8000 --dart-define=MOVR_WS_BASE_URL=ws://10.0.2.2:8000 --dart-define=MOVR_ENVIRONMENT=development --dart-define=GOOGLE_MAPS_API_KEY=your_key --dart-define=GOOGLE_PLACES_API_KEY=your_key
```

## Common Mobile Tasks

### Analyze

```bash
flutter analyze
```

### Format

```bash
dart format lib test
```

### Build APK

```bash
flutter build apk --release
```

### Build App Bundle

```bash
flutter build appbundle --release
```

## Mobile Integration Notes

- The app depends on backend JWT auth and refresh handling.
- Route and wallet flows can fail if the backend URL, storage, or gateway config is missing.
- Map-related testing is best validated on a physical device.
