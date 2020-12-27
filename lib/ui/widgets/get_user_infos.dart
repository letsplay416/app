import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserInfos {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Map data;
  Future<Map> getPic(String uid) async {
    try {
      users.doc(uid).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('User is: ${documentSnapshot.data()}');
          data = documentSnapshot.data();
        } else {
          print('Document does not exist on the database');
          data = {};
        }
      });

      return data;
    } catch (e) {
      print('Erooooooooooooooooooooooooooooor');
      data = {};
      return data;
    }
  }

  Future<Map> get datas =>
      users.doc("7SbvtFu4miYRcoIz9Yr82UlCO4w1").get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('User is: ${documentSnapshot.data()}');
          return documentSnapshot.data();
        } else {
          print('Document does not exist on the database');
          return {};
        }
      });
}
