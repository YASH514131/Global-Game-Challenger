import 'package:flutter/material.dart';
import 'package:game_first/Screen/leaderboard.dart';
import 'package:game_first/pixel_adventure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase=FirebaseAuth.instance;
class GamerOverMenu extends StatefulWidget {
  static const String ID = 'GameOverMenu';
  final PixelAdventure gameRef;

  const GamerOverMenu({Key? key, required this.gameRef}) : super(key: key);
  @override
  State<GamerOverMenu> createState() {
    return _GameOverMenuState();
  }
}
class _GameOverMenuState extends State<GamerOverMenu>{

  @override
  void initState(){
    _initializeData();
    super.initState();
  }

Future<void> _initializeData() async {
  
  try {
    await saveUserScore(_firebase.currentUser!.uid);
  } catch (error) {
   
    // Handle the error as needed
  }
}


Future<void> saveUserScore(String uid) async {
  String username = await getUsernameFromUid(uid);

  if (username.isNotEmpty) {
    // Use ScoreManager to handle score logic
    int currentScore = widget.gameRef.score;
    int timePlayed = widget.gameRef.timePlayed;
    int minute = widget.gameRef.minute;

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('userScores')
        .doc(uid) // Use UID as a unique identifier
        .get();

    if (userSnapshot.exists) {
      // User data exists, compare scores and total time played
      int backendScore = userSnapshot['bestScore'] as int? ?? 0;
      int backendTotalTime = (userSnapshot['minute'] as int? ?? 0) * 60 + (userSnapshot['timePlayed'] as int? ?? 0);

      if (currentScore > backendScore || (currentScore == backendScore && ((minute*60) + timePlayed) <= backendTotalTime)) {
        // Update user data with the new best score and total time played
        await FirebaseFirestore.instance
            .collection('userScores')
            .doc(uid) // Use UID as a unique identifier
            .set({
          'playerName': username,
          'minute': minute,
          'score': currentScore,
          'timePlayed': timePlayed,
          'bestScore': currentScore,
        });
      }
      // else, do nothing as the current score is not greater or total time played is greater
    } else {
      // User data doesn't exist, store initial data
      await FirebaseFirestore.instance
          .collection('userScores')
          .doc(uid) // Use UID as a unique identifier
          .set({
        'playerName': username,
        'minute': minute,
        'score': currentScore,
        'timePlayed': timePlayed,
        'bestScore': currentScore,
      });
    }
  }
}
Future<String> getUsernameFromUid(String uid) async {
  String username = '';

  DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (userSnapshot.exists) {
    username = userSnapshot['username'];
  }

  return username;
}
Future<void>sinOut()async {
  return await FirebaseAuth.instance.signOut();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Background/game_over.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Score:${widget.gameRef.score}',
                    style: const TextStyle(
                        decoration: TextDecoration.none,
                        color: Color.fromARGB(255, 171, 63, 49),
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Time:${widget.gameRef.minute}:${widget.gameRef.timePlayed}s',
                    style: const TextStyle(
                        decoration: TextDecoration.none,
                        color: Color.fromARGB(255, 171, 63, 49),
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
           const    SizedBox(width: 20,),
                   ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 171, 63, 49),
                            ),
                            ),
                    onPressed: ()  {
                      widget.gameRef.overlays.remove(GamerOverMenu.ID);
                      widget.gameRef.resumeEngine(); 
                      widget.gameRef.score=0;
                      widget.gameRef.minute=0;
                      widget.gameRef.timePlayed=0;
                      widget.gameRef.loadLevel();
                    },
                    child: Text(
                      'Play Again',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.yellow.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    ),
                    const SizedBox(width: 20,),
                     ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 171, 63, 49),
                            ),
                            ),
                    onPressed: ()  {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const LeaderBoard()));
                    },
                    child: Text(
                      'LeaderBoard',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.yellow.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ))
                
                ],),
               
              ],
            ),
          ),
        ),
      );
  }
}
