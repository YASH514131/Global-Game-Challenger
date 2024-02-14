import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class SplashScreen extends StatelessWidget{

  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('FlutterChat') ,
      ),
      body: Center(
        child:Lottie.network('https://lottie.host/4abbbb07-9a3c-45e4-8ca1-b84dbcda94ab/MSniVNB8ZP.json'),
        ),
    );
  }
}