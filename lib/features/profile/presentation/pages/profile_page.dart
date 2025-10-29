import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人资料'),
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
            // 头像部分
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '用户名称',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'user@example.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // 个人信息卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '个人信息',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem('姓名', '张三'),
                    _buildInfoItem('电话', '138****5678'),
                    _buildInfoItem('地址', '北京市朝阳区'),
                    _buildInfoItem('注册时间', '2024-01-01'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 功能菜单
            Card(
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.edit,
                    title: '编辑资料',
                    onTap: () {
                      // 编辑资料逻辑
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    icon: Icons.security,
                    title: '隐私设置',
                    onTap: () {
                      // 隐私设置逻辑
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    icon: Icons.notifications,
                    title: '通知设置',
                    onTap: () {
                      // 通知设置逻辑
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuTile(
                    icon: Icons.help,
                    title: '帮助与反馈',
                    onTap: () {
                      // 帮助与反馈逻辑
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 操作按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 退出登录逻辑
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('退出登录'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认退出'),
          content: const Text('您确定要退出登录吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 执行退出登录逻辑
                context.go('/home');
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );
  }
}