import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/speech_service.dart';
import '../../ui_engine/age_adaptive_controller.dart';

class MascotGreeting extends ConsumerStatefulWidget {
  const MascotGreeting({super.key});

  @override
  ConsumerState<MascotGreeting> createState() => _MascotGreetingState();
}

class _MascotGreetingState extends ConsumerState<MascotGreeting> {
  @override
  void initState() {
    super.initState();
    // Lisa checks mode after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndSpeak();
    });
  }

  void _checkAndSpeak() {
    final uiState = ref.read(uiProvider);
    if (!uiState.isParentMode && !uiState.hasGreeted) {
      _speakGreeting();
      ref.read(uiProvider.notifier).markGreeted();
    }
  }

  void _speakGreeting() {
    speechService.speak("Hi! I'm Lisa. Let's learn and play together!");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // The Mascot "Lisa"
          FadeInLeft(
            child: GestureDetector(
              onTap: _speakGreeting, // Re-speak on tap
              child: SizedBox(
                width: 80.w,
                height: 80.w,
                child: Lottie.network(
                  'https://assets9.lottiefiles.com/packages/lf20_myejioos.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          // Speech Bubble
          Expanded(
            child: FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.r),
                    topRight: Radius.circular(25.r),
                    bottomRight: Radius.circular(25.r),
                    bottomLeft: Radius.circular(5.r),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Text(
                  "Hi! I'm Lisa. Let's learn and play together!",
                  style: TextStyle(
                    fontSize: 14.sp, 
                    fontWeight: FontWeight.w700, 
                    color: AppColors.textMain,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
