import 'package:flutter/material.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:zephyr18112020/ui/screens/wallet_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:zephyr18112020/ui/widgets/mission_row.dart';
import 'package:zephyr18112020/ui/widgets/my_app_bar.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _walletButton(context),
        Spacer(),
        _aBtn(context),
        _notifBtn(context),
      ],
    );
  }
}

_aBtn(BuildContext context) {
  return GestureDetector(
    onTap: () {
      context.nextPage(MissionList());
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: new BoxDecoration(
        color: Colors.amberAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Unicon(
          UniconData.uniTrophy,
          color: Colors.amber,
        ),
      ),
      height: 40,
    ),
  );
}

Widget _notifBtn(BuildContext context) {
  CollectionReference users = FirebaseFirestore.instance.collection('AppData');
  return FutureBuilder<DocumentSnapshot>(
      future: users.doc("vote").get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return snapshot.data["isMessage"]
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    splashColor: Theme.of(context).accentColor,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Vote(),
                      );
                    },
                    child: Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).accentColor.withOpacity(0.2),
                          ),
                          child: Icon(
                            Icons.notifications_active,
                            color: Colors.white.withOpacity(0.8),
                          ),
                          width: (MediaQuery.of(context).size.width - 60) * 0.1,
                          height: 40,
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "1",
                              style: TextStyle(
                                fontSize: 9,
                                height: 1,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  width: 20,
                );
        } else {
          return Container();
        }
      });
}

Widget _walletButton(BuildContext context) {
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection("Users")
        .doc(context.watch<User>().uid)
        .snapshots(),
    initialData: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: new BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("0"),
                SizedBox(
                  width: 2,
                ),
                Image.asset(
                  'assets/images/bullet_icon.png',
                  width: 15,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("0"),
                SizedBox(
                  width: 2,
                ),
                Image.asset(
                  'assets/images/jeton.png',
                  width: 15,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("0"),
                SizedBox(
                  width: 2,
                ),
                Image.asset(
                  'assets/images/diamond.png',
                  width: 19,
                ),
              ],
            ),
          ),
        ),
        height: 40,
      ),
    ),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasError) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            decoration: new BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("0"),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      'assets/images/bullet_icon.png',
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("0"),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      'assets/images/jeton.png',
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("0"),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      'assets/images/diamond.png',
                      width: 19,
                    ),
                  ],
                ),
              ),
            ),
            height: 40,
          ),
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            decoration: new BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("0"),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      'assets/images/bullet_icon.png',
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("0"),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      'assets/images/jeton.png',
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("0"),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      'assets/images/diamond.png',
                      width: 19,
                    ),
                  ],
                ),
              ),
            ),
            height: 40,
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: new BoxDecoration(
            color: Theme.of(context).accentColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            splashColor: Theme.of(context).accentColor.withOpacity(0.5),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => WalletScreen())),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(snapshot.data["bullets"].toString().length > 4
                        ? toCurrencyString(snapshot.data["bullets"].toString(),
                            shorteningPolicy: ShorteningPolicy.Automatic)
                        : snapshot.data["bullets"].toString()),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      'assets/images/bullet_icon.png',
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(snapshot.data["coins"].toString().length > 4
                        ? toCurrencyString(snapshot.data["coins"].toString(),
                            shorteningPolicy: ShorteningPolicy.Automatic)
                        : snapshot.data["coins"].toString()),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      'assets/images/jeton.png',
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(snapshot.data["diamonds"].toString().length > 4
                        ? toCurrencyString(snapshot.data["diamonds"].toString(),
                            shorteningPolicy: ShorteningPolicy.Automatic)
                        : snapshot.data["diamonds"].toString()),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      'assets/images/diamond.png',
                      width: 19,
                    ),
                  ],
                ),
              ),
            ),
          ),
          height: 40,
        ),
      );
    },
  );
}

class Vote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('AppData');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc("vote").get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return data["isMessage"]
              ? Container(
                  child: Center(
                    child: AlertDialog(
                      backgroundColor: context.theme.primaryColor,
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(
                              "assets/images/logo.png",
                            ),
                            maxRadius: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data["title"] ?? "",
                              style: TextStyle(
                                fontFamily: "Quando",
                                color: Theme.of(context).accentColor,
                                fontSize: 30.0,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              data["text"] ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container();
        }

        return Container();
      },
    );
  }
}

class MissionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("AppData")
          .doc("Notifs")
          .snapshots(),
      initialData: Container(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return Scaffold(
          appBar: myAppBar(
              context: context, title: "Missions", todo: () => context.pop()),
          body: ListView.builder(
            itemCount: snapshot.data["liste"].length,
            itemBuilder: (context, index) {
              return MissionRow(
                title: snapshot.data["liste"][index]["title"],
                desc: snapshot.data["liste"][index]["desc"],
                img: snapshot.data["liste"][index]["img"],
              );
            },
          ),
        );
      },
    );
  }
}
