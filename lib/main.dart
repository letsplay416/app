import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zephyr18112020/services/firestore_services.dart';
import 'package:zephyr18112020/providers/main_page_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zephyr18112020/ui/widgets/get_user_infos.dart';
import 'services/auth_services.dart';
import 'ui/widgets/wrapper.dart';
import 'package:zephyr18112020/ui/screens/splash_screen.dart';

//!Test 1
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LetsPlay());
}

class LetsPlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthServices>(
          create: (_) => AuthServices(FirebaseAuth.instance),
        ),
        Provider<GetUserInfos>(
          create: (_) => GetUserInfos(),
        ),
        Provider<FirestoreServices>(
          create: (_) => FirestoreServices(FirebaseFirestore.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthServices>().authStateChanges,
        ),
        ChangeNotifierProvider(
          create: (context) => MainPageProvider(),
        ),
      ],
      child: MaterialApp(
        color: Colors.redAccent,
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.namedRoute,
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Varela',
          primaryColor: Color(0xFF1b1e44),
          primarySwatch: generateMaterialColor(Color(0xFFe63946)),
          canvasColor: Color(0xFF1b1e44),
          backgroundColor: Color(0xFF14213d),
          accentColor: Color(0xFFe63946),
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xFF1b1e44),
          ),
          iconTheme: ThemeData.dark().iconTheme.copyWith(
                color: Color(0xFFF3F7FB),
              ),
          textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'Varela',
                bodyColor: Color(0xFFF3F7FB),
                displayColor: Color(0xFFF3F7FB),
              ),
        ),
        routes: {
          SplashScreen.namedRoute: (context) => SplashScreen(),
        },
        title: "Let's Play",
        home: Wrapper(),
      ),
    );
  }
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.5),
    100: tintColor(color, 0.4),
    200: tintColor(color, 0.3),
    300: tintColor(color, 0.2),
    400: tintColor(color, 0.1),
    500: tintColor(color, 0),
    600: tintColor(color, -0.1),
    700: tintColor(color, -0.2),
    800: tintColor(color, -0.3),
    900: tintColor(color, -0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);
