import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  // Singleton instance
  static final AudioManager _instance = AudioManager._internal();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  final AudioPlayer _bgPlayer = AudioPlayer();
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  Future<void> init() async {
    _bgPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playBackgroundMusic() async {
    if (_isMuted) return;
    await _bgPlayer.play(
      AssetSource('audio/background_music.wav'),
      volume: 0.3,
    );
  }

  Future<void> pauseBackgroundMusic() async {
    await _bgPlayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    if (_isMuted) return;
    await _bgPlayer.resume();
  }

  Future<void> stopBackgroundMusic() async {
    await _bgPlayer.stop();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      pauseBackgroundMusic();
    } else {
      resumeBackgroundMusic();
    }
  }
}
