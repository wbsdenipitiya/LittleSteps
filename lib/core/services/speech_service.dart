import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;
import '../../features/ui_engine/age_adaptive_controller.dart';

class SpeechService with WidgetsBindingObserver {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;

  SpeechService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isStopping = false;

  Future<void> _init({AgeLevel level = AgeLevel.toddler}) async {
    if (_isInitialized) {
      // Potentially update rate if level changed
      await _updateRate(level);
      return;
    }
    
    await _tts.setLanguage("en-US");
    await _updateRate(level);
    await _tts.setPitch(1.05); 
    await _tts.setVolume(1.0);

    try {
      if (Platform.isAndroid) {
        await _tts.setVoice({"name": "en-us-x-sfg-network", "locale": "en-US"});
      } else {
        await _tts.setVoice({"name": "Samantha", "locale": "en-US"});
      }
    } catch (_) {}
    
    _isInitialized = true;
  }

  Future<void> _updateRate(AgeLevel level) async {
    double rate = 0.30; // Toddler (Slowest)
    if (level == AgeLevel.explorer) rate = 0.40;
    if (level == AgeLevel.preschool) rate = 0.50; // Preschool (Faster)
    
    // Platform adjustment
    if (!Platform.isAndroid) {
      rate = rate * 0.9; 
    }
    
    await _tts.setSpeechRate(rate);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _isStopping = true;
      _tts.stop();
    } else {
      _isStopping = false;
    }
  }

  Future<void> speak(String text, {AgeLevel level = AgeLevel.toddler}) async {
    if (_isStopping) return;
    await _init(level: level);
    await _tts.stop(); 
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> readStoryPage(String text, {AgeLevel level = AgeLevel.toddler}) async {
    if (_isStopping) return;
    await _init(level: level);
    await _tts.stop();
    
    final sentences = text.split(RegExp(r'(?<=[.!?])\s+'));
    for (final sentence in sentences) {
      if (_isStopping) break;
      await _tts.speak(sentence);
      await Future.delayed(const Duration(milliseconds: 1200)); 
    }
  }
}

final speechService = SpeechService();
