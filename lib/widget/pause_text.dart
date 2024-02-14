import 'package:flutter/material.dart';
import 'package:game_first/pixel_adventure.dart';
import 'package:game_first/widget/pause_menu.dart';

class PauseMaterial extends  StatelessWidget{
  static const String ID='PauseMenu';
  final PixelAdventure gameRef;
  const PauseMaterial({super.key,required this.gameRef});
  @override
  Widget build(BuildContext context) {
    return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    'Paused',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 50.0,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          blurRadius: 20.0,
                          color: Colors.white,
                          offset: Offset(0, 0),
                        )
                      ]
                    ),
                  ),
                  ),
                ElevatedButton(
                    onPressed: () {
                        gameRef.resumeEngine();
                        gameRef.overlays.remove(PauseMaterial.ID);
                        gameRef.overlays.add(PauseButton.ID);
                    },
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all<Color>(Colors.blueGrey.shade200)
                    ),
                    child: const Text(
                      'Resume',
                      style: TextStyle(
                        color: Color.fromARGB(255, 104, 50, 11),
                        fontSize: 30,
                      ),
                    )),
                 

              ],
            ),
          );
  }
}