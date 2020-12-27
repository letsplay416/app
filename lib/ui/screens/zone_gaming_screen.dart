import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ZoneGamingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List img = [
      'assets/images/93868.jpg',
      'assets/images/58670.jpg',
      'assets/images/942281.png',
      'assets/images/942282.png',
      'assets/images/3745105.jpg',
      'assets/images/3820362.jpg',
    ];
    return Container(
      color: Theme.of(context).backgroundColor,
      width: MediaQuery.of(context).size.width - 60,
      child: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 170,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                      ),
                    ),
                    child: GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                        ),
                        child: Image.asset(
                          img[Random().nextInt(5)],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      onVerticalDragEnd: (details) {
                        if (details.primaryVelocity > 50) {}
                      },
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    GameList(),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            mini: true,
            isExtended: true,
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    " Devenir Gamer",
                    style: TextStyle(color: context.theme.accentColor),
                  ),
                  backgroundColor: context.theme.primaryColor,
                  content: Text(
                      "Vous voulez devenir gamer ? Participer aux Events, aux lives et aux différentes activités? Vous ne voulez plus être un simple utilisateur de Let's Play ? Venez et passez à la vitesse supérieure."),
                  actions: [
                    OutlineButton(
                      color: Colors.lightBlue,
                      textColor: Colors.red,
                      child: Text("Fermer"),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    OutlineButton(
                      color: Colors.lightBlue,
                      textColor: Colors.lightBlue,
                      child: Text("Let's Go"),
                      onPressed: () async {
                        String id = context.read<User>().uid;
                        String link =
                            "https://wa.me/%2B33656744389?text=Je%20veux%20devenir%20un%20Gamer%20voici%20mon%20id: $id";
                        if (await canLaunch(link)) {
                          await launch(link);
                        } else {
                          throw 'Could not launch wha link';
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            child: Icon(Icons.gamepad), tooltip: ">> Devenir gamer",
            // label: Text("devenir Gamer"),
            // onPressed: () {},
          ),
        ),
      ),
    );
  }
}

class GameList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference game = FirebaseFirestore.instance.collection('Games');

    return StreamBuilder<QuerySnapshot>(
      stream: game.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
            height: 32,
            width: double.infinity,
            color: Colors.red,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Center(child: CircularProgressIndicator()));
        }
        return Container(
          height: context.screenHeight - 180,
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => context.nextPage(GameScreen(
                  desc: snapshot.data.docs[index]["desc"],
                  name: snapshot.data.docs[index]["gameName"],
                  link: snapshot.data.docs[index]["link"],
                  img: snapshot.data.docs[index]["imageURL"],
                )),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 19),
                  child: VxBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 300,
                            width: double.infinity,
                            imageUrl: snapshot.data.docs[index]["imageURL"] ??
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
                          Container(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Vx.randomPrimaryColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: (15.0),
                                vertical: (10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    snapshot.data.docs[index]["gameName"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.varela(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22,
                                      // color: Colors.white70,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data.docs[index]["desc"] ??
                                        "Plus ...",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.varela(
                                      fontWeight: FontWeight.w700,
                                      color: context.theme.primaryColor,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                      .centered(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class GameScreen extends StatelessWidget {
  final String name;
  final String desc;
  final String img;
  final String link;

  const GameScreen({Key key, this.name, this.desc, this.img, this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.topLeft,
        children: [
          _gamePicture(img ??
              "https://firebasestorage.googleapis.com/v0/b/let-s-play-05122020.appspot.com/o/app_icon.jpeg?alt=media&token=66f40d51-167e-429b-93f7-915d8d0033b1"),
          _backBtn(context, "Games"),
          _lPPic(
            context,
            12,
            name,
            desc,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.theme.accentColor.withOpacity(0.8),
        child: Unicon(
          UniconData.uniDownloadAlt,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () async {
          if (await canLaunch(link)) {
            await launch(link);
          } else {
            throw 'Could not launch $link';
          }
        },
      ),
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
                      "Let's Play",
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
                      "Quand le virtuel défi le réel.",
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
              name,
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
