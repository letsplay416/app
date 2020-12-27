import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'firestore_services.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

sendImg({
  @required String filename,
  @required String userId,
  @required File file,
  @required String convId,
  @required BuildContext context,
}) async {
  final _storage = FirebaseStorage.instance;

  await _storage.ref().child(filename).putFile(file);
  String url = await _storage.ref().child(filename).getDownloadURL();

  Map<String, dynamic> messageMap = {
    'message': url,
    'sendBy': '$userId',
    'time': DateTime.now().millisecondsSinceEpoch,
    'type': 2
  };
  context.read<FirestoreServices>().addConversationMessages(
        chatRoomId: convId,
        messageMap: messageMap,
      );
  context.read<FirestoreServices>().addLastMessage(
        chatRoomId: convId,
        sendBy: userId,
        message: "📷",
      );
}

postImg({
  @required String filename,
  @required String userId,
  @required File file,
  @required BuildContext context,
}) async {
  final _storage = FirebaseStorage.instance;
  await _storage.ref().child(filename).putFile(file);
  String url = await _storage.ref().child(filename).getDownloadURL();
  context.showToast(msg: "En cours !", bgColor: context.backgroundColor);
  Map<String, dynamic> postMap = {
    'picture': url,
    'userUid': '$userId',
    'time': DateTime.now().millisecondsSinceEpoch,
    'id': "",
    'views': 0,
    "likers": [""]
  };
  context
      .read<FirestoreServices>()
      .addPost(postMap: postMap, uid: userId, context: context);
}

// addProfilePic({
//   @required String filename,
//   @required String userId,
//   @required File file,
//   @required BuildContext context,
// }) async {
//   final _storage = FirebaseStorage.instance;
//   await _storage.ref().child(filename).putFile(file);
//   String url = await _storage.ref().child(filename).getDownloadURL();
//   context.showToast(msg: "En cours !", bgColor: context.backgroundColor);
  // await context.read<FirestoreServices>().addProfilePicTofs(uid: userId, link: url);
// }

sendSticker({
  @required String stickerName,
  @required String userId,
  @required String convId,
  @required BuildContext context,
}) async {
  Map<String, dynamic> messageMap = {
    'message': stickerName,
    'sendBy': '$userId',
    'time': DateTime.now().millisecondsSinceEpoch,
    'type': 5
  };
  context.read<FirestoreServices>().addConversationMessages(
        chatRoomId: convId,
        messageMap: messageMap,
      );
  context.read<FirestoreServices>().addLastMessage(
        chatRoomId: convId,
        sendBy: userId,
        message: "😂😍😴😡🐸",
      );
}
