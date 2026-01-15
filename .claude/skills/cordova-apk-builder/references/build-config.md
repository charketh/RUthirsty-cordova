# Cordova Build Configuration Reference

This document provides detailed information about configuring Cordova builds, especially for release APKs with signing configurations.

## Table of Contents

1. [build.json Configuration](#buildjson-configuration)
2. [Environment Variables](#environment-variables)
3. [Keystore Generation](#keystore-generation)
4. [Common Build Options](#common-build-options)
5. [Troubleshooting](#troubleshooting)

## build.json Configuration

The `build.json` file contains platform-specific build configurations, including signing information for release builds.

### Basic Structure

```json
{
  "android": {
    "debug": {
      "keystore": "debug.keystore",
      "storePassword": "android",
      "alias": "androiddebugkey",
      "password": "android",
      "keystoreType": ""
    },
    "release": {
      "keystore": "release.keystore",
      "storePassword": "your-store-password",
      "alias": "your-key-alias",
      "password": "your-key-password",
      "keystoreType": ""
    }
  }
}
```

### Using Environment Variables

For security, avoid hardcoding passwords in build.json. Use environment variables instead:

```json
{
  "android": {
    "release": {
      "keystore": "release.keystore",
      "storePassword": "",
      "alias": "my-release-key",
      "password": "",
      "keystoreType": ""
    }
  }
}
```

Set passwords via command line:

```bash
export ANDROID_KEYSTORE_PASSWORD="your-store-password"
export ANDROID_KEY_PASSWORD="your-key-password"
cordova build android --release
```

### Complete Example with All Options

```json
{
  "android": {
    "release": {
      "keystore": "../my-release-key.keystore",
      "storePassword": "storepass123",
      "alias": "my-release-key",
      "password": "keypass123",
      "keystoreType": "",
      "packageType": "apk"
    }
  }
}
```

## Environment Variables

Cordova recognizes these environment variables for Android builds:

### SDK and Tools

- `ANDROID_HOME` or `ANDROID_SDK_ROOT`: Path to Android SDK
- `JAVA_HOME`: Path to JDK installation
- `GRADLE_HOME`: Path to Gradle installation (optional)

### Signing Configuration

- `ANDROID_KEYSTORE_PASSWORD`: Keystore password
- `ANDROID_KEY_PASSWORD`: Key password
- `ANDROID_KEYSTORE_ALIAS`: Key alias
- `ANDROID_KEYSTORE`: Path to keystore file

### Build Options

- `CORDOVA_ANDROID_GRADLE_DISTRIBUTION_URL`: Custom Gradle distribution URL

## Keystore Generation

### Generate a Release Keystore

```bash
keytool -genkey -v \
  -keystore my-release-key.keystore \
  -alias my-release-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

This command will prompt you for:
- Keystore password
- Key password
- Your name
- Organizational unit
- Organization
- City/Locality
- State/Province
- Country code

### Important Notes

- **Store your keystore safely**: If you lose it, you cannot update your app in Google Play
- **Remember your passwords**: You'll need them for every release build
- **Backup your keystore**: Keep multiple secure copies
- **Never commit keystores to version control**: Add to .gitignore

### View Keystore Information

```bash
keytool -list -v -keystore my-release-key.keystore -alias my-release-key
```

### Verify APK Signature

```bash
# Using jarsigner
jarsigner -verify -verbose -certs app-release.apk

# Using apksigner (from Android SDK build-tools)
apksigner verify --verbose app-release.apk
```

## Common Build Options

### Build Types

```bash
# Debug build (no signing required)
cordova build android --debug

# Release build (requires signing configuration)
cordova build android --release
```

### Build Options

```bash
# Build APK only (not AAB)
cordova build android --release -- --packageType=apk

# Build with specific Gradle task
cordova build android --release -- --gradleArg=--no-daemon

# Build with specific Android SDK version
cordova build android --release -- --target=android-34

# Clean build
cordova clean android
cordova build android --release
```

### Gradle Properties

Create `platforms/android/gradle.properties` for additional configuration:

```properties
# Increase Java heap size for builds
org.gradle.jvmargs=-Xmx4096m

# Enable Gradle daemon
org.gradle.daemon=true

# Enable parallel builds
org.gradle.parallel=true

# Use AndroidX
android.useAndroidX=true
android.enableJetifier=true
```

## config.xml Android Settings

Configure Android-specific settings in your `config.xml`:

```xml
<platform name="android">
    <!-- Minimum SDK version -->
    <preference name="android-minSdkVersion" value="24" />

    <!-- Target SDK version -->
    <preference name="android-targetSdkVersion" value="34" />

    <!-- Build tools version -->
    <preference name="android-buildToolsVersion" value="34.0.0" />

    <!-- Gradle version -->
    <preference name="GradleVersion" value="8.0" />

    <!-- Android Gradle Plugin version -->
    <preference name="AndroidGradlePluginVersion" value="8.0.0" />

    <!-- Kotlin version -->
    <preference name="GradlePluginKotlinVersion" value="1.8.0" />

    <!-- Enable AndroidX -->
    <preference name="AndroidXEnabled" value="true" />
</platform>
```

## Troubleshooting

### Common Issues

#### Build fails with "SDK location not found"

**Solution**: Set ANDROID_HOME or ANDROID_SDK_ROOT environment variable:

```bash
export ANDROID_HOME=/path/to/android/sdk
export ANDROID_SDK_ROOT=/path/to/android/sdk
```

#### Build fails with "JAVA_HOME not set"

**Solution**: Set JAVA_HOME to your JDK installation:

```bash
export JAVA_HOME=/path/to/jdk
```

#### Gradle daemon issues

**Solution**: Kill gradle daemons and rebuild:

```bash
./gradlew --stop
cordova clean android
cordova build android --release
```

#### Out of memory during build

**Solution**: Increase Gradle heap size in `platforms/android/gradle.properties`:

```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=1024m
```

#### Wrong keystore password

**Error**: `Failed to read key from keystore`

**Solution**: Verify keystore password and alias:

```bash
keytool -list -v -keystore my-release-key.keystore -alias my-release-key
```

#### APK not signed properly

**Solution**: Ensure build.json has correct signing configuration and rebuild:

```bash
cordova clean android
cordova build android --release
```

### Verify Build Configuration

Check which signing configuration is being used:

```bash
# Enable verbose logging
cordova build android --release --verbose
```

### Debug Build Issues

```bash
# Clean all build artifacts
cordova clean android
rm -rf platforms/android/app/build

# Rebuild with verbose output
cordova build android --release --verbose
```

## Security Best Practices

1. **Never commit build.json with passwords** to version control
2. **Use environment variables** for sensitive information
3. **Store keystores securely** outside of project directory
4. **Backup keystores** in multiple secure locations
5. **Use different keystores** for debug and release builds
6. **Rotate signing keys** if compromised (requires Google Play app signing)
7. **Limit access** to keystore files and passwords

## Additional Resources

- [Cordova Android Platform Guide](https://cordova.apache.org/docs/en/latest/guide/platforms/android/)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [Google Play App Signing](https://developer.android.com/studio/publish/app-signing#app-signing-google-play)
