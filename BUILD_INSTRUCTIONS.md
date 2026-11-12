# Smart Scanner PDF - Android & iOS Build Instructions

This document provides step-by-step instructions to compile and build the Android APK and iOS application.

---

## 1. Prerequisites

- **Flutter SDK**: >= 3.2.0 installed (`flutter --version`)
- **Android Studio**: With Android SDK & NDK installed (API level 24+)
- **Xcode**: 15.0+ (for iOS builds, macOS required)
- **CocoaPods**: `sudo gem install cocoapods`

---

## 2. Setup Dependencies

```bash
# 1. Navigate to the project root
cd smart_scanner_pdf

# 2. Get all Flutter packages
flutter pub get
```

---

## 3. Android APK Build (Release)

### Option A: Build Universal Release APK (Ready to install)
```bash
flutter build apk --release
```
Output path: `build/app/outputs/flutter-apk/app-release.apk`

### Option B: Build Split-per-ABI APKs (Smaller file size)
```bash
flutter build apk --split-per-abi --release
```
Outputs:
- `app-armeabi-v7a-release.apk` (~18 MB)
- `app-arm64-v8a-release.apk` (~21 MB)
- `app-x86_64-release.apk`

### Option C: Google Play App Bundle (AAB for Store Publishing)
```bash
flutter build appbundle --release
```
Output path: `build/app/outputs/bundle/release/app-release.aab`

---

## 4. iOS IPA Build (Release)

### Step 1: Install CocoaPods
```bash
cd ios
pod install --repo-update
cd ..
```

### Step 2: Open Xcode to configure Signing & Team
```bash
open ios/Runner.xcworkspace
```
- Select the **Runner** target.
- Under **Signing & Capabilities**, check **Automatically manage signing**.
- Select your Apple Developer Team.
- Ensure `NSCameraUsageDescription` is present in `Info.plist`.

### Step 3: Build the IPA
```bash
# Build the iOS archive
flutter build ipa --release
```
Output path: `build/ios/archive/Runner.xcarchive` and `build/ios/ipa/`.

---

## 5. Testing with Connected Devices

```bash
# Run on connected Android phone
```
