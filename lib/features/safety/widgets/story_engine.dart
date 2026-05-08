import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/sound_service.dart';
import '../../../core/services/speech_service.dart';
import '../../ui_engine/age_adaptive_controller.dart';
import '../../../core/network/supabase_service.dart';

class StoryEngine extends ConsumerStatefulWidget {
  final String title;
  final List<Map<String, String>> pages;

  const StoryEngine({
    super.key,
    required this.title,
    required this.pages,
  });

  @override
  ConsumerState<StoryEngine> createState() => _StoryEngineState();
}

class _StoryEngineState extends ConsumerState<StoryEngine> {
  int _currentPage = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    // Start reading the first page automatically
    _speakCurrentPage();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    speechService.stop(); // Stop speaking when leaving
    super.dispose();
  }

  void _speakCurrentPage() {
    speechService.readStoryPage(widget.pages[_currentPage]['text']!);
  }

  void _nextPage() {
    if (_currentPage < widget.pages.length - 1) {
      soundService.playTap();
      setState(() {
        _currentPage++;
      });
      _speakCurrentPage();
    } else {
      _finishStory();
    }
  }

  void _finishStory() async {
    soundService.playSuccess();
    _confettiController.play();
    
    // Auto-record milestone
    final childId = ref.read(uiProvider).activeChildId;
    if (childId != null) {
      await SupabaseService().recordMilestone(
        childId: childId,
        milestoneType: 'Story: ${widget.title}',
        score: 20,
        metadata: {'title': widget.title},
      );
    }

    // Give them 1.5 seconds of confetti celebration before returning to the home screen
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = widget.pages[_currentPage];

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(32.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: FadeInDown(
                      key: ValueKey(_currentPage),
                      child: Text(
                        page['image']!,
                        style: TextStyle(fontSize: 120.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                FadeInUp(
                  key: ValueKey("text_$_currentPage"),
                  child: Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32.r),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                    ),
                    child: Text(
                      page['text']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600, color: AppColors.textMain),
                    ),
                  ),
                ),
                SizedBox(height: 60.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      IconButton(
                        onPressed: () {
                          setState(() => _currentPage--);
                          _speakCurrentPage();
                        },
                        icon: const Icon(Icons.arrow_back_ios_rounded),
                      )
                    else
                      const SizedBox(),
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.azure,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                      ),
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage < widget.pages.length - 1 ? "Next Page" : "I'm Done!",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }
}
