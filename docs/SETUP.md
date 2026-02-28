# 快速开始指南 (Quick Start Guide)

## 🚀 5分钟快速测试

### 选项 1: 浏览器测试（最快）

1. **直接打开文件**
   ```bash
   # 在浏览器中打开
   open src/index.html
   # 或者双击 src/index.html 文件
   ```

2. **或使用开发服务器**
   ```bash
   # 启动 live-server (推荐)
   ./scripts/start-server.sh

   # 或使用测试服务器
   ./scripts/test-server.sh
   ```
   然后访问 http://localhost:8080 或 http://localhost:8000

### 选项 2: Android设备测试

#### 步骤 1: 安装依赖
```bash
# 全局安装Cordova（仅首次需要）
npm install -g cordova

# 添加Android平台
cordova platform add android
```

#### 步骤 2: 构建应用
```bash
cordova build android
```

#### 步骤 3: 运行应用
```bash
# 在连接的Android设备上运行
cordova run android

# 或在模拟器上运行
cordova emulate android
```

## ✅ 功能验证清单

### 基本功能
- [ ] 点击打卡按钮
- [ ] 检查今日计数 +1
- [ ] 检查总计数 +1
- [ ] 查看记录列表
- [ ] 删除记录

### 数据持久化
- [ ] 刷新页面
- [ ] 确认数据保持
- [ ] 关闭重新打开应用
- [ ] 确认数据仍然存在

### UI/UX
- [ ] 按钮点击效果
- [ ] 响应式布局（手机/平板）
- [ ] 滚动记录列表
- [ ] 日期分组显示

## 📁 项目文件说明

| 文件 | 说明 |
|------|------|
| `config.xml` | Cordova应用配置（应用名、包名、权限等） |
| `package.json` | Node.js项目配置 |
| `src/index.html` | 主页面HTML结构 |
| `src/css/style.css` | 样式表（蓝色主题、响应式设计） |
| `src/js/app.js` | 应用逻辑（打卡、存储、UI更新） |
| `docs/CLAUDE.md` | 编码规范文档 |
| `scripts/*.sh` | 开发和测试脚本 |

## 🛠️ 常见问题

### Q: 浏览器中无法存储数据？
A: 确保浏览器支持localStorage，没有禁用第三方cookie。

### Q: Android构建失败？
A: 检查是否安装了Android SDK和Java JDK。确保环境变量配置正确。

### Q: 如何添加振动插件？
A:
```bash
cordova plugin add cordova-plugin-vibration
```

### Q: 如何修改应用名称？
A: 编辑 `config.xml` 文件中的 `<name>` 标签。

## 📱 打包发布

### 生成发布版APK
```bash
cordova build android --release
```

### 签名APK
```bash
# 生成密钥（仅首次）
keytool -genkey -v -keystore release.keystore -alias ruthirsty -keyalg RSA -keysize 2048 -validity 10000

# 签名APK
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore release.keystore platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk ruthirsty

# 对齐APK
zipalign -v 4 platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk RUthirsty.apk
```

## 🔗 有用的链接

- [Cordova官方文档](https://cordova.apache.org/docs/en/latest/)
- [Android平台指南](https://cordova.apache.org/docs/en/latest/guide/platforms/android/)
- [Cordova插件列表](https://cordova.apache.org/plugins/)

---

**需要帮助？** 查看 README.md 或提交 issue
