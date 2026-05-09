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

class ExplorerLayout extends ConsumerWidget {
  const ExplorerLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childId = ref.watch(uiProvider).activeChildId;

    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref),
              const MascotGreeting(),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                  children: [
                    _buildBigCard(
                      context,
                      "My Books", 
                      "Stories from around the world!",
                      Icons.menu_book_rounded,
                      AppColors.azure,
                      () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (c) => const StoryLibrary()));
                        if (childId != null) ref.invalidate(milestonesProvider(childId));
                      },
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSmallCard(
                            context,
                            "Feelings", 
                            Icons.face_retouching_natural_rounded,
                            AppColors.coral,
                            () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (c) => const MoodCheckIn()));
                              if (childId != null) ref.invalidate(milestonesProvider(childId));
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildSmallCard(
                            context,
                            "Fun Games", 
                            Icons.rocket_launch_rounded,
                            AppColors.seafoam,
                            () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (c) => const GameHub()));
                              if (childId != null) ref.invalidate(milestonesProvider(childId));
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildBigCard(
                      context,
                      "Safe Zone", 
                      "Learn the rules of the road!",
                      Icons.shield_rounded,
                      Colors.orangeAccent,
                      () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (c) => const SafetyLibrary()));
                        if (childId != null) ref.invalidate(milestonesProvider(childId));
                      },
                    ),
                    SizedBox(height: 24.h),
                    const DailyBadgeHolder(),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeInLeft(
            child: Text("Welcome Kiddo!", style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900, color: AppColors.textMain)),
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

  Widget _buildBigCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          soundService.playTap();
          onTap();
        },
        child: Container(
          width: double.infinity,
          height: 120.h,
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(40.r),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: [
              Icon(icon, size: 50.sp, color: Colors.white),
              SizedBox(width: 24.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text(subtitle, style: TextStyle(fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.9))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          soundService.playTap();
          onTap();
        },
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(40.r),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40.sp, color: Colors.white),
              SizedBox(height: 12.h),
              Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
