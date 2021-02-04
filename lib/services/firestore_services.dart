import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:zephyr18112020/ui/screens/main_page.dart';
import 'package:zephyr18112020/ui/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  final FirebaseFirestore _firebaseFirestore;

  FirestoreServices(this._firebaseFirestore);
  Future<void> updateUserData({
    String pseudo,
    String uid,
    String picture,
    String mail,
  }) {
    return _firebaseFirestore
        .collection("Users")
        .doc(uid.toString())
        .set(
          {
            'pseudo': pseudo,
            'coins': 0,
            'bullets': 0,
            'diamonds': 0,
            'isVip': false,
            'isBanned': false,
            'mail': mail,
            'picture': picture,
            'uid': uid,
          },
        )
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Stream getChatRoomStream() {
    return _firebaseFirestore
        .collection("discussions")
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<String> getPseudo({@required uid}) {
    return _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .get()
        .then((value) => "null");
  }

  Future<dynamic> addAbet(
      {String userUid,
      int amount,
      String eventId,
      String equipe,
      int previousCoins}) {
    return _firebaseFirestore
        .collection("Events")
        .doc(eventId)
        .collection("bets")
        .add({
      "userUid": userUid,
      "amount": amount,
      "player": equipe,
    }).then((value) {
      _firebaseFirestore
          .collection("Users")
          .doc(userUid)
          .collection("bets")
          .add({
        "userUid": userUid,
        "amount": amount,
        "player": equipe,
      });
    }).then((value) => {
              _firebaseFirestore
                  .collection("Users")
                  .doc(userUid)
                  .update({"coins": previousCoins - amount}).catchError(
                      (error) => print("Failed to add user: $error"))
            });
  }

  Future<dynamic> userRegistration({
    @required String pseudo,
    @required String email,
    @required BuildContext context,
    @required String filename,
    @required File file,
  }) async {
    var user = FirebaseAuth.instance.currentUser;
    final _storage = FirebaseStorage.instance;
    await _storage.ref().child(filename).putFile(file);
    String url = await _storage.ref().child(filename).getDownloadURL();
    context.showToast(msg: "En cours !", bgColor: context.backgroundColor);
    return _firebaseFirestore
        .collection("Users")
        .doc(user.uid)
        .set({
          "phoneNumber": user.phoneNumber.toString().trim(),
          'pseudo': pseudo,
          'mail': email,
          'signInDate': DateTime.now(),
          'bullets': 2000,
          'coins': 0,
          'diamonds': 0,
          'picture': url,
          'isVip': false,
          'isBanned': false,
          "uid": user.uid
        })
        .then((value) {})
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<dynamic> addConversationMessages({
    @required String chatRoomId,
    @required messageMap,
  }) {
    return _firebaseFirestore
        .collection("discussions")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<dynamic> addPost(
      {@required String uid,
      @required postMap,
      @required BuildContext context}) {
    return _firebaseFirestore
        .collection("Posts")
        .add(postMap)
        .catchError((error) => print("Failed to add user: $error"))
        .then((value) async {
      _firebaseFirestore.collection("Posts").doc(value.id).update(
          {"id": value.id}).then((value) => context.showToast(msg: "Fait"));
    });
  }

  Future<dynamic> addProfilePicTofs({@required String uid, @required link}) {
    return _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .update({"picture": link}).catchError(
            (error) => print("Failed to add user: $error"));
  }

  Future<dynamic> editPseudo({@required String uid, @required newPseudo}) {
    return _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .update({"pseudo": newPseudo}).catchError(
            (error) => print("Failed to add user: $error"));
  }

  Future<dynamic> addLastMessage({
    @required String chatRoomId,
    @required String sendBy,
    @required String message,
  }) {
    return _firebaseFirestore.collection("discussions").doc(chatRoomId).update({
      'lastMessage': message,
      'lastMessageSendBy': sendBy,
      'time': DateTime.now().millisecondsSinceEpoch,
      'isRead': false,
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<dynamic> aMethod({
    String uid,
  }) {
    return _firebaseFirestore.collection("Users").doc(uid).get().then((value) {
      if (value.exists) {
        return MainPage();
      } else {
        return SignUpScreen();
      }
    }).catchError((error) => print("erreur ici $error"));
  }
}
