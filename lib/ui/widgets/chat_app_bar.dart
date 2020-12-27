import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 70;
  final String groupeId;

  const ChatAppBar({
    @required this.groupeId,
  });
  @override
  Widget build(BuildContext context) {
    var textHeading = TextStyle(
      color: Theme.of(context).accentColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    var textStyle = TextStyle(color: Colors.orange);
    return Material(
      color: Theme.of(context).primaryColor.withOpacity(0.5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          boxShadow: [
            new BoxShadow(
              color: Theme.of(context).primaryColor,
              blurRadius: 5.0,
            )
          ],
        ),
        child: Container(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getGroupeName(context, textHeading, textStyle, groupeId),
              _getGroupePicture(context: context, groupeId: groupeId),
            ],
          ),
        ),
      ),
    );
  }

  _getGroupeName(BuildContext context, TextStyle textHeading,
      TextStyle textStyle, String groupeId) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("discussions")
          .doc(groupeId)
          .get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Container(
            child: Center(
              child: Row(
                children: <Widget>[
                  Container(
                    child: IconButton(
                      color: Theme.of(context).accentColor,
                      icon: Unicon(
                        UniconData.uniAngleLeft,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        snapshot.data["title"] ?? "groupe",
                        style: textHeading,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "Let's Play",
                        style: textStyle,
                      ),
                    ],
                  ),
                ],
              ),
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

  Widget _getGroupePicture({BuildContext context, String groupeId}) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("discussions")
          .doc(groupeId)
          .get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).accentColor.withOpacity(0.4),
                  border: Border.all(
                    color: Colors.amberAccent.withOpacity(0.4),
                    width: 3,
                  ),
                ),
                margin: const EdgeInsets.all(5),
                child: Center(
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
                            imageUrl: snapshot.data["groupePicture"] ??
                                "https://firebasestorage.googleapis.com/v0/b/let-s-play-05122020.appspot.com/o/app_icon.jpeg?alt=media&token=66f40d51-167e-429b-93f7-915d8d0033b1",
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                              value: downloadProgress.progress,
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
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
                  child: ClipOval(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                      imageUrl: snapshot.data["groupePicture"] ??
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
                ) //Image.network(snapshot.data["groupePicture"]),
                    ),
              ),
              // if (!isRead)
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).accentColor.withOpacity(0.9),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 3),
                ),
                child: Unicon(
                  UniconData.uniExpandArrowsAlt,
                  color: Colors.amber,
                  size: 10,
                ),
                width: 20,
                height: 20,
              ),
            ],
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

  @override
  Size get preferredSize => Size.fromHeight(height);
}
