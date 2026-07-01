import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthConfig {
  // Replace these with your actual Client IDs from Firebase/Google Console when ready
  static const String iosClientId = '630134708747-o5c8nlum9p82s58j54soiphh6uq2s6ag.apps.googleusercontent.com';
  static const String serverClientId = '630134708747-eghjbf2f82lcl616dvb6augfueo7a0p5.apps.googleusercontent.com';

  static final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS ? iosClientId : null,
    serverClientId: serverClientId,
    scopes: ['email', 'profile'],
  );
}
