import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  // Play background music (using system sounds for now)
  Future<void> playBackgroundMusic() async {
    if (_isPlaying) return;
    
    try {
      // For now, we'll use a simple beep pattern as background
      // In a real app, you'd load an actual music file
      _isPlaying = true;
      _playBeepPattern();
    } catch (e) {
      // Silently handle audio errors
    }
  }

  void _playBeepPattern() {
    if (!_isPlaying) return;
    
    // Play a low-frequency beep for spooky atmosphere
    _audioPlayer.play(AssetSource('sounds/background.wav')).catchError((e) {
      // If no sound file, just continue silently
    });
    
    // Schedule next beep
    Future.delayed(const Duration(seconds: 3), () {
      if (_isPlaying) {
        _playBeepPattern();
      }
    });
  }

  // Play jump scare sound
  Future<void> playJumpScare() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/jump_scare.wav'));
    } catch (e) {
      // If no sound file, continue silently
    }
  }

  // Play success sound
  Future<void> playSuccess() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/success.wav'));
    } catch (e) {
      // If no sound file, continue silently
    }
  }

  // Play trap sound
  Future<void> playTrap() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/trap.wav'));
    } catch (e) {
      // If no sound file, continue silently
    }
  }

  // Stop all sounds
  Future<void> stopAll() async {
    _isPlaying = false;
    await _audioPlayer.stop();
  }

  // Dispose resources
  void dispose() {
    _isPlaying = false;
    _audioPlayer.dispose();
  }
}
