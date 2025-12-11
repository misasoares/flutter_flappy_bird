import 'package:flutter/material.dart';
import '../../game/flappy_bird_game.dart';
import '../../score/score_manager.dart';

class WelcomeMenu extends StatefulWidget {
  final FlappyBirdGame gameRef;

  const WelcomeMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  State<WelcomeMenu> createState() => _WelcomeMenuState();
}

class _WelcomeMenuState extends State<WelcomeMenu> {
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    await ScoreManager().loadHighScore();
    setState(() {
      highScore = ScoreManager().highScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Plano de fundo com background.png
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Conteúdo sobreposto ao plano de fundo
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem-vindo ao Flappy Bird',
                style: TextStyle(
                  fontFamily: 'PressStart2P', // Usando a mesma fonte
                  fontSize: 14, // Mesmo tamanho de fonte
                  height: 1.2, // Altura da linha
                  color: Colors.white,
                  letterSpacing: -1, // Mesma cor
                  shadows: [
                    Shadow(
                      blurRadius: 3.0, // Mesma borda desfocada
                      color: Colors.black, // Mesma cor de sombra
                      offset: Offset(1.0, 1.0), // Mesmo deslocamento
                    ),
                  ],
                ),
              ),
              const Text(
                'By MisaTech ✌️😋',
                style: TextStyle(
                  fontFamily: 'PressStart2P', // Usando a mesma fonte
                  fontSize: 10, // Mesmo tamanho de fonte
                  height: 1.8, // Altura da linha
                  color: Colors.white,
                  letterSpacing: -1, // Mesma cor
                  shadows: [
                    Shadow(
                      blurRadius: 3.0, // Mesma borda desfocada
                      color: Colors.black, // Mesma cor de sombra
                      offset: Offset(1.0, 1.0), // Mesmo deslocamento
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Recorde: $highScore',
                style: const TextStyle(
                  fontFamily: 'PressStart2P', // Usando a mesma fonte
                  fontSize: 16, // Mesmo tamanho de fonte
                  height: 1.2, // Altura da linha
                  color: Colors.yellow, // Mesma cor
                  shadows: [
                    Shadow(
                      blurRadius: 3.0, // Mesma borda desfocada
                      color: Color.fromARGB(
                        255,
                        255,
                        15,
                        15,
                      ), // Mesma cor de sombra
                      offset: Offset(1.0, 1.0), // Mesmo deslocamento
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
                    borderRadius: BorderRadius.circular(
                      5,
                    ), // Borda ligeiramente arredondada
                  ),
                  shadowColor: Colors.red, // Cor da sombra
                  elevation: 5, // Elevação do botão
                ),
                child: const Text(
                  'Iniciar Jogo',
                  style: TextStyle(
                    fontFamily: 'PressStart2P', // Fonte pixelada
                    fontSize: 14, // Tamanho da fonte
                    color: Colors.green, // Cor do texto
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
                  widget.gameRef.overlays.remove('WelcomeMenu');
                  widget.gameRef.resumeEngine();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
