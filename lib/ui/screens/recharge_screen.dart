import 'package:flutter/material.dart';

import 'package:zephyr18112020/ui/widgets/my_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recharge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        context: context,
        todo: () => context.pop(),
        title: "Recharger",
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("AppData")
            .doc("ComptaData")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 2,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      color: context.primaryColor,
                      elevation: 6,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  'Tableau de conversion',
                                  style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 38,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                      child: ListView(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '1',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        206, 217, 217, 1.0),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Image.asset(
                                                'assets/images/diamond.png',
                                                width: 19,
                                              ),
                                              Text(
                                                '=> ${snapshot.data["diamondToFcfa"]} FCFA',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        206, 217, 217, 1.0),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '1',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        206, 217, 217, 1.0),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Image.asset(
                                                'assets/images/jeton.png',
                                                width: 19,
                                              ),
                                              Text(
                                                '=> ${snapshot.data["coinToFcfa"]} FCFA',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        206, 217, 217, 1.0),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '1',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        206, 217, 217, 1.0),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Image.asset(
                                                'assets/images/bullet_icon.png',
                                                width: 19,
                                              ),
                                              Text(
                                                '=> ${snapshot.data["bulletToFcfa"]} FCFA',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        206, 217, 217, 1.0),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Pour recharger votre compte, il vous faut faire un transfert sur l'un des numéros ci-dessous.\n(Cliquez sur les numéros pour les copier.)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Varela",
                      ),
                    ),
                  ),
                  ProfileListItem(
                    text: 'MTN: +229 ${snapshot.data["mtn"]}',
                  ),
                  ProfileListItem(
                    text: 'MOOV:+229 ${snapshot.data["moov"]}',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Comme motif de transfert, utilisez l'Id ci-dessous. Cliquez dessus pour copier votre identifiant unique. Attention ne le divulguez à personne.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Varela",
                      ),
                    ),
                  ),
                  ProfileListItem(
                    text: 'Id: Appuyer pour copier',
                    numero: context.watch<User>().uid,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Après avoir effectué le transfert, vous recevrez un message de confirmation de l'envoi. Copiez l'id de la transaction. Appuyez sur le bouton \"Valider\" puis collez l'id de la transaction puis attendez la réponse. ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Varela",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final String text;
  final String numero;
  const ProfileListItem({Key key, this.text, this.numero}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(
          new ClipboardData(
            text: numero,
          ),
        );
        context.showToast(
            msg: "Copié",
            textColor: Theme.of(context).accentColor,
            bgColor: Theme.of(context).primaryColor);
      },
      child: Container(
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
