import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zephyr18112020/ui/widgets/my_app_bar.dart';
import 'package:zephyr18112020/services/storage_services.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UploadPost extends StatefulWidget {
  @override
  _UploadPostState createState() => _UploadPostState();
}

final storageRef = FirebaseStorage.instance.ref();
TextEditingController descriptionController = TextEditingController();
File imgPost;
String ppUrl = '';
String userPseudo;
bool isUploading = false;

class _UploadPostState extends State<UploadPost> {
  takePhoto() async {
    Navigator.pop(context);
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
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Theme.of(context).accentColor,
        toolbarTitle: "Rogner l'image",
        backgroundColor: context.primaryColor,
      ),
    );
    setState(() {
      imgPost = cropped;
    });
  }

  pickImage() async {
    Navigator.pop(context);
    PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);
    File cropped = await ImageCropper.cropImage(
      sourcePath: img.path,
      aspectRatio: CropAspectRatio(
        ratioX: 2,
        ratioY: 3,
      ),
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
      imgPost = cropped;
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    postImg(
        context: context,
        filename: "posts/${context.read<User>().uid}_${DateTime.now()}",
        file: imgPost,
        userId: context.read<User>().uid);
    setState(() {
      imgPost = null;
      isUploading = false;
    });
  }

  selectImage() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: Theme.of(context).primaryColor,
        children: <Widget>[
          FlatButton(
            onPressed: takePhoto,
            child: Row(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.camera,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Camera"),
              ],
            ),
          ),
          SizedBox(
            height: 6,
          ),
          FlatButton(
            onPressed: pickImage,
            child: Row(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.image,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Galerie"),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SimpleDialogOption(
                  child: Text("Annuler"),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      imgPost = null;
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSplashScreen() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: RaisedButton(
          onPressed: () async {
            bool isConnected = await DataConnectionChecker().hasConnection;
            if (isConnected) {
              selectImage();
            } else {
              context.showToast(msg: "Erreur connexion internet");
            }
          },
          color: Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text("Choisir une image"),
        ),
      ),
    );
  }

  buildUploadedForm() {
    return ListView(
      children: <Widget>[
        isUploading ? LinearProgressIndicator() : Container(),
        Container(
          child: AspectRatio(
            aspectRatio: 16 / 16,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(
                    imgPost,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          context: context,
          title: "Ajouter un Post",
          todo: () => context.pop()),
      body: Stack(
        children: [
          imgPost == null ? buildSplashScreen() : buildUploadedForm(),
          ExhibitionBottomSheet(),
        ],
      ),
      floatingActionButton: imgPost == null
          ? FloatingActionButton(
              onPressed: () {},
              child: Icon(
                FontAwesomeIcons.question,
              ),
            )
          : FloatingActionButton(
              onPressed: isUploading ? null : handleSubmit,
              child: Icon(
                FontAwesomeIcons.shareAlt,
              ),
            ),
    );
  }

  @override
  void dispose() {
    setState(() {
      imgPost = null;
    });
    super.dispose();
  }
}

const double minHeight = 50;

class ExhibitionBottomSheet extends StatefulWidget {
  @override
  _ExhibitionBottomSheetState createState() => _ExhibitionBottomSheetState();
}

class _ExhibitionBottomSheetState extends State<ExhibitionBottomSheet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller; //<-- Create a controller

  double get maxHeight =>
      MediaQuery.of(context).size.height *
      0.5; //<-- Get max height of the screen

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      //<-- initialize a controller
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); //<-- and remember to dispose it!
    super.dispose();
  }

  double lerp(double min, double max) => lerpDouble(
      min, max, _controller.value); //<-- lerp any value based on the controller

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      //<--add animated builder
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          height: lerp(minHeight,
              maxHeight), //<-- update height value to scale with controller
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            //<-- add a gesture detector
            onTap: _toggle,
            onVerticalDragUpdate:
                _handleDragUpdate, //<-- Add verticalDragUpdate callback
            onVerticalDragEnd: _handleDragEnd,
            child: Container(
              child: _controller.status == AnimationStatus.completed
                  ? ListView(
                      children: [
                        Wrap(
                          children: <Widget>[
                            Container(
                              width: 50,
                              margin: EdgeInsets.only(top: 10, bottom: 6),
                              height: 5,
                              decoration: new BoxDecoration(
                                color: Vx.randomPrimaryColor,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Let's Play",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Ici vous êtes chez vous.\n Interagissez avec la communauté, faites la course aux likes et aussi au dislikes 🤭🤭🤭. Sentez vous libre, partagez vos vies, vos rêves, vos pensées, vos conneries, vos blagues. Ici vous ferez ce que vous voudrez 😌.",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 200,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    )
                  : Wrap(
                      children: <Widget>[
                        Container(
                          width: 50,
                          margin: EdgeInsets.only(top: 10, bottom: 6),
                          height: 5,
                          decoration: new BoxDecoration(
                            color: Vx.randomPrimaryColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ],
                    ),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                color: Color(0xFF162A49),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta /
        maxHeight; //<-- Update the _controller.value by the movement done by user.
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy /
        maxHeight; //<-- calculate the velocity of the gesture
    if (flingVelocity < 0.0)
      _controller.fling(
          velocity: max(2.0, -flingVelocity)); //<-- either continue it upwards
    else if (flingVelocity > 0.0)
      _controller.fling(
          velocity: min(-2.0, -flingVelocity)); //<-- or continue it downwards
    else
      _controller.fling(
          velocity: _controller.value < 0.5
              ? -2.0
              : 2.0); //<-- or just continue to whichever edge is closer
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(
        velocity: isOpen ? -2 : 2); //<-- ...snap the sheet in proper direction
  }
}
