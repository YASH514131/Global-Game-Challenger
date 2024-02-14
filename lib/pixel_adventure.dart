import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:game_first/Screen/game_over_menu.dart';
import 'package:game_first/components/jump_button.dart';
import 'package:game_first/components/player.dart';
import 'package:game_first/components/level.dart';

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {

  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  int playerlife=3;
  Player player = Player(character: 'Virtual Guy');
  late JoystickComponent joystick;
  late TextComponent _scoreText;
  late Timer _timer;
  int minute=0;
  late TextComponent _timeText;
  int timePlayed=0;
  bool showControls =false;
  int score=0;
  bool playSounds = true;
  bool isPaused=false;
  double soundVolume = 1.0;
  bool isAlreadyLoded=false;
  List<String> levelNames = ['Level-01', 'Level-02','Level-03','Level-04','Level-05'];
  int currentLevelIndex = 0;



  @override
  FutureOr<void> onLoad() async {

    if(!isAlreadyLoded){
        await images.loadAllImages();
    loadLevel();

    if (showControls) {
      priority=10;
      addJoystick();
      add(JumpButton());
    }

  _scoreText=TextComponent(text: '$score',
    position: Vector2(0, 20),
    anchor: Anchor.topLeft,
    textRenderer: TextPaint(
      style: TextStyle(
        color: BasicPalette.white.color,
        fontSize: 20,
      ),
    ),
  );
  add(_scoreText);

  _timer=Timer(1,repeat: true,
  onTick: (){
    if(timePlayed==60){
      minute++;
      timePlayed=1;
    }
   timePlayed++;

   isAlreadyLoded=true;
  }
  );
  
    _timeText=TextComponent(text: '$minute:$timePlayed',
    priority: 10,
    position: Vector2(size.x, 20),
    anchor: Anchor.topRight,
    textRenderer: TextPaint(
      style: TextStyle(
        color: BasicPalette.white.color,
        fontSize: 20,
      ),
    ),
  );
  add(_timeText);
  _timer.start();
    }
    // Load all images into cache
    
  
    return super.onLoad();
  }

  @override
  void update(double dt) {
    
   
    if (showControls) {
      updateJoystick();
    }

    _timer.update(dt);
    _scoreText.text='🔥:$score';
    _timeText.text='🕛$minute:$timePlayed';
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: CircleComponent(
        radius: 30,
        paint: BasicPalette.gray.withAlpha(200).paint(),

      ),
      background: CircleComponent(
        priority: 1,
        radius: 50,
        paint: BasicPalette.black.withAlpha(100).paint(),

      ),
      margin: const EdgeInsets.only(left: 5, bottom: 45),
      //knobRadius: 20.0
    );
  
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }


  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      loadLevel();
    } else {
      // no more levels
      currentLevelIndex=0;
      pauseEngine();
      overlays.add(GamerOverMenu.ID);
      //_loadLevel();
    }
  }

 /* void loadLevel() {
  /*if (playerlife == 0) {
    currentLevelIndex = 0;
    score = 0;
    timePlayed = 0;
    minute = 0;
    //playerlife = 3;
  }*/

  // Reset player state here if needed
  player.gotHit = false;
  player.current = PlayerState.idle;

  Level world = Level(
    player: player,
    levelName: levelNames[currentLevelIndex],
  );

  cam = CameraComponent.withFixedResolution(
    world: world,
    width: 640,
    height: 360,
  );
  cam.viewfinder.anchor = Anchor.topLeft;

  addAll([cam, world]);
}*/
 void loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }

 
}
