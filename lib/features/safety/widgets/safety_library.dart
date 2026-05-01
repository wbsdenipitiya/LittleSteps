import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/sound_service.dart';
import '../../ui_engine/age_adaptive_controller.dart';
import '../widgets/story_engine.dart';

class SafetyLibrary extends ConsumerWidget {
  const SafetyLibrary({super.key});

  final List<Map<String, dynamic>> _safetyModules = const [
    {
      'title': 'Road Safety with Tuk-Tuks',
      'icon': Icons.traffic_rounded,
      'color': Colors.blue,
      'level': AgeLevel.toddler,
      'pages': [
        {'text': 'Before crossing, hold a big person\'s hand.', 'image': '🤝'},
        {'text': 'Look left, then right, then left again.', 'image': '👀'},
        {'text': 'Wait for the Three-Wheeler to stop completely!', 'image': '🛺'},
      ]
    },
    {
      'title': 'Sparky Plugs (Safety)',
      'icon': Icons.electrical_services_rounded,
      'color': Colors.orange,
      'level': AgeLevel.toddler,
      'pages': [
        {'text': 'Electric plugs are for adults only!', 'image': '🔌'},
        {'text': 'Never put your fingers near the small holes.', 'image': '🛑'},
        {'text': 'Electricity is powerful. Stay safe and play away!', 'image': '⚡'},
      ]
    },
    {
      'title': 'Wash Your Hands',
      'icon': Icons.wash_rounded,
      'color': Colors.cyan,
      'level': AgeLevel.toddler,
      'pages': [
        {'text': 'Wash your hands before you eat a snack.', 'image': '🧼'},
        {'text': 'Scrub with soap while you sing a song.', 'image': '🧼'},
        {'text': 'Now your hands are clean and happy!', 'image': '✨'},
      ]
    },
    {
      'title': 'Gentle with Paws',
      'icon': Icons.pets_rounded,
      'color': Colors.brown,
      'level': AgeLevel.toddler,
      'pages': [
        {'text': 'Street cats and dogs need their space.', 'image': '🐱'},
        {'text': 'Always be gentle and never pull their tails.', 'image': '🐕'},
        {'text': 'Ask a big person before you say hello to a pet.', 'image': '🧡'},
      ]
    },
    {
      'title': 'The Tricky Stranger',
      'icon': Icons.security_rounded,
      'color': Colors.redAccent,
      'level': AgeLevel.explorer,
      'pages': [
        {'text': 'A tricky person asks you to find their puppy.', 'image': '🐶'},
        {'text': 'Run to a safe person and say "NO!" loudly.', 'image': '🏃'},
        {'text': 'You are a smart and safe hero!', 'image': '🦸'},
      ]
    },
    {
      'title': 'Water Safety (The Well)',
      'icon': Icons.waves_rounded,
      'color': Colors.blueAccent,
      'level': AgeLevel.explorer,
      'pages': [
        {'text': 'Ponds and Wells are for looking, not touching.', 'image': '💧'},
        {'text': 'Always keep a safe distance from deep water.', 'image': '🛑'},
        {'text': 'Wait for an adult before you go near!', 'image': '👨‍👩‍👧'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(uiProvider).level;
    
    // Expert logic: Ensure toddlers see at least 4 basic safety modules
    final modules = _safetyModules.where((m) {
      if (level == AgeLevel.toddler) return m['level'] == AgeLevel.toddler;
      return true; 
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text("Safe Zone", style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(24.r),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return FadeInLeft(
            delay: Duration(milliseconds: index * 100),
            child: Card(
              margin: EdgeInsets.only(bottom: 16.h),
              child: ListTile(
                contentPadding: EdgeInsets.all(20.r),
                leading: CircleAvatar(
                  backgroundColor: module['color'].withValues(alpha: 0.1),
                  child: Icon(module['icon'], color: module['color']),
                ),
                title: Text(module['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.textMain)),
                trailing: const Icon(Icons.shield_rounded, color: AppColors.azure, size: 40),
                onTap: () {
                  soundService.playTap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryEngine(
                        title: module['title'],
                        pages: List<Map<String, String>>.from(module['pages'].map((p) => Map<String, String>.from(p))),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
