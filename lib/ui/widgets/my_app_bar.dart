import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

PreferredSize myAppBar(
    {@required BuildContext context,
    @required String title,
    @required Function todo}) {
  return PreferredSize(
    preferredSize: Size(
      double.infinity,
      80,
    ),
    child: GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity > 50) {
          todo();
        }
      },
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Wrap(
                  children: <Widget>[
                    Container(
                      width: 50,
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 5,
                      decoration: new BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.quando(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
                fontSize: 30.0,
                letterSpacing: 1.0,
                height: 1.5,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
