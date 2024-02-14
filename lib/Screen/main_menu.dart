import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_first/Screen/gameplay.dart';
import 'package:game_first/Screen/leaderboard.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Background/intro_page.jpg"),
                fit: BoxFit.fill
                ),
                
              ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Game First',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Color.fromARGB(255, 104, 50, 11),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      
                    },
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(Colors.blueGrey.shade200)
                    ),
                    child: const Text(
                      'SignOut',
                      style: TextStyle(
                        color: Color.fromARGB(255, 104, 50, 11),
                        fontSize: 30,
                      ),
                    )),
                  const    SizedBox(width: 20,),
                    ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const GamePlay()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(Colors.blueGrey.shade200)
                    ),
                    child: const Text(
                      'Play',
                      style: TextStyle(
                        color: Color.fromARGB(255, 104, 50, 11),
                        fontSize: 30,
                      ),
                    )),
                    const    SizedBox(width: 20,),
                    ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LeaderBoard()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(Colors.blueGrey.shade200)
                    ),
                    child: const Text(
                      'LeaderBoard',
                      style: TextStyle(
                        color: Color.fromARGB(255, 104, 50, 11),
                        fontSize: 30,
                      ),
                    )),
                    ],
                  ),
                
                    
              ],
            ),
          )),
    );
  }
}
