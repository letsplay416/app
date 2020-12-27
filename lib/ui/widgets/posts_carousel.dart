import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:zephyr18112020/ui/screens/upload_post.dart';

class PostsCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Posts');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
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

Row _header(BuildContext ctx) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        "Posts",
        style: GoogleFonts.varela(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      IconButton(
        icon: Unicon(
          UniconData.uniImagePlus,
          color: Theme.of(ctx).accentColor,
        ),
        onPressed: () => ctx.nextPage(UploadPost()),
      )
    ],
  );
}

_midHeader(BuildContext ctx, List posts) {
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
              "Socialify",
            ),
          ),
        ),
        SizedBox(
          width: 15.0,
        ),
        Text(
          "${posts.length}+ Posts ",
        ),
      ],
    ),
  );
}

_carousel(List posts) {
  return CarouselSlider.builder(
    itemCount: posts.length,
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
      return PostCard(
        picture: posts[itemIndex]["picture"],
        likes: posts[itemIndex]["likers"],
        userUid: posts[itemIndex]["userUid"],
        views: posts[itemIndex]["views"],
        time: posts[itemIndex]["time"],
        id: posts[itemIndex]["id"],
      );
    },
  );
}

class PostCard extends StatelessWidget {
  final String userUid;
  final String picture;
  final String id;
  final int time;
  final int views;
  final List likes;
  const PostCard({
    Key key,
    @required this.picture,
    @required this.id,
    @required this.views,
    @required this.userUid,
    @required this.likes,
    @required this.time,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (likes.contains(context.read<User>().uid)) {
          context.showToast(
              msg: "Déjà liké !",
              bgColor: context.primaryColor,
              textColor: Colors.amber,
              position: VxToastPosition.center);
        } else {
          print(context.read<User>().uid);
          List wxc = likes;
          wxc.add(context.read<User>().uid);
          FirebaseFirestore.instance
              .collection('Posts')
              .doc(id)
              .update({"likers": wxc});
        }
      },
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
                  Row(
                    children: [
                      _userPicture(context, userUid),
                      _userPseudo(userUid),
                      Spacer(),
                      GestureDetector(
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
                                  imageUrl: picture ??
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
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Unicon(
                            UniconData.uniExpandArrows,
                            size: 20,
                            color: context.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (likes.contains(context.read<User>().uid)) {
                              context.showToast(
                                  msg: "Déjà liké !",
                                  bgColor: context.primaryColor,
                                  textColor: Colors.amber,
                                  position: VxToastPosition.center);
                            } else {
                              print(context.read<User>().uid);
                              List wxc = likes;
                              wxc.add(context.read<User>().uid);
                              FirebaseFirestore.instance
                                  .collection('Posts')
                                  .doc(id)
                                  .update({"likers": wxc});
                            }
                          },
                          child: Row(
                            children: [
                              likes.contains(context.watch<User>().uid)
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 8, bottom: 8),
                                      child: Unicon(
                                        UniconData.uniBoltAlt,
                                        size: 25,
                                        color: Colors.amberAccent,
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 8, bottom: 8),
                                      child: Unicon(
                                        UniconData.uniBolt,
                                        size: 25,
                                        color: Colors.white38,
                                      ),
                                    ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                likes.length.toString(),
                                style: TextStyle(color: Colors.amberAccent),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 8, bottom: 8),
                              child: Unicon(
                                UniconData.uniEye,
                                color: Colors.white,
                              ),
                            ),
                            Text(toCurrencyString(
                                "${DateTime.now().millisecondsSinceEpoch / 599999001 + views}",
                                shorteningPolicy: ShorteningPolicy.Automatic))
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Unicon(
                            UniconData.uniShare,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    height: 50,
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
              color: Theme.of(context).accentColor.withOpacity(0.9),
              blurRadius: 4,
              spreadRadius: 3,
            ),
          ],
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _userPicture(BuildContext context, String uid) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
                color: Theme.of(context).accentColor.withOpacity(0.45),
              ),
            ),
            height: 50,
            width: 50,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.contain,
                  image: new NetworkImage(
                    data["picture"] ??
                        "https://images.pexels.com/photos/2007647/pexels-photo-2007647.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                  ),
                ),
                border: Border.all(
                  width: 3,
                  color: Theme.of(context).accentColor,
                ),
              ),
              height: 40,
              width: 40,
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _userPseudo(String uid) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text(
            data["pseudo"] ?? "Noboby",
            style: GoogleFonts.quando(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              height: 1.5,
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
