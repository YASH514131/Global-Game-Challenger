import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_first/widget/fetchscore.dart';

class LeaderBoard extends StatefulWidget{
  const LeaderBoard({super.key});
  @override
  State<LeaderBoard> createState() {
   return _LeaderBoardState();
  }
}
class _LeaderBoardState extends State<LeaderBoard>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: const Text('LeaderBoard'),
    ),
    body: LeaderboardWidget(),
   );
  }
}