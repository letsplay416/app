import 'package:flutter/material.dart';
import 'package:zephyr18112020/providers/main_page_provider.dart';
import 'package:provider/provider.dart';
import 'package:zephyr18112020/ui/screens/home_screen.dart';
import 'package:zephyr18112020/ui/screens/menu_screen.dart';
import 'package:zephyr18112020/ui/screens/chat_room_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zephyr18112020/ui/screens/zone_gaming_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zephyr18112020/ui/widgets/get_profil_pic.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:flutter_unicons/model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zephyr18112020/utils/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainPageProvider = context.watch<MainPageProvider>();
    return Scaffold(
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("AppData")
              .doc("version")
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return LoadingOverlay(
                isLoading: snapshot.data["name"] != version,
                progressIndicator: AlertDialog(
                  title: Text(
                    "Mise à jour requise !",
                    style: TextStyle(color: context.theme.accentColor),
                  ),
                  backgroundColor: context.theme.primaryColor,
                  content: Text(
                    "Vous devez effectuer la mise à jour vers la version ${snapshot.data["name"]}",
                  ),
                  actions: [
                    OutlineButton(
                      color: Colors.lightBlue,
                      textColor: Colors.lightBlue,
                      child: Text("Mettre à jour"),
                      onPressed: () async {
                        const url =
                            'https://play.google.com/store/apps/details?id=inc.poison.zephyr05122020';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  ],
                ),
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("AppData")
                        .doc("blockUser")
                        .get(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return LoadingOverlay(
                          isLoading: snapshot.data["isBlock"],
                          progressIndicator: Container(
                            width: double.infinity,
                            height: 150,
                            margin: EdgeInsets.all((20)),
                            padding: EdgeInsets.symmetric(
                              horizontal: (20),
                              vertical: (15),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).accentColor,
                            ),
                            child: ListView(
                              children: [
                                Text(
                                  snapshot.data["title"] ?? "",
                                  style: GoogleFonts.quando(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  snapshot.data["content"] ?? "",
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.varela(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              _sideBar(context, mainPageProvider),
                              _currentPage(mainPageProvider.currentPage),
                            ],
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
                    }),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  Container _sideBar(BuildContext context, MainPageProvider mainPageProvider) {
    return Container(
      height: double.infinity,
      color: Theme.of(context).accentColor.withOpacity(0.15),
      width: 60,
      child: Column(
        children: [
          _sideBarCircle(mainPageProvider.currentPage, context),
          Spacer(),
          _sideBarIcon(mainPageProvider.currentPage == mPP.Home,
              UniconData.uniHouseUserMonochrome, mPP.Home, context),
          _sideBarIcon(mainPageProvider.currentPage == mPP.ChatRoom,
              UniconData.uniCommentsAlt, mPP.ChatRoom, context),
          _sideBarIcon(mainPageProvider.currentPage == mPP.ZoneGaming,
              UniconData.uniClub, mPP.ZoneGaming, context),
          _sideBarIcon(
            mainPageProvider.currentPage == mPP.Menu,
            UniconData.uniListUiAlt,
            mPP.Menu,
            context,
          ),
        ],
      ),
    );
  }

  Widget _sideBarCircle(mPP currentPage, BuildContext ctx) {
    final firebaseUser = ctx.watch<User>();
    if (currentPage == mPP.Home) {
      return SafeArea(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                const url = 'https://let-s-play-416.github.io/landing-page/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Container(
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(ctx).accentColor.withOpacity(0.4),
                    border: Border.all(
                        color: Colors.amberAccent.withOpacity(0.4), width: 3)),
                margin: const EdgeInsets.all(1),
                child: Center(
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
            ),
            // if (!isRead)
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(ctx).accentColor.withOpacity(0.9),
                  border:
                      Border.all(color: Theme.of(ctx).primaryColor, width: 3)),
              child: Icon(
                Icons.near_me,
                size: 10,
                color: Colors.amberAccent,
              ),
              width: 40,
              height: 20,
            ),
          ],
        ),
      );
    } else if (currentPage == mPP.Menu) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: SafeArea(
            child: GetProfilPic(
          user: firebaseUser,
        )),
      );
    } else {
      return SafeArea(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(ctx).accentColor.withOpacity(0.4),
                  border: Border.all(
                      color: Colors.amberAccent.withOpacity(0.4), width: 3)),
              margin: const EdgeInsets.all(1),
              child: Center(
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
            // if (!isRead)
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(ctx).accentColor.withOpacity(0.9),
                  border:
                      Border.all(color: Theme.of(ctx).primaryColor, width: 3)),
              child: Icon(
                Icons.near_me,
                size: 10,
                color: Colors.amberAccent,
              ),
              width: 40,
              height: 20,
            ),
          ],
        ),
      );
    }
  }

  Widget _currentPage(mPP currentPage) {
    if (currentPage == mPP.Menu) {
      return MenuScreen();
    } else if (currentPage == mPP.ChatRoom) {
      return ChatRoomScreen();
    } else if (currentPage == mPP.ZoneGaming) {
      return ZoneGamingScreen();
    } else {
      return HomeScreen();
    }
  }

  Widget _sideBarIcon(
      bool isSelected, UniconDataModel icon, mPP route, BuildContext ctx) {
    return GestureDetector(
      onTap: () => ctx.read<MainPageProvider>().changePage(route),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 3),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.redAccent.withOpacity(0.1)
              : Colors.transparent,
          border: Border(
            right: BorderSide(
              width: 5,
              color: isSelected ? Colors.redAccent : Colors.transparent,
            ),
          ),
        ),
        child: Unicon(
          icon,
          color: isSelected ? Colors.white : Colors.white54,
          size: isSelected ? 30 : 25,
        ),
      ),
    );
  }
}
