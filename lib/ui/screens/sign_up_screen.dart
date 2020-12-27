import 'package:flutter/material.dart';
import 'package:zephyr18112020/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zephyr18112020/services/firestore_services.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'on_boarding.dart';

enum currentPage {
  OnBoarding,
  Email,
  Name,
  Pseudo,
}
enum tfType {
  Pseudo,
  Pic,
  Mail,
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

File profilePicture;

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController picController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.nextPage(OnBoardingScreen());
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: ListView(
          children: [
            _textField(
              ctrl: pseudoController,
              isRequired: true,
              type: tfType.Pseudo,
            ),
            _textField(
              ctrl: pseudoController,
              isRequired: true,
              type: tfType.Mail,
            ),
            _textField(
              ctrl: pseudoController,
              isRequired: true,
              type: tfType.Pic,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: OutlineButton(
                splashColor: Color(0xFF0b032d),
                hoverColor: Color(0xFF0b032d),
                highlightColor: Color(0xFF0b032d),
                highlightedBorderColor: Color(0xFF0b032d),
                disabledTextColor: Color(0xFF0b032d),
                disabledBorderColor: Color(0xFF0b032d),
                color: Color(0xFF0b032d),
                focusColor: Color(0xFF0b032d),
                borderSide: BorderSide(color: Color(0xFF0b032d), width: 2),
                onPressed: () async {
                  context.read<FirestoreServices>().updateUserData(
                      mail: mailController.text.trim(),
                      pseudo: pseudoController.text,
                      uid: firebaseUser.uid,
                      picture: picController.text);
                },
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: Text(
                  'Envoyer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.logout,
        ),
        onPressed: () => context.read<AuthServices>().signOut(),
      ),
    );
  }

  Column _textField({
    @required tfType type,
    @required TextEditingController ctrl,
    @required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (type == tfType.Pseudo)
          Text(
            'Choisir un pseudo',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        if (type == tfType.Mail)
          Text(
            'Entrez votre mail',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        if (type == tfType.Pic)
          Text(
            'Choisir une photo',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        SizedBox(
          height: 10,
        ),
        //!Pseudo
        if (type == tfType.Pseudo)
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFF0b032d),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 60,
            child: TextFormField(
              keyboardType: TextInputType.name,
              autofocus: false,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                ),
                hintText: 'Ex: NoobMaster02',
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                ),
              ),
              validator: (value) =>
                  value.isEmpty ? 'Veuillez choisir un pseudo' : null,
              controller: pseudoController,
            ),
          ),
        //!email
        if (type == tfType.Mail)
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFF0b032d),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 60,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
                hintText: 'Ex: Monmail@monmail.game',
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                ),
              ),
              validator: (value) =>
                  value.isEmpty ? 'Veuillez choisir un mail' : null,
              controller: mailController,
            ),
          ),
        //!Pic
        if (type == tfType.Pic)
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xFF0b032d),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 60,
            child: TextFormField(
              keyboardType: TextInputType.phone,
              autofocus: false,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                hintText: 'Ex: NoobMaster02',
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                ),
              ),
              validator: (value) =>
                  value.isEmpty ? 'Veuillez choisir un pseudo' : null,
              controller: picController,
            ),
          ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String email;
  String pseudo;
  takePhoto() async {
    try {
      PickedFile img = await ImagePicker().getImage(source: ImageSource.camera);
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
      setState(() {
        profilePicture = cropped;
      });
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
      setState(() {
        profilePicture = cropped;
      });
    } catch (e) {}
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04), // 4%
                  Text(
                    "Complète tes informations",
                    style: TextStyle(
                      fontSize: (28),
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    "Complete tes informations pour évoluer \ndans ce monde facinant",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.9),
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
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).accentColor.withOpacity(0.4),
                            border: Border.all(
                              color: Colors.amberAccent.withOpacity(0.4),
                              width: 3,
                            ),
                          ),
                          margin: const EdgeInsets.all(5),
                          child: Center(
                              child: ClipOval(
                            child: profilePicture == null
                                ? Unicon(
                                    UniconData.uniUser,
                                    color: Colors.amber,
                                    size: 40,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        Image.file(profilePicture).image,
                                    radius: 50,
                                  ),
                          )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.all(0),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Theme.of(context).accentColor.withOpacity(0.9),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 3),
                          ),
                          child: Unicon(
                            UniconData.uniPen,
                            color: Colors.amber,
                            size: 20,
                          ),
                          width: 35,
                          height: 35,
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.name,
                          onSaved: (newValue) => pseudo = newValue,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              removeError(error: "Please Enter your Pseudo");
                            } else if (value.length < 4) {
                              removeError(error: "Please Enter Valid Pseudo");
                            }
                            return null;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              addError(error: "Please Enter your Pseudo");
                              return "";
                            } else if (value.isNotEmpty && value.length < 4) {
                              addError(error: "Please Enter Valid Pseudo");
                              return "";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Pseudo",
                            hintText: "Entre une Pseudo",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(Icons.verified_user),
                          ),
                        ),
                        SizedBox(height: (30)),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (newValue) => email = newValue,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              removeError(error: "Please Enter your email");
                            } else if (RegExp(
                                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              removeError(error: "Please Enter Valid Email");
                            }
                            return null;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              addError(error: "Please Enter your email");
                              return "";
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              addError(error: "Please Enter Valid Email");
                              return "";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Enter your email",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: (30)),
                        FormError(errors: errors),
                        SizedBox(height: (40)),
                        Container(),
                        DefaultButton(
                          text: "Commencer mon aventure",
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              await context
                                  .read<FirestoreServices>()
                                  .userRegistration(
                                      email: email,
                                      context: context,
                                      file: profilePicture,
                                      filename:
                                          "profilePicture/${context.read<User>().uid}",
                                      pseudo: pseudo);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: (20)),
                  Text(
                    'By continuing your confirm that you agree \nwith our Term and Condition',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormError extends StatelessWidget {
  const FormError({
    Key key,
    @required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index])),
    );
  }

  Row formErrorText({String error}) {
    return Row(
      children: [
        Unicon(
          UniconData.uniExclamationTriangle,
          size: 25,
          color: Colors.redAccent,
        ),
        SizedBox(
          width: (10),
        ),
        Text(error),
      ],
    );
  }
}

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: (56),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Color(0xFFFF7643),
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: (18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
