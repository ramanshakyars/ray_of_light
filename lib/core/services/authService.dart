import 'dart:async';
import 'dart:io';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    try {
      final response = await HttpService.post(PathConfig.login, body);
      if (response['jwtToken'] != null) {
        await LocalStorageService.setToken(response['jwtToken']);
        await LocalStorageService.setUser({
          'userId': response['userId'],
          'name': response['name'],
          'email': response['email'],
          'roles': response['roles'],
        });
        return {
          'success': true,
          'message': response['message'] ?? 'Login successful',
        };
      }
      return {
        'success': false,
        'message': response['message'] ?? 'Login failed',
      };
    } catch (e) {
      return {'success': false, 'message': _getErrorMessage(e)};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await HttpService.post(PathConfig.verifyOtp, body);
      return {
        'success': true,
        'message': response['message'] ?? 'OTP sent successfully',
      };
    } catch (e) {
      return {'success': false, 'message': _getErrorMessage(e)};
    }
  }

  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await HttpService.post(PathConfig.register, body);
      return {
        'success': true,
        'message': response['message'] ?? 'Registration successful',
      };
    } catch (e) {
      return {'success': false, 'message': _getErrorMessage(e)};
    }
  }

  static Future<Map<String, dynamic>> forgotPassword(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await HttpService.post(PathConfig.forgotPassword, body);
      return response['success'] == true
          ? {'success': true, 'message': 'OTP sent successfully'}
          : {
            'success': false,
            'message': response['message'] ?? 'Failed to send OTP',
          };
    } catch (e) {
      return {'success': false, 'message': _getErrorMessage(e)};
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await HttpService.post(
        PathConfig.passwordResetComplete,
        body,
      );
      return response['success'] == true
          ? {'success': true, 'message': 'Password reset successful'}
          : {
            'success': false,
            'message': response['message'] ?? 'Password reset failed',
          };
    } catch (e) {
      return {'success': false, 'message': _getErrorMessage(e)};
    }
  }

  static String _getErrorMessage(dynamic error) {
    if (error is SocketException) return 'No internet connection';
    if (error is TimeoutException) return 'Request timed out';
    if (error is FormatException) return 'Invalid server response';
    return 'Something went wrong';
  }
}
