import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MissionRow extends StatelessWidget {
  final String title;
  final String desc;
  final String img;
  const MissionRow({
    @required this.title,
    @required this.desc,
    @required this.img,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RaisedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => Container(
            child: Center(
              child: AlertDialog(
                backgroundColor: context.theme.primaryColor,
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: CachedNetworkImage(
                        imageUrl: img,
                        fit: BoxFit.cover,
                      ),
                      height: 100,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Quando",
                          color: Theme.of(context).accentColor,
                          fontSize: 30.0,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        desc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlineButton(
                            color: Colors.blueAccent.withOpacity(0.3),
                            child: Text(
                              "Okay",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        elevation: 0.3,
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            img.circularNetworkImage(radius: 35),
            SizedBox(
              width: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    desc,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.amber),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
