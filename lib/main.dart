import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setPortrait();
  runApp(
    GameWidget(
      game: FlappyBirdGame(),
      overlayBuilderMap: {
        'GameOverMenu': (BuildContext context, FlappyBirdGame game) {
          return GameOverMenu(gameRef: game);
        },
        'WelcomeMenu': (BuildContext context, FlappyBirdGame game) {
          return WelcomeMenu(gameRef: game);
        },
      },
      initialActiveOverlays: [
        'WelcomeMenu',
      ], // Mostra a tela inicial ao iniciar o app
    ),
  );
}

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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
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

class GameOverMenu extends StatelessWidget {
  final FlappyBirdGame gameRef;

  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
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
          SizedBox(height: 10),
          Text(
            'Pontuação: ${gameRef.score}',
            style: TextStyle(
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
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
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

class FlappyBirdGame extends FlameGame
    with TapDetector, WidgetsBindingObserver {
  late Bird bird;
  Pipe? topPipe;
  Pipe? bottomPipe;
  bool isGameStarted = false;
  double gravity = 900.0;
  double velocity = 0.0;
  int score = 0;
  double gap = 70.0;
  double pipeSpeed = 100.0;
  bool hasScored = false;
  late TextComponent scoreText;
  int highScore = 0;

  final AudioPlayer bgPlayer = AudioPlayer();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    WidgetsBinding.instance.addObserver(this);

    // Carregar a música de fundo e colocá-la em loop
    bgPlayer.setReleaseMode(ReleaseMode.loop);
    await bgPlayer.play(
      AssetSource('audio/background_music.wav'),
      volume: 0.3, // Volume moderado para música de fundo
    );

    // Carregar o recorde do dispositivo
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;

    // Carregar e adicionar o background
    final background = Background();
    add(background);

    // Configurações iniciais
    bird = Bird();
    add(bird);

    createPipes();

    // Inicialização do texto de pontuação (não exibido ainda)
    scoreText = TextComponent(
      text: 'Pontuação: $score',
      position: Vector2(10, 30),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(
          fontFamily: 'PressStart2P',
          color: Colors.yellow,
          fontSize: 16,
          height: 1.2,
          shadows: [
            Shadow(
              blurRadius: 3.0,
              color: Color.fromARGB(255, 255, 15, 15),
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
      priority: 10,
    );

    pauseEngine(); // Pausa o jogo, mas mantém o background visível
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      bgPlayer.pause();
      if (isGameStarted) {
        pauseEngine();
      }
    } else if (state == AppLifecycleState.resumed) {
      bgPlayer.resume();
      if (isGameStarted) {
        resumeEngine();
      }
    }
  }

  void updateScoreText() {
    scoreText.text = 'Pontuação: $score';
  }

  void updateHighScore() async {
    if (score > highScore) {
      highScore = score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highScore', highScore);
    }
  }

  void createPipes() {
    // Espaço entre os canos (gap)
    double pipeGap = bird.size.y + gap;

    // Define os limites para a altura central onde os canos serão renderizados
    double centralMinHeight = size.y * 0.2; // 20% do topo
    double centralMaxHeight = size.y * 0.8; // 20% antes do final da tela

    // Altura do próximo cano com base no último
    double minPipeHeight = centralMinHeight;
    double maxPipeHeight = centralMaxHeight - pipeGap;

    // Se for o primeiro par de canos, inicializa aleatoriamente dentro do intervalo
    double topPipeHeight;
    if (topPipe == null) {
      topPipeHeight =
          Random().nextDouble() * (maxPipeHeight - minPipeHeight) +
          minPipeHeight;
    } else {
      // Ajusta o próximo cano baseado no último cano
      double lastPipeCenter = topPipe!.height + pipeGap / 2;
      double minNextHeight = (lastPipeCenter - pipeGap).clamp(
        minPipeHeight,
        maxPipeHeight,
      );
      double maxNextHeight = (lastPipeCenter + pipeGap).clamp(
        minPipeHeight,
        maxPipeHeight,
      );
      topPipeHeight =
          Random().nextDouble() * (maxNextHeight - minNextHeight) +
          minNextHeight;
    }

    double bottomPipeHeight = size.y - topPipeHeight - pipeGap;

    // Renderiza o próximo par de canos
    topPipe = Pipe(isInverted: true, height: topPipeHeight);
    topPipe!.position = Vector2(size.x, 0);

    if (topPipe!.isInverted) {
      topPipe!.y += topPipeHeight;
    }

    bottomPipe = Pipe(isInverted: false, height: bottomPipeHeight);
    bottomPipe!.position = Vector2(size.x, topPipeHeight + pipeGap);

    add(topPipe!);
    add(bottomPipe!);

    hasScored = false;
  }

  void updatePipeSpeed() {
    if (score < 10) {
      if (score % 2 == 0) {
        pipeSpeed = 100.0 + (score * 15.0);
      }
    }

    if (score > 10 && score < 20) {
      if (score % 3 == 0) {
        pipeSpeed = 100.0 + (score * 15.0);
      }
    }

    if (score > 10 && score > 20) {
      if (score % 5 == 0) {
        pipeSpeed = 100.0 + (score * 15.0);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameStarted) {
      velocity += gravity * dt;
      bird.y += velocity * dt;

      // Atualiza posição dos canos, verificando se não são nulos
      if (topPipe != null && bottomPipe != null) {
        topPipe!.x -= pipeSpeed * dt;
        bottomPipe!.x -= pipeSpeed * dt;

        // Verifica se o jogador passou pelos canos
        if (!hasScored && topPipe!.x + topPipe!.width < bird.x) {
          score += 1;
          hasScored = true;
          updateScoreText();

          updatePipeSpeed();
        }

        // Remove e cria novos canos quando saem da tela
        if (topPipe!.x < -topPipe!.width) {
          remove(topPipe!);
          remove(bottomPipe!);
          createPipes();
        }

        // Verifica colisão com os canos
        if (bird.y > size.y - bird.height ||
            bird.getCollisionRect().overlaps(topPipe!.getCollisionRect()) ||
            bird.getCollisionRect().overlaps(bottomPipe!.getCollisionRect())) {
          gameOver();
        }
      }
    }
  }

  @override
  void onTap() {
    if (!isGameStarted) {
      isGameStarted = true;
      velocity = -200;

      add(scoreText);
    } else {
      velocity = -200;
    }
  }

  @override
  Future<void> onDetach() async {
    WidgetsBinding.instance.removeObserver(this);
    await bgPlayer.stop();
    super.onDetach();
  }

  void gameOver() {
    pauseEngine();
    isGameStarted = false;
    updateHighScore();
    overlays.add('GameOverMenu');
    remove(scoreText);
  }

  void reset() {
    remove(bird);
    if (topPipe != null) remove(topPipe!);
    if (bottomPipe != null) remove(bottomPipe!);

    isGameStarted = false;
    velocity = 0.0;
    score = 0;
    updateScoreText();
    hasScored = false;
    pipeSpeed = 100;

    topPipe = null;
    bottomPipe = null;

    bird = Bird();
    add(bird);
    createPipes();

    overlays.add('WelcomeMenu');

    pauseEngine();
  }
}

class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Background() : super(priority: 0);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('background.png');
    size = gameRef.size;
    position = Vector2.zero();
    anchor = Anchor.topLeft;
  }
}

class Bird extends SpriteComponent {
  Bird() {
    width = 50;
    height = 50;
    x = 100;
    y = 300;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bird.png');
  }

  Rect getCollisionRect() {
    return toRect().deflate(5);
  }
}

class Pipe extends SpriteComponent {
  final bool isInverted;

  Pipe({required this.isInverted, required double height}) {
    size = Vector2(60, height);
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('pipe.png');

    if (isInverted) {
      scale.y = -1;
    }
  }

  Rect getCollisionRect() {
    return toRect().deflate(2);
  }
}
