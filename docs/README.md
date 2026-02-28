# RUthirsty - 喝水打卡应用

A simple and elegant water tracking reminder app built with Cordova for Android devices.

## 功能特性 (Features)

- 💧 **一键打卡** - 简单易用的大按钮记录喝水
- 📊 **数据统计** - 显示今日打卡次数和总打卡次数
- 📝 **历史记录** - 完整的打卡历史记录，按时间分组显示
- 🗑️ **删除记录** - 可以删除任意打卡记录
- 📱 **移动端优化** - 完美适配Android设备屏幕
- 💾 **本地存储** - 使用localStorage，数据永久保存
- 🎨 **精美设计** - 清新蓝色主题，水滴造型按钮

## 项目结构 (Project Structure)

```
RUthirsty-cordova/
├── config.xml           # Cordova应用配置
├── package.json         # NPM依赖配置
├── src/                 # 源代码目录
│   ├── index.html       # 主页面
│   ├── css/
│   │   └── style.css    # 样式文件
│   └── js/
│       └── app.js       # 应用逻辑
├── docs/                # 文档目录
│   ├── README.md        # 项目说明
│   ├── SETUP.md         # 快速开始指南
│   └── CLAUDE.md        # 编码规范
└── scripts/             # 开发脚本
    ├── start-server.sh  # 启动开发服务器
    ├── stop-server.sh   # 停止开发服务器
    └── test-server.sh   # 测试服务器
```

## 开发环境测试 (Browser Testing)

在浏览器中快速测试应用：

1. 直接在浏览器中打开 `src/index.html` 文件
2. 或者使用开发服务器：
   ```bash
   # 使用提供的脚本
   ./scripts/start-server.sh

   # 或使用测试服务器
   ./scripts/test-server.sh
   ```

3. 在浏览器中访问 `http://localhost:8080` 或 `http://localhost:8000`

### 浏览器测试清单

- [ ] 点击打卡按钮，检查计数器是否增加
- [ ] 检查今日次数是否正确更新
- [ ] 检查总次数是否正确更新
- [ ] 查看历史记录是否按时间倒序显示
- [ ] 刷新页面，检查数据是否保持（localStorage）
- [ ] 测试删除记录功能

## Android构建与测试 (Android Build)

### 前置要求 (Prerequisites)

- Node.js (推荐 v16 或更高版本)
- Android Studio (安装Android SDK)
- Java JDK 8 或更高版本

### 安装步骤 (Setup Steps)

1. 安装Cordova（如果还没有安装）：
   ```bash
   npm install -g cordova
   ```

2. 在项目目录中初始化Cordova：
   ```bash
   cordova platform add android
   ```

3. 构建应用：
   ```bash
   cordova build android
   ```

4. 在连接的Android设备上运行：
   ```bash
   cordova run android
   ```

### Android测试清单

- [ ] 应用在Android设备上正常启动
- [ ] 打卡按钮点击响应灵敏
- [ ] 今日次数统计正确
- [ ] 总次数统计正确
- [ ] 记录列表按时间倒序显示
- [ ] 记录按日期分组（今天/昨天/具体日期）
- [ ] 删除记录功能正常
- [ ] 震动反馈正常工作
- [ ] 应用关闭后重新打开，数据保持
- [ ] 界面在不同屏幕尺寸上正常显示

## 数据结构 (Data Structure)

数据使用localStorage存储，格式如下：

```json
{
  "records": [
    {
      "timestamp": 1738362000000,
      "date": "2025-02-01",
      "time": "14:30:25"
    }
  ]
}
```

## 技术栈 (Tech Stack)

- **框架**: Apache Cordova
- **平台**: Android
- **前端**: HTML5, CSS3, JavaScript (ES6+)
- **存储**: localStorage
- **UI设计**: 响应式设计，移动端优先

## 浏览器兼容性 (Browser Compatibility)

- Chrome/Edge (推荐)
- Firefox
- Safari
- Android WebView

## 未来增强功能 (Future Enhancements)

- [ ] 每日目标设定
- [ ] 提醒通知功能
- [ ] 数据导出功能
- [ ] 统计图表
- [ ] 云同步功能
- [ ] 主题切换
- [ ] iOS平台支持

## 许可证 (License)

MIT License

## 作者 (Author)

RUthirsty Team

---

**Happy Hydration! 💧**
