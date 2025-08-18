import 'package:dio/dio.dart';
import 'package:rayoflite/core/config/inteceptor.dart';

class HttpService {
  static final Dio _dio = AuthInterceptor.client;

  static Future<dynamic> get(String url) async {
    final response = await _dio.get(url);
    return response.data;
  }

  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post(url, data: body);
  //  print(response.data);
    return response.data;
  }

  static Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put(url, data: body);
    return response.data;
  }

  static Future<Map<String, dynamic>> delete(String url) async {
    final response = await _dio.delete(url);
    return response.data;
  }

  static Future<Map<String, dynamic>> patch(
    String url,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.patch(url, data: body);
    return response.data;
  }
}
