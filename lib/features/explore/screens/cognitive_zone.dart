import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/sound_service.dart';
import '../../ui_engine/age_adaptive_controller.dart';

class CognitiveZone extends ConsumerStatefulWidget {
  const CognitiveZone({super.key});

  @override
  ConsumerState<CognitiveZone> createState() => _CognitiveZoneState();
}

class _CognitiveZoneState extends ConsumerState<CognitiveZone> {
  late List<String> _shuffledIcons;
  List<int> _flippedIndices = [];
  List<int> _matchedIndices = [];
  late ConfettiController _confettiController;
  bool _isInitialized = false;

  final List<String> _allIcons = ["🍎", "🍌", "🍇", "🍓", "🍉", "🍍", "🥑", "🥥"];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _initGame() {
    final level = ref.read(uiProvider).level;
    int pairCount = 2; // Toddler: 4 cards
    if (level == AgeLevel.explorer) pairCount = 4; // Explorer: 8 cards
    if (level == AgeLevel.preschool) pairCount = 6; // Preschool: 12 cards

    final icons = _allIcons.take(pairCount).toList();
    _shuffledIcons = List.from([...icons, ...icons])..shuffle();
    _flippedIndices = [];
    _matchedIndices = [];
    _isInitialized = true;
  }

  void _onCardTap(int index) {
    if (_flippedIndices.length == 2 || _matchedIndices.contains(index) || _flippedIndices.contains(index)) return;

    soundService.playTap();
    setState(() {
      _flippedIndices.add(index);
    });

    if (_flippedIndices.length == 2) {
      if (_shuffledIcons[_flippedIndices[0]] == _shuffledIcons[_flippedIndices[1]]) {
        setState(() {
          _matchedIndices.addAll(_flippedIndices);
          _flippedIndices = [];
        });
        if (_matchedIndices.length == _shuffledIcons.length) {
          _showWin();
        }
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _flippedIndices = [];
            });
          }
        });
      }
    }
  }

  void _showWin() {
    soundService.playSuccess();
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FadeInUp(
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
          title: const Text("SUPER BRAIN!", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🏆", style: TextStyle(fontSize: 60.sp)),
              SizedBox(height: 16.h),
              const Text("You matched all the items! You are growing so smart.", textAlign: TextAlign.center),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.seafoam, foregroundColor: AppColors.textMain),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("I'm Done!"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) _initGame();
    final level = ref.watch(uiProvider).level;
    int crossAxisCount = level == AgeLevel.toddler ? 2 : 3;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text("Fun Games", style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(24.r),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
              ),
              itemCount: _shuffledIcons.length,
              itemBuilder: (context, index) {
                final isFlipped = _flippedIndices.contains(index) || _matchedIndices.contains(index);
                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: FlipCard(
                    isFlipped: isFlipped,
                    front: _buildCard("?"),
                    back: _buildCard(_shuffledIcons[index], color: AppColors.seafoam),
                  ),
                );
              },
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

  Widget _buildCard(String label, {Color color = Colors.white}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Center(
        child: Text(label, style: TextStyle(fontSize: 40.sp)),
      ),
    );
  }
}

class FlipCard extends StatelessWidget {
  final bool isFlipped;
  final Widget front;
  final Widget back;

  const FlipCard({super.key, required this.isFlipped, required this.front, required this.back});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final rotate = Tween(begin: pi, end: 0.0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.rotationY(rotate.value),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      child: isFlipped ? back : front,
    );
  }
}
