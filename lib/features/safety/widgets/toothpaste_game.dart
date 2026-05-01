import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/floating_card.dart';

class ToothpasteGame extends StatefulWidget {
  const ToothpasteGame({super.key});

  @override
  State<ToothpasteGame> createState() => _ToothpasteGameState();
}

class _ToothpasteGameState extends State<ToothpasteGame> {
  double toothpasteOut = 0.0;
  bool showMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Toothpaste Secret"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Text(
              "Squeeze the tube to post a picture online!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppColors.textMain),
            ),
            SizedBox(height: 40.h),
            
            // Tube Illustration / Interaction
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta! < 0) { // Squeezing up
                    setState(() {
                      toothpasteOut = (toothpasteOut + 0.01).clamp(0.0, 1.0);
                      if (toothpasteOut > 0.8) showMessage = true;
                    });
                  }
                },
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Toothpaste appearing
                      Container(
                        width: 40.w,
                        height: 300.h * toothpasteOut,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.2), blurRadius: 10)],
                        ),
                      ),
                      // The Tube
                      Image.network(
                        'https://cdn-icons-png.flaticon.com/512/914/914652.png',
                        width: 150.w,
                        height: 250.h,
                        color: AppColors.coral,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.brush_rounded, size: 150.sp, color: AppColors.coral),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            if (showMessage) ...[
              FloatingCard(
                color: AppColors.seafoam,
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    children: [
                      Text(
                        "Oops! Can you put the toothpaste back in?",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textMain),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Just like toothpaste, once you post something online, everyone can see it and you can't take it back. Always ask a grown-up first!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, color: AppColors.textMain),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.azure, foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(context),
                child: const Text("I understand!"),
              ),
            ] else 
              Text("Squeeze up on the tube!", style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp)),
            
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
