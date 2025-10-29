import 'dart:convert';
import 'package:flutter_demo/core/services/api_service.dart';
import 'package:flutter_demo/core/services/storage_service.dart';
import 'package:flutter_demo/shared/models/user_model.dart';

class UserRepository {

  UserRepository({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;
  final ApiService _apiService;
  final StorageService _storageService;

  // 获取用户信息
  Future<UserModel> getUser(String userId) async {
    try {
      final response = await _apiService.get('/users/$userId');
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } catch (e) {
      throw Exception('获取用户信息失败: $e');
    }
  }

  // 更新用户信息
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response = await _apiService.put(
        '/users/${user.id}',
        body: user.toJson(),
      );
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } catch (e) {
      throw Exception('更新用户信息失败: $e');
    }
  }

  // 保存用户信息到本地
  Future<void> saveUserToLocal(UserModel user) async {
    try {
      await _storageService.setString('current_user', jsonEncode(user.toJson()));
    } catch (e) {
      throw Exception('保存用户信息到本地失败: $e');
    }
  }

  // 从本地获取用户信息
  Future<UserModel?> getUserFromLocal() async {
    try {
      final userJson = _storageService.getString('current_user');
      if (userJson != null) {
        final data = jsonDecode(userJson);
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('从本地获取用户信息失败: $e');
    }
  }

  // 清除本地用户信息
  Future<void> clearLocalUser() async {
    try {
      await _storageService.remove('current_user');
    } catch (e) {
      throw Exception('清除本地用户信息失败: $e');
    }
  }

  // 检查用户是否已登录
  Future<bool> isUserLoggedIn() async {
    try {
      final token = _storageService.getString('user_token');
      final user = await getUserFromLocal();
      return token != null && user != null;
    } catch (e) {
      return false;
    }
  }
}

class AuthRepository {

  AuthRepository({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;
  final ApiService _apiService;
  final StorageService _storageService;

  // 用户登录
  Future<String> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );
      
      final data = jsonDecode(response.body);
      final token = data['token'] as String;
      
      // 保存token到本地
      await _storageService.setString('user_token', token);
      
      return token;
    } catch (e) {
      throw Exception('登录失败: $e');
    }
  }

  // 用户注册
  Future<String> register(String name, String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      
      final data = jsonDecode(response.body);
      final token = data['token'] as String;
      
      // 保存token到本地
      await _storageService.setString('user_token', token);
      
      return token;
    } catch (e) {
      throw Exception('注册失败: $e');
    }
  }

  // 用户登出
  Future<void> logout() async {
    try {
      // 调用登出API
      await _apiService.post('/auth/logout');
      
      // 清除本地存储
      await _storageService.remove('user_token');
      await _storageService.remove('current_user');
    } catch (e) {
      // 即使API调用失败，也要清除本地存储
      await _storageService.remove('user_token');
      await _storageService.remove('current_user');
      throw Exception('登出失败: $e');
    }
  }

  // 获取当前token
  String? getCurrentToken() {
    return _storageService.getString('user_token');
  }

  // 刷新token
  Future<String> refreshToken() async {
    try {
      final response = await _apiService.post('/auth/refresh');
      final data = jsonDecode(response.body);
      final token = data['token'] as String;
      
      // 保存新token到本地
      await _storageService.setString('user_token', token);
      
      return token;
    } catch (e) {
      throw Exception('刷新token失败: $e');
    }
  }
}