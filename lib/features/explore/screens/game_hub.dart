import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/sound_service.dart';
import 'cognitive_zone.dart';
import 'color_burst_game.dart';

class GameHub extends StatelessWidget {
  const GameHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text("Games Zone", style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            _buildGameCard(
              context,
              "Memory Hero", 
              "Find the matching items!", 
              Icons.psychology_rounded,
              AppColors.azure,
              () => Navigator.push(context, MaterialPageRoute(builder: (c) => const CognitiveZone())),
            ),
            SizedBox(height: 20.h),
            _buildGameCard(
              context,
              "Color Burst", 
              "Tap the colors Lisa says!", 
              Icons.color_lens_rounded,
              AppColors.coral,
              () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ColorBurstGame())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          soundService.playTap();
          onTap();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20.r)),
                child: Icon(icon, size: 40.sp, color: color),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                    Text(subtitle, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow_rounded, color: AppColors.azure),
            ],
          ),
        ),
      ),
    );
  }
}
