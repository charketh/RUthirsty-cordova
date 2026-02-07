# RUthirsty 编码规范

本文档定义了 RUthirsty 项目的编码规范和开发流程，确保团队协作时代码风格一致、质量可控。

## 目录

1. [JavaScript 编码规范](#1-javascript-编码规范)
2. [HTML/CSS 规范](#2-htmlcss-规范)
3. [Git 提交规范](#3-git-提交规范)
4. [项目开发流程](#4-项目开发流程)
5. [代码审查清单](#5-代码审查清单)

---

## 1. JavaScript 编码规范

### 1.1 命名规范

**变量和函数命名（小驼峰 camelCase）**
```javascript
// ✅ 正确
let userName = 'John';
function getUserData() { }
const recordCount = 10;

// ❌ 错误
let user_name = 'John';
function GetUserData() { }
```

**类和构造函数命名（大驼峰 PascalCase）**
```javascript
// ✅ 正确
class UserManager { }
function UserProfile(name) { }

// ❌ 错误
class userManager { }
```

**常量命名（UPPER_SNAKE_CASE）**
```javascript
// ✅ 正确
const MAX_RECORDS = 100;
const DEFAULT_TIMEOUT = 5000;
const API_BASE_URL = 'https://api.example.com';

// ❌ 错误
const maxRecords = 100;
const default_timeout = 5000;
```

**私有变量命名（前缀下划线）**
```javascript
// ✅ 正确
class DataManager {
  constructor() {
    this._storage = null;
  }

  _validateData(data) {
    // 私有方法
  }
}
```

### 1.2 代码风格

**使用 const/let，禁止 var**
```javascript
// ✅ 正确
const config = { debug: true };
let counter = 0;

// ❌ 错误
var config = { debug: true };
var counter = 0;
```

**使用 ES6+ 语法**
```javascript
// ✅ 使用箭头函数
const add = (a, b) => a + b;

// ✅ 使用模板字符串
const message = `Hello ${userName}`;

// ✅ 使用解构
const { name, age } = user;
const [first, second] = array;

// ✅ 使用展开运算符
const newUser = { ...userData, id: 1 };
const newArray = [...oldArray, newItem];

// ✅ 使用可选链
const city = user?.address?.city;

// ✅ 使用空值合并
const timeout = options?.timeout ?? 3000;
```

**函数声明优先**
```javascript
// ✅ 函数声明（推荐用于独立函数）
function calculateTotal(records) {
  return records.length;
}

// ✅ 箭头函数（推荐用于回调和方法）
const handleClick = (event) => {
  console.log(event.target);
};
```

### 1.3 代码格式

**缩进：2 空格**
```javascript
// ✅ 正确
function processRecords(records) {
  records.forEach(record => {
    if (record.valid) {
      saveRecord(record);
    }
  });
}

// ❌ 错误（使用 tab 或 4 空格）
function processRecords(records) {
		records.forEach(record => {
				if (record.valid) {
						saveRecord(record);
				}
		});
}
```

**单行长度限制：100 字符**
```javascript
// ✅ 正确（换行）
const longMessage =
  'This is a very long message that should be broken ' +
  'into multiple lines for readability';

// ✅ 使用模板字符串换行
const longMessage = `This is a very long message that should be broken
into multiple lines for readability`;

// ❌ 错误（超过 100 字符）
const longMessage = 'This is a very long message that exceeds the 100 character limit and should be broken into multiple lines';
```

**对象和数组格式**
```javascript
// ✅ 正确
const config = {
  host: 'localhost',
  port: 8080,
  ssl: true,
};

const numbers = [1, 2, 3, 4, 5];

// ✅ 多行对象（使用尾随逗号）
const user = {
  id: 1,
  name: 'John',
  email: 'john@example.com',
};
```

### 1.4 最佳实践

**避免全局变量污染**
```javascript
// ✅ 正确（使用 IIFE 或模块）
(function() {
  let privateVariable = 'private';

  function privateFunction() {
    // ...
  }

  window.app = {
    publicMethod: () => {
      // ...
    }
  };
})();

// ✅ 正确（使用模块模式）
const app = (() => {
  let privateVariable = 'private';

  function privateFunction() {
    // ...
  }

  return {
    publicMethod: () => {
      // ...
    }
  };
})();

// ❌ 错误（全局变量）
var userName = 'John';
function doSomething() {
  // ...
}
```

**使用事件委托**
```javascript
// ✅ 正确（事件委托）
document.addEventListener('click', (event) => {
  if (event.target.matches('.delete-button')) {
    deleteRecord(event.target.dataset.id);
  }
});

// ❌ 错误（为每个元素添加事件）
document.querySelectorAll('.delete-button').forEach(button => {
  button.addEventListener('click', (event) => {
    deleteRecord(event.target.dataset.id);
  });
});
```

**错误处理**
```javascript
// ✅ 正确（处理错误）
try {
  const data = JSON.parse(jsonString);
  processData(data);
} catch (error) {
  console.error('Failed to parse JSON:', error);
  showError('Invalid data format');
}

// ✅ 正确（验证输入）
function saveRecord(record) {
  if (!record || !record.timestamp) {
    throw new Error('Invalid record: missing timestamp');
  }

  localStorage.setItem('record', JSON.stringify(record));
}

// ❌ 错误（忽略错误）
function saveRecord(record) {
  localStorage.setItem('record', JSON.stringify(record));
}
```

**使用严格模式**
```javascript
// ✅ 在文件或函数开头使用
'use strict';

function processData(data) {
  // 严格模式下的代码
}
```

**注释规范**
```javascript
// ✅ 单行注释：解释为什么这样做（而非做了什么）
// 使用 localStorage 而非 sessionStorage，因为数据需要跨会话保持
const storage = localStorage;

/**
 * ✅ 多行注释（JSDoc 风格）
 * 保存打卡记录到本地存储
 * @param {Object} record - 打卡记录对象
 * @param {number} record.timestamp - 时间戳
 * @param {string} record.date - 日期字符串
 * @returns {boolean} 保存是否成功
 */
function saveRecord(record) {
  try {
    // 实现逻辑
    return true;
  } catch (error) {
    return false;
  }
}

// ❌ 避免无意义的注释
let count = 0; // 设置 count 为 0
```

---

## 2. HTML/CSS 规范

### 2.1 HTML 规范

**使用语义化标签**
```html
<!-- ✅ 正确 -->
<header>
  <nav>
    <ul>
      <li><a href="/">Home</a></li>
    </ul>
  </nav>
</header>

<main>
  <article>
    <h1>Article Title</h1>
    <p>Article content...</p>
  </article>
</main>

<footer>
  <p>&copy; 2025 RUthirsty</p>
</footer>

<!-- ❌ 错误（过度使用 div） -->
<div class="header">
  <div class="nav">
    <div class="nav-item">
      <a href="/">Home</a>
    </div>
  </div>
</div>
```

**缩进：2 空格**
```html
<!-- ✅ 正确 -->
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>RUthirsty</title>
  </head>
  <body>
    <div id="app">
      <h1>Water Tracker</h1>
    </div>
  </body>
</html>
```

**属性使用双引号**
```html
<!-- ✅ 正确 -->
<div class="container" data-id="123">
  <a href="https://example.com">Link</a>
</div>

<!-- ❌ 错误 -->
<div class=container data-id=123>
  <a href='https://example.com'>Link</a>
</div>
```

**自闭合标签不需要斜杠**
```html
<!-- ✅ 正确 -->
<img src="logo.png" alt="Logo">
<input type="text" name="username">
<br>
<hr>

<!-- ❌ 过时（但可接受） -->
<img src="logo.png" alt="Logo" />
<input type="text" name="username" />
```

**类名使用 kebab-case**
```html
<!-- ✅ 正确 -->
<div class="record-item">
  <button class="delete-button">Delete</button>
</div>

<!-- ❌ 错误 -->
<div class="recordItem">
  <button class="delete_button">Delete</button>
</div>
```

**可访问性**
```html
<!-- ✅ 正确 -->
<button type="button" aria-label="Delete record">
  <span class="icon-trash"></span>
</button>

<img src="chart.png" alt="Weekly water consumption chart">

<form>
  <label for="username">Username:</label>
  <input type="text" id="username" name="username" required>
</form>

<!-- ❌ 错误 -->
<button>
  <span class="icon-trash"></span>
</button>

<img src="chart.png">

<input type="text" name="username">
```

### 2.2 CSS 规范

**使用 CSS 变量定义主题色**
```css
/* ✅ 正确 */
:root {
  /* 主题颜色 */
  --color-primary: #3498db;
  --color-primary-dark: #2980b9;
  --color-primary-light: #5dade2;

  /* 中性色 */
  --color-text: #333333;
  --color-text-light: #666666;
  --color-background: #ffffff;
  --color-background-alt: #f5f5f5;

  /* 间距 */
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;

  /* 字体 */
  --font-size-base: 16px;
  --font-size-large: 20px;
  --font-size-small: 14px;
}

.button {
  background-color: var(--color-primary);
  padding: var(--spacing-sm) var(--spacing-md);
}
```

**类名命名规范（BEM 风格）**
```css
/* ✅ BEM 命名 */
/* Block */
.record { }

/* Element */
.record__title { }
.record__timestamp { }
.record__delete-btn { }

/* Modifier */
.record--today { }
.record--yesterday { }
.button--primary { }
.button--secondary { }

/* 使用示例 */
<div class="record record--today">
  <h3 class="record__title">Record Title</h3>
  <span class="record__timestamp">14:30:25</span>
  <button class="record__delete-btn button--primary">Delete</button>
</div>
```

**移动优先（Mobile-First）**
```css
/* ✅ 移动优先 */
/* 基础样式（移动设备） */
.container {
  width: 100%;
  padding: 16px;
}

.button {
  font-size: 14px;
  padding: 8px 16px;
}

/* 平板设备 */
@media (min-width: 768px) {
  .container {
    max-width: 768px;
    margin: 0 auto;
  }

  .button {
    font-size: 16px;
    padding: 12px 24px;
  }
}

/* 桌面设备 */
@media (min-width: 1024px) {
  .container {
    max-width: 1024px;
  }
}
```

**使用相对单位**
```css
/* ✅ 正确 */
body {
  font-size: 16px; /* 基准字体大小 */
}

.heading {
  font-size: 1.5rem; /* 24px，相对于根元素 */
  margin-bottom: 1em; /* 相对于当前元素字体大小 */
}

/* ❌ 错误（固定像素） */
.heading {
  font-size: 24px;
  margin-bottom: 24px;
}
```

**避免深层嵌套（最多 3 层）**
```css
/* ✅ 正确 */
.record-list { }
.record-list__item { }
.record-list__item__title { }

/* ❌ 错误（嵌套过深） */
.record-list {
  .item {
    .content {
      .title {
        .text {
          /* 太深了！ */
        }
      }
    }
  }
}
```

**使用 Flexbox/Grid 布局**
```css
/* ✅ Flexbox */
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

/* ✅ Grid */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}
```

**CSS 属性顺序**
```css
/* ✅ 推荐顺序 */
.button {
  /* 1. 定位 */
  position: relative;
  display: inline-block;
  top: 0;
  left: 0;

  /* 2. 盒模型 */
  width: 100%;
  padding: 12px 24px;
  margin: 8px 0;
  border: 1px solid #ccc;
  border-radius: 4px;

  /* 3. 字体 */
  font-size: 16px;
  font-weight: 500;
  line-height: 1.5;
  color: #333;
  text-align: center;

  /* 4. 背景 */
  background-color: #3498db;

  /* 5. 其他 */
  opacity: 1;
  transition: all 0.3s ease;
  cursor: pointer;
}
```

---

## 3. Git 提交规范

### 3.1 Commit Message 格式

采用约定式提交（Conventional Commits）格式：

```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型（type）**
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式调整（不影响功能）
- `refactor`: 重构（既不是新功能也不是修复）
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建/工具链相关
- `revert`: 回滚之前的提交

**示例提交**

```bash
# 新功能
git commit -m "feat(records): add delete record functionality

- Add delete button to each record item
- Implement deleteRecord() method
- Update localStorage after deletion
- Add confirmation dialog before deletion

Closes #123"

# 修复 bug
git commit -m "fix(storage): prevent data loss on page refresh

- Fix localStorage key collision
- Add data validation before saving
- Implement error handling for quota exceeded

Fixes #45"

# 文档更新
git commit -m "docs(readme): update setup instructions

- Add Python installation steps
- Update Android SDK requirements
- Fix broken links"

# 重构
git commit -m "refactor(ui): extract button component

- Create reusable Button component
- Update all button instances
- Reduce code duplication"
```

### 3.2 提交消息规范

**Subject（标题）**
- 使用动词原形开头（add、fix、update）
- 首字母小写
- 不以句号结尾
- 限制在 50 字符以内

**Body（正文）**
- 说明"是什么"和"为什么"（而非"如何"）
- 每行限制在 72 字符以内
- 使用列表说明变更内容

**Footer（脚注）**
- 关联 issue：`Closes #123` 或 `Fixes #456`
- 破坏性变更：`BREAKING CHANGE: detailed description`

### 3.3 分支策略

**主分支**
- `main`: 生产环境代码，始终保持稳定

**功能分支**
- `feature/feature-name`: 新功能开发
- `bugfix/bug-name`: Bug 修复
- `hotfix/urgent-issue`: 紧急修复
- `docs/update-name`: 文档更新

**分支命名示例**
```bash
feature/daily-goal-setting
bugfix/localstorage-data-loss
hotfix/crash-on-android-10
docs/api-documentation
refactor/code-structure
```

### 3.4 工作流程

```bash
# 1. 从 main 创建功能分支
git checkout main
git pull origin main
git checkout -b feature/new-feature

# 2. 开发和提交
git add src/js/app.js
git commit -m "feat(feature): add new functionality"

# 3. 推送到远程
git push origin feature/new-feature

# 4. 创建 Pull Request
# 在 GitHub/GitLab 上创建 PR

# 5. 代码审查后合并到 main
# 使用 Squash and merge 保持历史清洁

# 6. 删除功能分支
git checkout main
git pull origin main
git branch -d feature/new-feature
```

---

## 4. 项目开发流程

### 4.1 开发环境设置

**1. 克隆项目**
```bash
git clone https://github.com/your-org/RUthirsty-cordova.git
cd RUthirsty-cordova
```

**2. 安装依赖**
```bash
npm install
```

**3. 添加 Cordova 平台**
```bash
cordova platform add android
```

**4. 启动开发服务器**
```bash
./scripts/start-server.sh
# 访问 http://localhost:8080
```

### 4.2 开发流程

**1. 创建功能分支**
```bash
git checkout -b feature/your-feature-name
```

**2. 在 `src/` 目录下开发**
- HTML: `src/index.html`
- CSS: `src/css/style.css`
- JavaScript: `src/js/app.js`

**3. 本地测试**
```bash
# 浏览器测试
./scripts/test-server.sh

# Android 设备测试
cordova build android
cordova run android
```

**4. 提交代码（遵循 commit 规范）**
```bash
git add src/
git commit -m "feat(feature): description of changes"
```

**5. 推送到远程**
```bash
git push origin feature/your-feature-name
```

**6. 创建 Pull Request**
- 在 GitHub 上创建 PR
- 填写 PR 模板
- 等待代码审查

**7. 合并后清理**
```bash
git checkout main
git pull origin main
git branch -d feature/your-feature-name
```

### 4.3 测试清单

**功能测试**
- [ ] 打卡功能正常
- [ ] 统计显示正确（今日/总计）
- [ ] 历史记录按时间倒序显示
- [ ] 删除记录功能正常
- [ ] 数据持久化正常
- [ ] 无控制台错误

**UI/UX 测试**
- [ ] 响应式布局正常（手机/平板）
- [ ] 按钮点击效果正常
- [ ] 滚动记录列表流畅
- [ ] 日期分组显示正确
- [ ] 加载状态显示

**兼容性测试**
- [ ] Chrome/Edge 浏览器
- [ ] Firefox 浏览器
- [ ] Safari 浏览器
- [ ] Android 设备
- [ ] 不同屏幕尺寸

**性能测试**
- [ ] 页面加载时间 < 2 秒
- [ ] 交互响应时间 < 100ms
- [ ] 内存使用正常
- [ ] 无内存泄漏

### 4.4 构建与部署

**开发构建**
```bash
cordova build android
```

**生产构建**
```bash
cordova build android --release
```

**签名 APK**
```bash
# 生成密钥（仅首次）
keytool -genkey -v -keystore release.keystore -alias ruthirsty -keyalg RSA -keysize 2048 -validity 10000

# 签名 APK
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore release.keystore \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk ruthirsty

# 对齐 APK
zipalign -v 4 \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  RUthirsty.apk
```

---

## 5. 代码审查清单

### 5.1 代码质量

- [ ] 代码遵循本编码规范
- [ ] 无 console.log 调试代码
- [ ] 无注释掉的代码
- [ ] 无未使用的变量/函数
- [ ] 适当的错误处理
- [ ] 适当的输入验证

### 5.2 功能性

- [ ] 功能按需求实现
- [ ] 边界情况处理
- [ ] 错误情况处理
- [ ] 性能影响可接受
- [ ] 无安全漏洞
- [ ] 无内存泄漏

### 5.3 可维护性

- [ ] 代码清晰易懂
- [ ] 适当的注释
- [ ] 函数职责单一
- [ ] 避免重复代码
- [ ] 命名有意义
- [ ] 代码结构合理

### 5.4 测试

- [ ] 包含必要的测试
- [ ] 测试覆盖主要功能
- [ ] 测试通过
- [ ] 手动测试验证

---

## 附录：工具配置

### VS Code 配置

**.editorconfig**
```ini
root = true

[*]
charset = utf-8
indent_style = space
indent_size = 2
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
trim_trailing_whitespace = false
```

**.eslintrc.json**
```json
{
  "env": {
    "browser": true,
    "es2021": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "rules": {
    "indent": ["error", 2],
    "linebreak-style": ["error", "unix"],
    "quotes": ["error", "single"],
    "semi": ["error", "always"],
    "no-var": "error",
    "prefer-const": "error"
  }
}
```

**.prettierrc**
```json
{
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5",
  "bracketSpacing": true,
  "arrowParens": "avoid"
}
```

---

## 更新日志

- **2025-02-01**: 初始版本，创建编码规范文档

---

**遵守本规范有助于提高代码质量、减少 Bug、提升团队协作效率。如有疑问或建议，请联系团队维护者。**
