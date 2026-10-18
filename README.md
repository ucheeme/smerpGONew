# SmerpGO

## Summary
SmerpGO is a Flutter mobile application for both Android and iOS platforms. It's a business application that provides order management, reporting, and catalog functionalities with Firebase integration for analytics, messaging, and remote configuration.

## Structure
- **lib/**: Contains the main Dart code for the application
  - **apiServiceLayer/**: API service implementations
  - **controller/**: Application controllers
  - **cubit/**: State management using BLoC pattern with Cubit
  - **model/**: Data models
  - **Reposistory/**: Data repositories
  - **screens/**: UI screens and components
  - **utils/**: Utility functions and services
- **android/**: Android platform-specific code
- **ios/**: iOS platform-specific code
- **assets/**: Application assets (images, fonts, JSON files)
- **test/**: Test files for the application

## Language & Runtime
- **Language**: Dart
- **Version**: SDK >=3.3.2 <4.0.0
- **Framework**: Flutter
- **Build System**: Flutter build system
- **Package Manager**: pub (Flutter/Dart package manager)

## Dependencies
- **Main Dependencies**:
  - flutter: Flutter SDK
  - get: ^4.7.2 (GetX for state management)
  - firebase_core: ^3.13.1
  - firebase_analytics: ^11.4.6
  - firebase_messaging: ^15.2.6
  - firebase_remote_config: ^5.4.4
  - flutter_bloc: (BLoC pattern implementation)
  - flutter_screenutil: ^5.6.1
  - http: (HTTP client)
  - path_provider: ^2.1.0
  - shared_preferences: (Local storage)
- **Development Dependencies**:
  - flutter_test: Flutter testing framework
  - flutter_lints: ^2.0.0

## Build & Installation
```bash
# Get dependencies
flutter pub get

# Run debug version
flutter run

# Build release APK for Android
flutter build apk --release

# Build release IPA for iOS
flutter build ios --release
```

## Testing
- **Framework**: Flutter Test
- **Test Location**: test/
- **Naming Convention**: *_test.dart
- **Run Command**:
```bash
flutter test
```

## Firebase Integration
- **Services**:
  - Firebase Analytics
  - Firebase Messaging
  - Firebase Remote Config
  - Firebase Core
- **Configuration Files**:
  - lib/firebase_options.dart
  - firebase.json
  - android/app/google-services.json (Android)
  - ios/Runner/GoogleService-Info.plist (iOS)

## Platform Configuration
- **Android**:
  - Minimum SDK: 24
  - Target SDK: 35
  - Kotlin: JVM target 17
  - Application ID: com.fifthlab.smerp_go
- **iOS**:
  - Managed via Podfile
  - Uses Swift
  - Application Bundle ID: Configured in Runner