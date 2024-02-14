import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_first/Screen/game_over_menu.dart';
import 'package:game_first/pixel_adventure.dart';
import 'package:game_first/widget/pause_menu.dart';
import 'package:game_first/widget/pause_text.dart';


final PixelAdventure _pixelGame=PixelAdventure();
class GamePlay extends StatelessWidget{

  const GamePlay({super.key});
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      initialActiveOverlays:const  [
        PauseButton.ID,
      ],
      game: _pixelGame,
      overlayBuilderMap: {
        GamerOverMenu.ID:(BuildContext context,PixelAdventure gameRef)=>
          GamerOverMenu(gameRef: gameRef),
          PauseButton.ID:(BuildContext context,PixelAdventure gameRef)=>
         PauseButton(gameRef: gameRef,),
         PauseMaterial.ID:(BuildContext context,PixelAdventure gameRef)=>
         PauseMaterial(gameRef: gameRef,)
      },
      );
  }
}