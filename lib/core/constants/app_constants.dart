class AppConstants {
  static const String appName = 'Flutter Demo';
  static const String appVersion = '1.0.0';
  
  // API endpoints
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/v1';
  
  // Storage keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'app_language';
  static const String userTokenKey = 'user_token';
  
  // Animation durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  
  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm:ss';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
}