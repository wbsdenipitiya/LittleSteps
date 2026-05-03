import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();

  // --- UI SOUNDS (High-Quality Expert Assets) ---
  
  Future<void> playTap() async {
    // Light haptic for every tap
    HapticFeedback.lightImpact();
    await _player.play(UrlSource('https://assets.mixkit.co/active_storage/sfx/2571/2571-preview.mp3'));
  }

  Future<void> playSuccess() async {
    // Stronger haptic for success
    HapticFeedback.mediumImpact();
    await _player.play(UrlSource('https://assets.mixkit.co/active_storage/sfx/2013/2013-preview.mp3'));
  }

  Future<void> playCardFlip() async {
    HapticFeedback.selectionClick();
    await _player.play(UrlSource('https://assets.mixkit.co/active_storage/sfx/211/211-preview.mp3'));
  }

  Future<void> playMood(String mood) async {
    HapticFeedback.mediumImpact();
    String url = 'https://assets.mixkit.co/active_storage/sfx/2013/2013-preview.mp3'; // Happy
    switch (mood.toLowerCase()) {
      case 'sad': 
        url = 'https://assets.mixkit.co/active_storage/sfx/127/127-preview.mp3'; 
        break;
      case 'grumpy': 
        // Improved high-quality comical huff for kids
        url = 'https://assets.mixkit.co/active_storage/sfx/2802/2802-preview.mp3'; 
        break;
      case 'sleepy': 
        url = 'https://assets.mixkit.co/active_storage/sfx/1888/1888-preview.mp3'; 
        break;
    }
    await _player.play(UrlSource(url));
  }
}
final soundService = SoundService();
