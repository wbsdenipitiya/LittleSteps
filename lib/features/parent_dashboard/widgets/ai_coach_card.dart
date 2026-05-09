import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/ai_service.dart';
import '../../ui_engine/age_adaptive_controller.dart';

class AiCoachCard extends ConsumerWidget {
  const AiCoachCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(uiProvider);
    final childId = uiState.activeChildId;

    if (childId == null) return const SizedBox();

    return FutureBuilder<Map<String, String>>(
      future: aiService.getParentInsight(childId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final insight = snapshot.data!;

        return FadeInUp(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 10))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                    SizedBox(width: 10.w),
                    Text(
                      insight['title']!,
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  insight['content']!,
                  style: TextStyle(fontSize: 14.sp, color: Colors.white.withValues(alpha: 0.9), height: 1.5),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => _showAdviceDialog(context, insight['title']!, insight['content']!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2575FC),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                  ),
                  child: const Text("View Expert Advice"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAdviceDialog(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 400.h,
        padding: EdgeInsets.all(32.r),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Expert Guidance", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.azure)),
            SizedBox(height: 8.h),
            Text(title, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: AppColors.textMain)),
            SizedBox(height: 24.h),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "$content\n\nLisa Analysis: Your child is progressing at a healthy rate. Continued exposure to this specific curriculum will reinforce neural pathways associated with $title.",
                  style: TextStyle(fontSize: 15.sp, color: AppColors.textSecondary, height: 1.6),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.azure, foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(context),
                child: const Text("Thank You, Lisa"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
