import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  bool _isPlaying = false;

  // Play background music
  Future<void> playBackgroundMusic() async {
    if (_isPlaying) return;
    
    try {
      _isPlaying = true;
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundPlayer.play(AssetSource('sounds/background.wav'));
    } catch (e) {
      if (kDebugMode) {
        print('Background music error: $e');
      }
    }
  }

  // Sound effects removed - only background music is used

  // Stop all sounds
  Future<void> stopAll() async {
    _isPlaying = false;
    await _backgroundPlayer.stop();
  }

  // Dispose resources
  void dispose() {
    _isPlaying = false;
    _backgroundPlayer.dispose();
  }
}
