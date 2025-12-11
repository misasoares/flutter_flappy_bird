import 'package:flutter/material.dart';
import '../../game/flappy_bird_game.dart';

class GameOverMenu extends StatelessWidget {
  final FlappyBirdGame gameRef;

  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Game Over',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 20,
              color: Colors.red,
              shadows: [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.black,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Pontuação: ${gameRef.score}',
            style: const TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 16,
              color: Colors.yellow,
              shadows: [
                Shadow(
                  blurRadius: 3.0,
                  color: Colors.black,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ), // Espaçamento interno
              backgroundColor: const Color.fromARGB(
                255,
                255,
                219,
                59,
              ), // Cor de fundo do botão
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              shadowColor: Colors.red, // Cor da sombra
              elevation: 5, // Elevação do botão
            ),
            child: const Text(
              'Tentar Novamente',
              style: TextStyle(
                fontFamily: 'PressStart2P', // Fonte pixelada
                fontSize: 14, // Tamanho da fonte
                color: Colors.red, // Cor do texto
                shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: Colors.white,
                    offset: Offset(3.0, 2.0), // Pequena sombra para realce
                  ),
                ],
              ),
            ),
            onPressed: () {
              gameRef.reset(); // Reinicia o estado do jogo
              gameRef.overlays.remove(
                'GameOverMenu',
              ); // Remove a tela de Game Over
              gameRef.overlays.add(
                'WelcomeMenu',
              ); // Adiciona a tela de boas-vindas
            },
          ),
        ],
      ),
    );
  }
}
