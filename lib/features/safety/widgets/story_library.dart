import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/sound_service.dart';
import '../../ui_engine/age_adaptive_controller.dart';
import '../widgets/story_engine.dart';

class StoryLibrary extends ConsumerWidget {
  const StoryLibrary({super.key});

  final List<Map<String, dynamic>> _funStories = const [
    {
      'title': 'The Brave Elephant',
      'icon': Icons.pets_rounded,
      'color': Colors.grey,
      'level': AgeLevel.toddler,
      'pages': [
        {'text': 'Ellie the Elephant found a giant mango!', 'image': '🐘'},
        {'text': 'She shared it with all her jungle friends.', 'image': '🥭'},
        {'text': 'Sharing makes everyone happy!', 'image': '🌈'},
      ]
    },
    {
      'title': 'Colorful Shapes',
      'icon': Icons.category_rounded,
      'color': Colors.pinkAccent,
      'level': AgeLevel.toddler,
      'pages': [
        {'text': 'The Red Square is like a little box.', 'image': '🟥'},
        {'text': 'The Blue Circle is like a bouncing ball.', 'image': '🔵'},
        {'text': 'The Yellow Triangle is like a piece of cheese!', 'image': '🧀'},
      ]
    },
    {
      'title': 'Monkey\'s Tea Party',
      'icon': Icons.emoji_food_beverage_rounded,
      'color': Colors.brown,
      'level': AgeLevel.explorer,
      'pages': [
        {'text': 'Momo the Monkey invited the birds for tea.', 'image': '🐒'},
        {'text': 'They had sweet bananas and cold coconut water.', 'image': '🥥'},
        {'text': 'Everyone sang a happy song together.', 'image': '🎶'},
      ]
    },
    {
      'title': 'Journey to Mars',
      'icon': Icons.rocket_rounded,
      'color': Colors.deepOrangeAccent,
      'level': AgeLevel.preschool,
      'pages': [
        {'text': 'Countdown! 3... 2... 1... Blast off!', 'image': '🚀'},
        {'text': 'Look! The Earth looks like a big blue marble.', 'image': '🌍'},
        {'text': 'We landed on the red planet!', 'image': '👽'},
      ]
    },
    // AI Curated expansions
    {
      'title': 'The Magical Rain',
      'icon': Icons.cloudy_snowing,
      'color': Colors.blueAccent,
      'level': AgeLevel.explorer,
      'pages': [
        {'text': 'When it rains, the flowers dance!', 'image': '🌸'},
        {'text': 'The frogs enjoy their jump in the mud.', 'image': '🐸'},
      ]
    },
    {
      'title': 'Counting Stars',
      'icon': Icons.star_border_rounded,
      'color': Colors.amber,
      'level': AgeLevel.toddler,
      'pages': [
        {'text': 'One star, two stars, three stars... wow!', 'image': '⭐'},
        {'text': 'The whole sky is twinkling for you.', 'image': '🌃'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(uiProvider).level;
    final stories = _getStoriesForLevel(level);

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text("My Books", style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(24.r),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return FadeInLeft(
            delay: Duration(milliseconds: index * 100),
            child: Card(
              margin: EdgeInsets.only(bottom: 16.h),
              child: ListTile(
                contentPadding: EdgeInsets.all(20.r),
                leading: CircleAvatar(
                  backgroundColor: story['color'].withValues(alpha: 0.1),
                  child: Icon(story['icon'], color: story['color']),
                ),
                title: Text(story['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.textMain)),
                trailing: const Icon(Icons.menu_book_rounded, color: AppColors.azure, size: 40),
                onTap: () {
                  soundService.playTap();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryEngine(
                        title: story['title'],
                        pages: List<Map<String, String>>.from(story['pages'].map((p) => Map<String, String>.from(p))),
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

  List<Map<String, dynamic>> _getStoriesForLevel(AgeLevel level) {
    return _funStories.where((s) {
      if (level == AgeLevel.toddler) return s['level'] == AgeLevel.toddler;
      if (level == AgeLevel.explorer) return s['level'] != AgeLevel.preschool;
      return true; 
    }).toList();
  }
}
