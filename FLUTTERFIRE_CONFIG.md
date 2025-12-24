# FlutterFire Configuration (for reference)

This file contains the FlutterFire configuration that was previously in firebase.json.
The "flutter" property is not recognized by Firebase CLI but is used by FlutterFire CLI.

## Project Configuration

**Project ID**: l-alternative-bf37d

### Android
- **App ID**: 1:163109185356:android:f5fe07168e0f2acbd791e9
- **Config File**: android/app/google-services.json

### iOS
- **App ID**: 1:163109185356:ios:76efeacb47644c79d791e9
- **Config File**: ios/Runner/GoogleService-Info.plist
- **Upload Debug Symbols**: false

### Dart/Flutter
- **Options File**: lib/firebase_options.dart
- **Android Config**: 1:163109185356:android:f5fe07168e0f2acbd791e9
- **iOS Config**: 1:163109185356:ios:76efeacb47644c79d791e9

## Regenerating Firebase Options

If you need to regenerate your Firebase configuration files, use:

```bash
# Using FlutterFire CLI
flutterfire configure --project=l-alternative-bf37d

# Or manually download:
# - google-services.json from Firebase Console > Android app
# - GoogleService-Info.plist from Firebase Console > iOS app
```

## Note

The firebase.json file has been updated to use standard Firebase CLI configuration.
Your existing google-services.json and GoogleService-Info.plist files remain intact.
