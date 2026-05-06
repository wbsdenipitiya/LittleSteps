import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/speech_service.dart';
import '../../../core/services/sound_service.dart';

class AlphabetLab extends StatefulWidget {
  const AlphabetLab({super.key});

  @override
  State<AlphabetLab> createState() => _AlphabetLabState();
}

class _AlphabetLabState extends State<AlphabetLab> {
  final List<Map<String, String>> _alphabet = [
    {'letter': 'A', 'word': 'Apple', 'icon': '🍎'},
    {'letter': 'B', 'word': 'Bus', 'icon': '🚌'},
    {'letter': 'C', 'word': 'Cat', 'icon': '🐱'},
    {'letter': 'D', 'word': 'Dog', 'icon': '🐶'},
    {'letter': 'E', 'word': 'Elephant', 'icon': '🐘'},
    {'letter': 'F', 'word': 'Fish', 'icon': '🐟'},
    {'letter': 'G', 'word': 'Giraffe', 'icon': '🦒'},
    {'letter': 'H', 'word': 'House', 'icon': '🏠'},
    {'letter': 'I', 'word': 'Ice cream', 'icon': '🍦'},
    {'letter': 'J', 'word': 'Jar', 'icon': '🫙'},
    {'letter': 'K', 'word': 'Kite', 'icon': '🪁'},
    {'letter': 'L', 'word': 'Lion', 'icon': '🦁'},
    {'letter': 'M', 'word': 'Monkey', 'icon': '🐒'},
    {'letter': 'N', 'word': 'Nest', 'icon': '🪺'},
    {'letter': 'O', 'word': 'Owl', 'icon': '🦉'},
    {'letter': 'P', 'word': 'Parrot', 'icon': '🦜'},
    {'letter': 'Q', 'word': 'Queen', 'icon': '👸'},
    {'letter': 'R', 'word': 'Rabbit', 'icon': '🐇'},
    {'letter': 'S', 'word': 'Sun', 'icon': '☀️'},
    {'letter': 'T', 'word': 'Tiger', 'icon': '🐅'},
    {'letter': 'U', 'word': 'Umbrella', 'icon': '☂️'},
    {'letter': 'V', 'word': 'Violin', 'icon': '🎻'},
    {'letter': 'W', 'word': 'Whale', 'icon': '🐋'},
    {'letter': 'X', 'word': 'Xylophone', 'icon': '🎹'},
    {'letter': 'Y', 'word': 'Yo-yo', 'icon': '🪀'},
    {'letter': 'Z', 'word': 'Zebra', 'icon': '🦓'},
  ];

  void _onLetterTap(Map<String, String> item) {
    soundService.playTap();
    speechService.speak("${item['letter']} is for ${item['word']}");
    
    showDialog(
      context: context,
      builder: (context) => FadeInUp(
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item['icon']!, style: TextStyle(fontSize: 100.sp)),
              SizedBox(height: 20.h),
              Text(
                "${item['letter']} is for ${item['word']}", 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: AppColors.textMain),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text("Alphabet Lab", style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(24.r),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 15.r,
          crossAxisSpacing: 15.r,
        ),
        itemCount: _alphabet.length,
        itemBuilder: (context, index) {
          final item = _alphabet[index];
          return FadeInDown(
            delay: Duration(milliseconds: index * 20),
            child: GestureDetector(
              onTap: () => _onLetterTap(item),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Center(
                  child: Text(
                    item['letter']!, 
                    style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900, color: AppColors.azure),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
