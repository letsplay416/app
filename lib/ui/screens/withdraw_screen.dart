import 'package:flutter/material.dart';

import 'package:zephyr18112020/ui/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WithdrawScreen extends StatefulWidget {
  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

TextEditingController numberController = TextEditingController();
TextEditingController prenomController = TextEditingController();
TextEditingController nomController = TextEditingController();
TextEditingController adresseController = TextEditingController();
TextEditingController villeController = TextEditingController();
TextEditingController withdrawNumberController = TextEditingController();

int group = 0;
int pourcentage = 0;
var coins = 0;
var bullets = 0;
var diamonds = 0;
const couleur9 = Color(0xFF1b1e44);

class _WithdrawScreenState extends State<WithdrawScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        context: context,
        todo: () => context.pop(),
        title: "Retrait",
      ),
      body: ListView(
        children: [
          //!Numéro de téléphone mobile
          Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Numéro de téléphone mobile *',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: couleur9,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  height: 60,
                  child: TextField(
                    inputFormatters: [PhoneInputFormatter()],
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 14.0),
                      prefixIcon: Icon(
                        FontAwesomeIcons.phone,
                        color: Colors.red,
                      ),
                      hintText: 'Entrer le numéro de téléphone',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
                //!Prénom
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Prénom (s) *',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: couleur9,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        height: 60,
                        child: TextField(
                          controller: prenomController,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.red,
                            ),
                            hintText: 'Ex: John Daniel',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //!Nom de famille
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Nom de famille *',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: couleur9, // Color(0xFF6CA8F1),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        height: 60,
                        child: TextField(
                          controller: nomController,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.red,
                            ),
                            hintText: 'Ex: DOSSOU',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //!Ville
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Ville *',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: couleur9, // Color(0xFF6CA8F1),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        height: 60,
                        child: TextField(
                          controller: villeController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              FontAwesomeIcons.city,
                              color: Colors.red,
                            ),
                            hintText: 'Ex: Cotonou',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //!Adresse
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Adresse ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: couleur9, // Color(0xFF6CA8F1),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        height: 60,
                        child: TextField(
                          controller: adresseController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              FontAwesomeIcons.mapMarkerAlt,
                              color: Colors.red,
                            ),
                            hintText: 'Ex: Cotonou',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Methode de retrait',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Radio(
                                        value: 1,
                                        activeColor: Colors.yellow,
                                        groupValue: group,
                                        onChanged: (T) {
                                          setState(() {
                                            group = T;
                                          });
                                        }),
                                    Text("MTN"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Radio(
                                        value: 2,
                                        groupValue: group,
                                        activeColor: Colors.green,
                                        onChanged: (T) {
                                          setState(() {
                                            group = T;
                                          });
                                        }),
                                    Text("MOOV"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Radio(
                                        value: 3,
                                        groupValue: group,
                                        activeColor: Colors.blueAccent,
                                        onChanged: (T) {
                                          setState(() {
                                            group = T;
                                          });
                                        }),
                                    Text("Autre..."),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //!Numéro du compte de retrait
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Numéro du compte de retrait *',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: couleur9, // Color(0xFF6CA8F1),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        height: 60,
                        child: TextField(
                          inputFormatters: [PhoneInputFormatter()],
                          controller: withdrawNumberController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14.0),
                            prefixIcon: Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.red,
                            ),
                            hintText: 'Entrer le numéro du compte de retrait',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                //!Montant du retrait
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Montant du retrait *',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(context.watch<User>().uid)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return new SpinKitFadingCircle(
                        size: 20,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                            ),
                          );
                        },
                      );
                    }
                    return SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Theme.of(context).accentColor,
                        inactiveTrackColor: Color(0xFFe5e5e5),
                        thumbColor: Color(0xFFEB1555),
                        overlayColor: Color(0x29EB1555),
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 15.0),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 30.0),
                        showValueIndicator: ShowValueIndicator.always,
                        valueIndicatorColor:
                            Theme.of(context).accentColor.withOpacity(0.9),
                        valueIndicatorTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      child: Slider(
                        value: pourcentage.toDouble(),
                        label: "${pourcentage.toInt()} Coins",
                        min: 0.0,
                        max: snapshot.data["coins"].toDouble() + 1,
                        // divisions: 50000,
                        onChanged: (double newValue) {
                          setState(() {
                            pourcentage = newValue.round();
                            coins = snapshot.data["coins"];
                          });
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Valider",
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: "Valider",
        onPressed: () async {
          if (pourcentage > coins) {
            context.showToast(msg: "Impossible de retirer cette somme");
          } else {
            if (numberController.text.isEmpty) {
              context.showToast(
                  msg: "Erreur Numéro de téléphone mobile",
                  textColor: Theme.of(context).accentColor,
                  position: VxToastPosition.top,
                  bgColor: Theme.of(context).primaryColor);
            } else if (prenomController.text.isEmpty) {
              context.showToast(
                  msg: "Erreur Prénom",
                  textColor: Theme.of(context).accentColor,
                  position: VxToastPosition.top,
                  bgColor: Theme.of(context).primaryColor);
            } else if (nomController.text.isEmpty) {
              context.showToast(
                  msg: "Ereur Nom de famille",
                  textColor: Theme.of(context).accentColor,
                  position: VxToastPosition.top,
                  bgColor: Theme.of(context).primaryColor);
            } else if (villeController.text.isEmpty) {
              context.showToast(
                  msg: "Erreur Ville",
                  textColor: Theme.of(context).accentColor,
                  position: VxToastPosition.top,
                  bgColor: Theme.of(context).primaryColor);
            } else if (group == null) {
              context.showToast(
                  msg: "Erreur Methode de retrait",
                  textColor: Theme.of(context).accentColor,
                  position: VxToastPosition.top,
                  bgColor: Theme.of(context).primaryColor);
            } else if (withdrawNumberController.text.isEmpty) {
              context.showToast(
                  msg: "Erreur Numéro de retrait",
                  textColor: Theme.of(context).accentColor,
                  position: VxToastPosition.top,
                  bgColor: Theme.of(context).primaryColor);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Confirmation",
                      style: TextStyle(color: context.theme.accentColor),
                    ),
                    backgroundColor: context.theme.primaryColor,
                    content: Text(
                        "Voulez-vous vraiment retirer cette somme ? La procédure est irréversible !"),
                    actions: [
                      OutlineButton(
                        color: Colors.lightBlue,
                        textColor: Colors.red,
                        child: Text("Annuler"),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      RaisedButton(
                        color: Colors.lightBlue.withOpacity(0.3),
                        textColor: Colors.white,
                        child: Text("Valider"),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("demandeDeRetrait")
                              .add({
                            "NumeroDeRetrait":
                                withdrawNumberController.text.trim(),
                            "uid": context.read<User>().uid,
                            "prenom": prenomController.text.trim(),
                            "time": DateTime.now().millisecondsSinceEpoch,
                            "nom": nomController.text.trim(),
                            "adresse": adresseController.text.trim(),
                            "ville": villeController.text.trim(),
                            "fait": false,
                            "modeRetrait": group == 1
                                ? "MTN"
                                : group == 2
                                    ? "Moov"
                                    : "Autre",
                          }).then((value) {
                            nomController.clear();
                            numberController.clear();
                            prenomController.clear();
                            adresseController.clear();
                            withdrawNumberController.clear();
                            villeController.clear();
                            context.showToast(
                                msg: "En cours de traitement",
                                textColor: Theme.of(context).accentColor,
                                position: VxToastPosition.top,
                                bgColor: Theme.of(context).primaryColor);
                            context.pop();
                            context.pop();
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
