import 'package:flutter/material.dart';
import 'package:game_first/pixel_adventure.dart';
import 'package:game_first/widget/pause_text.dart';

class PauseButton extends StatelessWidget{
  
  static const String ID='PauseButton';
  final PixelAdventure gameRef;

  const PauseButton({super.key,required this.gameRef});
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment:Alignment.topCenter,
        child: TextButton(
          child: const Icon(
            Icons.pause_rounded,
          ),
          onPressed: (){
              gameRef.pauseEngine();
              gameRef.overlays.add(PauseMaterial.ID);
              gameRef.overlays.remove(PauseButton.ID);
          },
        ),
    );
  }
}