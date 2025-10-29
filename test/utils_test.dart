import 'package:flutter_demo/core/utils/app_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUtils 测试', () {
    test('邮箱格式验证', () {
      expect(AppUtils.isValidEmail('test@example.com'), true);
      expect(AppUtils.isValidEmail('invalid-email'), false);
      expect(AppUtils.isValidEmail('test@'), false);
      expect(AppUtils.isValidEmail('@example.com'), false);
    });

    test('手机号格式验证', () {
      expect(AppUtils.isValidPhone('13812345678'), true);
      expect(AppUtils.isValidPhone('12345678901'), false);
      expect(AppUtils.isValidPhone('1381234567'), false);
      expect(AppUtils.isValidPhone('abc12345678'), false);
    });

    test('文件大小格式化', () {
      expect(AppUtils.formatFileSize(0), '0 B');
      expect(AppUtils.formatFileSize(1024), '1.00 KB');
      expect(AppUtils.formatFileSize(1048576), '1.00 MB');
      expect(AppUtils.formatFileSize(1073741824), '1.00 GB');
    });
  });

  group('字符串扩展方法测试', () {
    test('首字母大写', () {
      expect('hello'.capitalize(), 'Hello');
      expect(''.capitalize(), '');
      expect('h'.capitalize(), 'H');
    });

    test('空值检查', () {
      expect(''.isNullOrEmpty, true);
      expect('hello'.isNullOrEmpty, false);
    });
  });

  group('日期扩展方法测试', () {
    test('日期格式化', () {
      final date = DateTime(2024, 1, 15);
      expect(date.toFormattedString(), '2024-01-15');
    });

    test('是否为今天', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      
      expect(today.isToday(), true);
      expect(yesterday.isToday(), false);
    });
  });
}