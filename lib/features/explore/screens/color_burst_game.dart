import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/services/speech_service.dart';
import '../../ui_engine/age_adaptive_controller.dart';

class ColorBurstGame extends ConsumerStatefulWidget {
  const ColorBurstGame({super.key});

  @override
  ConsumerState<ColorBurstGame> createState() => _ColorBurstGameState();
}

class _ColorBurstGameState extends ConsumerState<ColorBurstGame> {
  final List<Map<String, dynamic>> _colors = [
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Orange', 'color': Colors.orange},
  ];

  late String _targetColorName;
  List<Map<String, dynamic>> _options = [];
  int _score = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  void _startNewRound() {
    final level = ref.read(uiProvider).level;
    int optionCount = level == AgeLevel.toddler ? 2 : 4;
    
    final random = Random();
    _options = List<Map<String, dynamic>>.from(_colors)..shuffle();
    _options = _options.take(optionCount).toList();
    
    final target = _options[random.nextInt(optionCount)];
    setState(() {
      _targetColorName = target['name'];
    });

    // Lisa speaks the color
    speechService.speak("Tap the $_targetColorName color!");
  }

  void _onTap(Map<String, dynamic> tapped) {
    if (tapped['name'] == _targetColorName) {
      soundService.playSuccess();
      setState(() {
        _score++;
      });
      if (_score >= 5) {
        setState(() => _isGameOver = true);
      } else {
        _startNewRound();
      }
    } else {
      soundService.playMood('sad');
      speechService.speak("Not that one. Try again! Find $_targetColorName");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text("Color Burst", style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isGameOver ? _buildWinScreen() : _buildGameScreen(),
    );
  }

  Widget _buildGameScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Score: $_score / 5", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.h),
          Text(
            "Find the $_targetColorName balloon!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w900, color: AppColors.textMain),
          ),
          SizedBox(height: 48.h),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: _options.map((opt) => _buildBalloon(opt)).toList(),
          ),
          SizedBox(height: 40.h),
          IconButton(
            icon: const Icon(Icons.volume_up_rounded, size: 40, color: AppColors.azure),
            onPressed: () => speechService.speak("Tap the $_targetColorName color!"),
          ),
        ],
      ),
    );
  }

  Widget _buildBalloon(Map<String, dynamic> opt) {
    return FadeInUp(
      key: ValueKey(opt['name']),
      child: GestureDetector(
        onTap: () => _onTap(opt),
        child: Container(
          width: 120.w,
          height: 160.h,
          decoration: BoxDecoration(
            color: opt['color'],
            borderRadius: BorderRadius.all(Radius.elliptical(60.w, 80.h)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Center(
            child: Container(
              width: 15.w,
              height: 40.h,
              margin: EdgeInsets.only(top: 100.h),
              color: Colors.white24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWinScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElasticIn(child: Icon(Icons.stars_rounded, color: Colors.amber, size: 100.sp)),
          SizedBox(height: 24.h),
          Text("Amazing!", style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900, color: AppColors.textMain)),
          const Text("You know your colors perfectly!"),
          SizedBox(height: 40.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.azure, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context),
            child: const Text("I'm Done!"),
          ),
        ],
      ),
    );
  }
}
