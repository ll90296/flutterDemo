# Flutter应用云构建指南

## 概述
本文档指导如何在Windows系统上使用云构建服务打包Flutter应用的iOS版本。

## 云构建服务选择

### 1. Codemagic（推荐）
**优点：**
- 专门为Flutter优化
- 每月500分钟免费构建时间
- 支持iOS、Android、Web、macOS
- 图形化界面，易于使用

**注册地址：** https://codemagic.io/

### 2. GitHub Actions + macOS Runner
**优点：**
- 与GitHub完美集成
- 成本相对较低
- 完全自定义构建流程

### 3. Bitrise
**优点：**
- 每月150分钟免费额度
- 图形化配置界面
- 丰富的Flutter模板

## 使用Codemagic的详细步骤

### 第一步：准备代码仓库
1. 将代码推送到GitHub仓库
2. 确保代码可以正常构建（运行 `flutter pub get` 和 `flutter test`）

### 第二步：注册Codemagic账户
1. 访问 https://codemagic.io/
2. 使用GitHub账户登录
3. 授权Codemagic访问你的GitHub仓库

### 第三步：配置构建
1. 在Codemagic控制台点击"Add application"
2. 选择你的GitHub仓库
3. 选择"Flutter app"类型
4. Codemagic会自动检测 `codemagic.yaml` 配置文件

### 第四步：配置iOS证书（关键步骤）

#### 准备iOS开发者账户
1. 需要Apple Developer账户（年费$99）
2. 在App Store Connect中创建App ID
3. 生成证书和配置文件

#### 在Codemagic中配置证书
1. 在Codemagic控制台进入应用设置
2. 点击"Code signing"选项卡
3. 上传以下文件：
   - **证书文件** (.p12)
   - **配置文件** (.mobileprovision)
   - **App Store Connect API密钥**

### 第五步：触发构建
1. 在Codemagic控制台点击"Start new build"
2. 选择分支和构建配置
3. 点击"Start build"

## 配置文件说明

### codemagic.yaml 文件结构
```yaml
workflows:
  flutter-ios-workflow:
    name: Flutter iOS构建
    environment:
      # 环境变量和证书配置
    scripts:
      # 构建脚本
    artifacts:
      # 构建产物
    publishing:
      # 发布配置
```

### 关键配置项
1. **FLUTTER_VERSION**: 指定Flutter版本
2. **BUNDLE_ID**: iOS应用的Bundle Identifier
3. **证书配置**: 通过环境变量组配置

## 构建流程优化建议

### 1. 缓存依赖
```yaml
cache:
  cache_paths:
    - ~/.pub-cache
```

### 2. 并行构建
```yaml
instance_type: mac_mini_m1
```

### 3. 构建矩阵
可以配置同时构建多个Flutter版本或不同配置

## 常见问题解决

### 问题1：证书配置错误
**症状：** 构建失败，提示证书问题
**解决：**
- 检查证书是否过期
- 确认Bundle ID匹配
- 重新生成证书和配置文件

### 问题2：依赖下载失败
**症状：** pub get失败
**解决：**
- 检查网络连接
- 使用镜像源
- 配置依赖缓存

### 问题3：构建超时
**症状：** 构建过程超过默认时间限制
**解决：**
- 优化构建脚本
- 减少不必要的步骤
- 联系Codemagic支持增加时间限制

## 成本估算

### Codemagic免费额度
- **每月500分钟**构建时间
- 对于中小项目足够使用
- 超出部分按使用量计费

### Apple Developer费用
- **年费$99**（必需）
- 包含所有iOS设备测试和发布

## 替代方案

### 1. 租用macOS云服务器
- **MacStadium**: 提供macOS云服务器
- **MacinCloud**: 按小时计费
- **AWS EC2 Mac实例**: Amazon的macOS实例

### 2. 使用Flutter Desktop
既然在Windows上，可以直接打包Windows桌面应用：
```bash
flutter build windows
```

## 下一步行动

1. **立即开始**: 将代码推送到GitHub，注册Codemagic试用
2. **学习iOS开发**: 了解iOS证书管理和App Store发布流程
3. **优化应用**: 确保应用在iOS设备上运行流畅

## 技术支持
- Codemagic文档: https://docs.codemagic.io/
- Flutter官方文档: https://flutter.dev/docs
- Apple Developer文档: https://developer.apple.com/

---

*最后更新: ${new Date().toLocaleDateString()}*