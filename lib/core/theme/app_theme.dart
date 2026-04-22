import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.seafoam,
        primary: AppColors.seafoam,
        secondary: AppColors.azure,
        surface: AppColors.primaryBackground,
      ),
      scaffoldBackgroundColor: AppColors.primaryBackground,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w900, // Thicker for better readability
          color: AppColors.textMain,
          fontSize: 32.sp,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Outfit',
          color: AppColors.textMain,
          fontSize: 18.sp,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.seafoam,
          foregroundColor: AppColors.textMain,
          elevation: 6,
          shadowColor: AppColors.seafoam.withValues(alpha: 0.3),
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          textStyle: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.secondaryBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.r),
        ),
      ),
    );
  }
}
