import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _biometricAuth = false;
  String _language = '中文';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 主题设置
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '主题设置',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildSwitchTile(
                    title: '深色模式',
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() {
                        _darkMode = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    title: '语言',
                    subtitle: _language,
                    onTap: () {
                      _showLanguageDialog(context);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 通知设置
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '通知设置',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildSwitchTile(
                    title: '推送通知',
                    value: _notifications,
                    onChanged: (value) {
                      setState(() {
                        _notifications = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    title: '声音提醒',
                    value: true,
                    onChanged: (value) {
                      // 声音提醒设置逻辑
                    },
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    title: '振动提醒',
                    value: true,
                    onChanged: (value) {
                      // 振动提醒设置逻辑
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 安全设置
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '安全设置',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildSwitchTile(
                    title: '生物识别登录',
                    value: _biometricAuth,
                    onChanged: (value) {
                      setState(() {
                        _biometricAuth = value;
                      });
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    title: '修改密码',
                    onTap: () {
                      // 修改密码逻辑
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    title: '隐私政策',
                    onTap: () {
                      // 隐私政策逻辑
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 关于应用
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '关于应用',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildListTile(
                    title: '版本信息',
                    subtitle: 'v1.0.0',
                    onTap: () {
                      // 版本信息逻辑
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    title: '检查更新',
                    onTap: () {
                      // 检查更新逻辑
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    title: '用户协议',
                    onTap: () {
                      // 用户协议逻辑
                    },
                  ),
                  const Divider(height: 1),
                  _buildListTile(
                    title: '意见反馈',
                    onTap: () {
                      // 意见反馈逻辑
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 清除数据按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _showClearDataDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                ),
                child: const Text('清除缓存数据'),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 注销账户按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteAccountDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('注销账户'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
  
  Widget _buildListTile({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
  
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('选择语言'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('中文', context),
              _buildLanguageOption('English', context),
              _buildLanguageOption('日本語', context),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildLanguageOption(String language, BuildContext context) {
    return ListTile(
      title: Text(language),
      trailing: _language == language ? const Icon(Icons.check) : null,
      onTap: () {
        setState(() {
          _language = language;
        });
        Navigator.of(context).pop();
      },
    );
  }
  
  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('清除缓存数据'),
          content: const Text('这将清除所有本地缓存数据，但不会影响您的账户信息。确定要继续吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 清除缓存数据逻辑
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('缓存数据已清除')),
                );
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
  
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('注销账户'),
          content: const Text('此操作不可逆，您的所有数据将被永久删除。确定要继续吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 注销账户逻辑
                context.go('/home');
              },
              child: const Text('确定注销'),
            ),
          ],
        );
      },
    );
  }
}