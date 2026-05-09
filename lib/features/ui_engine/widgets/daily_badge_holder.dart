import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/supabase_service.dart';
import '../age_adaptive_controller.dart';

class DailyBadgeHolder extends ConsumerWidget {
  const DailyBadgeHolder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(uiProvider);
    final childId = uiState.activeChildId;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Trophies", 
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textMain),
          ),
          SizedBox(height: 12.h),
          if (childId == null)
            _buildPlaceholderCard(isLoading: true)
          else
            ref.watch(milestonesProvider(childId)).when(
              loading: () => _buildPlaceholderCard(isLoading: true),
              error: (err, stack) => _buildPlaceholderCard(isLoading: false),
              data: (milestones) {
                // Filter for today's activity only, translating UTC timestamps to local device timezone
                final todayMilestones = milestones.where((m) {
                  try {
                    final createdAtStr = m['created_at'] as String;
                    final createdAt = DateTime.parse(createdAtStr).toLocal();
                    final nowLocal = DateTime.now();
                    return createdAt.year == nowLocal.year &&
                        createdAt.month == nowLocal.month &&
                        createdAt.day == nowLocal.day;
                  } catch (_) {
                    return false;
                  }
                }).toList();
                
                final hasActivity = todayMilestones.isNotEmpty;
                
                return _buildTrophyCard(hasActivity, todayMilestones.length);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderCard({required bool isLoading}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(Icons.stars_rounded, color: Colors.grey.withValues(alpha: 0.2), size: 50.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoading ? "Loading Badges..." : "Start Learning!",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textMain),
                ),
                Text(
                  isLoading ? "Checking your active dashboard progress..." : "Complete a book or game to earn a trophy.",
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrophyCard(bool hasActivity, int count) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          if (hasActivity)
            ElasticIn(
              child: Icon(Icons.stars_rounded, color: Colors.amber, size: 50.sp),
            )
          else
            Icon(Icons.stars_rounded, color: Colors.grey.withValues(alpha: 0.2), size: 50.sp),
          
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasActivity ? "Daily Champion!" : "Start Learning!",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textMain),
                ),
                Text(
                  hasActivity 
                    ? "You earned $count ${count == 1 ? 'trophy' : 'trophies'} today." 
                    : "Complete a book or game to earn a trophy.",
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
