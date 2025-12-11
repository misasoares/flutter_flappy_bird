import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  // Singleton instance
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  final AudioPlayer _bgPlayer = AudioPlayer();

  Future<void> init() async {
    _bgPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playBackgroundMusic() async {
    await _bgPlayer.play(
      AssetSource('audio/background_music.wav'),
      volume: 0.3,
    );
  }

  Future<void> pauseBackgroundMusic() async {
    await _bgPlayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    await _bgPlayer.resume();
  }

  Future<void> stopBackgroundMusic() async {
    await _bgPlayer.stop();
  }
}
