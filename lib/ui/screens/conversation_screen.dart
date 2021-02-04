import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unicons/flutter_unicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zephyr18112020/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zephyr18112020/services/storage_services.dart';
import 'package:zephyr18112020/ui/widgets/chat_item.dart';
import 'package:zephyr18112020/ui/widgets/chat_app_bar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConversationScreen extends StatefulWidget {
  final convId;

  const ConversationScreen({@required this.convId});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

TextEditingController messageController = new TextEditingController();

class _ConversationScreenState extends State<ConversationScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the bottom");
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("reach the top");
    }
  }

  File img;
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  List<String> backgrounds = [
    "assets/background/Aare.png",
    "assets/background/Clarence.png",
    "assets/background/Doubs.png",
    "assets/background/Hinterrhein.png",
    "assets/background/Inn.png",
    "assets/background/Kander.png",
    "assets/background/Linth.png",
    "assets/background/Mataura.png",
    "assets/background/Mohaka.png",
    "assets/background/Ngaruroro.png",
    "assets/background/Oreti.png",
    "assets/background/Rangitikei.png",
    "assets/background/Reuss.png",
    "assets/background/Rho╠éne.png",
    "assets/background/Taieri.png",
    "assets/background/Thur.png",
    "assets/background/Vorderrhein.png",
    "assets/background/Waiau.png",
    "assets/background/Waihou.png",
    "assets/background/Waimakariri.png",
    "assets/background/Wairau.png",
    "assets/background/Whangaehu.png",
  ];
  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int randomNumber = random.nextInt(21);
    return SafeArea(
      child: img != null
          ? viewPicture()
          : Scaffold(
              appBar: ChatAppBar(
                groupeId: widget.convId,
              ),
              body: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Theme.of(context).accentColor.withOpacity(0.3),
                    child: Image.asset(
                      backgrounds[randomNumber],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                  Column(
                    children: [
                      _messagesList(
                          chatRoomId: widget.convId,
                          ctx: context,
                          scrollController: _scrollController),
                      _inputWidget(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  viewPicture() {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        title: Text("Groupe"),
        leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.arrowLeft,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              setState(() {
                img = null;
              });
            }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: FileImage(
                    img,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await sendImg(
            file: img,
            filename: "images/${context.read<User>().uid}_${DateTime.now()}",
            context: context,
            convId: widget.convId,
            userId: context.read<User>().uid,
          );
          setState(() {
            img = null;
          });
        },
        child: Icon(
          FontAwesomeIcons.shareAlt,
        ),
      ),
    );
  }

  _messagesList(
      {@required chatRoomId,
      @required scrollController,
      @required BuildContext ctx}) {
    return Expanded(
      child: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('discussions')
              .doc(chatRoomId)
              .collection('chats')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Container(
                  child: Text('Erreur'),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return (snapshot.hasData || snapshot.data != null)
                ? ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    controller: scrollController,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      //
                      return ChatItemWidget(
                        message:
                            snapshot.data.documents[index].data()["message"],
                        sendBy: snapshot.data.documents[index].data()["sendBy"],
                        time: snapshot.data.documents[index].data()["time"],
                        type: snapshot.data.documents[index].data()["type"],
                        isSendByMe:
                            snapshot.data.documents[index].data()["sendBy"] ==
                                ctx.read<User>().uid,
                      );
                    },
                  )
                : Center(
                    child: Container(
                      child: Text('Aucun message'),
                    ),
                  );
          },
        ),
      ),
    );
  }

  selectImage() {
    showModalBottomSheet(
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
                  pickImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickImage() async {
    context.pop();
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      PickedFile img1 =
          await ImagePicker().getImage(source: ImageSource.gallery);
      File cropped = await ImageCropper.cropImage(
        sourcePath: img1.path,
        compressQuality: 50,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Theme.of(context).accentColor,
          toolbarTitle: "Rogner l'image",
          backgroundColor: context.theme.primaryColor,
          showCropGrid: false,
          hideBottomControls: false,
        ),
      );
      setState(() {
        img = cropped;
      });
    } else {
      print("erreur permission");
    }
  }

  takePhoto() async {
    context.pop();
    PickedFile img1 = await ImagePicker().getImage(source: ImageSource.camera);
    File cropped = await ImageCropper.cropImage(
      sourcePath: img1.path,
      compressQuality: 50,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Theme.of(context).accentColor,
        toolbarTitle: "Rogner l'image",
        backgroundColor: context.theme.primaryColor,
        showCropGrid: false,
        hideBottomControls: false,
      ),
    );
    setState(() {
      img = cropped;
    });
  }

  _inputWidget() {
    return GestureDetector(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Material(
              elevation: 60,
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFfca311),
                  borderRadius: BorderRadius.circular(60),
                ),
                // height: 50,
                child: Row(
                  children: [
                    _emojiBtn(),
                    _messageField(),
                    _sendBtn(
                        ctrl: messageController,
                        groupeId: widget.convId,
                        scrollController: _scrollController,
                        ctx: context),
                  ],
                ),
              ),
            ),
            Wrap(
              children: <Widget>[
                Container(
                  width: 50,
                  margin: EdgeInsets.only(top: 10, bottom: 6),
                  height: 5,
                  decoration: new BoxDecoration(
                    color: Vx.randomPrimaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ],
            ),
          ],
        ),
        // onTap: () => moreAction(),
        onPanUpdate: (details) {
          if (details.delta.dy < 50) {
            moreAction();
          }
        });
  }

  Future moreAction() {
    return showModalBottomSheet(
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
                  Icons.image,
                  color: Color(0xFFe5e5e5),
                ),
                title: Text(
                  'Image',
                  style: TextStyle(color: Colors.amber),
                ),
                onTap: () {
                  Navigator.pop(context);

                  selectImage();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.videocam,
                  color: Color(0xFFe5e5e5),
                ),
                title: Text(
                  'Vidéo',
                  style: TextStyle(color: Colors.amber),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.showToast(
                      msg: "Bientôt disponible",
                      textColor: Theme.of(context).accentColor,
                      position: VxToastPosition.top,
                      bgColor: Theme.of(context).primaryColor);
                },
              ),
              ListTile(
                  leading: Icon(
                    Icons.attach_file,
                    color: Color(0xFFe5e5e5),
                  ),
                  title: Text(
                    'Fichier',
                    style: TextStyle(color: Colors.amber),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.showToast(
                        msg: "Bientôt disponible",
                        textColor: Theme.of(context).accentColor,
                        position: VxToastPosition.top,
                        bgColor: Theme.of(context).primaryColor);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sendBtn({
    @required TextEditingController ctrl,
    @required String groupeId,
    @required ScrollController scrollController,
    @required BuildContext ctx,
  }) {
    return GestureDetector(
      onTap: () async {
        if (messageController.text.isNotEmpty &&
            messageController.text.trim() != '') {
          String userId = ctx.read<User>().uid;
          Map<String, dynamic> messageMap = {
            'message': messageController.text,
            'sendBy': '$userId',
            'time': DateTime.now().millisecondsSinceEpoch,
            'type': 1
          };
          scrollController.animateTo(
            0.0,
            curve: Curves.linear,
            duration: Duration(
              milliseconds: 250,
            ),
          );
          ctx.read<FirestoreServices>().addConversationMessages(
                chatRoomId: groupeId,
                messageMap: messageMap,
              );
          ctx.read<FirestoreServices>().addLastMessage(
                chatRoomId: groupeId,
                sendBy: userId,
                message: messageController.text.trim(),
              );
          ctrl.clear();
        } else {
          ctx.showToast(
              msg: "Rien à envoyer",
              textColor: Theme.of(ctx).accentColor,
              position: VxToastPosition.top,
              bgColor: Theme.of(ctx).primaryColor);
        }
      },
      child: Container(
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        width: 40,
        child: Unicon(
          UniconData.uniMessage,
          size: 30,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Flexible _messageField() {
    return Flexible(
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white54.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: TextField(
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          minLines: 1,
          maxLines: 5,
          style: TextStyle(color: Colors.black, fontSize: 15.0),
          controller: messageController,
          decoration: InputDecoration.collapsed(
            hintText: 'Message ...',
            hintStyle: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }

  _emojiBtn() {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return VxBox(
            child: PageView(
              children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0.5,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 0.5,
                  ),
                  itemCount: 14,
                  padding: EdgeInsets.all(13.0),
                  itemBuilder: (context, index) {
                    return emojiItem('assets/stickers/boy/s${index + 1}.png');
                  },
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0.5,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 0.5,
                  ),
                  itemCount: 14,
                  padding: EdgeInsets.all(13.0),
                  itemBuilder: (context, index) {
                    return emojiItem('assets/stickers/girl/s${index + 1}.png');
                  },
                ),
              ],
            ),
          )
              .withRounded(value: 40)
              .color(context.backgroundColor.withOpacity(0.7))
              .border(
                color: context.accentColor,
                width: 2,
              )
              .make()
              .centered()
              .p24();
        },
      ),
      child: Container(
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        width: 40,
        child: Unicon(
          UniconData.uniSmileBeam,
          size: 30,
          color: Colors.amber,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withOpacity(0.6),
        ),
      ),
    );
  }

  emojiItem(
    String url,
  ) {
    return GestureDetector(
      onTap: () {
        sendSticker(
          context: context,
          convId: widget.convId,
          stickerName: url,
          userId: context.read<User>().uid,
        );
        context.pop();
      },
      child: VxBox(
              child: url.circularAssetImage(
                  bgColor: Vx.randomColor.withOpacity(0.5)))
          .color(Colors.transparent)
          .p12
          .make(),
    );
  }
}
