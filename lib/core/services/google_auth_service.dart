import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rayoflite/core/config/google_auth_config.dart';
import 'package:rayoflite/core/services/authService.dart';

class GoogleAuthService {
  static final GoogleSignIn _googleSignIn = GoogleAuthConfig.googleSignIn;

  /// Centralised method to handle full Google Sign-In flow:
  /// 1. Safe sign-out (clears stale state, catches uninitialized errors)
  /// 2. Launch Google account picker
  /// 3. Handle user cancellation quietly
  /// 4. Retrieve ID Token (with fallback retry if null)
  /// 5. Authenticate with backend API
  static Future<Map<String, dynamic>> signIn() async {
    try {
      // Step 1: Safely clear previous session without failing on errors
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        dev.log(
          '[GoogleAuthService] signOut warning (safe to ignore): $e',
          name: 'GoogleOAuth',
        );
      }

      // Step 2: Trigger Google Sign-In UI picker
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        dev.log(
          '[GoogleAuthService] User cancelled Google Account selection.',
          name: 'GoogleOAuth',
        );
        return {
          'success': false,
          'cancelled': true,
          'message': 'Sign-In cancelled',
        };
      }

      dev.log(
        '[GoogleAuthService] Account selected: ${googleUser.email}',
        name: 'GoogleOAuth',
      );

      // Step 3: Fetch authentication tokens
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      String? idToken = googleAuth.idToken;

      // Step 4: Retry token retrieval if initially null
      if (idToken == null || idToken.isEmpty) {
        dev.log(
          '[GoogleAuthService] idToken null on first attempt. Retrying authentication...',
          name: 'GoogleOAuth',
        );
        await Future.delayed(const Duration(milliseconds: 300));
        googleAuth = await googleUser.authentication;
        idToken = googleAuth.idToken;
      }

      if (idToken == null || idToken.isEmpty) {
        dev.log(
          '[GoogleAuthService] Failed to retrieve idToken after retry. '
          'Verify serverClientId matches client_type: 3 in google-services.json.',
          name: 'GoogleOAuth',
        );
        return {
          'success': false,
          'cancelled': false,
          'message': 'Google authentication failed: unable to obtain ID token.',
        };
      }

      dev.log(
        '[GoogleAuthService] ID Token retrieved successfully. Authenticating with server...',
        name: 'GoogleOAuth',
      );

      // Step 5: Send token to backend
      final serverResponse = await AuthService.googleLogin(idToken);
      return serverResponse;

    } on PlatformException catch (e, st) {
      dev.log(
        '[GoogleAuthService] PlatformException: ${e.code} - ${e.message}',
        name: 'GoogleOAuth',
        error: e,
        stackTrace: st,
      );

      String errorMessage = 'Google Sign-In failed.';
      if (e.code == 'network_error') {
        errorMessage = 'Network error during Google Sign-In. Please check your internet connection.';
      } else if (e.code == 'sign_in_failed' || e.code == '10') {
        errorMessage = 'Google Sign-In configuration error (ApiException 10). Ensure SHA-1 fingerprint is registered in Firebase/Google Cloud Console for com.wrappedweb.rayoflite.';
      } else if (e.code == 'concurrent_requests') {
        errorMessage = 'Sign-In request already in progress. Please wait a moment.';
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMessage = 'Google Sign-In failed: ${e.message}';
      }

      return {
        'success': false,
        'cancelled': false,
        'message': errorMessage,
      };
    } catch (e, st) {
      dev.log(
        '[GoogleAuthService] Unexpected error: $e',
        name: 'GoogleOAuth',
        error: e,
        stackTrace: st,
      );

      return {
        'success': false,
        'cancelled': false,
        'message': 'Google Sign-In failed: ${e.toString()}',
      };
    }
  }
}
