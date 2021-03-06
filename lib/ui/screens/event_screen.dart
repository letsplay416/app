import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:zephyr18112020/services/firestore_services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventScreen extends StatelessWidget {
  final String id;

  const EventScreen({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DocumentReference users =
        FirebaseFirestore.instance.collection('Events').doc(id);

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
              _gamePicture(snapshot.data.data()["imageURL"]),
              _backBtn(context, snapshot.data.data()["type"]),
              _lPPic(
                context,
                snapshot.data.data()["date"],
                snapshot.data.data()["gameName"],
                snapshot.data.data()["desc"],
              ),
              _betBtn(
                ctx: context,
                eventId: snapshot.data.data()["id"],
                gain: snapshot.data.data()["gain"].toInt(),
                type: snapshot.data.data()["type"],
                mise: snapshot.data.data()["mise"],
              ),
            ],
          ),
        );
      },
    );
  }

  Align _betBtn({
    BuildContext ctx,
    int gain,
    int mise,
    String type,
    String eventId,
  }) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 242, right: 32),
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(24.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20.0,
                  spreadRadius: 2.0,
                  offset: Offset(
                    5.0,
                    5.0,
                  ),
                ),
              ],
              color: Colors.white),
          child: IconButton(
            onPressed: () {
              type == "Soon"
                  ? ctx.showToast(
                      msg: "Aucun pari de disponible",
                      bgColor: ctx.theme.primaryColor,
                      textColor: ctx.theme.accentColor,
                    )
                  : type == "daily"
                      ? showModalBottomSheet(
                          context: ctx,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext bc) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(ctx).primaryColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    topLeft: Radius.circular(20.0)),
                              ),
                              child: new Wrap(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    width: double.infinity,
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(color: Colors.white),
                                        children: [
                                          TextSpan(
                                            text: "Vous misez: ",
                                            style: GoogleFonts.arbutusSlab(
                                              fontSize: 15.0,
                                              color: Colors.white60,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "$mise Coin(s)",
                                            style: GoogleFonts.arbutusSlab(
                                              fontSize: 15.0,
                                              color: Colors.amberAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 5),
                                    color: Colors.amber.withOpacity(0.2),
                                    height: 2,
                                  ),
                                  ListTile(
                                      leading: new Icon(Icons.music_note),
                                      title: new Text(
                                        'Blue Team',
                                        style: GoogleFonts.arbutusSlab(
                                          fontSize: 15.0,
                                          color: Colors.lightBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () => {
                                            _bet(
                                              mise: mise,
                                              equipe: "Blue Team",
                                              ctx: ctx,
                                              eventId: eventId,
                                              gain: gain,
                                            )
                                          }),
                                  ListTile(
                                    leading: new Icon(Icons.videocam),
                                    title: new Text(
                                      'Red Team',
                                      style: GoogleFonts.arbutusSlab(
                                        fontSize: 15.0,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () => {
                                      _bet(
                                        ctx: ctx,
                                        mise: mise,
                                        equipe: "Red Team",
                                        eventId: eventId,
                                        gain: gain,
                                      ),
                                    },
                                  ),
                                ],
                              ),
                            );
                          })
                      : showModalBottomSheet(
                          context: ctx,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext bc) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(ctx).primaryColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    topLeft: Radius.circular(20.0)),
                              ),
                              child: new Wrap(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    width: double.infinity,
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(color: Colors.white),
                                        children: [
                                          TextSpan(
                                            text: "Vous misez:",
                                            style: GoogleFonts.arbutusSlab(
                                              fontSize: 15.0,
                                              color: Colors.white60,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "$mise Coin(s)",
                                            style: GoogleFonts.arbutusSlab(
                                              fontSize: 15.0,
                                              color: Colors.amberAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 5),
                                    color: Colors.amber.withOpacity(0.2),
                                    height: 2,
                                  ),
                                  Container(
                                    height: ctx.screenHeight * 0.33,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("Events")
                                          .doc(eventId)
                                          .snapshots(),
                                      initialData: Container(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasError) {
                                          return Container();
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        return ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              Container(
                                            width: 50,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 150, vertical: 5),
                                            color: Colors.grey.withOpacity(0.4),
                                            height: 2,
                                          ),
                                          itemCount: snapshot
                                              .data["playerList"].length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                                leading: new Icon(
                                                  FontAwesomeIcons.user,
                                                  color: Colors.lightBlue,
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    new Text(
                                                      snapshot.data[
                                                              "playerList"]
                                                          [index]["name"],
                                                      style: GoogleFonts
                                                          .arbutusSlab(
                                                        fontSize: 15.0,
                                                        color: Vx
                                                            .randomPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        children: [
                                                          TextSpan(
                                                            text: "Rank: ",
                                                            style: GoogleFonts
                                                                .arbutusSlab(
                                                              fontSize: 11.0,
                                                              color: Colors
                                                                  .white60,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: snapshot.data[
                                                                    "playerList"]
                                                                    [index]
                                                                    ["rank"]
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .arbutusSlab(
                                                              fontSize: 11.0,
                                                              color: Colors
                                                                  .amberAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                onTap: () => {
                                                      _bet(
                                                          equipe: snapshot.data[
                                                                  "playerList"]
                                                              [index]["name"],
                                                          ctx: ctx,
                                                          eventId: eventId,
                                                          gain: gain,
                                                          mise: mise),
                                                    });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
            },
            icon: Icon(
              Icons.play_arrow_sharp,
              color: Colors.black,
              size: 24.0,
            ),
          ),
        ),
      ),
    );
  }

  Future _bet({
    BuildContext ctx,
    int gain,
    String equipe,
    String eventId,
    int mise,
  }) async {
    var user = await FirebaseFirestore.instance
        .collection("Users")
        .doc(ctx.read<User>().uid)
        .get();
    if (user["coins"] >= gain) {
      return showDialog(
        context: ctx,
        builder: (_) => new CupertinoAlertDialog(
          title: Text(
            'Confirmer le pari',
            style: GoogleFonts.arbutusSlab(
              color: Theme.of(ctx).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: new Text(
              "Si tu confirmes ce pari, tu remporteras environ $gain Coins si $equipe gagne. Mais si tu veux annuler, appui sur le bouton 'Annuler'."),
          actions: <Widget>[
            TextButton(
              child: Text(
                'C\'est parti!',
                style: GoogleFonts.arbutusSlab(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                ctx.read<FirestoreServices>().addAbet(
                    amount: mise,
                    eventId: eventId,
                    userUid: user.id,
                    equipe: equipe,
                    previousCoins: user["coins"]);
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text(
                'Annuler',
                style: GoogleFonts.arbutusSlab(
                  color: Colors.redAccent.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    } else
      print("pas assez de Coins");
    ctx.showToast(
        msg: "Pas assez de Coins",
        bgColor: ctx.theme.primaryColor,
        position: VxToastPosition.bottom,
        textColor: ctx.theme.accentColor,
        showTime: 4000);
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                    child: Text(
                      title,
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
                      DateFormat('kk:mm - dd/MM/yyyy')
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
