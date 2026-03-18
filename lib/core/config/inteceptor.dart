// lib/core/config/inteceptor.dart
import 'package:dio/dio.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/localStorageService.dart';

class AuthInterceptor {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: PathConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ),
  );

  static Dio get client {
    _dio.interceptors.clear();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorageService.getToken();
          // print('TOKEN USED: $token');
          // print('REQUEST HEADERS: ${options.headers}');
          // print('REQUEST URL: ${options.uri}');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print('❌ Error: ${e.response?.statusCode} - ${e.message}');
          
          // 🔴 ONLY clear on 401 Unauthorized
          if (e.response?.statusCode == 401) {
            print('🔑 Token expired - logging out');
            LocalStorageService.clearAll();
          }
          // ✅ Don't clear on other errors (network issues, server errors, etc.)
          
          return handler.next(e);
        },
      ),
    );
    return _dio;
  }
}