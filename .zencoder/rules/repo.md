---
description: Repository Information Overview
alwaysApply: true
---

# Movr Information

## Summary
Movr is a transportation platform mobile application built with Flutter. It provides ride-sharing, delivery, and moving services through a comprehensive mobile interface. The app includes features for user authentication, payment processing, route planning, and service scheduling.

## Structure
- **lib/**: Core application code organized in a domain-driven design pattern
  - **core/**: Core utilities and exports
  - **data/**: Data layer with models
  - **domain/**: Business logic and domain entities
  - **presentation/**: UI screens and components
  - **services/**: Service implementations
  - **widgets/**: Reusable UI components
- **assets/**: Application assets including images, fonts, and Lottie animations
- **android/**, **ios/**, **web/**, **linux/**, **macos/**, **windows/**: Platform-specific code
- **test/**: Test files for the application

## Language & Runtime
**Language**: Dart
**Version**: SDK ^3.5.3
**Framework**: Flutter
**Package Manager**: pub (Flutter/Dart package manager)

## Dependencies
**Main Dependencies**:
- flutter_riverpod: ^2.5.1 (State management)
- http: ^1.3.0 (HTTP client)
- google_maps_flutter: ^2.12.3 (Maps integration)
- flutter_secure_storage: ^9.2.2 (Secure storage)
- dio: 5.8.0+1 (HTTP client)
- google_sign_in: ^6.2.2 (Authentication)
- flutter_screenutil: ^5.9.3 (Responsive UI)
- shared_preferences: ^2.3.0 (Local storage)
- location: ^5.0.0 (Location services)

**Development Dependencies**:
- flutter_test: SDK
- flutter_lints: ^5.0.0

## Build & Installation
```bash
flutter pub get
flutter build apk --release  # For Android
flutter build ios --release  # For iOS
flutter build web --release  # For Web
```

## Testing
**Framework**: flutter_test
**Test Location**: test/
**Naming Convention**: *_test.dart
**Run Command**:
```bash
flutter test
```

## Application Features
- **Authentication**: Email, password, and Google Sign-In
- **Payment Processing**: Integration with payment services
- **Ride Sharing**: Request and schedule rides
- **Delivery Services**: Package delivery management
- **Route Planning**: Add and manage routes with Google Maps integration
- **Multi-platform**: Support for Android, iOS, web, and desktop platforms