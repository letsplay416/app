import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zephyr18112020/services/firestore_services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:flutter_unicons/model.dart';
import 'package:zephyr18112020/ui/widgets/my_app_bar.dart';

class GetProfilPic extends StatefulWidget {
  final User user;

  const GetProfilPic({Key key, this.user}) : super(key: key);

  @override
  _GetProfilPicState createState() => _GetProfilPicState();
}

class _GetProfilPicState extends State<GetProfilPic> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    takePhoto() async {
      try {
        PickedFile img =
            await ImagePicker().getImage(source: ImageSource.camera);
        File cropped = await ImageCropper.cropImage(
          sourcePath: img.path,
          aspectRatio: CropAspectRatio(
            ratioX: 2,
            ratioY: 3,
          ),
          compressQuality: 90,
          maxHeight: 700,
          maxWidth: 700,
          cropStyle: CropStyle.circle,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Theme.of(context).accentColor,
            toolbarTitle: "Rogner l'image",
            backgroundColor: context.primaryColor,
          ),
        );
        var user = FirebaseAuth.instance.currentUser;
        final _storage = FirebaseStorage.instance;
        await _storage
            .ref()
            .child("profilePicture/${user.uid}")
            .putFile(cropped);

        String url = await _storage
            .ref()
            .child("profilePicture/${user.uid}")
            .getDownloadURL();
        context
            .read<FirestoreServices>()
            .addProfilePicTofs(uid: user.uid, link: url);
        context.pop();
      } catch (e) {}
    }

    pickImage() async {
      try {
        PickedFile img =
            await ImagePicker().getImage(source: ImageSource.gallery);
        File cropped = await ImageCropper.cropImage(
          sourcePath: img.path,
          aspectRatio: CropAspectRatio(
            ratioX: 1,
            ratioY: 1,
          ),
          cropStyle: CropStyle.circle,
          compressQuality: 90,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Theme.of(context).accentColor,
            toolbarTitle: "Rogner l'image",
            backgroundColor: context.primaryColor,
          ),
        );
        var user = FirebaseAuth.instance.currentUser;
        final _storage = FirebaseStorage.instance;
        await _storage
            .ref()
            .child("profilePicture/${user.uid}")
            .putFile(cropped);

        String url = await _storage
            .ref()
            .child("profilePicture/${user.uid}")
            .getDownloadURL();
        context
            .read<FirestoreServices>()
            .addProfilePicTofs(uid: user.uid, link: url);
        context.pop();
      } catch (e) {}
    }

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.user.uid).get(),
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
                builder: (context) =>
                    userProfile(data, context, takePhoto, pickImage),
              );
            },
            child: Container(
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
                          "https://firebasestorage.googleapis.com/v0/b/let-s-play-05122020.appspot.com/o/app_icon.jpeg?alt=media&token=66f40d51-167e-429b-93f7-915d8d0033b1",
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
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  userProfile(Map<String, dynamic> data, BuildContext context,
      Future<dynamic> takePhoto(), Future<dynamic> pickImage()) {
    return Scaffold(
      appBar: myAppBar(
        context: context,
        title: "Mon Profil",
        todo: () => context.pop(),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: context.accentColor.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.camera,
                          color: Color(0xFFe5e5e5),
                        ),
                        title: Text(
                          'Camera',
                          style: TextStyle(color: Colors.amber),
                        ),
                        onTap: () {
                          Navigator.pop(context);

                          takePhoto();
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.image,
                          color: Color(0xFFe5e5e5),
                        ),
                        title: Text(
                          'Galerie',
                          style: TextStyle(color: Colors.amber),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          pickImage();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 5,
                    color: Theme.of(context).accentColor.withOpacity(0.45),
                  ),
                ),
                height: 180,
                width: 180,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.contain,
                      image: new NetworkImage(
                        data["picture"] ??
                            "https://firebasestorage.googleapis.com/v0/b/let-s-play-05122020.appspot.com/o/app_icon.jpeg?alt=media&token=66f40d51-167e-429b-93f7-915d8d0033b1",
                      ),
                    ),
                    border: Border.all(
                      width: 5,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  height: 140,
                  width: 140,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              data["pseudo"] ?? "Mon Pseudo",
              textAlign: TextAlign.center,
              style: GoogleFonts.quando(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                height: 1.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data["phoneNumber"] ?? "+229 12345678",
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: data["isVip"]
                      ? Colors.amber.withOpacity(0.8)
                      : context.accentColor.withOpacity(0.8)),
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data["isVip"] ? "V.I.P" : "Passer V.I.P",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quando(
                    fontSize: data["isVip"] ? 20.0 : 11,
                    fontWeight:
                        data["isVip"] ? FontWeight.bold : FontWeight.normal,
                    letterSpacing: 1.0,
                    // height: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  context.showToast(
                      msg:
                          "Vous disposez de ${data["bullets"].toString()} Bullets",
                      textColor: Colors.redAccent,
                      showTime: 4000,
                      position: VxToastPosition.center,
                      bgColor: Theme.of(context).primaryColor);
                },
                child: Container(
                  width: 100,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF2d3447).withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40 / 2),
                            border:
                                Border.all(color: Colors.redAccent, width: 2),
                            color: Colors.redAccent.withOpacity(0.5),
                          ),
                          width: 40,
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/images/bullet_icon.png',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          data["bullets"].toString().length > 4
                              ? toCurrencyString(data["bullets"].toString(),
                                  shorteningPolicy: ShorteningPolicy.Automatic)
                              : data["bullets"].toString(),
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Bullets",
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.showToast(
                      msg: "Vous disposez de ${data["coins"].toString()} Coins",
                      textColor: Colors.amberAccent,
                      showTime: 4000,
                      position: VxToastPosition.center,
                      bgColor: Theme.of(context).primaryColor);
                },
                child: Container(
                  width: 100,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF2d3447).withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40 / 2),
                            border: Border.all(color: Colors.amber, width: 2),
                            color: Colors.amber.withOpacity(0.5),
                          ),
                          width: 40,
                          height: 40,
                          child: Icon(FontAwesomeIcons.coins),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          data["coins"].toString().length > 4
                              ? toCurrencyString(data["coins"].toString(),
                                  shorteningPolicy: ShorteningPolicy.Automatic)
                              : data["coins"].toString(),
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Coins",
                          style: TextStyle(color: Colors.amber, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.showToast(
                      msg:
                          "Vous disposez de ${data["diamonds"].toString()} Diamonds",
                      textColor: Colors.lightBlue,
                      showTime: 4000,
                      position: VxToastPosition.center,
                      bgColor: Theme.of(context).primaryColor);
                },
                child: Container(
                  width: 100,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFF2d3447).withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40 / 2),
                            border: Border.all(color: Colors.blue, width: 2),
                            color: Colors.blue.withOpacity(0.5),
                          ),
                          width: 40,
                          height: 40,
                          child: Icon(FontAwesomeIcons.gem),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          data["diamonds"].toString().length > 4
                              ? toCurrencyString(data["diamonds"].toString(),
                                  shorteningPolicy: ShorteningPolicy.Automatic)
                              : data["diamonds"].toString(),
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Diamonds",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              socialNetwork(
                  color: Color(0xFFE1306C),
                  press: () {},
                  icon: UniconData.uniInstagram,
                  text: "Instagram"),
              socialNetwork(
                  color: Color(0xFF4AC959),
                  press: () {},
                  icon: UniconData.uniWhatsapp,
                  text: "WhatsApp"),
              socialNetwork(
                  color: Color(0xFFFFFC00),
                  press: () {},
                  icon: UniconData.uniGooglePlay,
                  text: "Play Store"),
              socialNetwork(
                  color: Colors.blueAccent,
                  press: () {},
                  icon: UniconData.uniFacebook,
                  text: "FaceBook"),
              socialNetwork(
                  color: Color(0xFFFF0000),
                  press: () {},
                  icon: UniconData.uniYoutube,
                  text: "YouTube"),
            ],
          )
        ],
      ),
    );
  }

  socialNetwork({
    Color color,
    GestureTapCallback press,
    UniconDataModel icon,
    String text,
    String link,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 5),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 55,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(0),
                height: (45),
                width: (45),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 4,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Unicon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              SizedBox(height: 7),
              Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.quando(
                  fontSize: 7.0,
                  fontWeight: FontWeight.bold,
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
}
