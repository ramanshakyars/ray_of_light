// lib/services/http_interceptor.dart
import 'package:http/http.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:dio/dio.dart';
import 'package:rayoflite/core/services/localStorageService.dart';

class AuthInterceptor  {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.98.67:9090',
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
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print(e);
          return handler.next(e);
        },
      ),
    );
    return _dio;
  }
}