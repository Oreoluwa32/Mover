import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:movr/core/config/app_environment.dart';

class GoogleAuthHelper {
  /// Builds a GoogleSignIn that, when configured, requests an ID token
  /// audienced for our backend OAuth client. Without ``serverClientId``
  /// the resulting ID token's ``aud`` claim is the platform's Android /
  /// iOS client and the Movr backend will reject it.
  GoogleSignIn _googleSignIn() {
    final serverClientId = AppEnvironment.googleServerClientId;
    return GoogleSignIn(
      scopes: const ['email', 'profile'],
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );
  }

  // Handle google sign in to authenticate user
  Future<GoogleSignInAccount?> googleSignInProcess() async {
    return _googleSignIn().signIn();
  }

  // Authenticate with backend using Google data
  Future<Map<String, dynamic>?> authenticateWithBackend(
      GoogleSignInAccount googleUser) async {
    try {
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return null;
      }

      final response = await http.post(
        Uri.parse('${AppEnvironment.apiBaseUrl}/api/v1/auth/google-signin/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'id_token': idToken,
          'email': googleUser.email,
          'first_name': googleUser.displayName?.split(' ').first ?? '',
          'last_name': googleUser.displayName?.split(' ').skip(1).join(' ') ?? '',
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // To check if the user is already signed in through google
  Future<bool> alreadySignIn() async {
    return _googleSignIn().isSignedIn();
  }

  // To sign out from the application if the user is signed in through google
  Future<GoogleSignInAccount?> googleSignOutProcess() async {
    return _googleSignIn().signOut();
  }
}
