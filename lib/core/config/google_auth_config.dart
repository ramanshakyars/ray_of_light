import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthConfig {
  // ─────────────────────────────────────────────────────────────
  // iOS OAuth 2.0 Client ID
  // Google Cloud Console → Clients → iOS
  // ─────────────────────────────────────────────────────────────
  static const String iosClientId =
      '630134708747-o5c8nlum9p82s58j54soiphh6uq2s6ag.apps.googleusercontent.com';

  // ─────────────────────────────────────────────────────────────
  // Android OAuth 2.0 Client ID
  // Google Cloud Console → Clients → Android
  // ─────────────────────────────────────────────────────────────
  static const String androidClientId =
      '630134708747-jpe7erv2ev54voff0o72gvehcjqkffpq.apps.googleusercontent.com';

  // ─────────────────────────────────────────────────────────────
  // Web / Server OAuth 2.0 Client ID
  // This is the audience your Spring Boot backend verifies.
  // Google Cloud Console → Clients → Web application
  // ─────────────────────────────────────────────────────────────
  static const String serverClientId =
      '630134708747-eghjbf2f82lcl616dvb6augfueo7a0p5.apps.googleusercontent.com';

  static final GoogleSignIn googleSignIn = GoogleSignIn(
    // iOS → iOS OAuth client
    // Android → Android OAuth client
    clientId: Platform.isIOS
        ? iosClientId
        : androidClientId,

    // IMPORTANT:
    // This remains the WEB client ID because your backend
    // validates the ID token against this audience.
    serverClientId: serverClientId,

    scopes: [
      'email',
      'profile',
    ],
  );
}