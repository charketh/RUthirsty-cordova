#!/bin/bash

set -e  # 遇到错误立即退出

# ===================================
# 颜色定义
# ===================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ===================================
# 打印函数
# ===================================
print_header() {
    echo -e "${BLUE}======================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}======================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# ===================================
# 检查环境
# ===================================
check_environment() {
    print_header "检查环境依赖"

    # 检查 Node.js
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        print_success "Node.js 已安装: $NODE_VERSION"
    else
        print_error "Node.js 未安装"
        print_info "请访问 https://nodejs.org/ 下载安装"
        exit 1
    fi

    # 检查 npm
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm -v)
        print_success "npm 已安装: $NPM_VERSION"
    else
        print_error "npm 未安装"
        exit 1
    fi

    # 检查 Java
    if command -v java &> /dev/null; then
        JAVA_VERSION=$(java -version 2>&1 | head -n 1)
        print_success "Java 已安装: $JAVA_VERSION"
    else
        print_warning "Java 未安装，Android 构建可能失败"
        print_info "建议安装 OpenJDK 8 或更高版本"
    fi

    # 检查 Android SDK
    if [ -n "$ANDROID_HOME" ] || [ -n "$ANDROID_SDK_ROOT" ]; then
        print_success "Android SDK 环境变量已设置"
    else
        print_warning "未找到 ANDROID_HOME 环境变量"
        print_info "Android 构建可能失败"
        echo ""
        print_info "请设置环境变量："
        echo "   export ANDROID_HOME=\$HOME/Android/Sdk"
        echo "   export ANDROID_SDK_ROOT=\$ANDROID_HOME"
        echo "   export PATH=\$PATH:\$ANDROID_HOME/platform-tools"
        echo ""
    fi

    echo ""
}

# ===================================
# 安装 Cordova
# ===================================
install_cordova() {
    print_header "检查/安装 Cordova"

    if command -v cordova &> /dev/null; then
        CORDOVA_VERSION=$(cordova -v)
        print_success "Cordova 已安装: $CORDOVA_VERSION"
    else
        print_info "正在安装 Cordova..."
        npm install -g cordova
        print_success "Cordova 安装完成"
    fi

    echo ""
}

# ===================================
# 初始化 Cordova 项目
# ===================================
init_cordova() {
    print_header "初始化 Cordova 项目"

    # 检查是否已初始化
    if [ -d "platforms" ] && [ -d "plugins" ]; then
        print_success "Cordova 项目已初始化"
    else
        print_info "正在初始化 Cordova 项目..."

        # 如果存在 config.xml，说明项目结构已存在
        if [ -f "config.xml" ]; then
            print_info "检测到 config.xml，添加平台和插件..."

            # 添加 Android 平台
            if [ ! -d "platforms/android" ]; then
                print_info "正在添加 Android 平台..."
                cordova platform add android
                print_success "Android 平台添加完成"
            else
                print_success "Android 平台已存在"
            fi
        else
            print_error "未找到 config.xml，请确保在项目根目录运行此脚本"
            exit 1
        fi
    fi

    echo ""
}

# ===================================
# 构建调试版 APK
# ===================================
build_debug() {
    print_header "构建调试版 APK"

    print_info "正在构建调试版..."
    cordova build android

    if [ -f "platforms/android/app/build/outputs/apk/debug/app-debug.apk" ]; then
        print_success "调试版 APK 构建成功！"
        echo ""
        echo -e "${GREEN}📦 APK 位置:${NC}"
        echo "   $(pwd)/platforms/android/app/build/outputs/apk/debug/app-debug.apk"
        echo ""
        echo -e "${BLUE}📱 安装到设备:${NC}"
        echo "   cordova run android"
        echo ""
        return 0
    else
        print_error "APK 构建失败"
        return 1
    fi
}

# ===================================
# 构建发布版 APK（未签名）
# ===================================
build_release() {
    print_header "构建发布版 APK（未签名）"

    print_info "正在构建发布版..."
    cordova build android --release

    if [ -f "platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk" ]; then
        print_success "发布版 APK 构建成功！"
        echo ""
        echo -e "${GREEN}📦 APK 位置:${NC}"
        echo "   $(pwd)/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk"
        echo ""
        print_warning "注意: 此 APK 未签名，无法直接安装"
        print_info "使用签名脚本对 APK 进行签名"
        echo ""
        return 0
    else
        print_error "APK 构建失败"
        return 1
    fi
}

# ===================================
# 构建并签名发布版 APK
# ===================================
build_signed() {
    print_header "构建并签名发布版 APK"

    # 检查密钥库
    if [ ! -f "release.keystore" ]; then
        print_warning "未找到密钥库文件"
        echo ""
        print_info "生成新密钥库..."
        print_info "请填写以下信息："
        echo ""

        keytool -genkey -v -keystore release.keystore -alias ruthirsty -keyalg RSA -keysize 2048 -validity 10000

        if [ $? -eq 0 ]; then
            print_success "密钥库生成完成"
        else
            print_error "密钥库生成失败"
            exit 1
        fi
    fi

    echo ""
    print_info "正在构建发布版..."
    cordova build android --release

    UNSIGNED_APK="platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk"
    SIGNED_APK="RUthirsty-release.apk"

    if [ -f "$UNSIGNED_APK" ]; then
        print_info "正在签名 APK..."

        # 签名
        jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore release.keystore \
            "$UNSIGNED_APK" ruthirsty

        if [ $? -eq 0 ]; then
            print_success "APK 签名完成"

            # 对齐
            print_info "正在对齐 APK..."
            zipalign -v 4 "$UNSIGNED_APK" "$SIGNED_APK"

            if [ $? -eq 0 ]; then
                print_success "APK 对齐完成"
                echo ""
                echo -e "${GREEN}📦 签名版 APK 位置:${NC}"
                echo "   $(pwd)/$SIGNED_APK"
                echo ""
                echo -e "${GREEN}✅ APK 已准备好发布！${NC}"
                echo ""
                return 0
            fi
        fi
    else
        print_error "APK 构建失败"
        return 1
    fi
}

# ===================================
# 清理构建文件
# ===================================
clean_build() {
    print_header "清理构建文件"

    print_info "正在清理..."
    cordova clean android
    print_success "清理完成"
    echo ""
}

# ===================================
# 显示帮助信息
# ===================================
show_help() {
    echo "Cordova APK 打包工具"
    echo ""
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  debug    构建调试版 APK"
    echo "  release  构建发布版 APK（未签名）"
    echo "  signed   构建并签名发布版 APK"
    echo "  clean    清理构建文件"
    echo "  help     显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 debug     # 构建调试版"
    echo "  $0 signed    # 构建并签名发布版"
    echo ""
}

# ===================================
# 主程序
# ===================================
main() {
    # 获取项目根目录
    cd "$(dirname "$0")/.."
    PROJECT_ROOT=$(pwd)

    echo ""
    print_header "RUthirsty Cordova 打包工具"
    print_info "项目目录: $PROJECT_ROOT"
    echo ""

    # 检查命令
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    case "$1" in
        debug)
            check_environment
            install_cordova
            init_cordova
            build_debug
            ;;
        release)
            check_environment
            install_cordova
            init_cordova
            build_release
            ;;
        signed)
            check_environment
            install_cordova
            init_cordova
            build_signed
            ;;
        clean)
            clean_build
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "未知命令: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# 运行主程序
main "$@"
