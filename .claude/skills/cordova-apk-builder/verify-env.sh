#!/bin/bash
# Cordova Android Environment Verification Script
# Checks if all required tools and dependencies are installed

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓${NC} $1"
    ((CHECKS_PASSED++))
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((CHECKS_FAILED++))
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((CHECKS_WARNING++))
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Check Node.js
check_node() {
    print_header "Node.js"
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        print_success "Node.js is installed: $NODE_VERSION"

        # Check if version is >= 16
        NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
        if [[ $NODE_MAJOR -ge 16 ]]; then
            print_success "Node.js version is compatible (>= 16.x)"
        else
            print_warning "Node.js version should be >= 16.x for best compatibility"
        fi
    else
        print_error "Node.js is not installed"
        print_info "Install from: https://nodejs.org/"
    fi
}

# Check npm
check_npm() {
    print_header "npm"
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        print_success "npm is installed: $NPM_VERSION"
    else
        print_error "npm is not installed"
        print_info "npm usually comes with Node.js"
    fi
}

# Check Cordova
check_cordova() {
    print_header "Cordova"
    if command -v cordova &> /dev/null; then
        CORDOVA_VERSION=$(cordova --version)
        print_success "Cordova is installed: $CORDOVA_VERSION"
    else
        print_error "Cordova is not installed"
        print_info "Install with: npm install -g cordova"
    fi
}

# Check Java/JDK
check_java() {
    print_header "Java Development Kit (JDK)"
    if command -v java &> /dev/null; then
        JAVA_VERSION=$(java -version 2>&1 | head -n 1)
        print_success "Java is installed: $JAVA_VERSION"

        # Check JAVA_HOME
        if [[ -n "$JAVA_HOME" ]]; then
            print_success "JAVA_HOME is set: $JAVA_HOME"
        else
            print_warning "JAVA_HOME environment variable is not set"
            print_info "Set JAVA_HOME to your JDK installation path"
        fi
    else
        print_error "Java is not installed"
        print_info "Install JDK 11 or higher from: https://adoptium.net/"
    fi
}

# Check Gradle
check_gradle() {
    print_header "Gradle"
    if command -v gradle &> /dev/null; then
        GRADLE_VERSION=$(gradle --version | grep "Gradle" | head -n 1)
        print_success "Gradle is installed: $GRADLE_VERSION"
    else
        print_warning "Gradle is not installed globally"
        print_info "Cordova will use its own Gradle wrapper (this is fine)"
    fi
}

# Check Android SDK
check_android_sdk() {
    print_header "Android SDK"

    # Check ANDROID_HOME or ANDROID_SDK_ROOT
    if [[ -n "$ANDROID_HOME" ]]; then
        print_success "ANDROID_HOME is set: $ANDROID_HOME"

        # Check if directory exists
        if [[ -d "$ANDROID_HOME" ]]; then
            print_success "Android SDK directory exists"

            # Check for platform-tools
            if [[ -d "$ANDROID_HOME/platform-tools" ]]; then
                print_success "Android platform-tools found"
            else
                print_warning "Android platform-tools not found in $ANDROID_HOME"
            fi

            # Check for build-tools
            if [[ -d "$ANDROID_HOME/build-tools" ]]; then
                print_success "Android build-tools found"
                # List available versions
                BUILD_TOOLS_VERSIONS=$(ls "$ANDROID_HOME/build-tools" 2>/dev/null | tr '\n' ', ' | sed 's/,$//')
                if [[ -n "$BUILD_TOOLS_VERSIONS" ]]; then
                    print_info "Available build-tools versions: $BUILD_TOOLS_VERSIONS"
                fi
            else
                print_warning "Android build-tools not found in $ANDROID_HOME"
            fi

            # Check for platforms
            if [[ -d "$ANDROID_HOME/platforms" ]]; then
                print_success "Android platforms found"
                # List available platforms
                PLATFORMS=$(ls "$ANDROID_HOME/platforms" 2>/dev/null | tr '\n' ', ' | sed 's/,$//')
                if [[ -n "$PLATFORMS" ]]; then
                    print_info "Available platforms: $PLATFORMS"
                fi
            else
                print_warning "Android platforms not found in $ANDROID_HOME"
            fi
        else
            print_error "Android SDK directory does not exist: $ANDROID_HOME"
        fi
    elif [[ -n "$ANDROID_SDK_ROOT" ]]; then
        print_success "ANDROID_SDK_ROOT is set: $ANDROID_SDK_ROOT"
        print_info "Consider also setting ANDROID_HOME for better compatibility"
    else
        print_error "ANDROID_HOME or ANDROID_SDK_ROOT is not set"
        print_info "Install Android SDK and set ANDROID_HOME environment variable"
        print_info "Download from: https://developer.android.com/studio"
    fi

    # Check for adb
    if command -v adb &> /dev/null; then
        ADB_VERSION=$(adb --version | head -n 1)
        print_success "adb is available: $ADB_VERSION"
    else
        print_warning "adb is not in PATH"
        print_info "Add \$ANDROID_HOME/platform-tools to your PATH"
    fi
}

# Check for connected devices
check_devices() {
    print_header "Connected Devices"
    if command -v adb &> /dev/null; then
        DEVICES=$(adb devices | grep -v "List of devices" | grep -v "^$" | wc -l)
        if [[ $DEVICES -gt 0 ]]; then
            print_success "$DEVICES device(s) connected"
            adb devices | grep -v "List of devices" | grep -v "^$" | while read line; do
                print_info "  $line"
            done
        else
            print_warning "No devices connected"
            print_info "Connect a device or start an emulator to test your app"
        fi
    else
        print_warning "Cannot check devices (adb not available)"
    fi
}

# Check current project
check_project() {
    print_header "Current Project"
    if [[ -f "config.xml" ]]; then
        print_success "Cordova project detected (config.xml found)"

        # Get app info
        APP_NAME=$(grep -oP '(?<=<name>)[^<]+' config.xml 2>/dev/null | head -1)
        APP_VERSION=$(grep -oP '(?<=version=")[^"]+' config.xml 2>/dev/null | head -1)
        APP_ID=$(grep -oP '(?<=id=")[^"]+' config.xml 2>/dev/null | head -1)

        if [[ -n "$APP_NAME" ]]; then
            print_info "App name: $APP_NAME"
        fi
        if [[ -n "$APP_VERSION" ]]; then
            print_info "App version: $APP_VERSION"
        fi
        if [[ -n "$APP_ID" ]]; then
            print_info "App ID: $APP_ID"
        fi

        # Check if Android platform is added
        if [[ -d "platforms/android" ]]; then
            print_success "Android platform is added"
        else
            print_warning "Android platform is not added"
            print_info "Add with: cordova platform add android"
        fi

        # Check for build.json
        if [[ -f "build.json" ]]; then
            print_success "build.json found (signing configuration available)"
        else
            print_warning "build.json not found"
            print_info "Create build.json for release signing configuration"
        fi
    else
        print_warning "Not in a Cordova project directory"
        print_info "Navigate to your Cordova project or create one with: cordova create myapp"
    fi
}

# Main execution
main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Cordova Android Environment Verification             ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"

    check_node
    check_npm
    check_cordova
    check_java
    check_gradle
    check_android_sdk
    check_devices
    check_project

    # Summary
    print_header "Summary"
    echo -e "${GREEN}Passed:${NC}  $CHECKS_PASSED"
    echo -e "${YELLOW}Warnings:${NC} $CHECKS_WARNING"
    echo -e "${RED}Failed:${NC}  $CHECKS_FAILED"
    echo ""

    if [[ $CHECKS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}✓ Your environment is ready for Cordova Android development!${NC}"
        exit 0
    else
        echo -e "${RED}✗ Please fix the failed checks before building APKs${NC}"
        exit 1
    fi
}

# Run main function
main
