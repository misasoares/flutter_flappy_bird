import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'features/game/flappy_bird_game.dart';
import 'features/menu/ui/game_over_menu.dart';
import 'features/menu/ui/welcome_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setPortrait();
  runApp(
    const MaterialApp(home: GamePage(), debugShowCheckedModeBanner: false),
  );
}

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: FlappyBirdGame(),
        overlayBuilderMap: {
          'GameOverMenu': (BuildContext context, FlappyBirdGame game) {
            return GameOverMenu(gameRef: game);
          },
          'WelcomeMenu': (BuildContext context, FlappyBirdGame game) {
            return WelcomeMenu(gameRef: game);
          },
        },
        initialActiveOverlays: const [
          'WelcomeMenu',
        ], // Mostra a tela inicial ao iniciar o app
      ),
    );
  }
}
