import 'dart:async';
import 'dart:ui';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zephyr18112020/services/auth_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String verificationId;
  bool showCodePutter = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController mdpController = TextEditingController();

  bool loading = false;
  StreamSubscription<DataConnectionStatus> listener;

//!Méthode de vérification du numéro
  Future<void> verifyNumber({BuildContext ctx}) async {
    DataConnectionStatus status = await checkInternet();
    if (status == DataConnectionStatus.connected) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneController.text.trim(),
        codeSent: (String verfId, int resendToken) {
          setState(() {
            verificationId = verfId;
            loading = false;
            showCodePutter = true;
          });
        },
        verificationCompleted: (PhoneAuthCredential credential) {
          context.read<AuthServices>().verificationCompleted(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            loading = false;
          });
          if (e.code == 'invalid-phone-number') {
            ctx.showToast(
                msg: "Le numéro de téléphone fourni n'est pas valable.",
                textColor: Theme.of(ctx).accentColor,
                position: VxToastPosition.top,
                bgColor: Theme.of(ctx).primaryColor);
          } else {
            ctx.showToast(
                msg: e.message,
                textColor: Theme.of(ctx).accentColor,
                position: VxToastPosition.top,
                bgColor: Theme.of(ctx).primaryColor);
          }
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } else {
      setState(() {
        loading = false;
      });
      ctx.showToast(
          msg: "Erreur internet",
          textColor: Theme.of(ctx).accentColor,
          position: VxToastPosition.top,
          bgColor: Theme.of(ctx).primaryColor);
    }
  }

  checkInternet() async {
    // Simple check to see if we have internet
    print("The statement 'this machine is connected to the Internet' is: ");
    // Fluttertoa
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          break;
      }
    });

    return await DataConnectionChecker().connectionStatus;
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: loading,
      progressIndicator: SpinKitChasingDots(
        color: Colors.redAccent,
        size: 50.0,
      ),
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF63F48),
          ),
          child: Center(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: !showCodePutter ? _buildPhoneNumber() : _buildCodePutter(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          isExtended: true,
          tooltip: "Se connecter en super user",
          child: Icon(Icons.shield),
          backgroundColor: Color(0xFF0b032d),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Mot de passe"),
                actions: [
                  OutlineButton(
                    child: Text("Valider"),
                    onPressed: () => context
                        .read<AuthServices>()
                        .superUserLogin(
                            mdp: mdpController.text.trim(), ctx: context),
                  ),
                ],
                content: TextField(
                  obscureText: true,
                  autofocus: true,
                  controller: mdpController,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Column _buildPhoneNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Se connecter',
          style: GoogleFonts.quando(
            fontSize: 30.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'Numéro de Téléphone',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
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
            inputFormatters: [PhoneInputFormatter()],
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
              hintText: 'Ex: +229 12 34 56 78',
              hintStyle: TextStyle(
                color: Colors.white54,
              ),
            ),
            validator: (value) =>
                value.isEmpty ? 'Entrez votre Numéro de Téléphone' : null,
            controller: phoneController,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        //?Boutton de Verification du numero
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
              if (phoneController.text.isEmpty) {
                context.showToast(
                    msg: "Entrez votre Numéro de Téléphone.",
                    textColor: Theme.of(context).accentColor,
                    position: VxToastPosition.top,
                    bgColor: Theme.of(context).primaryColor);
              } else {
                setState(() {
                  loading = true;
                });
                verifyNumber(
                  ctx: context,
                );
              }
            },
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: Text(
              'Recevoir le code',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildCodePutter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Se connecter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "Code SMS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
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
                Icons.message_outlined,
                color: Colors.white,
              ),
              hintText: 'Ex: 367458',
              hintStyle: TextStyle(
                color: Colors.white54,
              ),
            ),
            validator: (value) =>
                value.isEmpty ? 'Entrez le code sms reçu' : null,
            controller: codeController,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        //?Boutton de Verification du numero
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
            onPressed: () {
              setState(() {
                loading = true;
              });
              context
                  .read<AuthServices>()
                  .signInWithOTP(codeController.text.trim(), verificationId);
            },
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: Text(
              'Se connecter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
