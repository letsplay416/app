import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatItemWidget extends StatelessWidget {
  final int type;
  final message;
  final bool isSendByMe;
  final String sendBy;
  final time;
  ChatItemWidget({
    @required this.type,
    @required this.message,
    @required this.isSendByMe,
    @required this.time,
    @required this.sendBy,
  });
  @override
  Widget build(BuildContext context) {
    if (isSendByMe) {
      if (type == 1) {
        return Container(
          /**
              text
           */
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(new ClipboardData(text: message));

                      context.showToast(
                          msg: "Copié dans le presse-papiers",
                          textColor: Theme.of(context).accentColor,
                          position: VxToastPosition.top,
                          bgColor: Theme.of(context).primaryColor);
                    },
                    child: Container(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                          color: Color(0xFFfca311),
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      DateFormat('kk:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(time)),
                      style: TextStyle(
                        color: Color(0xFFfca311),
                        fontSize: 12.0,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                  ),
                ],
              ),
            ],
          ),
        );
      } else if (type == 2) {
        return Container(
          /**
              image
           */
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierColor: context.backgroundColor.withOpacity(0.9),
                        builder: (context) => VxBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              // height: 50,
                              // width: 50,
                              imageUrl: "$message" ??
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
                              color: context.accentColor,
                              width: 4,
                            )
                            .make()
                            .centered()
                            .p24(),
                      );
                    },
                    onLongPress: () {

                      context.showToast(
                          msg: "Que la force soit avec toi jeune padawan",
                          textColor: Theme.of(context).accentColor,
                          position: VxToastPosition.center,
                          bgColor: Theme.of(context).primaryColor);
                    },
                    child: Container(
                      child: TestImg(message: message),
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                          color: Color(0xFFfca311),
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      DateFormat('kk:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(time)),
                      style: TextStyle(
                        color: Color(0xFFfca311),
                        fontSize: 12.0,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                  ),
                ],
              ),
            ],
          ),
        );
      } else if (type == 5) {
        return Container(
          //This is the sent message. We'll later use data from firebase instead of index to determine the message is sent or received.
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      message,
                    ),
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        color: Colors.transparent, //couleur11,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(right: 10.0),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(time)),
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 12.0,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                  ),
                ],
              ),
            ],
          ),
        );
      }
      else{  return Container(
          /**
              text
           */
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onLongPress: () {
                    },
                    child: Container(
                      child: Text(
                        "Quelque chose cloche 😭",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                          color: Color(0xFFfca311),
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      DateFormat('kk:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(time)),
                      style: TextStyle(
                        color: Color(0xFFfca311),
                        fontSize: 12.0,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                  ),
                ],
              ),
            ],
          ),
        );}
    } else {
      /**
       ** This is a received message
       */
      if (type == 1) {
        return Container(
          /**
              text
           */
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  child: GetPseudo(uid: sendBy),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                ),
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(new ClipboardData(text: message));

                      context.showToast(
                          msg: "Copié dans le presse-papiers",
                          textColor: Theme.of(context).accentColor,
                          position: VxToastPosition.top,
                          bgColor: Theme.of(context).primaryColor);
                    },
                    child: Container(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 17,
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.only(left: 10.0),
                    ),
                  )
                ],
              ),
              Container(
                child: Text(
                  DateFormat('kk:mm')
                      .format(DateTime.fromMillisecondsSinceEpoch(time)),
                  style: TextStyle(
                      color: Theme.of(context).accentColor.withGreen(100),
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal),
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      } else if (type == 2) {
        /**
            Image
         */
        return Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  child: GetPseudo(uid: sendBy),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                ),
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierColor: context.backgroundColor.withOpacity(0.9),
                        builder: (context) => VxBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              // height: 50,
                              // width: 50,
                              imageUrl: "$message" ??
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
                              color: context.accentColor,
                              width: 4,
                            )
                            .make()
                            .centered()
                            .p24(),
                      );
                    },
                    onDoubleTap: () {},
                    child: Container(
                      child: CachedNetworkImage(
                        imageUrl: "$message",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Unicon(
                          UniconData.uniBug,
                          color: Colors.white,
                        ),
                      ),
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor.withGreen(150),
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.only(left: 10.0),
                    ),
                  ),
                ],
              ),
              Container(
                child: Text(
                  DateFormat('dd MMM kk:mm')
                      .format(DateTime.fromMillisecondsSinceEpoch(time)),
                  style: TextStyle(
                      color: Theme.of(context).accentColor.withGreen(150),
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal),
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      } else if (type == 3) {
        /**
            audio
         */
        return Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  child: Text(
                    sendBy,
                    style: TextStyle(
                      color: Theme.of(context).accentColor.withGreen(100),
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(224, 30, 90, 1.0),
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0),
                  ),
                ],
              ),
              Container(
                child: Text(
                  DateFormat('kk:mm')
                      .format(DateTime.fromMillisecondsSinceEpoch(time)),
                  style: TextStyle(
                      color: Color.fromRGBO(224, 30, 90, 1.0),
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal),
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      } else if (type == 4) {
        /**
            video
         */
        return Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  child: Text(
                    sendBy,
                    style: TextStyle(
                      color: Theme.of(context).accentColor.withGreen(100),
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        context.showToast(
                            msg: "Envoi de vidéo",
                            textColor: Theme.of(context).accentColor,
                            position: VxToastPosition.top,
                            bgColor: Theme.of(context).primaryColor);
                      },
                      child: Image.asset(
                        "assets/images/telechargerVideo1.png",
                      ),
                    ),
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0),
                  ),
                ],
              ),
              Container(
                child: Text(
                  DateFormat('kk:mm')
                      .format(DateTime.fromMillisecondsSinceEpoch(time)),
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal),
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      } else if (type == 5) {
        /**
            sticker
         */
        return Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  child: GetPseudo(uid: sendBy),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      message,
                    ),
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0),
                  ),
                ],
              ),
              Container(
                child: Text(
                  DateFormat('kk:mm')
                      .format(DateTime.fromMillisecondsSinceEpoch(time)),
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal),
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      } else {
        /**
            other
         */
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      message,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0),
                  ),
                ],
              ),
              Container(
                child: Text(
                  DateFormat('kk:mm')
                      .format(DateTime.fromMillisecondsSinceEpoch(time)),
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal),
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      }
    }
  }
}

class TestImg extends StatelessWidget {
  const TestImg({
    Key key,
    @required this.message,
  }) : super(key: key);

  final message;

  @override
  Widget build(BuildContext context) {
    try {
      return Image.network(message);
    } catch (e) {
      print(e.toString());
      return Container();
    }
  }
}

class GetPseudo extends StatelessWidget {
  const GetPseudo({
    Key key,
    @required this.uid,
  }) : super(key: key);

  final String uid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .get(), //! remplacer par "7SbvtFu4miYRcoIz9Yr82UlCO4w1"
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Text(
            snapshot.data["pseudo"], 
            style: TextStyle(
              color: Vx.randomPrimaryColor,
              fontSize: 15.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return Text(
            "", //  sendBy,
            style: TextStyle(
              color: Theme.of(context).accentColor.withGreen(100),
              fontSize: 15.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          );
        }
      },
    );
  }
}
