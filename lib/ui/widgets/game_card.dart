import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_unicons/flutter_unicons.dart';

class GameCard extends StatelessWidget {
  final String name;
  final String picture;
  const GameCard({@required this.name, @required this.picture});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      color: Theme.of(context).accentColor.withOpacity(0.2),
      child: Container(
        height: 200,
        child: Stack(
          alignment: Alignment.bottomLeft,
          fit: StackFit.expand,
          children: [
            Image.network(
              picture ?? "",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.8),
                ),
                height: 41,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.arbutusSlab(
                            color: Colors.redAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Unicon(
                          UniconData.uniLocationArrow,
                          color: Theme.of(context).primaryColor,
                          // size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
