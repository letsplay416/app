import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zephyr18112020/ui/screens/actu_screen.dart';

class ActuCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference actus = FirebaseFirestore.instance.collection('Actus');

    return StreamBuilder<QuerySnapshot>(
      stream: actus.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
            color: Colors.red,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Column(
            children: [
              _header(),
              _midHeader(context, snapshot.data.docs),
              _carousel(snapshot.data.docs),
            ],
          ),
        );
      },
    );
  }
}

Row _header() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        "Actus",
        style: GoogleFonts.varela(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      IconButton(
        icon: Icon(
          Icons.add,
        ),
        onPressed: () {},
      )
    ],
  );
}

_midHeader(BuildContext ctx, List actus) {
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
              "Latests",
            ),
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text(
          "${actus.length}+ Actus ",
        ),
      ],
    ),
  );
}

_carousel(List actus) {
  return CarouselSlider.builder(
    itemCount: actus.length,
    options: CarouselOptions(
      height: 400,
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
      return ActuCard(
        title: actus[itemIndex]["title"],
        picture: actus[itemIndex]["picture"],
        desc: actus[itemIndex]["desc"],
        id: actus[itemIndex]["id"],
        link: actus[itemIndex]["link"],
      );
    },
  );
}

class ActuCard extends StatelessWidget {
  final String title;
  final String picture;
  final String desc;
  final String id;
  final String link;
  const ActuCard({
    Key key,
    @required this.title,
    @required this.picture,
    @required this.desc,
    @required this.id,
    this.link,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.nextPage(ActuScreen(
        id: id,
      )),
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
                        text: "$title\n",
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
          borderRadius: BorderRadius.circular(10),
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
