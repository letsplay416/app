import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:zephyr18112020/ui/screens/main_page.dart';
import 'package:zephyr18112020/ui/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zephyr18112020/ui/screens/sign_up_screen.dart';
import 'package:zephyr18112020/ui/widgets/loading_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      if (firebaseUser.isAnonymous) {
        return MainPage();
      } else {
        return NewUser();
      }
    }
    print("Aucun user connecté");
    return SignInPage();
  }
}

class NewUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(context.watch<User>().uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else {
          if (snapshot.data.exists) {
            return MainPage();
          }
          return RegistrationScreen();
        }
      },
    );
  }
}
