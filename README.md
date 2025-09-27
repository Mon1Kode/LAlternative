# L Alternative

A Flutter application with comprehensive mood tracking and theme management features.

## Features

- **Home View**: Welcome screen with mood selection and tools management
- **Mood Selection**: Track your daily mood with 5 different options (love, happy, neutral, frowning, sad)
- **Profile Management**: User profile with theme switching capabilities
- **Dark/Light Theme**: Dynamic theme switching with persistence
- **Tools Management**: Customizable tools with edit mode functionality

## Getting Started

This project is a starting point for a Flutter application with integrated testing and automated code quality checks.

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (included with Flutter)
- iOS development: Xcode and CocoaPods
- Android development: Android Studio and Android SDK
- Python 3.6+ (for pre-commit hooks)

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

4. Install pre-commit hooks:

   ```bash
   pip install pre-commit
   pre-commit install
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

## Code Quality & Pre-commit Hooks

This project uses automated code quality checks via pre-commit hooks to maintain high standards and prevent common issues.

### Pre-commit Setup

The project includes comprehensive pre-commit hooks that automatically run when you commit code:

```bash
# Install pre-commit (one-time setup)
pip install pre-commit
pre-commit install

# Hooks run automatically on commit
git add .
git commit -m "feat: your changes"

# Run hooks manually on all files
pre-commit run --all-files

# Run specific hook
pre-commit run dart-format
```

### Automated Checks

**Code Quality:**

- ✅ **Dart Formatting**: Auto-formats code with 80-character line limit
- ✅ **Flutter Analysis**: Static code analysis with fatal warnings
- ✅ **Unit Tests**: Runs comprehensive test suite automatically
- ✅ **Import Organization**: Ensures proper Dart import structure

**Security & Best Practices:**

- ✅ **Secret Detection**: Prevents committing API keys, passwords, tokens
- ✅ **Debug Code Prevention**: Blocks TODO, FIXME, print statements, debugPrint
- ✅ **Build Artifact Prevention**: Stops generated files (*.g.dart) from being committed

**Performance & Mobile Optimization:**

- ✅ **Image Size Validation**: Ensures images are under 500KB for mobile performance
- ✅ **Asset Reference Validation**: Verifies all referenced assets exist
- ✅ **Large File Prevention**: Blocks files over 1MB from being committed

**File Standards:**

- ✅ **Trailing Whitespace**: Removes unnecessary whitespace
- ✅ **Line Endings**: Ensures consistent LF line endings
- ✅ **YAML/JSON Validation**: Validates configuration files
- ✅ **Merge Conflict Detection**: Prevents incomplete merges

### Commit Message Standards

The project enforces conventional commit messages for better changelog generation:

```bash
# ✅ Good examples
git commit -m "feat: add dark theme toggle functionality"
git commit -m "fix: resolve flutter module dependency issue"
git commit -m "test: add comprehensive integration tests"
git commit -m "docs: update README with pre-commit setup"
git commit -m "refactor: improve mood selection state management"
git commit -m "perf: optimize image asset loading"

# ❌ Will be rejected
git commit -m "updated stuff"
git commit -m "WIP changes"
git commit -m "fixes"
```

**Commit Types:**

- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `test`: Adding or updating tests
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `style`: Code style changes
- `ci`: CI/CD changes

### Bypassing Hooks (Emergency Only)

In rare cases, you can bypass hooks:

```bash
# Skip all hooks (use sparingly)
git commit --no-verify -m "hotfix: emergency fix"

# Skip specific hook
SKIP=flutter-test git commit -m "docs: update README"
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
- **Automated quality gates** via pre-commit hooks

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
