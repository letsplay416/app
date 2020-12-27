import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ActuScreen extends StatelessWidget {
  final String id;

  const ActuScreen({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('Actus').doc(id);

    return StreamBuilder<DocumentSnapshot>(
      stream: users.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
            color: Colors.red,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.topLeft,
            children: [
              _gamePicture(snapshot.data.data()["picture"]),
              _backBtn(context, "News"),
              _lPPic(
                context,
                12,
                snapshot.data.data()["title"],
                snapshot.data.data()["desc"],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.open_in_browser),
            onPressed: () async {
              String url = snapshot.data.data()["link"];
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        );
      },
    );
  }

  Container _lPPic(BuildContext context, int time, String title, String desc) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16.0,
          ),
        ],
        color: Color(0xFF14213d),
      ),
      margin: EdgeInsets.only(top: 266),
      child: ListView(
        children: [
          SizedBox(
            height: 24,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 16.0,
              ),
              Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).accentColor.withOpacity(0.2),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.4), width: 3),
                ),
                height: 60,
                width: 60,
                margin: const EdgeInsets.all(1),
                child: Center(
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
              SizedBox(
                width: 12.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: context.screenWidth - 100,
                    child: Text(
                      title,
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: Text(
                      DateFormat('kk:mm')
                              .format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  time,
                                ),
                              )
                              .toString() ??
                          "00::00",
                      style: TextStyle(
                        height: 1.4,
                        color: Colors.white60,
                        fontSize: 18.0,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SingleChildScrollView(
              child: Text(
                desc,
                style: TextStyle(
                  height: 1.4,
                  color: Colors.white70,
                  fontSize: 18.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _backBtn(BuildContext context, String type) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20.0, // has the effect of softening the shadow
                    spreadRadius: 2.0,
                    offset: Offset(
                      5.0, // horizontal, move right 10
                      5.0, // vertical, move down 10
                    ),
                  ),
                ],
                color: Colors.black45),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ),
          SizedBox(
            height: 62,
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).accentColor,
                    blurRadius: 5,
                    spreadRadius: 1)
              ],
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
              child: Text(
                type,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Let's Play",
              style: GoogleFonts.quando(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }

  CachedNetworkImage _gamePicture(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      height: 280,
      width: double.infinity,
    );
  }
}
