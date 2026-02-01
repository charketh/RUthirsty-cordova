# Cordova APK 打包工具

自动处理 Cordova Android 应用的完整打包流程。

## 功能

- 检查环境依赖（Node.js, Java, Android SDK）
- 自动安装 Cordova（如需要）
- 初始化 Cordova 项目
- 添加 Android 平台
- 构建调试版 APK
- 构建发布版 APK（可选）
- 签名 APK（可选）

## 使用方法

```bash
# 构建调试版 APK
cordova-build.sh debug

# 构建发布版 APK（未签名）
cordova-build.sh release

# 构建并签名发布版 APK
cordova-build.sh signed
```

## 环境要求

- Node.js (v16+)
- Java JDK (8+)
- Android SDK
- Gradle（通常包含在 Android SDK 中）

## 输出

APK 文件位置：
- 调试版: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`
- 发布版: `platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`
