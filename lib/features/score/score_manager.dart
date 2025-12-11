import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager extends ChangeNotifier {
  // Singleton instance
  static final ScoreManager _instance = ScoreManager._internal();

  factory ScoreManager() {
    return _instance;
  }

  ScoreManager._internal();

  int _score = 0;
  int _highScore = 0;

  int get score => _score;
  int get highScore => _highScore;

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt('highScore') ?? 0;
    notifyListeners();
  }

  void resetScore() {
    _score = 0;
    notifyListeners();
  }

  void incrementScore() {
    _score += 1;
    _checkHighScore();
    notifyListeners();
  }

  Future<void> _checkHighScore() async {
    if (_score > _highScore) {
      _highScore = _score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highScore', _highScore);
      // We don't notify listeners here strictly for highScore update as incrementScore already does,
      // but if UI depends specifically on highScore changes it might be needed.
      // Since incrementScore calls notifyListeners, the UI will rebuild and see the new high score.
    }
  }
}
