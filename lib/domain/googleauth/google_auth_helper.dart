import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAuthHelper {
  // Handle google sign in to authenticate user
  Future<GoogleSignInAccount?> googleSignInProcess() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'profile',
      ],
    );
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      return googleUser;
    }
    return null;
  }

  // Authenticate with backend using Google data
  Future<Map<String, dynamic>?> authenticateWithBackend(GoogleSignInAccount googleUser) async {
    try {
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return null;
      }

      final response = await http.post(
        Uri.parse('https://movr-api.onrender.com/api/v1/auth/google-signin'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'id_token': idToken,
          'email': googleUser.email,
          'first_name': googleUser.displayName?.split(' ')[0] ?? 'User',
          'last_name': googleUser.displayName?.split(' ').skip(1).join(' ') ?? 'Account',
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Backend authentication error: $e');
      return null;
    }
  }

  // To check if the user is already signed in through google
  alreadySignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    bool alreadySignIn = await googleSignIn.isSignedIn();
    return alreadySignIn;
  }

  // To sign out from the applicarion if the user is signed in through google
  Future<GoogleSignInAccount?> googleSignOutProcess() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signOut();
    return googleUser;
  }
}