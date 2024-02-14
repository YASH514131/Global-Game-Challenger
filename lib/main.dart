import 'package:flame/flame.dart';
import 'package:game_first/Screen/auth.dart';
import 'package:game_first/Screen/splashscreen.dart';
//import 'package:flame/game.dart';
//import 'package:flutter/foundation.dart';
import 'package:game_first/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:game_first/Screen/main_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:game_first/pixel_adventure.dart';

User? user = FirebaseAuth.instance.currentUser;
GlobalKey<MyAppState> myAppKey = GlobalKey<MyAppState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(MyApp(key: myAppKey));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasData) {
            return const MainMenu();
          }

          return const AuthScreen();
        },
      ),
    );
  }
}

