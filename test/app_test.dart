import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App启动测试', (WidgetTester tester) async {
    // 构建我们的应用并触发一个帧
    await tester.pumpWidget(const MyApp());

    // 验证应用标题是否正确显示
    expect(find.text('Flutter Demo'), findsOneWidget);
  });

  testWidgets('首页计数器功能测试', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // 初始计数器值为0
    expect(find.text('0'), findsOneWidget);

    // 点击浮动按钮增加计数器
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // 验证计数器值变为1
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('导航功能测试', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // 初始在首页
    expect(find.text('欢迎使用 Flutter Demo'), findsOneWidget);

    // 点击个人资料按钮
    await tester.tap(find.text('查看个人资料'));
    await tester.pumpAndSettle();

    // 验证跳转到个人资料页面
    expect(find.text('个人资料'), findsOneWidget);
  });
}

class MockNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> routes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routes.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routes.remove(route);
  }
}