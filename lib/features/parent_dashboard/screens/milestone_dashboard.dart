import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/floating_card.dart';
import '../../../core/widgets/mesh_background.dart';
import '../../../core/network/supabase_service.dart';
import '../../ui_engine/age_adaptive_controller.dart';
import '../widgets/ai_coach_card.dart';

class MilestoneDashboard extends ConsumerWidget {
  const MilestoneDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(uiProvider);
    final uiNotifier = ref.read(uiProvider.notifier);
    final supabase = SupabaseService();

    return Scaffold(
      body: MeshBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 120.h,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Command Hub", 
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textMain),
                ),
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 24.w, bottom: 16.h),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: AppColors.textMain),
                  onPressed: () => supabase.signOut(),
                ),
              ],
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: const AiCoachCard(), 
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.all(24.r),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildGlassSection(
                    context,
                    title: "Active Mode",
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildLevelOption("Toddler", AgeLevel.toddler, ref),
                            _buildLevelOption("Explorer", AgeLevel.explorer, ref),
                            _buildLevelOption("Preschool", AgeLevel.preschool, ref),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.azure,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                            ),
                            onPressed: () => uiNotifier.toggleParentMode(false),
                            icon: const Icon(Icons.child_care_rounded),
                            label: const Text("Return to Child Play", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // REPLACED RADAR WITH GROWTH BARS
                  _buildGlassSection(
                    context,
                    title: "Growth Summary",
                    child: Column(
                      children: [
                        _buildGrowthBar("Cognitive", 0.85, AppColors.azure),
                        _buildGrowthBar("Safety", 0.70, AppColors.seafoam),
                        _buildGrowthBar("Social", 0.60, AppColors.coral),
                        _buildGrowthBar("Motor", 0.90, Colors.purpleAccent),
                        SizedBox(height: 8.h),
                        Text(
                          "Lisa's Insight: Concentration is peak today!", 
                          style: TextStyle(fontSize: 12.sp, fontStyle: FontStyle.italic, color: AppColors.textSecondary)
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),
                  Text(
                    "Recent Progress", 
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textMain),
                  ),
                  SizedBox(height: 16.h),
                  
                  // FIXED STREAM LOADING & FILTERING
                  if (uiState.activeChildId != null)
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: supabase.getMilestonesStream(uiState.activeChildId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(color: AppColors.azure),
                          ));
                        }
                        
                        if (snapshot.hasError) {
                          return Center(child: Text("Syncing with Lisa...", style: TextStyle(color: AppColors.textSecondary)));
                        }

                        final milestones = snapshot.data ?? [];
                        if (milestones.isEmpty) {
                          return Center(child: Padding(
                            padding: EdgeInsets.all(40.r),
                            child: Column(
                              children: [
                                Icon(Icons.history_rounded, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.3)),
                                SizedBox(height: 10.h),
                                Text("No activity recorded today.", style: TextStyle(color: AppColors.textSecondary)),
                              ],
                            ),
                          ));
                        }
                        
                        return Column(
                          children: milestones.take(15).map((m) => _buildMilestoneCard(context, m)).toList(),
                        );
                      },
                    )
                  else
                    const Center(child: Text("Preparing child profile...")),

                  SizedBox(height: 80.h), // Footer space
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthBar(String label, double value, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: AppColors.textMain)),
              Text("${(value * 100).toInt()}%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: color)),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: color.withValues(alpha: 0.1),
              color: color,
              minHeight: 8.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassSection(BuildContext context, {required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textMain)),
        SizedBox(height: 12.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(32.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelOption(String label, AgeLevel level, WidgetRef ref) {
    final currentLevel = ref.watch(uiProvider).level;
    final isSelected = currentLevel == level;

    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.textMain, fontWeight: FontWeight.bold)),
      selected: isSelected,
      onSelected: (val) {
        if (val) {
          ref.read(uiProvider.notifier).setLevel(level);
          final childId = ref.read(uiProvider).activeChildId;
          if (childId != null) {
            SupabaseService().updateChildLevel(childId, level.name);
          }
        }
      },
      selectedColor: AppColors.azure,
      backgroundColor: Colors.white.withValues(alpha: 0.3),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
    );
  }

  Widget _buildMilestoneCard(BuildContext context, Map<String, dynamic> milestone) {
    final type = milestone['type'] as String;
    final createdAt = DateTime.parse(milestone['created_at'] as String);
    final timeStr = "${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}";

    Color color = AppColors.seafoam;
    IconData icon = Icons.check_circle_rounded;

    if (type.contains('Mood')) {
      color = AppColors.coral;
      icon = Icons.face_retouching_natural_rounded;
    } else if (type.contains('Story')) {
      color = AppColors.azure;
      icon = Icons.menu_book_rounded;
    }

    return FadeInRight(
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: FloatingCard(
          color: Colors.white.withValues(alpha: 0.9),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            onTap: () => _showMilestoneDetail(context, milestone),
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1), 
              child: Icon(icon, color: color),
            ),
            title: Text(
              type, 
              style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textMain, fontSize: 16.sp),
            ),
            subtitle: Text(
              "Achieved at $timeStr", 
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
            ),
            trailing: const Icon(Icons.info_outline_rounded, color: AppColors.azure),
          ),
        ),
      ),
    );
  }

  void _showMilestoneDetail(BuildContext context, Map<String, dynamic> milestone) {
    final type = milestone['type'] as String;
    final metadata = milestone['metadata'] as Map<String, dynamic>? ?? {};

    showDialog(
      context: context,
      builder: (context) => FadeInUp(
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
          title: Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Lisa's Professional Insight:", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.azure)),
              SizedBox(height: 8.h),
              Text(_getLisaInsight(type, metadata)),
              SizedBox(height: 20.h),
              if (metadata.isNotEmpty) ...[
                const Text("Data Points:", style: TextStyle(fontWeight: FontWeight.bold)),
                ...metadata.entries.map((e) => Text("• ${e.key}: ${e.value}")),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
          ],
        ),
      ),
    );
  }

  String _getLisaInsight(String type, Map<String, dynamic> metadata) {
    if (type.contains('Mood')) {
      return "Your child explored their emotions today. This helps build self-awareness and emotional intelligence.";
    }
    if (type.contains('Safety')) {
      return "This milestone shows your child is learning critical boundaries. They are becoming a 'Safe Hero'!";
    }
    if (type.contains('Game')) {
      return "Fantastic cognitive focus! Matching exercises like this improve short-term memory and pattern recognition.";
    }
    return "Great progress! Every click in LittleSteps is a step toward developmental mastery.";
  }
}
