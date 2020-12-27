import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zephyr18112020/ui/screens/event_screen.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_unicons/flutter_unicons.dart';

class EventCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Events');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            child: Column(
              children: [
                _header(context),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: <Widget>[
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 6.0),
                          child: Text(
                            "Daily/Extra",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text("Les Matchs"),
                    ],
                  ),
                ),
                CarouselSlider.builder(
                  itemCount: 1,
                  options: CarouselOptions(
                    height: 340,
                    initialPage: 0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    reverse: false,
                    pauseAutoPlayOnManualNavigate: true,
                    autoPlayInterval: Duration(seconds: 10),
                    autoPlayAnimationDuration: Duration(milliseconds: 2000),
                    pauseAutoPlayOnTouch: true,
                    enableInfiniteScroll: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                  ),
                  itemBuilder: (context, itemIndex) {
                    return EventCard(
                      gameName: "Let's Play",
                      picture: "Let's Play",
                      desc: "Let's Play",
                      date: 1234567,
                      type: "daily",
                      id: "Let's Play",
                    );
                  },
                )
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Column(
            children: [
              _header(context),
              _midHeader(context, snapshot.data.docs),
              _carousel(snapshot.data.docs),
            ],
          ),
        );
      },
    );
  }
}

Row _header(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        "Events",
        style: GoogleFonts.varela(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Events",
                  style: TextStyle(color: context.theme.accentColor),
                ),
                backgroundColor: context.theme.primaryColor,
                content: Text(
                    "Pariez sur des match virtuels. Des jeux de tout type où si la chance est de votre côté, vous pouvez vous faire de lourds bénéfices."),
                actions: [
                  OutlineButton(
                    color: Colors.lightBlue,
                    textColor: Colors.lightBlue,
                    child: Text("Fermer"),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Unicon(
          UniconData.uniQuestionCircle,
          color: Colors.white54,
          size: 20,
        ),
      ),
    ],
  );
}

_midHeader(BuildContext ctx, List events) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    child: Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Theme.of(ctx).accentColor,
                  blurRadius: 5,
                  spreadRadius: 1)
            ],
            color: Theme.of(ctx).accentColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
            child: Text(
              "Daily/Extra",
            ),
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text("Les Matchs"),
      ],
    ),
  );
}

_carousel(List events) {
  return CarouselSlider.builder(
    itemCount: events.length,
    options: CarouselOptions(
      height: 340,
      initialPage: 0,
      enlargeCenterPage: true,
      autoPlay: true,
      reverse: false,
      pauseAutoPlayOnManualNavigate: true,
      autoPlayInterval: Duration(seconds: 10),
      autoPlayAnimationDuration: Duration(milliseconds: 2000),
      pauseAutoPlayOnTouch: true,
      enableInfiniteScroll: true,
      autoPlayCurve: Curves.fastOutSlowIn,
      scrollDirection: Axis.horizontal,
    ),
    itemBuilder: (context, itemIndex) {
      return EventCard(
        gameName: events[itemIndex]["gameName"],
        picture: events[itemIndex]["imageURL"],
        desc: events[itemIndex]["desc"],
        date: events[itemIndex]["date"],
        type: events[itemIndex]["type"],
        id: events[itemIndex]["id"],
      );
    },
  );
}

class EventCard extends StatelessWidget {
  final String gameName;
  final String picture;
  final String desc;
  final String type;
  final String id;
  final int date;
  const EventCard(
      {Key key,
      this.gameName,
      this.picture,
      this.desc,
      this.id,
      this.date,
      this.type})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventScreen(
            id: id,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.expand,
            children: [
              Image.network(
                picture,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 5.0,
                  ),
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (type == "daily")
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(9),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: "Blue Team",
                                style: GoogleFonts.arbutusSlab(
                                  fontSize: 15.0,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " VS ",
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "Red Team",
                                style: GoogleFonts.arbutusSlab(
                                  fontSize: 15.0,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (type != "daily")
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(9),
                      width: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          type,
                          style: GoogleFonts.arbutusSlab(
                            fontSize: 15.0,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: type == "daily"
                          ? Theme.of(context).primaryColor.withOpacity(0.4)
                          : Theme.of(context).accentColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (type == "daily")
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: (15.0),
                              vertical: (10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "$gameName",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                    color: Colors.white70,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                Text(
                                  DateFormat('kk:mm')
                                          .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              date,
                                            ),
                                          )
                                          .toString() ??
                                      "00::00",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.6),
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (type != "daily")
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: (15.0),
                              vertical: (10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "$gameName",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.cabin(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                    color: Colors.blueAccent,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                Text(
                                  "$desc",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    height: 70,
                  ),
                ],
              ),
            ],
          ),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: type == "daily"
                  ? Theme.of(context).accentColor.withOpacity(0.9)
                  : Colors.lightBlue,
              blurRadius: 4,
              spreadRadius: 3,
            ),
          ],
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }
}
