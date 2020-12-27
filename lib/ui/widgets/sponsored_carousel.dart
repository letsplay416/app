import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';import 'package:url_launcher/url_launcher.dart';
import 'package:zephyr18112020/ui/screens/sponsored_screen.dart';

class SponsoredCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('Sponsored');

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
                            "Publicités",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Text(
                        "1+ Annonces ",
                      ),
                    ],
                  ),
                ),
                CarouselSlider.builder(
                  itemCount: 1,
                  options: CarouselOptions(
                    height: 150,
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
                    return SponsoredCard(
                      name: "Sponsored",
                      picture: "url",
                      desc: 'desc',
                      link: "",
                      id: 'sponsoreds[itemIndex]["id"]',
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
        "Sponsorisé",
        style: GoogleFonts.varela(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      IconButton(
        icon: Icon(
          Icons.add,
        ),
        onPressed: () async {
          String id = context.read<User>().uid;
          String link =
              "https://wa.me/%2B33656744389?text=Je%20voudrais%20faire%20la%20publicit%C3%A9%20de%20mon%20activit%C3%A9.%20mon%20id: $id";
          if (await canLaunch(link)) {
            await launch(link);
          } else {
            throw 'Could not launch wha link';
          }
        },
      )
    ],
  );
}

_midHeader(BuildContext ctx, List sponsoreds) {
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
              "Publicités",
            ),
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text(
          "${sponsoreds.length}+ Annonces ",
        ),
      ],
    ),
  );
}

_carousel(List sponsoreds) {
  return CarouselSlider.builder(
    itemCount: sponsoreds.length,
    options: CarouselOptions(
      height: 150,
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
      return SponsoredCard(
        name: sponsoreds[itemIndex]["name"],
        picture: sponsoreds[itemIndex]["imageURL"],
        desc: sponsoreds[itemIndex]["desc"],
        link: sponsoreds[itemIndex]["link"],
        id: sponsoreds[itemIndex]["id"],
      );
    },
  );
}

class SponsoredCard extends StatelessWidget {
  final String name;
  final String picture;
  final String link;
  final String desc;
  final String id;
  const SponsoredCard(
      {Key key, this.name, this.picture, this.link, this.desc, this.id})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SponsoredScreen(
            id: id,
          ),
        ),
      ),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.bottomLeft,
            fit: StackFit.expand,
            children: [
              Image.network(
                picture,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (15.0),
                  vertical: (10),
                ),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: "$name\n",
                        style: GoogleFonts.arbutusSlab(
                          fontSize: 20.0,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: "Let's Play"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.amber,
            width: 3.0,
          ),
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }
}
