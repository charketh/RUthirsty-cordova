# RUthirsty - APK 构建指南

## 📱 环境要求

在本地构建 APK 之前，需要安装以下工具：

### 1. Node.js (v16+)
- 下载：https://nodejs.org/
- 验证：`node -v`

### 2. Java JDK (8+)
- 推荐：OpenJDK 11 或 17
- 下载：https://adoptium.net/
- 验证：`java -version`

### 3. Android SDK
- 通过 Android Studio 安装（推荐）
- 下载：https://developer.android.com/studio
- 或使用命令行工具

### 4. 环境变量配置

在 `~/.bashrc` 或 `~/.zshrc` 中添加：

```bash
# Android SDK 路径（根据实际安装位置修改）
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME

export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

然后运行：
```bash
source ~/.bashrc
# 或
source ~/.zshrc
```

## 🚀 快速构建

### 方式 1: 使用构建脚本（推荐）

```bash
# 克隆项目
git clone https://github.com/zlccccc/RUthirsty-cordova.git
cd RUthirsty-cordova

# 运行构建脚本
./scripts/cordova-build.sh debug
```

### 方式 2: 手动构建

```bash
# 1. 安装 Cordova（如未安装）
npm install -g cordova

# 2. 添加 Android 平台
cordova platform add android

# 3. 构建调试版 APK
cordova build android

# 或者构建发布版
cordova build android --release
```

## 📦 构建输出

### 调试版 APK
- **位置**: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`
- **用途**: 开发和测试
- **特点**: 包含调试信息，可直接安装

### 发布版 APK
- **位置**: `platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`
- **用途**: 发布到应用商店
- **特点**: 优化过的代码，但需要签名

## 🔐 APK 签名

### 生成密钥库

```bash
keytool -genkey -v -keystore release.keystore -alias ruthirsty -keyalg RSA -keysize 2048 -validity 10000
```

填写信息：
- **密码**: 记住你的密钥库密码
- **姓名**: RUthirsty
- **组织**: RUthirsty Team
- **城市/省份/国家代码**: 根据实际情况填写

### 签名 APK

```bash
# 1. 签名
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 -keystore release.keystore \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  ruthirsty

# 2. 对齐
zipalign -v 4 \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  RUthirsty-release.apk
```

### 使用脚本签名

```bash
./scripts/cordova-build.sh signed
```

## 📱 安装到设备

### 通过 USB 连接

```bash
# 启用 USB 调试后
cordova run android

# 或手动安装
adb install platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

### 通过 WiFi 连接

```bash
# 1. 连接 USB 并启用 TCP/IP
adb tcpip 5555

# 2. 获取设备 IP
adb shell ip addr show wlan0

# 3. 连接 WiFi（替换 IP 地址）
adb connect 192.168.1.100:5555

# 4. 运行应用
cordova run android
```

## 🛠️ 常见问题

### 1. "ANDROID_HOME not found"
**解决方案**：设置环境变量（见上文"环境变量配置"）

### 2. "Failed to install android"
**解决方案**：
```bash
# 清理缓存
cordova clean android

# 重新添加平台
cordova platform remove android
cordova platform add android
```

### 3. 构建失败 "Gradle build failed"
**解决方案**：
```bash
# 删除 .gradle 缓存
rm -rf ~/.gradle/caches/

# 清理并重新构建
cordova clean android
cordova build android
```

### 4. "Out of memory" 错误
**解决方案**：
在 `platforms/android/build.gradle` 中增加堆大小：
```gradle
android {
    dexOptions {
        javaMaxHeapSize "4g"
    }
}
```

### 5. SDK 版本不匹配
**解决方案**：通过 Android Studio 安装所需的 SDK 版本

## 📊 构建配置

修改 `config.xml` 来调整构建设置：

```xml
<platform name="android">
    <!-- 屏幕方向 -->
    <preference name="Orientation" value="portrait" />

    <!-- 全屏模式 -->
    <preference name="Fullscreen" value="false" />

    <!-- 最小 SDK 版本 -->
    <preference name="android-minSdkVersion" value="22" />

    <!-- 目标 SDK 版本 -->
    <preference name="android-targetSdkVersion" value="33" />

    <!-- Gradle 版本 -->
    <preference name="android-gradle-file" value="gradle.properties" />
</platform>
```

## 🎯 优化构建

### 减小 APK 大小

1. **启用代码压缩**
   在 `platforms/android/app/build.gradle` 中：
   ```gradle
   buildTypes {
       release {
           minifyEnabled true
           proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-project.txt'
       }
   }
   ```

2. **启用 APK 拆分**
   ```gradle
   splits {
       abi {
           enable true
           reset()
           include 'armeabi-v7a', 'arm64-v8a', 'x86', 'x86_64'
       }
   }
   ```

3. **移除未使用的资源**
   ```bash
   cd platforms/android
   ./gradlew clean
   ./gradlew build
   ```

## 🔄 自动化构建

### GitHub Actions

创建 `.github/workflows/build.yml`：

```yaml
name: Build Android APK

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'

    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'temurin'
        java-version: '17'

    - name: Install Cordova
      run: npm install -g cordova

    - name: Install dependencies
      run: npm install

    - name: Add Android Platform
      run: cordova platform add android

    - name: Build APK
      run: cordova build android

    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: app-debug
        path: platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

## 📚 更多资源

- [Cordova Android 文档](https://cordova.apache.org/docs/en/latest/guide/platforms/android/)
- [Android 开发者文档](https://developer.android.com/docs)
- [Gradle 构建工具](https://gradle.org/)

---

**Happy Building! 🚀**
