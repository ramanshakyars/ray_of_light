import 'package:dio/dio.dart';
import 'package:rayoflite/core/config/inteceptor.dart';

class HttpService {
  static final Dio _dio = AuthInterceptor.client;

  static Future<dynamic> get(String url) async {
    try {
      final response = await _dio.get(url);
      return response.data;
    } on DioException catch (e) {
      print("HTTP GET ERROR => ${e.type}");
      throw e;
    }
  }

  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post(url, data: body);
      //  print(response.data);
      return response.data;
    } on DioException catch (e) {
      print("HTTP GET ERROR => ${e.type}");
      throw e;
    }
  }

  static Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.put(url, data: body);
      return response.data;
    } on DioException catch (e) {
      print("HTTP GET ERROR => ${e.type}");
      throw e;
    }
  }

  static Future<Map<String, dynamic>> delete(String url) async {
    try {
      final response = await _dio.delete(url);
      return response.data;
    } on DioException catch (e) {
      print("HTTP GET ERROR => ${e.type}");
      throw e;
    }
  }

  static Future<Map<String, dynamic>> patch(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.patch(url, data: body);
      return response.data;
    } on DioException catch (e) {
      print("HTTP GET ERROR => ${e.type}");
      throw e;
    }
  }

  static Future<dynamic> postMultipart(String url, FormData formData) async {
    try {
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return response.data;
    } on DioException catch (e) {
      print("HTTP GET ERROR => ${e.type}");
      throw e;
    }
  }

  static Future<dynamic> postRaw(String url, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(url, data: body);
      return response.data;
    } on DioException catch (e) {
      print("HTTP GET ERROR => ${e.type}");
      throw e;
    }
  }
}
