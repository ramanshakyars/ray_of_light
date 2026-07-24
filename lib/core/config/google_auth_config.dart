import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthConfig {
  // ── iOS OAuth 2.0 Client ID (type: iOS) ─────────────────────────────────────
  // Source: Google Cloud Console → Credentials → iOS Client
  static const String iosClientId =
      '630134708747-o5c8nlum9p82s58j54soiphh6uq2s6ag.apps.googleusercontent.com';

  // ── Web / Server OAuth 2.0 Client ID (type: Web application) ────────────────
  // Required on BOTH platforms to obtain an idToken in GoogleSignInAuthentication.
  // On Android the SDK reads package info from google-services.json automatically
  // (no separate Android client ID is needed in Dart code).
  // This ID must also appear as client_type:3 inside google-services.json.
  static const String serverClientId =
      '630134708747-eghjbf2f82lcl616dvb6augfueo7a0p5.apps.googleusercontent.com';

  static final GoogleSignIn googleSignIn = GoogleSignIn(
    // iOS  → pass the iOS client ID so the SDK picks the right credential.
    // Android → must be null; the SDK resolves credentials from google-services.json.
    clientId: Platform.isIOS ? iosClientId : null,

    // serverClientId tells the SDK which audience to mint the ID token for.
    // This is what your Spring Boot /public/login/google endpoint verifies.
    serverClientId: serverClientId,

    scopes: ['email', 'profile'],
  );
}
