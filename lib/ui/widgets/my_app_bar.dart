import 'package:flutter/material.dart';

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
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
