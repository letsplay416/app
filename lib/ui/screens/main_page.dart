import 'package:flutter/material.dart';
import 'package:zephyr18112020/providers/main_page_provider.dart';
import 'package:provider/provider.dart';
import 'package:zephyr18112020/ui/screens/home_screen.dart';
import 'package:zephyr18112020/ui/screens/menu_screen.dart';
import 'package:zephyr18112020/ui/screens/chat_room_screen.dart';
import 'package:zephyr18112020/ui/screens/zone_gaming_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zephyr18112020/ui/widgets/get_profil_pic.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:flutter_unicons/model.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainPageProvider = context.watch<MainPageProvider>();
    return Scaffold(
      body: Row(
        children: [
          _sideBar(context, mainPageProvider),
          _currentPage(mainPageProvider.currentPage),
        ],
      ),
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
