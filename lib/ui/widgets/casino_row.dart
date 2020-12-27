import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_unicons/model.dart';

class CasinoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Casino",
                style: GoogleFonts.quando(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  height: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Casino",
                          style: TextStyle(color: context.theme.accentColor),
                        ),
                        backgroundColor: context.theme.primaryColor,
                        content: Text(
                            "Cette section regroupe l'un des nombreux moyens de se faire de l'argent dans Let's Play. Vous pouvez jouer à de nombreux mini jeux pour gagner de l'argent sans attendre d'Event."),
                        actions: [
                          OutlineButton(
                            color: Colors.lightBlue,
                            textColor: Colors.lightBlue,
                            child: Text("Fermer"),
                            onPressed: () {
                              context.pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Unicon(
                  UniconData.uniQuestionCircle,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CasinoCard(
              icon: UniconData.uniCoins,
              text: "Jackpot",
              press: () {
                context.showToast(
                    msg: "Bientôt disponible",
                    textColor: Theme.of(context).accentColor,
                    position: VxToastPosition.top,
                    bgColor: Theme.of(context).primaryColor);
              },
            ),
            CasinoCard(
              icon: UniconData.uniFire,
              text: "Crash",
              press: () {
                context.showToast(
                    msg: "Bientôt disponible",
                    textColor: Theme.of(context).accentColor,
                    position: VxToastPosition.top,
                    bgColor: Theme.of(context).primaryColor);
              },
            ),
            CasinoCard(
              icon: UniconData.uniAdjustHalf,
              text: "Pile Face",
              press: () {
                context.showToast(
                    msg: "Bientôt disponible",
                    textColor: Theme.of(context).accentColor,
                    position: VxToastPosition.top,
                    bgColor: Theme.of(context).primaryColor);
              },
            ),
            CasinoCard(
              icon: UniconData.uniDiceSix,
              text: "Roulette",
              press: () {
                context.showToast(
                    msg: "Bientôt disponible",
                    textColor: Theme.of(context).accentColor,
                    position: VxToastPosition.top,
                    bgColor: Theme.of(context).primaryColor);
              },
            ),
            CasinoCard(
              icon: UniconData.uniBoltAlt,
              text: "Flash",
              press: () {
                context.showToast(
                    msg: "Bientôt disponible",
                    textColor: Theme.of(context).accentColor,
                    position: VxToastPosition.top,
                    bgColor: Theme.of(context).primaryColor);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class CasinoCard extends StatelessWidget {
  const CasinoCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
  }) : super(key: key);
  final UniconDataModel icon;
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 55,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: (55),
              width: (55),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Unicon(
                icon,
                color: Theme.of(context).primaryColor,
                // size: 28,
              ),
            ),
            SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.allertaStencil(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                height: 1.5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
