#!/bin/bash
# Cordova APK Build Script
# Builds debug or release APK for Android

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
BUILD_TYPE="debug"
CORDOVA_DIR=""
OUTPUT_DIR=""

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to show usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Build Cordova Android APK

OPTIONS:
    -t, --type TYPE         Build type: debug or release (default: debug)
    -d, --dir DIR          Cordova project directory (default: current directory)
    -o, --output DIR       Output directory for APK (default: ./build)
    -h, --help             Show this help message

EXAMPLES:
    $0                                    # Build debug APK in current directory
    $0 -t release                         # Build release APK
    $0 -d ./RUthirsty -t debug           # Build debug APK for specific project
    $0 -t release -o ./output            # Build release APK to custom output directory

EOF
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        -d|--dir)
            CORDOVA_DIR="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate build type
if [[ "$BUILD_TYPE" != "debug" && "$BUILD_TYPE" != "release" ]]; then
    print_error "Invalid build type: $BUILD_TYPE. Must be 'debug' or 'release'"
    exit 1
fi

# Set Cordova directory
if [[ -z "$CORDOVA_DIR" ]]; then
    CORDOVA_DIR="$(pwd)"
fi

# Check if directory exists
if [[ ! -d "$CORDOVA_DIR" ]]; then
    print_error "Directory not found: $CORDOVA_DIR"
    exit 1
fi

# Check if it's a Cordova project
if [[ ! -f "$CORDOVA_DIR/config.xml" ]]; then
    print_error "Not a Cordova project: config.xml not found in $CORDOVA_DIR"
    exit 1
fi

# Set output directory
if [[ -z "$OUTPUT_DIR" ]]; then
    OUTPUT_DIR="$CORDOVA_DIR/build"
fi

print_info "Starting Cordova APK build..."
print_info "Build type: $BUILD_TYPE"
print_info "Project directory: $CORDOVA_DIR"
print_info "Output directory: $OUTPUT_DIR"

# Change to Cordova directory
cd "$CORDOVA_DIR"

# Check if Android platform is added
if [[ ! -d "platforms/android" ]]; then
    print_warning "Android platform not found. Adding Android platform..."
    cordova platform add android
    if [[ $? -ne 0 ]]; then
        print_error "Failed to add Android platform"
        exit 1
    fi
    print_info "Android platform added successfully"
fi

# Build the APK
print_info "Building $BUILD_TYPE APK..."

if [[ "$BUILD_TYPE" == "debug" ]]; then
    cordova build android --debug
    APK_SOURCE="platforms/android/app/build/outputs/apk/debug/app-debug.apk"
else
    # Check if build.json exists for release builds
    if [[ ! -f "build.json" ]]; then
        print_warning "build.json not found. Release APK will be unsigned."
        print_warning "Create build.json with signing configuration for signed release builds."
    fi
    cordova build android --release
    APK_SOURCE="platforms/android/app/build/outputs/apk/release/app-release.apk"
fi

# Check if build was successful
if [[ ! -f "$APK_SOURCE" ]]; then
    print_error "Build failed: APK not found at $APK_SOURCE"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Get app name and version from config.xml
APP_NAME=$(grep -oP '(?<=<name>)[^<]+' config.xml | head -1 | tr ' ' '-')
APP_VERSION=$(grep -oP '(?<=version=")[^"]+' config.xml | head -1)

# Copy APK to output directory with meaningful name
OUTPUT_APK="$OUTPUT_DIR/${APP_NAME}-${APP_VERSION}-${BUILD_TYPE}.apk"
cp "$APK_SOURCE" "$OUTPUT_APK"

print_info "Build completed successfully!"
print_info "APK location: $OUTPUT_APK"

# Get APK size
APK_SIZE=$(du -h "$OUTPUT_APK" | cut -f1)
print_info "APK size: $APK_SIZE"

# Show APK info
print_info ""
print_info "=== APK Information ==="
print_info "Name: $APP_NAME"
print_info "Version: $APP_VERSION"
print_info "Build Type: $BUILD_TYPE"
print_info "File: $OUTPUT_APK"
print_info "======================="

exit 0
