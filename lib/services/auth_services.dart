import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth;
  AuthServices(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> superUserLogin(
      {@required String mdp, @required BuildContext ctx}) async {
    Navigator.of(ctx).pop();
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: "letsplay.app.game@gmail.com", password: mdp);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ctx.showToast(
            msg: "Oups",
            textColor: Theme.of(ctx).accentColor,
            position: VxToastPosition.top,
            bgColor: Theme.of(ctx).primaryColor);
      } else if (e.code == 'wrong-password') {
        ctx.showToast(
            msg: "Mauvais mots de passe",
            textColor: Theme.of(ctx).accentColor,
            position: VxToastPosition.top,
            bgColor: Theme.of(ctx).primaryColor);
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return "Sign out successfully";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> verificationCompleted(AuthCredential authCreds) async {
    try {
      // UserCredential result =
      await _firebaseAuth.signInWithCredential(authCreds);

      print("Le numero à été vérifié");
    } catch (e) {
      print('Erreur: ${e.toString()}');
    }
  }

  void signInWithOTP(smsCode, verificationId) async {
    AuthCredential authCreds = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    await _firebaseAuth.signInWithCredential(authCreds);
  }
}
