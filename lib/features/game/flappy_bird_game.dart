import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../features/audio/audio_manager.dart';
import '../../features/background/background_component.dart';
import '../../features/bird/bird_component.dart';
import '../../features/pipe/pipe_component.dart';
import '../../features/pipe/pipe_manager.dart';
import '../../features/score/score_manager.dart';

class FlappyBirdGame extends FlameGame
    with TapDetector, WidgetsBindingObserver {
  late Bird bird;
  Pipe? topPipe;
  Pipe? bottomPipe;
  bool isGameStarted = false;
  double gravity = 900.0;
  double velocity = 0.0;

  // Score is now managed by ScoreManager, but we keep a local reference to update UI text event if needed
  // actually we can just read from ScoreManager.
  // But for optimization, we might keep local cache? No, reading getter is fast.

  double gap = 70.0;
  double pipeSpeed = 100.0;
  bool hasScored = false;
  late TextComponent scoreText;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    WidgetsBinding.instance.addObserver(this);

    // Initialize Managers
    await AudioManager().init(); // Ensure init
    await AudioManager().playBackgroundMusic();
    await ScoreManager().loadHighScore();

    // Add Background
    add(Background());

    // Add Bird
    bird = Bird();
    add(bird);

    createPipes();

    // Score Text
    scoreText = TextComponent(
      text: 'Pontuação: ${ScoreManager().score}',
      position: Vector2(10, 30),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: const TextStyle(
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

    pauseEngine();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      AudioManager().pauseBackgroundMusic();
      if (isGameStarted) {
        pauseEngine();
      }
    } else if (state == AppLifecycleState.resumed) {
      AudioManager().resumeBackgroundMusic();
      if (isGameStarted) {
        resumeEngine();
      }
    }
  }

  void updateScoreText() {
    scoreText.text = 'Pontuação: ${ScoreManager().score}';
  }

  void createPipes() {
    double pipeGap = bird.size.y + gap;
    double centralMinHeight = size.y * 0.2;
    double centralMaxHeight = size.y * 0.8;

    double minPipeHeight = centralMinHeight;
    double maxPipeHeight = centralMaxHeight - pipeGap;

    double topPipeHeight;
    if (topPipe == null) {
      topPipeHeight =
          Random().nextDouble() * (maxPipeHeight - minPipeHeight) +
          minPipeHeight;
    } else {
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

    // Use PipeFactory
    topPipe = PipeFactory().createPipe(true, topPipeHeight); // inverted
    topPipe!.position = Vector2(size.x, 0);
    if (topPipe!.isInverted) {
      topPipe!.y += topPipeHeight;
    }

    bottomPipe = PipeFactory().createPipe(false, bottomPipeHeight); // normal
    bottomPipe!.position = Vector2(size.x, topPipeHeight + pipeGap);

    add(topPipe!);
    add(bottomPipe!);

    hasScored = false;
  }

  void updatePipeSpeed() {
    int score = ScoreManager().score;
    if (score < 10) {
      if (score % 2 == 0) {
        pipeSpeed = 100.0 + (score * 15.0);
      }
    } else if (score < 20) {
      if (score % 3 == 0) {
        pipeSpeed = 100.0 + (score * 15.0);
      }
    } else {
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

      if (topPipe != null && bottomPipe != null) {
        topPipe!.x -= pipeSpeed * dt;
        bottomPipe!.x -= pipeSpeed * dt;

        // Score logic
        if (!hasScored && topPipe!.x + topPipe!.width < bird.x) {
          ScoreManager().incrementScore();
          hasScored = true;
          updateScoreText();
          updatePipeSpeed();
        }

        // Remove and recycle pipes
        if (topPipe!.x < -topPipe!.width) {
          remove(topPipe!);
          remove(bottomPipe!);

          // Return to pool
          PipeFactory().returnPipe(topPipe!);
          PipeFactory().returnPipe(bottomPipe!);

          createPipes();
        }

        // Collision logic
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
    await AudioManager().stopBackgroundMusic();
    super.onDetach();
  }

  void gameOver() {
    pauseEngine();
    isGameStarted = false;
    // High score is auto-checked in ScoreManager.incrementScore, but to be safe/explicit if needed:
    // ScoreManager().checkHighScore(); (private in manager, effectively done)

    overlays.add('GameOverMenu');
    remove(scoreText);
  }

  void reset() {
    remove(bird);
    if (topPipe != null) {
      remove(topPipe!);
      PipeFactory().returnPipe(topPipe!);
    }
    if (bottomPipe != null) {
      remove(bottomPipe!);
      PipeFactory().returnPipe(bottomPipe!);
    }

    isGameStarted = false;
    velocity = 0.0;
    ScoreManager().resetScore();
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

  // Getter for score to support legacy Menu access if they use gameRef.score
  // Ideally Menus should use ScoreManager directly.
  int get score => ScoreManager().score;
}
