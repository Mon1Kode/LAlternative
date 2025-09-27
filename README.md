# L Alternative

A Flutter application with comprehensive mood tracking and theme management features.

## Features

- **Home View**: Welcome screen with mood selection and tools management
- **Mood Selection**: Track your daily mood with 5 different options (love, happy, neutral, frowning, sad)
- **Profile Management**: User profile with theme switching capabilities
- **Dark/Light Theme**: Dynamic theme switching with persistence
- **Tools Management**: Customizable tools with edit mode functionality

## Getting Started

This project is a starting point for a Flutter application with integrated testing.

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (included with Flutter)
- iOS development: Xcode and CocoaPods
- Android development: Android Studio and Android SDK

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. For iOS, install CocoaPods dependencies:
   ```bash
   cd ios && pod install && cd ..
   ```

## Running the App

### Debug Mode
```bash
flutter run
```

### Release Mode
```bash
flutter run --release
```

### Specific Platform
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android
```

## Testing

This project includes comprehensive test coverage with unit tests and integration tests.

### Unit Tests

Run all unit tests:
```bash
flutter test test/unit/
```

Run specific unit test files:
```bash
# Mood selection logic tests
flutter test test/unit/mood_selection_logic_test.dart

# Home view component tests
flutter test test/unit/home_view_test.dart

# Home view sections rendering tests
flutter test test/unit/home_view_sections_test.dart
```

**Unit Test Coverage:**
- ✅ Mood selection business logic (16 tests)
- ✅ HomeView widget functionality (12 tests)  
- ✅ Section rendering and interactions (18 tests)
- ✅ Error handling and edge cases
- ✅ State management with SharedPreferences
- ✅ UI component behavior validation

### Integration/E2E Tests

Run all integration tests:
```bash
flutter test integration_test/
```

Run specific integration test:
```bash
flutter test integration_test/app_flow_test.dart
```

**For device testing (recommended for E2E):**
```bash
# Run on connected device/simulator
flutter drive --target=integration_test/app_flow_test.dart

# Run with specific device
flutter drive -d <device-id> --target=integration_test/app_flow_test.dart
```

**Integration Test Coverage:**
- ✅ Complete user journey: Open app → View home → Select mood → Open profile → Change theme
- ✅ Theme switching (light ↔ dark mode)
- ✅ Navigation flows (HomeView ↔ ProfileView)
- ✅ Mood selection persistence across navigation
- ✅ UI component interactions and state management
- ✅ Error handling and rapid navigation scenarios

### Test Results Summary

The project maintains **high test coverage** with:
- **46+ unit tests** covering business logic and UI components
- **8 integration tests** covering complete user workflows
- **Comprehensive error handling** and edge case testing
- **State persistence validation** (SharedPreferences, Riverpod)

### Running All Tests

Run complete test suite:
```bash
# Unit tests
flutter test test/

# Integration tests  
flutter test integration_test/

# All tests (run separately due to different environments)
flutter test test/ && flutter test integration_test/
```

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── src/
    ├── app.dart                       # Main app configuration
    ├── core/
    │   ├── components/                # Reusable UI components
    │   ├── provider/                  # Riverpod providers
    │   └── service/                   # Business logic services
    └── features/
        ├── home/
        │   └── view/home_view.dart    # Main home screen
        └── profile/
            └── view/profile_view.dart # Profile and settings

test/
├── unit/                              # Unit tests
│   ├── mood_selection_logic_test.dart # Business logic tests
│   ├── home_view_test.dart           # Widget tests
│   └── home_view_sections_test.dart  # Section rendering tests
└── widget_test.dart                   # Default Flutter test

integration_test/
└── app_flow_test.dart                 # E2E user journey tests
```

## Key Technologies

- **Flutter & Dart**: Cross-platform mobile development
- **Riverpod**: State management and dependency injection
- **SharedPreferences**: Local data persistence
- **Integration Test**: End-to-end testing framework
- **Flutter Test**: Unit and widget testing

## Development Workflow

1. **Make Changes**: Edit code in `lib/` directory
2. **Run Unit Tests**: `flutter test test/unit/` to verify logic
3. **Run Integration Tests**: `flutter test integration_test/` to verify user flows
4. **Manual Testing**: `flutter run` to test on device/simulator
5. **Build**: `flutter build` for production releases

## Troubleshooting

### iOS Build Issues
If you encounter iOS deployment target errors:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### Test Failures
- Ensure all dependencies are installed: `flutter pub get`
- Clear Flutter cache: `flutter clean`
- Restart your IDE/editor
- Check device/simulator is properly connected for integration tests

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.
