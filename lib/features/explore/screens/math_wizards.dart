import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/speech_service.dart';
import '../../../core/services/sound_service.dart';

class MathWizards extends StatefulWidget {
  const MathWizards({super.key});

  @override
  State<MathWizards> createState() => _MathWizardsState();
}

class _MathWizardsState extends State<MathWizards> {
  int _currentCount = 0;

  void _speakCount() {
    soundService.playTap();
    speechService.speak("$_currentCount");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text("Math Wizards", style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: Text(
                _currentCount == 0 ? "Tap to Start Counting!" : "Great! Keep Tapping!", 
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: AppColors.textMain),
              ),
            ),
            SizedBox(height: 40.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentCount = (_currentCount % 10) + 1;
                });
                _speakCount();
              },
              child: ZoomIn(
                key: ValueKey(_currentCount),
                child: Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    color: AppColors.coral,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.coral.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 10)],
                  ),
                  child: Center(
                    child: Text(
                      _currentCount.toString(),
                      style: TextStyle(fontSize: 100.sp, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: List.generate(_currentCount, (index) => FadeIn(
                delay: Duration(milliseconds: index * 100),
                child: Text("⭐", style: TextStyle(fontSize: 30.sp)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
