import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/mesh_background.dart';
import '../../../core/services/sound_service.dart';
import '../../mood/screens/mood_checkin.dart';
import '../../explore/screens/game_hub.dart';
import '../../safety/widgets/story_library.dart';
import '../../safety/widgets/safety_library.dart';
import '../../parent_dashboard/widgets/security_gate.dart';
import '../age_adaptive_controller.dart';
import '../widgets/mascot_greeting.dart';
import '../widgets/daily_badge_holder.dart';

class ToddlerLayout extends ConsumerWidget {
  const ToddlerLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childId = ref.watch(uiProvider).activeChildId;

    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref),
                const MascotGreeting(),
                SizedBox(height: 10.h),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.r,
                  crossAxisSpacing: 16.r,
                  children: [
                    _buildModuleCard(
                      context,
                      "Safe Zone", 
                      Icons.security_rounded,
                      AppColors.seafoam,
                      () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (c) => const SafetyLibrary()));
                        if (childId != null) ref.invalidate(milestonesProvider(childId));
                      },
                    ),
                    _buildModuleCard(
                      context,
                      "Feelings", 
                      Icons.face_retouching_natural_rounded,
                      AppColors.coral,
                      () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (c) => const MoodCheckIn()));
                        if (childId != null) ref.invalidate(milestonesProvider(childId));
                      },
                    ),
                    _buildModuleCard(
                      context,
                      "Games", 
                      Icons.rocket_launch_rounded,
                      AppColors.azure,
                      () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (c) => const GameHub()));
                        if (childId != null) ref.invalidate(milestonesProvider(childId));
                      },
                    ),
                    _buildModuleCard(
                      context,
                      "My Books", 
                      Icons.menu_book_rounded,
                      Colors.orangeAccent,
                      () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (c) => const StoryLibrary()));
                        if (childId != null) ref.invalidate(milestonesProvider(childId));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                const DailyBadgeHolder(),
                SizedBox(height: 24.h),
              ],
            ),
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
                Text("Welcome Kiddo!", style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900, color: AppColors.textMain)),
                Text("Let's play and learn today.", style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          FadeInRight(
            child: GestureDetector(
              onLongPress: () {
                soundService.playTap();
                _showSecurityGate(context, ref);
              },
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
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
            color: color,
            borderRadius: BorderRadius.circular(40.r),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60.sp, color: Colors.white),
              SizedBox(height: 12.h),
              Text(
                title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
