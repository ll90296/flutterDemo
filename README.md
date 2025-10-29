# Flutter Demo

一个完整的Flutter项目框架，包含现代化的开发结构和最佳实践。

## 项目特性

- 🚀 现代化的Flutter架构
- 📱 响应式UI设计
- 🔄 状态管理（Riverpod）
- 🧭 路由管理（GoRouter）
- 🎨 主题和样式系统
- 📊 数据持久化
- 🌐 HTTP网络请求
- 🧪 测试框架

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── app/                      # 应用配置
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── core/                     # 核心功能
│   ├── constants/
│   ├── utils/
│   └── services/
├── features/                 # 功能模块
│   ├── home/
│   ├── profile/
│   └── settings/
├── shared/                   # 共享组件
│   ├── widgets/
│   ├── models/
│   └── repositories/
└── test/                     # 测试文件
```

## 快速开始

### 环境要求

- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
flutter run
```

### 构建应用

```bash
# 构建APK
flutter build apk

# 构建iOS
flutter build ios

# 构建Web
flutter build web
```

## 开发指南

### 添加新功能

1. 在 `lib/features/` 目录下创建新的功能模块
2. 遵循模块化架构原则
3. 添加相应的路由配置
4. 编写单元测试

### 状态管理

项目使用 Riverpod 进行状态管理：

```dart
final counterProvider = StateProvider<int>((ref) => 0);
```

### 路由管理

使用 GoRouter 进行路由管理：

```dart
GoRoute(
  path: '/home',
  builder: (context, state) => HomePage(),
),
```

## 贡献指南

1. Fork 项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建Pull Request

## 许可证

MIT License