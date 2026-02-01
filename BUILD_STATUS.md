# 📱 RUthirsty - 构建状态

## ✅ 已完成

- [x] 项目结构重构完成
- [x] 毛玻璃 UI 设计实现
- [x] 创建 Cordova 构建脚本 (`scripts/cordova-build.sh`)
- [x] 创建详细构建文档 (`docs/BUILD.md`)
- [x] Cordova 项目初始化测试

## ⚠️ 环境限制

### Codespaces 环境
当前 Codespaces 环境中**未安装 Android SDK**，无法直接构建 APK。

**原因**: Android SDK 需要约 4-5GB 存储空间，不适合在云端环境中安装。

## 🚀 本地构建步骤

### 在您的本地机器上执行：

#### 1. 准备环境
确保已安装：
- **Node.js** (v16+): https://nodejs.org/
- **Java JDK** (11+): https://adoptium.net/
- **Android Studio** (包含 Android SDK): https://developer.android.com/studio

#### 2. 克隆项目
```bash
git clone https://github.com/zlccccc/RUthirsty-cordova.git
cd RUthirsty-cordova
```

#### 3. 运行构建脚本
```bash
# 构建调试版 APK（推荐用于测试）
./scripts/cordova-build.sh debug

# 或构建发布版 APK
./scripts/cordova-build.sh release
```

#### 4. 查找生成的 APK
构建成功后，APK 文件位于：
```
platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

## 📖 详细文档

完整的构建指南请参阅：[`docs/BUILD.md`](docs/BUILD.md)

包含内容：
- 环境配置详解
- APK 签名流程
- 常见问题解决
- 自动化构建设置
- 优化技巧

## 🎯 快速命令参考

```bash
# 安装 Cordova
npm install -g cordova

# 添加 Android 平台
cordova platform add android

# 构建调试版
cordova build android

# 构建发布版
cordova build android --release

# 运行到设备
cordova run android
```

## 📦 构建输出类型

| 类型 | 命令 | 位置 | 用途 |
|------|------|------|------|
| 调试版 | `cordova build android` | `platforms/android/app/build/outputs/apk/debug/` | 开发测试 |
| 发布版 | `cordova build android --release` | `platforms/android/app/build/outputs/apk/release/` | 应用商店 |

## 🔧 故障排除

### 常见问题

**Q: "ANDROID_HOME not found"**
```bash
# 解决方案：设置环境变量
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

**Q: Gradle 构建失败**
```bash
# 解决方案：清理并重新构建
cordova clean android
cordova build android
```

**Q: 找不到 Android SDK**
- 安装 Android Studio
- 通过 SDK Manager 安装 Android SDK
- 设置 ANDROID_HOME 环境变量

详细解决方案请参阅 [`docs/BUILD.md`](docs/BUILD.md)

## 📞 需要帮助？

- 查看 [`docs/BUILD.md`](docs/BUILD.md) 获取详细指南
- 查看 [`docs/CLAUDE.md`](docs/CLAUDE.md) 了解编码规范
- 提交 Issue: https://github.com/charketh/RUthirsty-cordova/issues

---

**准备好在本地构建了吗？** 🚀

按照上面的步骤，在您的本地机器上运行构建脚本即可！
