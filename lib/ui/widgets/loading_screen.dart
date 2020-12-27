import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  static const namedRoute = "/loading";
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.redAccent,
          size: 50.0,
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }
}
