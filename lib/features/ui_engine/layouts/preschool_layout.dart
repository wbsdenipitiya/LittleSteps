import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/mesh_background.dart';
import '../../../core/services/sound_service.dart';
import '../../mood/screens/mood_checkin.dart';
import '../../explore/screens/alphabet_lab.dart';
import '../../explore/screens/math_wizards.dart';
import '../../safety/widgets/safety_library.dart';
import '../../parent_dashboard/widgets/security_gate.dart';
import '../age_adaptive_controller.dart';
import '../widgets/mascot_greeting.dart';
import '../widgets/daily_badge_holder.dart';

class PreschoolLayout extends ConsumerWidget {
  const PreschoolLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref),
              const MascotGreeting(),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  "Logic & Letters", 
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: AppColors.textMain),
                ),
              ),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(24.r),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.r,
                  crossAxisSpacing: 20.r,
                  children: [
                    _buildModuleCard(
                      context,
                      "Alphabet Lab", 
                      Icons.font_download_rounded,
                      AppColors.azure,
                      () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AlphabetLab())),
                    ),
                    _buildModuleCard(
                      context,
                      "Math Wizards", 
                      Icons.calculate_rounded,
                      AppColors.coral,
                      () => Navigator.push(context, MaterialPageRoute(builder: (c) => const MathWizards())),
                    ),
                    _buildModuleCard(
                      context,
                      "Safe Hero", 
                      Icons.shield_rounded,
                      AppColors.seafoam,
                      () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SafetyLibrary())),
                    ),
                    _buildModuleCard(
                      context,
                      "Mood Check", 
                      Icons.emoji_emotions_rounded,
                      Colors.orangeAccent,
                      () => Navigator.push(context, MaterialPageRoute(builder: (c) => const MoodCheckIn())),
                    ),
                  ],
                ),
              ),
              const DailyBadgeHolder(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeInLeft(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hello Scholar!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.textMain)),
                const Text("Ready for advanced fun?", style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              ],
            ),
          ),
          FadeInRight(
            child: GestureDetector(
              onLongPress: () => _showSecurityGate(context, ref),
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                child: const Icon(Icons.settings_rounded, color: AppColors.textMain),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSecurityGate(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SecurityGate(
        onAuthenticated: () {
          Navigator.pop(context);
          ref.read(uiProvider.notifier).toggleParentMode(true);
        },
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          soundService.playTap();
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Icon(icon, size: 40.sp, color: color),
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textMain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
