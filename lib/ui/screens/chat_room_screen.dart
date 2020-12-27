import 'dart:async';
import 'package:intl/intl.dart';
import 'conversation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zephyr18112020/ui/widgets/my_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zephyr18112020/services/firestore_services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      width: MediaQuery.of(context).size.width - 60,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar(context: context, title: "ChatRoom", todo: () {}),
          body: StreamBuilder(
              stream: context.watch<FirestoreServices>().getChatRoomStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    color: Colors.red,
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if ((!snapshot.hasData || snapshot.data == null)) {
                  Timer(Duration(milliseconds: 40), () {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.error,
                              color: Theme.of(context).accentColor,
                              size: 70,
                            ),
                            Text(
                              'Aucune converssation',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                } else if (snapshot.hasData && snapshot.data != null) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(left: 75, right: 20),
                      child: Divider(
                        color: Color(0xFFfca311),
                      ),
                    ),
                    itemCount: snapshot.data.documents.length,
                    addAutomaticKeepAlives: true,
                    itemBuilder: (context, index) {
                      return ChatRoomRowWidget(
                        groupeName: snapshot.data.documents[index]["title"],
                        isRead: snapshot.data.documents[index]["isRead"],
                        lastMessage: snapshot.data.documents[index]
                            ["lastMessage"],
                        groupePicture: snapshot.data.documents[index]
                            ["groupePicture"],
                        time: snapshot.data.documents[index]["time"],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              }),
        ),
      ),
    );
  }
}

class ChatRoomRowWidget extends StatelessWidget {
  final String lastMessage;
  final String groupeName;
  final bool isRead;
  final String groupePicture;
  final int time;

  const ChatRoomRowWidget(
      {Key key,
      @required this.lastMessage,
      @required this.groupeName,
      @required this.isRead,
      this.groupePicture,
      this.time})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(
              convId: groupeName,
            ),
          ),
        );
      },
      child: Container(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 14, left: 2),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => VxBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              // height: 50,
                              // width: 50,
                              imageUrl: groupePicture ??
                                  "https://firebasestorage.googleapis.com/v0/b/let-s-play-05122020.appspot.com/o/app_icon.jpeg?alt=media&token=66f40d51-167e-429b-93f7-915d8d0033b1",
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    Image.asset('assets/images/profile.png')
                                        .image,
                              ),
                            ),
                          ),
                        )
                            .withRounded(value: 40)
                            .color(context.backgroundColor.withOpacity(0.7))
                            .border(
                              color: Vx.randomPrimaryColor,
                              width: 4,
                            )
                            .make()
                            .centered()
                            .p24(),
                      );
                    },
                    child: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                        imageUrl: groupePicture ??
                            "https://firebasestorage.googleapis.com/v0/b/let-s-play-05122020.appspot.com/o/app_icon.jpeg?alt=media&token=66f40d51-167e-429b-93f7-915d8d0033b1",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              Image.asset('assets/images/profile.png').image,
                        ),
                      ),
                    ),
                  ),
                ),
                // if (!isRead)
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRead
                        ? Colors.transparent
                        : Theme.of(context).accentColor.withOpacity(0.9),
                    border: Border.all(
                      color: isRead
                          ? Colors.transparent
                          : Theme.of(context).primaryColor,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.near_me,
                    size: 10,
                    color: isRead ? Colors.transparent : Colors.amberAccent,
                  ),
                  width: 40,
                  height: 20,
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    groupeName,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    lastMessage ?? 'Aucun message',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white70),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    DateFormat('kk:mm')
                            .format(
                              DateTime.fromMillisecondsSinceEpoch(
                                time,
                              ),
                            )
                            .toString() ??
                        "00::00",
                    style: GoogleFonts.copse(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      letterSpacing: 1.0,
                      color: Colors.amber,
                      height: 1.5,
                    ),
                  ),
                  Icon(
                    Icons.remove_red_eye_rounded,
                    size: 10,
                    color: isRead
                        ? Colors.transparent
                        : Theme.of(context).accentColor.withOpacity(0.9),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
