import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  //SIGN IN AND SIGN UP METHOD

  Future signInOrSignUp(
      {required bool isSignIn,
      required String email,
      required String password}) async {
    try {
      isSignIn
          ? await _auth.signInWithEmailAndPassword(
              email: email, password: password)
          : await _auth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
  }
}
