import 'package:flutter/material.dart';
import 'package:zephyr18112020/services/auth_services.dart';
import 'package:zephyr18112020/ui/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zephyr18112020/utils/constants.dart';
import 'package:zephyr18112020/services/firestore_services.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController textctrl = TextEditingController();
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar(context: context, title: "Menu", todo: () {}),
          body: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                  color: Theme.of(context).accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                barrierColor:
                                    context.backgroundColor.withOpacity(0.9),
                                builder: (context) => AlertDialog(
                                      title: Text("Modifier le pseudo"),
                                      backgroundColor:
                                          context.theme.primaryColor,
                                      content: Container(
                                          child: TextField(
                                        controller: textctrl,
                                      )),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            if (textctrl.text.trim() !=
                                                "Super User") {
                                              context
                                                  .read<FirestoreServices>()
                                                  .editPseudo(
                                                      uid: context
                                                          .read<User>()
                                                          .uid,
                                                      newPseudo:
                                                          textctrl.text.trim());
                                              context.showToast(
                                                  msg: "Pseudo changé",
                                                  bgColor: context
                                                      .theme.primaryColor,
                                                  position: VxToastPosition.top,
                                                  textColor:
                                                      context.theme.accentColor,
                                                  showTime: 4000);
                                            } else {
                                              context.showToast(
                                                  msg: "Impossible",
                                                  bgColor: context
                                                      .theme.primaryColor,
                                                  position: VxToastPosition.top,
                                                  textColor:
                                                      context.theme.accentColor,
                                                  showTime: 4000);
                                            }

                                            context.pop();
                                          },
                                          child: Text("Changer"),
                                        ),
                                      ],
                                    ));
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Unicon(
                                UniconData.uniUserCircle,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Modifier le pseudo"),
                            ],
                          ),
                        ),
                        Container(
                          color: Theme.of(context).accentColor.withOpacity(0.8),
                          height: 3,
                          margin: const EdgeInsets.all(18.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            TextEditingController textctrl;
                            showDialog(
                                context: context,
                                barrierColor:
                                    context.backgroundColor.withOpacity(0.9),
                                builder: (context) => AlertDialog(
                                      backgroundColor:
                                          context.theme.primaryColor,
                                      title: Text("Modifier le Mail"),
                                      content: Container(
                                          child: TextField(
                                        controller: textctrl,
                                      )),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            context.pop();
                                            context.showToast(
                                                msg: "Laisse moi réfléchir",
                                                bgColor:
                                                    context.theme.primaryColor,
                                                position: VxToastPosition.top,
                                                textColor:
                                                    context.theme.accentColor,
                                                showTime: 4000);
                                          },
                                          child: Text("Changer"),
                                        ),
                                      ],
                                    ));
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.mail),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Modifier le mail"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                  color: Theme.of(context).accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            const url =
                                'https://play.google.com/store/apps/details?id=inc.poison.zephyr05122020';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(Icons.star),
                                  Icon(
                                    Icons.star_border,
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.4),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Noter Let's Play"),
                              Spacer(),
                              Icon(
                                Icons.arrow_right,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.8),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Theme.of(context).accentColor.withOpacity(0.8),
                          height: 3,
                          margin: const EdgeInsets.all(18.0),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Uri url = Uri(
                                scheme: 'mailto',
                                path: 'letsplay.app.game@gmail.com',
                                queryParameters: {
                                  'subject': context.read<User>().uid,
                                });

                            if (await canLaunch(url.toString())) {
                              await launch(url.toString());
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.headset_mic,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Contactez-nous"),
                              Spacer(),
                              Icon(
                                Icons.arrow_right,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.8),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Theme.of(context).accentColor.withOpacity(0.8),
                          height: 3,
                          margin: const EdgeInsets.all(18.0),
                        ),
                        GestureDetector(
                          onTap: () async {
                            const url =
                                'https://let-s-play-416.github.io/landing-page/';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.help_center_rounded),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Aide & Soutien"),
                              Spacer(),
                              Icon(
                                Icons.arrow_right,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.8),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                  color: Theme.of(context).accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            const url =
                                'https://let-s-play-416.github.io/landing-page/';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.policy),
                              SizedBox(
                                width: 20,
                              ),
                              Text("G.C.U"),
                              Spacer(),
                              Icon(
                                Icons.arrow_right,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.8),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Theme.of(context).accentColor.withOpacity(0.8),
                          height: 3,
                          margin: const EdgeInsets.all(18.0),
                        ),
                        GestureDetector(
                          onTap: () async {
                            const url =
                                'https://let-s-play-416.github.io/landing-page/';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.verified),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Confidentialité"),
                              Spacer(),
                              Icon(
                                Icons.arrow_right,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.8),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Theme.of(context).accentColor.withOpacity(0.8),
                          height: 3,
                          margin: const EdgeInsets.all(18.0),
                        ),
                        GestureDetector(
                          onTap: () async {
                            const url =
                                'https://let-s-play-416.github.io/landing-page/';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.lock),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Protection de vos données",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_right,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.8),
                              ),
                              // SizedBox(
                              //   width: 20,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirmer la déconnexion"),
                      backgroundColor: context.theme.primaryColor,
                      content: Text(
                          "En confirmant, vous serez déconnecté de cet appareil, mais vos données ne seront pas effacées."),
                      actions: [
                        OutlineButton(
                          color: Colors.lightBlue,
                          textColor: Colors.lightBlue,
                          child: Text("Annuler"),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                        RaisedButton(
                          color: Colors.redAccent.withOpacity(0.7),
                          child: Text("Déconnexion"),
                          onPressed: () {
                            context.pop();
                            context.read<AuthServices>().signOut();
                          },
                        ),
                      ],
                    );
                  },
                ),
                child: Container(
                  margin: const EdgeInsets.all(40.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                    color: Theme.of(context).accentColor.withOpacity(0.6),
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Icon(Icons.logout),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Se déconnecter"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Confidentialité",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Aucune donnée personnelle ne sera transmise à des tiers. Nous ne réalisons ni ne commercialisons des statistiques mêmes anonymisées. Avec Let's Play, votre vie privée est respectée.",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Version: " + version,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color:
                              Theme.of(context).accentColor.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
