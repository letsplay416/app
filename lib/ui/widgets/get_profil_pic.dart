import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetProfilPic extends StatelessWidget {
  final User user;

  const GetProfilPic({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    if (user.isAnonymous) {
      return Image.asset("assets/images/profile.png");
    } else {
      return FutureBuilder<DocumentSnapshot>(
        future: users
            .doc(user.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: Theme.of(context).accentColor.withOpacity(0.45),
                ),
              ),
              height: 100,
              width: 100,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: new NetworkImage(
                      data["picture"] ??
                          "https://images.pexels.com/photos/2007647/pexels-photo-2007647.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                    ),
                  ),
                  border: Border.all(
                    width: 3,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                height: 90,
                width: 90,
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}
