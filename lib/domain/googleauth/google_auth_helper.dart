import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthHelper {
  // Handle google sign in to authenticate user
  Future<GoogleSignInAccount?> googleSignInProcess() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      return googleUser;
    }
    return null;
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