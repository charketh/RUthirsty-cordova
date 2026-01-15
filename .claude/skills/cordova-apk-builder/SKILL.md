---
name: cordova-apk-builder
description: Build and package Apache Cordova applications into Android APK files. Use this skill when you need to build Android APKs from Cordova projects, including both debug and release builds with proper signing configuration. Supports environment verification, build configuration management, and automated APK generation. Trigger this skill when users request to build APK, package Cordova app for Android, create Android build, generate APK, or prepare app for Android distribution.
---

# Cordova APK Builder

Build Apache Cordova applications into Android APK packages with support for debug and release builds.

## Quick Start

When a user requests to build an APK:

1. Verify the environment is ready:
   ```bash
   bash verify-env.sh
   ```

2. Build the APK using the build script:
   ```bash
   bash build-apk.sh
   ```

The script will automatically:
- Check for config.xml (Cordova project)
- Add Android platform if not present
- Build the appropriate APK type
- Output to build/ directory with meaningful filename

## Build Script Usage

The `build-apk.sh` script supports flexible options:

### Basic Usage

```bash
# Build debug APK in current directory
bash build-apk.sh

# Build release APK
bash build-apk.sh -t release

# Build for specific project directory
bash build-apk.sh -d ./RUthirsty -t debug

# Custom output directory
bash build-apk.sh -t release -o ./dist
```

### Options

- `-t, --type TYPE`: Build type - `debug` or `release` (default: debug)
- `-d, --dir DIR`: Cordova project directory (default: current directory)
- `-o, --output DIR`: Output directory for APK (default: ./build)
- `-h, --help`: Show help message

### Output Format

APKs are named with the pattern: `{AppName}-{Version}-{BuildType}.apk`

Example: `喝水打卡-1.0.0-debug.apk`

## Environment Verification

The `verify-env.sh` script checks all required tools and dependencies:

```bash
bash verify-env.sh
```

It verifies:
- Node.js (>= 16.x recommended)
- npm
- Cordova CLI
- Java Development Kit (JDK)
- Gradle (optional, Cordova uses wrapper)
- Android SDK and related tools
- ANDROID_HOME environment variable
- Connected devices (if available)
- Current project configuration

The script provides:
- Color-coded output (✓ success, ✗ error, ⚠ warning)
- Installation instructions for missing components
- Summary of checks passed/failed/warned
- Exit code 0 if ready, 1 if critical issues found

## Build Configuration

### For Debug Builds

Debug builds require no additional configuration. They are automatically signed with a debug keystore.

### For Release Builds

Release builds require signing configuration. Two approaches:

#### Option 1: build.json (Recommended)

Create `build.json` in the project root:

```json
{
  "android": {
    "release": {
      "keystore": "path/to/release.keystore",
      "storePassword": "",
      "alias": "your-key-alias",
      "password": "",
      "keystoreType": ""
    }
  }
}
```

Set passwords via environment variables for security:

```bash
export ANDROID_KEYSTORE_PASSWORD="store-password"
export ANDROID_KEY_PASSWORD="key-password"
```

#### Option 2: Environment Variables Only

```bash
export ANDROID_KEYSTORE="path/to/release.keystore"
export ANDROID_KEYSTORE_ALIAS="your-key-alias"
export ANDROID_KEYSTORE_PASSWORD="store-password"
export ANDROID_KEY_PASSWORD="key-password"
```

### Generating a Release Keystore

If the user needs a release keystore:

```bash
keytool -genkey -v \
  -keystore release.keystore \
  -alias my-release-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

**Important**: Warn users to:
- Store keystore securely (loss means cannot update app in Play Store)
- Never commit to version control
- Keep multiple backups
- Remember passwords

### Advanced Configuration

For detailed build configuration information including:
- Complete build.json examples
- Environment variable reference
- Gradle configuration
- config.xml Android settings
- Security best practices
- Troubleshooting common issues

See [references/build-config.md](references/build-config.md)

## Workflow Patterns

### Simple Build Request

User: "Build the APK"

Response:
1. Check if in Cordova project directory (look for config.xml)
2. Run build script with defaults: `bash build-apk.sh`
3. Report success with APK location and size

### Build with Specific Type

User: "Build a release APK"

Response:
1. Check for config.xml in current or nearby directories
2. Check if build.json exists (warn if not for release)
3. Run: `bash build-apk.sh -t release`
4. Report APK location

### First-Time Build

User: "How do I build an APK for my Cordova app?"

Response:
1. Run environment verification: `bash verify-env.sh`
2. If issues found, guide user through fixes
3. Explain debug vs release builds
4. Run appropriate build command
5. Explain output location and next steps

### Build with Signing Setup

User: "Build a signed release APK"

Response:
1. Check if build.json exists
2. If not, ask if user has a keystore:
   - If yes: Guide to create build.json
   - If no: Guide to generate keystore, then create build.json
3. Explain password security (environment variables)
4. Run release build
5. Verify APK signature if needed

## Common Issues and Solutions

### "Not a Cordova project"

Check for config.xml. If not found, ask user:
- Are they in correct directory?
- Is this a Cordova project?
- Should you help initialize a new project?

### "Android platform not found"

The build script automatically adds Android platform. If it fails:
- Check ANDROID_HOME is set
- Verify Android SDK is installed
- Run verify-env.sh to diagnose

### "Build failed" with unclear error

1. Enable verbose logging: `cordova build android --release --verbose`
2. Check common issues:
   - ANDROID_HOME not set
   - JAVA_HOME not set
   - Insufficient heap memory
   - Network issues downloading Gradle dependencies

### Release build produces unsigned APK

1. Verify build.json exists and is correct
2. Check environment variables are set
3. Verify keystore path is correct
4. Test keystore access: `keytool -list -v -keystore path/to/keystore`

## File Locations

After successful build, APKs are located at:

**Debug**: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`
**Release**: `platforms/android/app/build/outputs/apk/release/app-release.apk`

The build script copies APKs to the output directory with meaningful names.

## Notes

- Always use the build script instead of calling cordova directly - it provides better error handling and user experience
- Run environment verification first when helping new users
- For security, never include actual passwords in examples or suggestions
- When in doubt about project structure, search for config.xml to locate the Cordova project root
- APK size typically ranges from 3-50 MB depending on app complexity and assets
