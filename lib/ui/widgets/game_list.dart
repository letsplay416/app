import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zephyr18112020/ui/widgets/game_card.dart';

class GameList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Games');

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return GameCard(
                name: snapshot.data.docs[index]["gameName"],
                picture: "",
              );
            },
          ),
        );
      },
    );
  }
}
