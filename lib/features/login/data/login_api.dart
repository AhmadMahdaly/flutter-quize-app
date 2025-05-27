import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi{
static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'openid', 'profile'],
  serverClientId: '389808664508-1c42hhj3512t0unhti8adggb1htoujpi.apps.googleusercontent.com'
);
static Future<GoogleSignInAccount?>login()=>_googleSignIn.signIn();
static Future<GoogleSignInAccount?>logOut()=>_googleSignIn.signOut();
}