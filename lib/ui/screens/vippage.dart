import 'package:flutter/material.dart';
import 'package:zephyr18112020/ui/widgets/my_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Vip extends StatefulWidget {
  @override
  _VipState createState() => _VipState();
}

class _VipState extends State<Vip> {
  listDesPhrases(String phrase) {
    return Row(
      children: <Widget>[
        Text(
          '-',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 50.0,
          ),
        ),
        Flexible(
          child: Text(
            phrase,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar(
              context: context, title: "V.I.P", todo: () => context.pop()),
          body: Container(
            color: Theme.of(context).primaryColor,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'AVANTAGES',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      listDesPhrases("Possibilité de cacher son numéro"),
                      listDesPhrases("Paiements en diamants"),
                      listDesPhrases("Créer ses propres battles"),
                      listDesPhrases("Badge qui montre votre statut de V.I.P."),
                      listDesPhrases(
                          "Réponse du service clientèle ultra rapide"),
                      listDesPhrases(
                          "Possibilité de poster des photos visibles par tous les utilisateurs"),
                      listDesPhrases(
                          "Moins 30 % de réduction sur les Publications sponsorisées"),
                      listDesPhrases(
                          "Envoi de vidéos et de fichiers dans les chats"),
                      listDesPhrases(
                          "Restitution de 20 % lors des pertes de paris"),
                      listDesPhrases("Plus de gains lors des paris"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Comment devenir V.I.P ?',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      listDesPhrases("Réaliser au moins 6 paris par semaines"),
                      listDesPhrases(
                          "Avoir plus de 155 Coins dans son porte-monnaie"),
                      listDesPhrases("Ou payer 7 Coins par semaine"),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text(
              "Passer V.I.P",
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () async {
              String id = context.read<User>().uid;
              String link =
                  "https://wa.me/%2B33656744389?text=Je%20veux%20devenir%20VIP%20voici%20mon%20id: $id";
              if (await canLaunch(link)) {
                await launch(link);
              } else {
                throw 'Could not launch wha link';
              }
            },
          ),
        ),
      ),
    );
  }
}
