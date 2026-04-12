// lib/core/config/inteceptor.dart
import 'package:dio/dio.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/providers/TokenManager.dart';
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
        onRequest: (options, handler) {
          final token = TokenManager.token;

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            print('🔑 Unauthorized → clearing session');

            await LocalStorageService.clearAll();
            TokenManager.clear();
          }

          return handler.next(e);
        },
      ),
    );
    return _dio;
  }
}
