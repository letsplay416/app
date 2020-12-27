import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';

class DailyMissionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('AppData');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc("DailyMission").get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                     data["title"] ?? "",
                      style: TextStyle(color: context.theme.accentColor),
                    ),
                    backgroundColor: context.theme.primaryColor,
                    content: Text(
                      data["content"] ?? "",
                    ),
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
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all((20)),
              padding: EdgeInsets.symmetric(
                horizontal: (20),
                vertical: (15),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).accentColor,
              ),
              child: Column(
                children: [
                  Text(
                    data["title"] ?? "",
                    style: GoogleFonts.quando(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    data["content"] ?? "",
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
          );
        }

        return Container(
          width: double.infinity,
          margin: EdgeInsets.all((20)),
          padding: EdgeInsets.symmetric(
            horizontal: (20),
            vertical: (15),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).accentColor,
          ),
          child: Column(
            children: [
              Text(
                "Mission du jour",
                style: GoogleFonts.quando(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  height: 1.5,
                ),
              ),
              Text(
                "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
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
        );
      },
    );
  }
}