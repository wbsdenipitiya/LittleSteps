import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/network/supabase_service.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/services/speech_service.dart';
import '../../ui_engine/age_adaptive_controller.dart';

class MoodCheckIn extends ConsumerStatefulWidget {
  const MoodCheckIn({super.key});

  @override
  ConsumerState<MoodCheckIn> createState() => _MoodCheckInState();
}

class _MoodCheckInState extends ConsumerState<MoodCheckIn> {
  String? _selectedMood;
  bool _isProcessing = false;

  final Map<String, dynamic> _moods = {
    'Happy': {'icon': Icons.sentiment_very_satisfied_rounded, 'color': AppColors.seafoam, 'desc': 'Feeling Bright!', 'voice': 'I am so glad you are happy today!'},
    'Sad': {'icon': Icons.sentiment_dissatisfied_rounded, 'color': AppColors.azure, 'desc': 'Need a Hug?', 'voice': 'It is okay to feel sad. I am Lisa, and I am here for you.'},
    'Grumpy': {'icon': Icons.sentiment_very_dissatisfied_rounded, 'color': AppColors.coral, 'desc': 'Rough Day?', 'voice': 'Feeling a bit grumpy? Let us take a deep breath.'},
    'Sleepy': {'icon': Icons.bed_rounded, 'color': Colors.deepPurpleAccent, 'desc': 'Nap Time!', 'voice': 'Time for a little rest. Lisa wishes you sweet dreams!'},
  };

  Future<void> _recordMood(String mood) async {
    if (_isProcessing || !mounted) return;
    
    setState(() {
      _isProcessing = true;
      _selectedMood = mood;
    });

    // Lisa speaks a comforting message (Ultra-Slow & Soft)
    await speechService.speak(_moods[mood]!['voice']);

    final uiState = ref.read(uiProvider);
    final childId = uiState.activeChildId;

    if (childId != null) {
      try {
        await SupabaseService().recordMilestone(
          childId: childId,
          milestoneType: 'Mood: $mood',
          score: 10,
          metadata: {'mood': mood},
        );
      } catch (_) {}
    }

    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: Text("How I Feel Today", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedMood == null) ...[
              FadeInDown(
                child: Text(
                  "Choose a face!",
                  style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w900, color: AppColors.textMain),
                ),
              ),
              SizedBox(height: 48.h),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemCount: _moods.length,
                itemBuilder: (context, index) {
                  final key = _moods.keys.elementAt(index);
                  final data = _moods[key]!;
                  return _buildMoodCard(key, data['icon'], data['color']);
                },
              ),
            ] else ...[
              ZoomIn(
                child: Column(
                  children: [
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      child: Icon(_moods[_selectedMood]!['icon'], size: 120.sp, color: _moods[_selectedMood]!['color']),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      _moods[_selectedMood]!['desc'],
                      style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900, color: AppColors.textMain),
                    ),
                    SizedBox(height: 16.h),
                    ElasticIn(
                      child: Icon(Icons.stars_rounded, color: Colors.amber, size: 40.sp),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(String label, IconData icon, Color color) {
    return FadeInUp(
      delay: Duration(milliseconds: 100 * label.length),
      child: GestureDetector(
        onTap: () {
          soundService.playTap();
          _recordMood(label);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50.sp, color: color),
              SizedBox(height: 10.h),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain, fontSize: 18.sp)),
            ],
          ),
        ),
      ),
    );
  }
}
