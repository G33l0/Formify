# Formify - Detailed Setup Guide

This guide will walk you through setting up the Formify project from scratch.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Development Environment Setup](#development-environment-setup)
3. [Project Setup](#project-setup)
4. [Running the App](#running-the-app)
5. [Building for Release](#building-for-release)
6. [Monetization Setup](#monetization-setup)
7. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software

1. **Flutter SDK** (3.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your PATH

2. **Dart SDK** (comes with Flutter)
   - Version 3.0 or higher

3. **IDE** (choose one):
   - **Android Studio** (recommended)
     - Download from: https://developer.android.com/studio
     - Install Flutter and Dart plugins
   - **VS Code**
     - Download from: https://code.visualstudio.com/
     - Install Flutter and Dart extensions

4. **Platform-Specific Tools**:
   - **For Android**:
     - Android Studio
     - Android SDK (API 21 or higher)
     - Java Development Kit (JDK) 11 or higher
   - **For iOS** (macOS only):
     - Xcode 13 or higher
     - CocoaPods
     - Valid Apple Developer account (for deployment)

### Verify Installation

Run these commands to verify your setup:

```bash
flutter doctor
```

This should show checkmarks for:
- ✓ Flutter
- ✓ Android toolchain
- ✓ Xcode (macOS only)
- ✓ VS Code or Android Studio
- ✓ Connected device or emulator

## Development Environment Setup

### Android Studio Setup

1. **Install Flutter Plugin**
   - Open Android Studio
   - Go to: File → Settings → Plugins (Windows/Linux) or Android Studio → Preferences → Plugins (macOS)
   - Search for "Flutter"
   - Click Install
   - Restart Android Studio

2. **Install Dart Plugin**
   - Same as above, search for "Dart"

3. **Configure Android SDK**
   - Go to: File → Settings → Appearance & Behavior → System Settings → Android SDK
   - Install SDK Platforms:
     - Android 13.0 (API 33)
     - Android 12.0 (API 31)
   - Install SDK Tools:
     - Android SDK Build-Tools
     - Android SDK Platform-Tools
     - Android Emulator

4. **Create Android Emulator**
   - Open AVD Manager
   - Create Virtual Device
   - Choose a device (Pixel 6 recommended)
   - Select system image (Android 13 recommended)
   - Finish setup

### VS Code Setup

1. **Install Extensions**
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Install:
     - Flutter (by Dart Code)
     - Dart (by Dart Code)

2. **Configure Flutter SDK Path**
   - Open Command Palette (Ctrl+Shift+P)
   - Type "Flutter: Change SDK"
   - Select your Flutter SDK location

### iOS Setup (macOS Only)

1. **Install Xcode**
   ```bash
   xcode-select --install
   ```

2. **Install CocoaPods**
   ```bash
   sudo gem install cocoapods
   ```

3. **Accept Xcode License**
   ```bash
   sudo xcodebuild -license accept
   ```

4. **Create iOS Simulator**
   - Open Xcode
   - Go to Xcode → Preferences → Components
   - Download iOS simulators

## Project Setup

### 1. Clone or Download Project

```bash
git clone https://github.com/yourusername/formify.git
cd formify
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will install all packages listed in `pubspec.yaml`.

### 3. Run Code Generation

The project uses code generation for Riverpod and Hive:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

If you make changes to generated code, run:
```bash
flutter pub run build_runner watch
```

### 4. Create Required Directories

Create the assets directories:

```bash
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/fonts
mkdir -p assets/templates
```

### 5. Add Assets

#### Fonts
Download Poppins font from Google Fonts and place in `assets/fonts/`:
- Poppins-Regular.ttf
- Poppins-Medium.ttf
- Poppins-SemiBold.ttf
- Poppins-Bold.ttf

Or download from: https://fonts.google.com/specimen/Poppins

#### App Icon
Create or add your app icon to `assets/icons/`

For automated icon generation, use `flutter_launcher_icons`:
```bash
flutter pub add --dev flutter_launcher_icons
```

Create `flutter_launcher_icons.yaml` and run:
```bash
flutter pub run flutter_launcher_icons:main
```

### 6. Configure Platform-Specific Files

#### Android Configuration

**android/app/build.gradle**
```gradle
android {
    compileSdkVersion 33

    defaultConfig {
        applicationId "com.yourcompany.formify"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
```

**android/app/src/main/AndroidManifest.xml**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.yourcompany.formify">

    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

    <application
        android:label="Formify"
        android:icon="@mipmap/ic_launcher">
        <!-- ... -->
    </application>
</manifest>
```

#### iOS Configuration (if building for iOS)

**ios/Runner/Info.plist**
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to save and share PDFs</string>
<key>NSCameraUsageDescription</key>
<string>We need camera access to upload logos</string>
```

### 7. Update Constants

Edit `lib/core/constants/app_constants.dart` with your information:

```dart
// URLs
static const String privacyPolicyUrl = 'https://yourwebsite.com/privacy';
static const String termsOfServiceUrl = 'https://yourwebsite.com/terms';
static const String supportEmail = 'support@yourapp.com';
```

## Running the App

### Check Connected Devices

```bash
flutter devices
```

### Run on Emulator/Simulator

1. Start your emulator/simulator
2. Run:
   ```bash
   flutter run
   ```

### Run with Hot Reload

Hot reload is enabled by default:
- Press `r` to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Run in Release Mode

```bash
flutter run --release
```

### Run on Specific Device

```bash
flutter run -d <device_id>
```

## Building for Release

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Signing Android App

1. **Create Keystore**
   ```bash
   keytool -genkey -v -keystore ~/formify-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias formify
   ```

2. **Create key.properties**
   Create `android/key.properties`:
   ```
   storePassword=<password>
   keyPassword=<password>
   keyAlias=formify
   storeFile=<path-to-keystore>
   ```

3. **Configure build.gradle**
   Edit `android/app/build.gradle`:
   ```gradle
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

   android {
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

### iOS Build

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode and archive.

## Monetization Setup

### Google AdMob

1. **Create AdMob Account**
   - Go to https://admob.google.com
   - Sign in with Google account
   - Create new app

2. **Get Ad Unit IDs**
   - Create ad units for:
     - Banner ads
     - Interstitial ads
   - Copy the Ad Unit IDs

3. **Update Constants**
   Edit `lib/core/constants/app_constants.dart`:
   ```dart
   // Replace with your actual Ad Unit IDs
   static const String androidBannerAdId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
   static const String iosBannerAdId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
   ```

4. **Update AndroidManifest.xml**
   Add inside `<application>` tag:
   ```xml
   <meta-data
       android:name="com.google.android.gms.ads.APPLICATION_ID"
       android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
   ```

5. **Update Info.plist** (iOS)
   ```xml
   <key>GADApplicationIdentifier</key>
   <string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
   ```

### In-App Purchases

#### Android (Google Play)

1. **Google Play Console**
   - Create app in Play Console
   - Go to Monetize → Products → In-app products
   - Create subscription products:
     - `formify_premium_monthly`
     - `formify_premium_yearly`

2. **Update Product IDs**
   In `app_constants.dart`:
   ```dart
   static const String premiumProductId = 'formify_premium_monthly';
   static const String premiumYearlyProductId = 'formify_premium_yearly';
   ```

#### iOS (App Store)

1. **App Store Connect**
   - Create app in App Store Connect
   - Go to Features → In-App Purchases
   - Create auto-renewable subscriptions
   - Use same product IDs as Android

2. **Update Bundle Identifier**
   In Xcode, set bundle identifier to match App Store Connect

## Troubleshooting

### Common Issues

**1. "No connected devices"**
```bash
# Check devices
flutter devices

# For Android, start emulator
flutter emulators --launch <emulator_id>

# For iOS
open -a Simulator
```

**2. "Gradle build failed"**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**3. "CocoaPods not installed"**
```bash
sudo gem install cocoapods
cd ios
pod install
```

**4. "Build runner errors"**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**5. "Permission denied" errors**
```bash
# Android
flutter clean
cd android
./gradlew clean
cd ..

# iOS
cd ios
rm -rf Pods
rm Podfile.lock
pod install
```

### Performance Issues

**Enable Performance Overlay**
```bash
flutter run --profile
```

**Analyze App Size**
```bash
flutter build apk --analyze-size
```

### Debugging

**Enable Debug Logging**
```dart
// In main.dart
import 'package:flutter/foundation.dart';

void main() {
  if (kDebugMode) {
    print('Running in debug mode');
  }
  runApp(MyApp());
}
```

**Check Database**
```bash
# Find database location
adb shell
cd /data/data/com.yourcompany.formify/databases
sqlite3 formify.db
.tables
.exit
```

## Next Steps

1. **Customize Branding**
   - Update colors in `app_theme.dart`
   - Add your logo
   - Update app name

2. **Test Thoroughly**
   - Test on real devices
   - Test all document types
   - Test premium features
   - Test PDF generation

3. **Prepare for Launch**
   - Create screenshots
   - Write app description
   - Prepare privacy policy
   - Set up support email
   - Test payment flow

4. **Deploy**
   - Submit to Google Play
   - Submit to App Store
   - Set up app analytics
   - Monitor crash reports

## Resources

- Flutter Documentation: https://flutter.dev/docs
- Riverpod Documentation: https://riverpod.dev
- Flutter Packages: https://pub.dev
- Flutter Community: https://flutter.dev/community

## Support

If you encounter issues:
1. Check the troubleshooting section
2. Search existing issues on GitHub
3. Open a new issue with details
4. Contact support at your-email@example.com

---

**Happy Coding! 🚀**
