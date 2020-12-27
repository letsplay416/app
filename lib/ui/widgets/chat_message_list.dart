import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

messagesList(
    {@required chatRoomId,
    @required scrollController,
    @required BuildContext ctx}) {
  return Expanded(
    child: Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('discussions')
            .doc(chatRoomId)
            .collection('chats')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Container(
                child: Text('Erreur'),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return (snapshot.hasData || snapshot.data != null)
              ? ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    //
                    return ChatItemWidget(
                      message: snapshot.data.documents[index].data()["message"],
                      sendBy: snapshot.data.documents[index].data()["sendBy"],
                      time: snapshot.data.documents[index].data()["time"],
                      type: snapshot.data.documents[index].data()["type"],
                      isSendByMe:
                          snapshot.data.documents[index].data()["sendBy"] ==
                              ctx.read<User>().uid,
                    );
                  },
                )
              : Center(
                  child: Container(
                    child: Text('Aucun message'),
                  ),
                );
        },
      ),
    ),
  );
}
